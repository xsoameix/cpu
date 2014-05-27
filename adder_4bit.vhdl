library ieee;
use ieee.std_logic_1164.all;

entity adder_4bit is port (
    a, b : in  std_logic_vector(3 downto 0);
    cin  : in  std_logic;
    g, p : out std_logic;
    sum  : out std_logic_vector(3 downto 0);
    v    : out std_logic);
end adder_4bit;

architecture adder_4bit_arch of adder_4bit is
    component block_carry_lookahead_generator is port (
        cin    : in  std_logic;
        g, p   : in  std_logic_vector(3 downto 0);
        c      : out std_logic_vector(2 downto 0);
        co     : out std_logic;
        go, po : out std_logic);
    end component;

    component adder_1bit is port (
        a, b, cin : in  std_logic;
        g, p, sum : out std_logic);
    end component;

    signal g_internal : std_logic_vector(3 downto 0);
    signal p_internal : std_logic_vector(3 downto 0);
    signal c          : std_logic_vector(2 downto 0);
    signal co         : std_logic;
begin
    block_carry_lookahead_generator_0 : block_carry_lookahead_generator port map (
        cin => cin,
        g => g_internal,
        p => p_internal,
        c => c,
        co => co,
        go => g,
        po => p);
    adder_1bit_0 : adder_1bit port map (
        a => a(0),
        b => b(0),
        cin => cin,
        g => g_internal(0),
        p => p_internal(0),
        sum => sum(0));
    adder_1bit_1 : adder_1bit port map (
        a => a(1),
        b => b(1),
        cin => c(0),
        g => g_internal(1),
        p => p_internal(1),
        sum => sum(1));
    adder_1bit_2 : adder_1bit port map (
        a => a(2),
        b => b(2),
        cin => c(1),
        g => g_internal(2),
        p => p_internal(2),
        sum => sum(2));
    adder_1bit_3 : adder_1bit port map (
        a => a(3),
        b => b(3),
        cin => c(2),
        g => g_internal(3),
        p => p_internal(3),
        sum => sum(3));
    v <= c(2) xor co;
end adder_4bit_arch;
