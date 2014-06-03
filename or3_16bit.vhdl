library ieee;
use ieee.std_logic_1164.all;

entity or3_16bit is port (
    a      : in  std_logic_vector(15 downto 0);
    b      : in  std_logic_vector(15 downto 0);
    c      : in  std_logic_vector(15 downto 0);
    output : out std_logic_vector(15 downto 0));
end or3_16bit;

architecture or3_16bit_arch of or3_16bit is
begin
    output <= a or b or c;
end or3_16bit_arch;
