library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity adder_16bit_test is port (
    sum  : out std_logic_vector(15 downto 0);
    co   : out std_logic;
    v    : out std_logic;
    s    : out std_logic;
    z    : out std_logic);
end adder_16bit_test;

architecture adder_16bit_test_arch of adder_16bit_test is
    component adder_16bit is port (
        a, b : in  std_logic_vector(15 downto 0);
        cin  : in  std_logic;
        co   : out std_logic;
        sum  : out std_logic_vector(15 downto 0);
        v    : out std_logic;
        s    : out std_logic;
        z    : out std_logic);
    end component;

    signal clk   : std_logic := '0';
    signal reset : std_logic := '1';
    constant clk_period : time := 20 ns;

    signal cin  : std_logic;
    signal a, b : std_logic_vector(15 downto 0);
begin
    adder_16bit_0 : adder_16bit port map (
        cin => cin,
        a => a,
        b => b,
        sum => sum,
        co => co,
        v => v,
        s => s,
        z => z);
    clk   <= not clk after clk_period / 2;
    reset <= '0'     after clk_period + clk_period / 2;
    process (clk) is
    begin
        if reset = '1' then
            cin <= '1';
            a <= x"8020";
            b <= x"FFF0";
        elsif clk'event and clk = '1' then
            a <= a - x"0001";
        end if;
    end process;
end adder_16bit_test_arch;
