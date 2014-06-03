library ieee;
use ieee.std_logic_1164.all;

entity alu_74181_16bit is port (
    m    : in  std_logic;
    sel  : in  std_logic_vector(3 downto 0);

    a, b : in  std_logic_vector(15 downto 0);
    cin  : in  std_logic;

    sum  : out std_logic_vector(15 downto 0);

    -- carry flag
    co   : out std_logic;

    -- overflow flag
    v    : out std_logic;

    -- signed flag
    s    : out std_logic;

    -- zero flag
    z    : out std_logic);
end alu_74181_16bit;

architecture alu_74181_16bit_arch of alu_74181_16bit is
    component block_carry_lookahead_generator is port (
        cin    : in  std_logic;
        g, p   : in  std_logic_vector(3 downto 0);
        c      : out std_logic_vector(2 downto 0);
        co     : out std_logic;
        go, po : out std_logic);
    end component;

    component alu_74181_4bit is port (
        m    : in  std_logic;
        sel  : in  std_logic_vector(3 downto 0);
        a, b : in  std_logic_vector(3 downto 0);
        cin  : in  std_logic;
        g, p : out std_logic;
        sum  : out std_logic_vector(3 downto 0);
        v    : out std_logic);
    end component;

    signal g            : std_logic_vector(3 downto 0);
    signal p            : std_logic_vector(3 downto 0);
    signal c            : std_logic_vector(2 downto 0);
    signal sum_internal : std_logic_vector(15 downto 0);
begin
    block_carry_lookahead_generator_0 : block_carry_lookahead_generator port map (
        cin => cin,
        g => g,
        p => p,
        c => c,
        co => co);
    alu_74181_4bit_0 : alu_74181_4bit port map(
        m => m,
        sel => sel,
        a => a(3 downto 0),
        b => b(3 downto 0),
        cin => cin,
        g => g(0),
        p => p(0),
        sum => sum_internal(3 downto 0));
    alu_74181_4bit_1 : alu_74181_4bit port map(
        m => m,
        sel => sel,
        a => a(7 downto 4),
        b => b(7 downto 4),
        cin => c(0),
        g => g(1),
        p => p(1),
        sum => sum_internal(7 downto 4));
    alu_74181_4bit_2 : alu_74181_4bit port map(
        m => m,
        sel => sel,
        a => a(11 downto 8),
        b => b(11 downto 8),
        cin => c(1),
        g => g(2),
        p => p(2),
        sum => sum_internal(11 downto 8));
    alu_74181_4bit_3 : alu_74181_4bit port map(
        m => m,
        sel => sel,
        a => a(15 downto 12),
        b => b(15 downto 12),
        cin => c(2),
        g => g(3),
        p => p(3),
        sum => sum_internal(15 downto 12),
        v => v);
    s <= sum_internal(15);
    z <= not(
         sum_internal(0) or sum_internal(1) or sum_internal(2) or sum_internal(3) or
         sum_internal(4) or sum_internal(5) or sum_internal(6) or sum_internal(7) or
         sum_internal(8) or sum_internal(9) or sum_internal(10) or sum_internal(11) or
         sum_internal(12) or sum_internal(13) or sum_internal(14) or sum_internal(15));
    sum <= sum_internal;
end alu_74181_16bit_arch;
