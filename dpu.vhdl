library ieee;
use ieee.std_logic_1164.all;

entity dpu is port (
    clk, reset, en : in  std_logic;

    -- c0:
    -- 0 memory to register
    -- 1 alu    to register
    c0             : in  std_logic;
    m              : in  std_logic;
    sel            : in  std_logic_vector(3 downto 0);
    sel_c          : in  std_logic_vector(1 downto 0);
    sel_a          : in  std_logic_vector(1 downto 0);
    sel_b          : in  std_logic_vector(1 downto 0);
    cin            : in  std_logic;
    input          : in  std_logic_vector(15 downto 0);
    output         : out std_logic_vector(15 downto 0);
    r0, r1, r2, r3 : out std_logic_vector(15 downto 0);
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

    signal a              : std_logic_vector(15 downto 0);
    signal b              : std_logic_vector(15 downto 0);
    signal c              : std_logic_vector(15 downto 0);
    signal sum            : std_logic_vector(15 downto 0);
    signal flags_internal : std_logic_vector(3 downto 0);
    signal flags_reg      : std_logic_vector(3 downto 0);
begin
    process (clk) is
    begin
        if reset = '1' then
            flags_reg <= "0000";
        elsif clk'event and clk = '1' then
            flags_reg <= flags_internal;
        end if;
    end process;
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
        c => c);
    with c0 select
        c <= input when '0',
             sum   when others;
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
    output <= sum;
end dpu_arch;
