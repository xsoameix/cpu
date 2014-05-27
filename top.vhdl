library ieee;
use ieee.std_logic_1164.all;

entity top is port (
    temp_in  : in  std_logic;
    temp_out : out std_logic;
    -- en       : in  std_logic;
    -- sel_a    : in  std_logic_vector(1 downto 0);
    -- sel_b    : in  std_logic_vector(1 downto 0);
    -- sel_c    : in  std_logic_vector(1 downto 0);
    -- c        : in  std_logic_vector(15 downto 0);
    -- a, b     : out std_logic_vector(15 downto 0));
    cin  : in  std_logic;
    a, b : in  std_logic_vector(3 downto 0);
    sum  : out std_logic_vector(3 downto 0);
    co   : out std_logic);
end top;

architecture top_arch of top is
    component adder_4bit is port (
        cin  : in  std_logic;
        a, b : in  std_logic_vector(3 downto 0);
        sum  : out std_logic_vector(3 downto 0);
        co   : out std_logic);
    end component;
    -- component cpu is port (
    --     clk, reset : in  std_logic;
    --     en         : in  std_logic;
    --     sel_a      : in  std_logic_vector(1 downto 0);
    --     sel_b      : in  std_logic_vector(1 downto 0);
    --     sel_c      : in  std_logic_vector(1 downto 0);
    --     c          : in  std_logic_vector(15 downto 0);
    --     a, b       : out std_logic_vector(15 downto 0));
    -- end component;

    signal clk   : std_logic := '0';
    signal reset : std_logic := '1';
    constant clk_period : time := 20 ns;
begin
    -- cpu_0 : cpu port map (
    --     clk => clk,
    --     reset => reset,
    --     en => en,
    --     sel_a => sel_a,
    --     sel_b => sel_b,
    --     sel_c => sel_c,
    --     c => c,
    --     a => a,
    --     b => b);
    adder_4bit_0 : adder_4bit port map (
        cin => cin,
        a => a,
        b => b,
        sum => sum,
        co => co);
    clk   <= not clk after clk_period / 2;
    reset <= '0'     after clk_period + clk_period / 2;
end top_arch;
