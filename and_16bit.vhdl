library ieee;
use ieee.std_logic_1164.all;

entity and_16bit is port (
    a      : in  std_logic_vector(15 downto 0);
    b      : in  std_logic;
    output : out std_logic_vector(15 downto 0));
end and_16bit;

architecture and_16bit_arch of and_16bit is
    component expand_16bit is port (
        input  : in  std_logic;
        output : out std_logic_vector(15 downto 0));
    end component;

    signal b_16bit : std_logic_vector(15 downto 0);
begin
    expand_16bit_0 : expand_16bit port map (
        input  => b,
        output => b_16bit);
    output <= a and b_16bit;
end and_16bit_arch;
