library ieee;
use ieee.std_logic_1164.all;

entity dpu is port (
    clk, reset, en : in  std_logic;

    -- c3: memory      -> register file
    -- c2: accumulator -> register file
    -- c1: memory <- address register
    --     memory <- register file
    -- c1: memory -> data register

    -- fetch:
    -- address register <- program counter
    --                     program counter + 1
    -- memory <- address register
    -- memory -> instruction register(IR)

    -- instruction     | code
    -- mov r0, [0xABC] | M(IR(operand 2)) -> RF[IR(operand 1)]
    -- mov r0, [r0]    |   AR             <- RF[IR(operand 2)]
    --                 | M(AR)            -> RF[IR(operand 1)]
    -- mov [0xABC], r0 | M(IR(operand 1)) <- RF[IR(operand 2)]
    -- add r0, r0, r1  | AC               <- RF[IR(operand 2, 3)]
    --                 | AC               -> RF[IR(operand 1)]
    c              : in  std_logic_vector(2 downto 0);
    m              : in  std_logic;
    sel            : in  std_logic_vector(3 downto 0);
    sel_c          : in  std_logic_vector(1 downto 0);
    sel_a          : in  std_logic_vector(1 downto 0);
    sel_b          : in  std_logic_vector(1 downto 0);
    cin            : in  std_logic;
    input          : in  std_logic_vector(15 downto 0);
    output         : out std_logic_vector(15 downto 0);
    r0, r1, r2, r3 : out std_logic_vector(15 downto 0);
    data_reg       : out std_logic_vector(15 downto 0);
    flags          : out std_logic_vector(3 downto 0));
end dpu;

architecture dpu_arch of dpu is
    component register_file is port (
        clk, reset, en : in  std_logic;
        sel_a, sel_b   : in  std_logic_vector(1 downto 0);
        a, b           : out std_logic_vector(15 downto 0);
        sel_c          : in  std_logic_vector(1 downto 0);
        c              : in  std_logic_vector(15 downto 0);
        r0, r1, r2, r3 : out std_logic_vector(15 downto 0));
    end component;
    component alu is port (
        m    : in  std_logic;
        sel  : in  std_logic_vector(3 downto 0);
        a, b : in  std_logic_vector(15 downto 0);
        cin  : in  std_logic;
        sum  : out std_logic_vector(15 downto 0);
        co   : out std_logic;
        v    : out std_logic;
        s    : out std_logic;
        z    : out std_logic);
    end component;
    component and_16bit is port (
        a      : in  std_logic_vector(15 downto 0);
        b      : in  std_logic;
        output : out std_logic_vector(15 downto 0));
    end component;
    component or2_16bit is port (
        a      : in  std_logic_vector(15 downto 0);
        b      : in  std_logic_vector(15 downto 0);
        output : out std_logic_vector(15 downto 0));
    end component;

    signal a                      : std_logic_vector(15 downto 0);
    signal b                      : std_logic_vector(15 downto 0);
    signal c_internal             : std_logic_vector(15 downto 0);
    signal sum                    : std_logic_vector(15 downto 0);
    signal flags_internal         : std_logic_vector(3 downto 0);
    signal flags_reg              : std_logic_vector(3 downto 0);
    signal data_reg_internal      : std_logic_vector(15 downto 0);
    signal data_reg_0             : std_logic_vector(15 downto 0);
    signal data_reg_1             : std_logic_vector(15 downto 0);
    signal data_reg_2             : std_logic_vector(15 downto 0);
    signal register_file_1        : std_logic_vector(15 downto 0);
    signal register_file_2        : std_logic_vector(15 downto 0);

    signal memory_to_reg_file     : std_logic;
    signal alu_to_reg_file        : std_logic;
begin
    process (clk) is
    begin
        if reset = '1' then
            flags_reg <= "0000";
            data_reg_internal <= x"0000";
        elsif clk'event and clk = '1' then
            flags_reg <= flags_internal;
            data_reg_internal <= data_reg_2;
        end if;
    end process;
    memory_to_reg_file <= not(c(2));
    alu_to_reg_file    <=     c(2);

    data_reg_input : and_16bit port map (
        a => input,
        b => c(1),
        output => data_reg_0);
    data_reg_output_b <= not(c(1));
    data_reg_output : and_16bit port map (
        a => data_reg_internal,
        b => data_reg_output_b,
        output => data_reg_1);
    data_reg_select : or2_16bit port map (
        a => data_reg_0,
        b => data_reg_1,
        output => data_reg_2);

    register_file_memory : and_16bit port map (
        a => input,
        b => memory_to_reg_file,
        output => register_file_1);
    register_file_alu : and_16bit port map (
        a => sum,
        b => alu_to_reg_file,
        output => register_file_2);
    register_file_select : or2_16bit port map (
        a => register_file_1,
        b => register_file_2,
        output => c_internal);
    register_file_0 : register_file port map (
        clk => clk,
        reset => reset,
        en => en,
        sel_a => sel_a,
        sel_b => sel_b,
        a => a,
        b => b,
        r0 => r0,
        r1 => r1,
        r2 => r2,
        r3 => r3,
        sel_c => sel_c,
        c => c_internal);
    alu_0 : alu port map (
        m => m,
        sel => sel,
        a => a,
        b => b,
        cin => cin,
        sum => sum,
        co => flags_internal(3),
        v => flags_internal(2),
        s => flags_internal(1),
        z => flags_internal(0));
    flags <= flags_reg;
    data_reg <= data_reg_internal;
    output <= sum;
end dpu_arch;
