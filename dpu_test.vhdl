library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity dpu_test is port (
    output         : out std_logic_vector(15 downto 0);
    r0, r1, r2, r3 : out std_logic_vector(15 downto 0);
    flags          : out std_logic_vector(3 downto 0));
end dpu_test;

architecture dpu_test_arch of dpu_test is
    component dpu is port (
        clk, reset, en : in  std_logic;
        c0             : in  std_logic;
        m              : in  std_logic;
        sel            : in  std_logic_vector(3 downto 0);
        sel_c          : in  std_logic_vector(1 downto 0);
        sel_a          : in  std_logic_vector(1 downto 0);
        sel_b          : in  std_logic_vector(1 downto 0);
        cin            : in  std_logic;
        input          : in  std_logic_vector(15 downto 0);
        output         : out std_logic_vector(15 downto 0);
        r0, r1, r2, r3 : out std_logic_vector(15 downto 0);
        flags          : out std_logic_vector(3 downto 0));
    end component;

    signal clk   : std_logic := '0';
    signal reset : std_logic := '1';
    constant clk_period : time := 20 ns;
    signal count : std_logic_vector(15 downto 0) := x"0000";

    signal en    : std_logic;
    signal c0    : std_logic;
    signal m     : std_logic;
    signal sel   : std_logic_vector(3 downto 0);
    signal sel_c : std_logic_vector(1 downto 0);
    signal sel_a : std_logic_vector(1 downto 0);
    signal sel_b : std_logic_vector(1 downto 0);

    signal input : std_logic_vector(15 downto 0);
    signal cin   : std_logic;
begin
    dpu_0 : dpu port map (
        clk => clk,
        reset => reset,
        en => en,
        c0 => c0,
        m => m,
        sel => sel,
        sel_c => sel_c,
        sel_a => sel_a,
        sel_b => sel_b,
        cin => cin,
        input => input,
        output => output,
        r0 => r0,
        r1 => r1,
        r2 => r2,
        r3 => r3,
        flags => flags);
    clk   <= not clk after clk_period / 2;
    reset <= '0'     after clk_period + clk_period / 2;
    count <= count + x"0001" after clk_period;
    process (clk, reset) is
    begin
        if reset = '1' then
            en <= '0';
            c0 <= '0';
            m <= '1';
            sel <= "0110";
            sel_c <= "00";
            sel_a <= "00";
            sel_b <= "00";
            input <= x"0000";
            cin <= '0';
        elsif clk'event and clk = '1' then
            case count is
            when x"0002" =>
                input <= x"7FF0";
                en <= '1';
            when x"0003" =>
                sel_c <= "01";
                input <= x"0002";
            when x"0004" =>
                c0 <= '1';
                sel_c <= "00";
                sel_b <= "01";
            when others =>
            end case;
        end if;
    end process;
end dpu_test_arch;
