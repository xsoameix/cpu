library ieee;
use ieee.std_logic_1164.all;

entity register_file is port (
    clk, reset, en : in  std_logic;

    -- read
    sel_a, sel_b   : in  std_logic_vector(1 downto 0);
    a, b           : out std_logic_vector(15 downto 0);

    -- write
    sel_c          : in  std_logic_vector(1 downto 0);
    c              : in  std_logic_vector(15 downto 0);

    r0, r1, r2, r3 : out std_logic_vector(15 downto 0));
end register_file;

architecture register_file_arch of register_file is
    signal r0_internal : std_logic_vector(15 downto 0);
    signal r1_internal : std_logic_vector(15 downto 0);
    signal r2_internal : std_logic_vector(15 downto 0);
    signal r3_internal : std_logic_vector(15 downto 0);
begin
    r0 <= r0_internal;
    r1 <= r1_internal;
    r2 <= r2_internal;
    r3 <= r3_internal;
    process (clk) is
    begin
        if reset = '1' then
            r0_internal <= x"0000";
            r1_internal <= x"0000";
            r2_internal <= x"0000";
            r3_internal <= x"0000";
        elsif clk'event and clk = '1' and en = '1' then
            case sel_c is
            when "00" => r0_internal <= c;
            when "01" => r1_internal <= c;
            when "10" => r2_internal <= c;
            when "11" => r3_internal <= c;
            when others =>
            end case;
        end if;
    end process;
    with sel_a select
        a <= r0_internal when "00",
             r1_internal when "01",
             r2_internal when "10",
             r3_internal when others;
    with sel_b select
        b <= r0_internal when "00",
             r1_internal when "01",
             r2_internal when "10",
             r3_internal when others;
end register_file_arch;
