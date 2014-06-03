library ieee;
use ieee.std_logic_1164.all;

entity or2_16bit is port (
    a      : in  std_logic_vector(15 downto 0);
    b      : in  std_logic_vector(15 downto 0);
    output : out std_logic_vector(15 downto 0));
end or2_16bit;

architecture or2_16bit_arch of or2_16bit is
begin
    output <= a or b;
end or2_16bit_arch;
