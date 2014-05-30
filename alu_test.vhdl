library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity alu_test is port (
    sum  : out std_logic_vector(15 downto 0);
    co   : out std_logic;
    v    : out std_logic;
    s    : out std_logic;
    z    : out std_logic);
end alu_test;

architecture alu_test_arch of alu_test is
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


    signal clk   : std_logic := '0';
    signal reset : std_logic := '1';
    constant clk_period : time := 20 ns;

    signal m    : std_logic;
    signal sel  : std_logic_vector(3 downto 0);

    signal a, b : std_logic_vector(15 downto 0);
    signal cin  : std_logic;
begin
    alu_0 : alu port map (
        m => m,
        sel => sel,
        a => a,
        b => b,
        cin => cin,
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
            m <= '0';
            sel <= "1111";
            a <= x"0010";
            b <= x"0000";
            cin <= '0';
        elsif clk'event and clk = '1' then
            a <= a + x"0001";
        end if;
    end process;
end alu_test_arch;
