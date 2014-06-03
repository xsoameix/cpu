library ieee;
use ieee.std_logic_1164.all;

entity mux2_16bit is port (
    sel      : in  std_logic;
    if_true  : in  std_logic_vector(15 downto 0);
    if_false : in  std_logic_vector(15 downto 0);
    output   : out std_logic_vector(15 downto 0));
end mux2_16bit;

architecture mux2_16bit_arch of mux2_16bit is
    component and_16bit is port (
        a      : in  std_logic_vector(15 downto 0);
        b      : in  std_logic;
        output : out std_logic_vector(15 downto 0));
    end component;
    component or2_16bit is port (
        a      : in  std_logic_vector(15 downto 0);
        b      : in  std_logic_vector(15 downto 0);
        output : out std_logic_vector(15 downto 0));
    end component;

    signal b_0_sel  : std_logic;
    signal output_1 : std_logic_vector(15 downto 0);
    signal output_2 : std_logic_vector(15 downto 0);
begin
    a_0 : and_16bit port map (
        a => if_true,
        b => sel,
        output => output_1);
    b_0_sel <= not(sel);
    b_0 : and_16bit port map (
        a => if_false,
        b => b_0_sel,
        output => output_2);
    output_0 : or2_16bit port map (
        a => output_1,
        b => output_2,
        output => output);
end mux2_16bit_arch;
