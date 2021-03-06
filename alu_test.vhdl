library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity alu_test is port (
    sum     : out std_logic_vector(15 downto 0);
    co      : out std_logic;
    v       : out std_logic;
    s       : out std_logic;
    z       : out std_logic;
    finined : out std_logic;
    en    : out std_logic;
    sign_out : out std_logic;
    alu_count : out std_logic_vector(3 downto 0);
    mlier : out std_logic_vector(15 downto 0);
    mcand : out std_logic_vector(15 downto 0);
    accum : out std_logic_vector(15 downto 0);
    alu_a_1 : out std_logic_vector(15 downto 0);
    alu_b_1 : out std_logic_vector(15 downto 0));
end alu_test;

architecture alu_test_arch of alu_test is
    component alu is port (
        clk, reset : in  std_logic;
        control    : in  std_logic_vector(19 downto 0);
        a, b       : in  std_logic_vector(15 downto 0);
        sum        : out std_logic_vector(15 downto 0);
        co         : out std_logic;
        v          : out std_logic;
        s          : out std_logic;
        z          : out std_logic;
        finined    : out std_logic;
        en    : out std_logic;
        sign_out : out std_logic;
        count : out std_logic_vector(3 downto 0);
        mlier : out std_logic_vector(15 downto 0);
        mcand : out std_logic_vector(15 downto 0);
        accum : out std_logic_vector(15 downto 0);
        alu_a_1 : out std_logic_vector(15 downto 0);
        alu_b_1 : out std_logic_vector(15 downto 0));
    end component;

    signal clk   : std_logic := '0';
    signal reset : std_logic := '1';
    constant clk_period : time := 20 ns;
    signal count : std_logic_vector(15 downto 0) := x"0000";
    signal offset : std_logic_vector(15 downto 0) := x"0001";

    signal control : std_logic_vector(19 downto 0);

    signal a, b    : std_logic_vector(15 downto 0);

    signal finined_internal : std_logic;
begin
    alu_0 : alu port map (
        clk => clk,
        reset => reset,
        control => control,
        a => a,
        b => b,
        sum => sum,
        co => co,
        v => v,
        s => s,
        z => z,
        finined => finined_internal,
        en => en,
        sign_out => sign_out,
        count => alu_count,
        mlier => mlier,
        mcand => mcand,
        accum => accum,
        alu_a_1 => alu_a_1,
        alu_b_1 => alu_b_1
    );
    clk   <= not clk after clk_period / 2;
    reset <= '0'     after clk_period + clk_period / 2;
    process (clk) is
    begin
        if reset = '1' then
            control <= "00000000000000000000";
            a <= x"FFFF";
            b <= x"0002";
        elsif clk'event and clk = '1' then
            case count is
            when x"0002" =>
                -- and
                control <= "00000100000000000000";
            when x"0003" =>
                control <= "00000000000000000100";
            when x"0004" =>
                -- or
                control <= "00000001000000000000";
            when x"0005" =>
                control <= "00000000000000000100";
            when x"0006" =>
                -- xor
                control <= "00000000100000000000";
            when x"0007" =>
                control <= "00000000000000000100";
            when x"0008" =>
                -- nxor
                control <= "00000000010000000000";
            when x"0009" =>
                control <= "00000000000000000100";
            when x"000A" =>
                -- nor
                control <= "00000000001000000000";
            when x"000B" =>
                control <= "00000000000000000100";
            when x"000C" =>
                -- nand
                control <= "00000000000100000000";
            when x"000D" =>
                control <= "00000000000000000100";
            when x"000E" =>
                -- not
                control <= "00000000000010000000";
            when x"000F" =>
                control <= "00000000000000000100";
            when x"0010" =>
                -- shl
                control <= "01000000000000000000";
            when x"0011" =>
                control <= "00000000000000000100";
            when x"0012" =>
                -- sal
                control <= "01000000000000000000";
            when x"0013" =>
                control <= "00000000000000000100";
            when x"0014" =>
                -- shr
                control <= "00000000000000001000";
            when x"0015" =>
                control <= "00000000000000000001";
            when x"0016" =>
                control <= "00000000000000000100";
            when x"0017" =>
                -- sar
                control <= "00000000000000001000";
            when x"0018" =>
                control <= "00000000000000000010";
            when x"0019" =>
                control <= "00000000000000000001";
            when x"001A" =>
                control <= "00000000000000000100";
            when x"001B" =>
                -- inc
                control <= "10000000000000000000";
            when x"001C" =>
                control <= "00000000000000000100";
            when x"001D" =>
                -- dec
                control <= "00001000000000000000";
            when x"001E" =>
                control <= "00000000000000000100";
            when x"001F" =>
                -- add
                control <= "00100000000000000000";
            when x"0020" =>
                control <= "00000000000000000100";
            when x"0021" =>
                -- sub
                control <= "00010000000000000000";
            when x"0022" =>
                control <= "00000000000000000100";
            when x"0023" =>
                -- mul (reset)
                control <= "00000000000000010000";
            when x"0024" =>
                -- mul (add)
                offset <= x"0001";
                control <= "00000000000001000000";
            when x"0025" =>
                -- mul (shift, count + 1)
                control <= "00000000000000000001";
            when x"0026" =>
                control <= "00000000000000000100";
                if finined_internal = '0' then
                    offset <= x"FFFE";
                end if;
            when x"0027" =>
                -- mul (sub)
                control <= "00000000000000100000";
            when x"0028" =>
                -- mul (shift, count + 1)
                control <= "00000000000000000001";
            when x"0029" =>
                -- mul (product high bits)
                control <= "00000000000000000100";
            when x"002A" =>
                -- mul (product low bits)
                control <= "00000000000000001000";
            when others =>
            end case;
        elsif clk'event and clk = '0' then
            count <= count + offset;
        end if;
    end process;
    finined <= finined_internal;
end alu_test_arch;
