library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity alu_test is port (
    sum     : out std_logic_vector(15 downto 0);
    co      : out std_logic;
    v       : out std_logic;
    s       : out std_logic;
    z       : out std_logic;
    finined : out std_logic;
    en    : out std_logic;
    sign_out : out std_logic;
    alu_count : out std_logic_vector(3 downto 0);
    mlier : out std_logic_vector(15 downto 0);
    mcand : out std_logic_vector(15 downto 0);
    accum : out std_logic_vector(15 downto 0));
end alu_test;

architecture alu_test_arch of alu_test is
    component alu is port (
        clk, reset : in  std_logic;
        c          : in  std_logic_vector(2 downto 0);
        m          : in  std_logic;
        sel        : in  std_logic_vector(3 downto 0);
        a, b       : in  std_logic_vector(15 downto 0);
        cin        : in  std_logic;
        sum        : out std_logic_vector(15 downto 0);
        co         : out std_logic;
        v          : out std_logic;
        s          : out std_logic;
        z          : out std_logic;
        finined    : out std_logic;
        en    : out std_logic;
        sign_out : out std_logic;
        count : out std_logic_vector(3 downto 0);
        mlier : out std_logic_vector(15 downto 0);
        mcand : out std_logic_vector(15 downto 0);
        accum : out std_logic_vector(15 downto 0));
    end component;

    signal clk   : std_logic := '0';
    signal reset : std_logic := '1';
    constant clk_period : time := 20 ns;
    signal count : std_logic_vector(15 downto 0) := x"0000";
    signal offset : std_logic_vector(15 downto 0) := x"0001";

    signal c       : std_logic_vector(2 downto 0);
    signal m       : std_logic;
    signal sel     : std_logic_vector(3 downto 0);

    signal a, b    : std_logic_vector(15 downto 0);
    signal cin     : std_logic;

    signal finined_internal : std_logic;
begin
    alu_0 : alu port map (
        clk => clk,
        reset => reset,
        c => c,
        m => m,
        sel => sel,
        a => a,
        b => b,
        cin => cin,
        sum => sum,
        co => co,
        v => v,
        s => s,
        z => z,
        finined => finined_internal,
        en => en,
        sign_out => sign_out,
        count => alu_count,
        mlier => mlier,
        mcand => mcand,
        accum => accum);
    clk   <= not clk after clk_period / 2;
    reset <= '0'     after clk_period + clk_period / 2;
    process (clk) is
    begin
        if reset = '1' then
            c <= "001";
            m <= '0';
            sel <= "0000";
            a <= x"0000";
            b <= x"0000";
            cin <= '0';
        elsif clk'event and clk = '1' then
            case count is
            when x"0002" =>
                -- add
                m <= '1';
                sel <= "0110";
                c <= "001";
                a <= x"0010";
                b <= x"0011";
                cin <= '0';
            when x"0003" =>
                c <= "010";
            when x"0004" =>
                -- sub
                m <= '1';
                sel <= "1001";
                c <= "001";
                a <= x"0101";
                b <= x"0110";
                cin <= '1';
            when x"0005" =>
                c <= "010";
            when x"0007" =>
                -- mul (reset)
                m <= '0';
                sel <= "0011";
                cin <= '0';
                c <= "001";

                a <= x"FFFF";
                b <= x"0002";
            when x"0008" =>
                -- mul (add)
                offset <= x"0001";

                m <= '1';
                sel <= "0110";
                cin <= '0';
                c <= "010";
            when x"0009" =>
                -- mul (shift, count + 1)
                m <= '1';
                sel <= "0110";
                c <= "100";
                cin <= '0';
            when x"000A" =>
                m <= '0';
                sel <= "0000";
                cin <= '0';
                c <= "010";
                if finined_internal = '0' then
                    offset <= x"FFFE";
                end if;
            when x"000B" =>
                -- mul (sub)
                m <= '1';
                sel <= "1001";
                cin <= '1';
                c <= "010";
            when x"000C" =>
                -- mul (shift, count + 1)
                m <= '0';
                sel <= "0000";
                cin <= '0';
                c <= "100";
            when x"000D" =>
                -- mul (product high bits)
                c <= "010";
                m <= '0';
                sel <= "0000";
                cin <= '0';
            when x"000E" =>
                -- mul (product low bits)
                c <= "001";
                m <= '0';
                sel <= "0000";
                cin <= '0';
            when others =>
            end case;
        elsif clk'event and clk = '0' then
            count <= count + offset;
        end if;
    end process;
    finined <= finined_internal;
end alu_test_arch;
