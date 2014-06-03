library ieee;
use ieee.std_logic_1164.all;
use work.lib.all;

entity alu is port (
    clk, reset : in  std_logic;

    -- control signal:
    -- c0: 
    -- c1: shift
    c          : in  std_logic_vector(2 downto 0);
    m          : in  std_logic;
    sel        : in  std_logic_vector(3 downto 0);

    a, b       : in  std_logic_vector(15 downto 0);
    cin        : in  std_logic;

    sum        : out std_logic_vector(15 downto 0);

    -- carry flag
    co         : out std_logic;

    -- overflow flag
    v          : out std_logic;

    -- signed flag
    s          : out std_logic;

    -- zero flag
    z          : out std_logic;
    
    -- count is finined (sequential multiplier)
    finined    : out std_logic;
    en    : out std_logic;
    sign_out : out std_logic;
    count : out std_logic_vector(3 downto 0);
    mlier : out std_logic_vector(15 downto 0);
    mcand : out std_logic_vector(15 downto 0);
    accum : out std_logic_vector(15 downto 0));
end alu;

architecture alu_arch of alu is
    component alu_sign_logic is port (
        clk, reset      : in  std_logic;
        m               : in  std_logic;
        sel             : in  std_logic_vector(1 downto 0);
        c               : in  std_logic_vector(1 downto 0);
        multiplier_0    : in  std_logic;
        multiplier_15   : in  std_logic;
        multiplicand_15 : in  std_logic;
        output          : out std_logic);
    end component;
    component alu_74181_16bit is port (
        m    : in  std_logic;
        sel  : in  std_logic_vector(3 downto 0);
        a, b : in  std_logic_vector(15 downto 0);
        cin  : in  std_logic;
        sum  : out std_logic_vector(15 downto 0);
        co   : out std_logic;
        v    : out std_logic;
        s    : out std_logic;
        z    : out std_logic);
    end component;
    component counter_4bit is port (
        clk, reset, en : in  std_logic;
        output         : out std_logic_vector(3 downto 0));
    end component;
    component mux2_16bit is port (
        sel      : in  std_logic;
        if_true  : in  std_logic_vector(15 downto 0);
        if_false : in  std_logic_vector(15 downto 0);
        output   : out std_logic_vector(15 downto 0));
    end component;
    component case3_16bit is port (
        if_a   : in  std_logic;
        a      : in  std_logic_vector(15 downto 0);
        if_b   : in  std_logic;
        b      : in  std_logic_vector(15 downto 0);
        if_c   : in  std_logic;
        c      : in  std_logic_vector(15 downto 0);
        output : out std_logic_vector(15 downto 0));
    end component;
    component case2_16bit is port (
        if_a   : in  std_logic;
        a      : in  std_logic_vector(15 downto 0);
        if_b   : in  std_logic;
        b      : in  std_logic_vector(15 downto 0);
        output : out std_logic_vector(15 downto 0));
    end component;

    signal accumulator  : std_logic_vector(15 downto 0);
    signal multiplier   : std_logic_vector(15 downto 0);
    signal multiplicand : std_logic_vector(15 downto 0);
    signal sign         : std_logic;
    signal alu_sum      : std_logic_vector(15 downto 0);
    signal counter      : std_logic_vector(3 downto 0);

    signal do_reset                    : std_logic;
    signal do_accumulate               : std_logic;
    signal do_shift                    : std_logic;

    signal accumulator_0        : std_logic_vector(15 downto 0);
    signal accumulator_shift    : std_logic_vector(15 downto 0);
    signal multiplier_0         : std_logic_vector(15 downto 0);
    signal multiplier_shift     : std_logic_vector(15 downto 0);
    signal multiplier_back      : std_logic;
    signal multiplicand_0       : std_logic_vector(15 downto 0);
    signal alu_a_0              : std_logic_vector(15 downto 0);
    signal alu_b_0              : std_logic_vector(15 downto 0);
    signal alu_b_do_accumulate  : std_logic;
    signal sum_0                : std_logic_vector(15 downto 0);
    signal counter_4bit_0_reset : std_logic;
begin
    --    action     | control signals
    -- -------------------------------
    -- 1. reset      | 001
    -- 2. accumulate | 010
    -- 3. shift      | 100
    do_reset      <= c(0);
    do_accumulate <= c(1);
    do_shift      <= c(2);

    accumulator_shift <= sign & accumulator(15 downto 1);
    accumulator_case : mux2_16bit port map (
        sel => do_shift,
        if_true => accumulator_shift,
        if_false => alu_sum,
        output => accumulator_0);

    multiplier_shift <= accumulator(0) & multiplier(15 downto 1);
    multiplier_case : case3_16bit port map (
        if_a => do_reset,
        a => a,
        if_b => do_shift,
        b => multiplier_shift,
        if_c => do_accumulate,
        c => multiplier,
        output => multiplier_0);

    multiplicand_mux : mux2_16bit port map (
        sel => do_reset,
        if_true => b,
        if_false => multiplicand,
        output => multiplicand_0);

    alu_a_mux : mux2_16bit port map (
        sel => do_reset,
        if_true => a,
        if_false => accumulator,
        output => alu_a_0);

    alu_b_do_accumulate <= multiplier(0) and do_accumulate;
    alu_b_select : mux2_16bit port map (
        sel => alu_b_do_accumulate,
        if_true => multiplicand,
        if_false => b,
        output => alu_b_0);

    sum_mux : mux2_16bit port map (
        sel => do_reset,
        if_true => multiplier,
        if_false => accumulator,
        output => sum_0);

    alu_sign_logic_0 : alu_sign_logic port map (
        clk => clk,
        reset => reset,
        m => m,
        sel => sel(3 downto 2),
        c => c(2 downto 1),
        multiplier_0 => multiplier(0),
        multiplier_15 => multiplier(15),
        multiplicand_15 => multiplicand(15),
        output => sign);
    sign_out <= sign;
    process (clk) is
    begin
        if reset = '1' then
            accumulator  <= x"0000";
            multiplier   <= x"0000";
            multiplicand <= x"0000";
        elsif clk'event and clk = '1' then
            accumulator  <= accumulator_0;
            multiplier   <= multiplier_0;
            multiplicand <= multiplicand_0;
        end if;
    end process;
    alu_74181_16bit_0 : alu_74181_16bit port map (
        m => m,
        sel => sel,
        a => alu_a_0,
        b => alu_b_0,
        cin => cin,
        sum => alu_sum,
        co => co,
        v => v,
        s => s,
        z => z);
    sum <= sum_0;
    counter_4bit_0_reset <= reset or do_reset;
    counter_4bit_0 : counter_4bit port map (
        clk => clk,
        reset => counter_4bit_0_reset,
        en => do_shift,
        output => counter);
    finined <= counter(3) and counter(2) and counter(1) and not(counter(0));
    en <= do_shift;
    count <= counter;
    mlier <= multiplier;
    mcand <= multiplicand;
    accum <= accumulator;
end alu_arch;
