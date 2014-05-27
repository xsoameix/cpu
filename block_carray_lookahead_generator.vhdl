library ieee;
use ieee.std_logic_1164.all;

entity block_carry_lookahead_generator is port (
    cin    : in  std_logic;
    g, p   : in  std_logic_vector(3 downto 0);
    c      : out std_logic_vector(2 downto 0);
    co     : out std_logic;
    go, po : out std_logic);
end block_carry_lookahead_generator;

architecture block_carry_lookahead_generator_arch of block_carry_lookahead_generator is
begin
    c(0) <= g(0) or (p(0) and cin);
    c(1) <= g(1) or (p(1) and g(0)) or (p(1) and p(0) and cin);
    c(2) <= g(2) or (p(2) and g(1)) or (p(2) and p(1) and g(0)) or (p(2) and p(1) and p(0) and cin);
    co   <= g(3) or (p(3) and g(2)) or (p(3) and p(2) and g(1)) or (p(3) and p(2) and p(1) and g(0)) or (p(3) and p(2) and p(1) and p(0) and cin);
    go   <= g(3) or (p(3) and g(2)) or (p(3) and p(2) and g(1)) or (p(3) and p(2) and p(1) and g(0));
    po   <= p(3) and p(2) and p(1) and p(0);
end block_carry_lookahead_generator_arch;
