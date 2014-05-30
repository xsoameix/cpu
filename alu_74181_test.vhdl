library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity alu_74181_test is port (
    sum  : out std_logic_vector(3 downto 0);
    co   : out std_logic;
    v    : out std_logic;
    s    : out std_logic;
    z    : out std_logic);
end alu_74181_test;

architecture alu_74181_test_arch of alu_74181_test is
    component alu_74181 is port (
        m    : in  std_logic;
        sel  : in  std_logic_vector(3 downto 0);
        a, b : in  std_logic_vector(3 downto 0);
        cin  : in  std_logic;
        g, p : out std_logic;
        sum  : out std_logic_vector(3 downto 0);
        v    : out std_logic);
    end component;

    signal clk   : std_logic := '0';
    signal reset : std_logic := '1';
    constant clk_period : time := 20 ns;

    signal m    : std_logic;
    signal sel  : std_logic_vector(3 downto 0);

    signal a, b : std_logic_vector(3 downto 0);
    signal cin  : std_logic;
begin
    alu_74181_0 : alu_74181 port map (
        m => m,
        sel => sel,
        a => a,
        b => b,
        cin => cin,
        sum => sum,
        v => v);
    clk   <= not clk after clk_period / 2;
    reset <= '0'     after clk_period + clk_period / 2;
    process (clk) is
    begin
        if reset = '1' then
            m <= '0';
            sel <= "0001";
            a <= "0000";
            b <= "0010";
            cin <= '0';
        elsif clk'event and clk = '1' then
            a <= a + "0001";
        end if;
    end process;
end alu_74181_test_arch;
