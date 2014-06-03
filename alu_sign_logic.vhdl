library ieee;
use ieee.std_logic_1164.all;

entity alu_sign_logic is port (
    clk, reset      : in  std_logic;
    m               : in  std_logic;
    sel             : in  std_logic_vector(1 downto 0);
    c               : in  std_logic_vector(1 downto 0);
    multiplier_0    : in  std_logic;
    multiplier_15   : in  std_logic;
    multiplicand_15 : in  std_logic;
    output          : out std_logic);
end alu_sign_logic;

architecture alu_sign_logic_arch of alu_sign_logic is
    signal sign      : std_logic;
    signal do_lock   : std_logic;
    signal do_extend : std_logic;
    signal do_add    : std_logic;
    signal do_sub    : std_logic;
begin
    do_lock   <= not(m) and not(sel(1)) and not(sel(0)) and (c(1) or c(0));
    do_extend <=     m  and not(sel(1)) and not(sel(0)) and  c(1);
    do_add    <=     m  and not(sel(1)) and     sel(0);
    do_sub    <=     m  and     sel(1)  and not(sel(0));
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
