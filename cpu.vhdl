library ieee;
use ieee.std_logic_1164.all;

entity cpu is port (
    clk, reset : in  std_logic;
    en         : in  std_logic;
    sel_a      : in  std_logic_vector(1 downto 0);
    sel_b      : in  std_logic_vector(1 downto 0);
    sel_c      : in  std_logic_vector(1 downto 0);
    c          : in  std_logic_vector(15 downto 0);
    a, b       : out std_logic_vector(15 downto 0));
end cpu;

architecture cpu_arch of cpu is
    component register_file is port (
        clk, reset : in  std_logic;
        en         : in  std_logic;
        sel_a      : in  std_logic_vector(1 downto 0);
        sel_b      : in  std_logic_vector(1 downto 0);
        sel_c      : in  std_logic_vector(1 downto 0);
        c          : in  std_logic_vector(15 downto 0);
        a, b       : out std_logic_vector(15 downto 0));
    end component;
begin
    register_file_0 : register_file port map (
        clk => clk,
        reset => reset,
        en => en,
        sel_a => sel_a,
        sel_b => sel_b,
        sel_c => sel_c,
        c => c,
        a => a,
        b => b);
end cpu_arch;
