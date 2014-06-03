library ieee;
use ieee.std_logic_1164.all;
use work.lib.all;

entity alu_74181_4bit is port (
    -- mode:
    -- 0 logic
    -- 1 arith
    m    : in  std_logic;
    sel  : in  std_logic_vector(3 downto 0);

    a, b : in  std_logic_vector(3 downto 0);
    cin  : in  std_logic;

    g, p : out std_logic;
    sum  : out std_logic_vector(3 downto 0);

    -- overflow flag
    v    : out std_logic);
end alu_74181_4bit;

architecture alu_74181_4bit_arch of alu_74181_4bit is
    component block_carry_lookahead_generator is port (
        cin    : in  std_logic;
        g, p   : in  std_logic_vector(3 downto 0);
        c      : out std_logic_vector(2 downto 0);
        co     : out std_logic;
        go, po : out std_logic);
    end component;

    signal g_internal : std_logic_vector(3 downto 0);
    signal p_internal : std_logic_vector(3 downto 0);
    signal c          : std_logic_vector(2 downto 0);
    signal co         : std_logic;
begin
    g_internal <= (a and not(b) and repeat(sel(0), 4)) or
                  (a and     b  and repeat(sel(1), 4));
    p_internal <= a or
                  (    b  and repeat(sel(2), 4)) or
                  (not(b) and repeat(sel(3), 4));
    block_carry_lookahead_generator_0 : block_carry_lookahead_generator port map (
        cin => cin,
        g => g_internal,
        p => p_internal,
        c => c,
        co => co,
        go => g,
        po => p);
    sum <= g_internal xor
           p_internal xor
           ((c & cin) and repeat(m, 4));
    v <= co xor c(2);
end alu_74181_4bit_arch;
