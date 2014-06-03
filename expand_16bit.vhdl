library ieee;
use ieee.std_logic_1164.all;
use work.lib.all;

entity expand_16bit is port (
    input  : in  std_logic;
    output : out std_logic_vector(15 downto 0));
end expand_16bit;

architecture expand_16bit_arch of expand_16bit is
begin
    output <= repeat(input, 16);
end expand_16bit_arch;
