library ieee;
use ieee.std_logic_1164.all;

package lib is
    function repeat(b : std_logic; n : natural) return std_logic_vector;
end;

package body lib is

    function repeat(b : std_logic; n : natural) return std_logic_vector is
    variable result : std_logic_vector(1 to n);
    begin
        for i in 1 to n loop
            result(i) := b;
        end loop;
        return result;
    end function repeat;
end package body;
