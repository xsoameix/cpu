library ieee;
use ieee.std_logic_1164.all;

entity counter_4bit is port (
    clk, reset, en : in  std_logic;
    output         : out std_logic_vector(3 downto 0));
end counter_4bit;

architecture counter_4bit_arch of counter_4bit is
    component counter_1bit is port (
        clk, reset, en : in  std_logic;
        output         : out std_logic);
    end component;

    signal en_internal        : std_logic;
    signal output_internal    : std_logic_vector(3 downto 0);
    signal counter_1bit_1_clk : std_logic;
    signal counter_1bit_2_clk : std_logic;
    signal counter_1bit_3_clk : std_logic;
begin
    process (clk) is
    begin
        if reset = '1' then
            en_internal <= '0';
        elsif clk'event and clk = '0' then
            en_internal <= en;
        end if;
    end process;
    counter_1bit_0 : counter_1bit port map (
        clk => clk,
        reset => reset,
        en => en_internal,
        output => output_internal(0));
    counter_1bit_1_clk <= not(output_internal(0));
    counter_1bit_1 : counter_1bit port map (
        clk => counter_1bit_1_clk,
        reset => reset,
        en => en_internal,
        output => output_internal(1));
    counter_1bit_2_clk <= not(output_internal(1));
    counter_1bit_2 : counter_1bit port map (
        clk => counter_1bit_2_clk,
        reset => reset,
        en => en_internal,
        output => output_internal(2));
    counter_1bit_3_clk <= not(output_internal(2));
    counter_1bit_3 : counter_1bit port map (
        clk => counter_1bit_3_clk,
        reset => reset,
        en => en_internal,
        output => output_internal(3));
    output <= output_internal;
end counter_4bit_arch;
