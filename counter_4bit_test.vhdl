library ieee;
use ieee.std_logic_1164.all;

entity counter_4bit_test is port (
    output : out std_logic_vector(3 downto 0));
end counter_4bit_test;

architecture counter_4bit_test_arch of counter_4bit_test is
    component counter_4bit is port (
        clk, reset, en : in  std_logic;
        output         : out std_logic_vector(3 downto 0));
    end component;

    signal clk   : std_logic := '0';
    signal reset : std_logic := '1';
    constant clk_period : time := 20 ns;

    signal en    : std_logic;
begin
    counter_4bit_0 : counter_4bit port map (
        clk => clk,
        reset => reset,
        en => en,
        output => output);
    clk   <= not clk after clk_period / 2;
    reset <= '0'     after clk_period + clk_period / 2;
    process (clk) is
    begin
        if reset = '1' then
            en <= '0';
        elsif clk'event and clk = '1' then
            en <= not(en);
        end if;
    end process;
end counter_4bit_test_arch;
