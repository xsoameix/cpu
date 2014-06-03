library ieee;
use ieee.std_logic_1164.all;

entity counter_1bit is port (
    clk, reset, en : in  std_logic;
    output         : out std_logic);
end counter_1bit;

architecture counter_1bit_arch of counter_1bit is
    signal output_internal : std_logic;
begin
    process (clk, reset) is
    begin
        if reset = '1' then
            output_internal <= '0';
        else
            if clk'event and clk = '1' and en = '1' then
                output_internal <= not(output_internal);
            end if;
        end if;
    end process;
    output <= output_internal;
end counter_1bit_arch;
