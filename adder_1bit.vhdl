library ieee;
use ieee.std_logic_1164.all;

entity adder_1bit is port (
    a, b, cin : in  std_logic;
    sum, g, p : out std_logic);
end adder_1bit;

architecture adder_1bit_arch of adder_1bit is
begin
    sum <= a xor b xor cin;
    g <= a and b;
    p <= a or b;
end adder_1bit_arch;
