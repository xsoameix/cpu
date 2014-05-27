library ieee;
use ieee.std_logic_1164.all;

entity register_file is port (
    clk, reset, en : in  std_logic;

    -- read
    sel_a, sel_b   : in  std_logic_vector(1 downto 0);
    a, b           : out std_logic_vector(15 downto 0);

    -- write
    sel_c          : in  std_logic_vector(1 downto 0);
    c              : in  std_logic_vector(15 downto 0));
end register_file;

architecture register_file_arch of register_file is
    signal r0 : std_logic_vector(15 downto 0);
    signal r1 : std_logic_vector(15 downto 0);
    signal r2 : std_logic_vector(15 downto 0);
    signal r3 : std_logic_vector(15 downto 0);
begin
    process (clk) is
    begin
        if reset = '1' then
            r0 <= x"0000";
            r1 <= x"0000";
            r2 <= x"0000";
            r3 <= x"0000";
        elsif clk'event and clk = '1' and en = '1' then
            case sel_c is
            when "00" => r0 <= c;
            when "01" => r1 <= c;
            when "10" => r2 <= c;
            when "11" => r3 <= c;
            end case;
        end if;
    end process;
    with sel_a select
        a <= r0 when "00",
             r1 when "01",
             r2 when "10",
             r3 when others;
    with sel_b select
        b <= r0 when "00",
             r1 when "01",
             r2 when "10",
             r3 when others;
end register_file_arch;
