library ieee;
use ieee.std_logic_1164.all;

entity alu_sign_logic is port (
    clk, reset      : in  std_logic;
    do_lock         : in  std_logic;
    do_extend       : in  std_logic;
    do_add          : in  std_logic;
    do_sub          : in  std_logic;
    multiplier_0    : in  std_logic;
    multiplier_15   : in  std_logic;
    multiplicand_15 : in  std_logic;
    output          : out std_logic);
end alu_sign_logic;

architecture alu_sign_logic_arch of alu_sign_logic is
    signal sign      : std_logic;
begin
    process (clk) is
    begin
        if reset = '1' then
            sign <= '0';
        elsif clk'event and clk = '1' then
            sign <= (do_lock and sign) or
                    (do_extend and multiplier_15) or
                    (do_add and ((multiplier_0 and multiplicand_15) or sign)) or
                    (do_sub and (multiplier_0 xor multiplicand_15));
        end if;
    end process;
    output <= sign;
end alu_sign_logic_arch;
