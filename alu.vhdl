library ieee;
use ieee.std_logic_1164.all;
use work.lib.all;

entity alu is port (
    clk, reset : in  std_logic;

    control    : in  std_logic_vector(19 downto 0);

    a, b       : in  std_logic_vector(15 downto 0);

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
    accum : out std_logic_vector(15 downto 0);
    alu_a_1 : out std_logic_vector(15 downto 0);
    alu_b_1 : out std_logic_vector(15 downto 0));
end alu;

architecture alu_arch of alu is
    component alu_sign_logic is port (
        clk, reset      : in  std_logic;
        do_lock         : in  std_logic;
        do_extend       : in  std_logic;
        do_add          : in  std_logic;
        do_sub          : in  std_logic;
        multiplier_0    : in  std_logic;
        multiplier_15   : in  std_logic;
        multiplicand_15 : in  std_logic;
        output          : out std_logic);
    end component;
    component alu_74181_16bit is port (
        do_nop  : in  std_logic;
        do_inc  : in  std_logic;
        do_shl  : in  std_logic;
        do_add  : in  std_logic;
        do_sub  : in  std_logic;
        do_dec  : in  std_logic;
        do_and  : in  std_logic;
        do_clr  : in  std_logic;
        do_or   : in  std_logic;
        do_xor  : in  std_logic;
        do_xnor : in  std_logic;
        do_nor  : in  std_logic;
        do_nand : in  std_logic;
        do_not  : in  std_logic;
        a, b    : in  std_logic_vector(15 downto 0);
        sum     : out std_logic_vector(15 downto 0);
        co      : out std_logic;
        v       : out std_logic;
        s       : out std_logic;
        z       : out std_logic);
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

    signal accumulator_0        : std_logic_vector(15 downto 0);
    signal accumulator_shift    : std_logic_vector(15 downto 0);
    signal multiplier_0         : std_logic_vector(15 downto 0);
    signal multiplier_shift     : std_logic_vector(15 downto 0);
    signal multiplier_lock      : std_logic;
    signal multiplicand_0       : std_logic_vector(15 downto 0);
    signal alu_a_0              : std_logic_vector(15 downto 0);
    signal alu_b_0              : std_logic_vector(15 downto 0);
    signal alu_b_do_accumulate  : std_logic;
    signal sum_0                : std_logic_vector(15 downto 0);
    signal counter_4bit_0_reset : std_logic;

    signal do_inc         : std_logic;
    signal do_shl         : std_logic;
    signal do_add         : std_logic;
    signal do_sub         : std_logic;
    signal do_dec         : std_logic;
    signal do_and         : std_logic;
    signal do_clr         : std_logic;
    signal do_or          : std_logic;
    signal do_xor         : std_logic;
    signal do_xnor        : std_logic;
    signal do_nor         : std_logic;
    signal do_nand        : std_logic;
    signal do_not         : std_logic;
    signal do_AC_add      : std_logic;
    signal do_AC_sub      : std_logic;
    signal do_AC_clr      : std_logic;
    signal do_shr         : std_logic;
    signal do_cmp         : std_logic;
    signal do_sign_extend : std_logic;
    signal do_shift       : std_logic;
    signal do_74181_add   : std_logic;
    signal do_74181_sub   : std_logic;
    signal do_74181_nop   : std_logic;
    signal do_sign_lock   : std_logic;
begin
    -- 74181
    do_inc         <= control(19);
    do_shl         <= control(18);
    do_add         <= control(17);
    do_sub         <= control(16);
    do_dec         <= control(15);
    do_and         <= control(14);
    do_clr         <= control(13);
    do_or          <= control(12);
    do_xor         <= control(11);
    do_xnor        <= control(10);
    do_nor         <= control(9);
    do_nand        <= control(8);
    do_not         <= control(7);

    -- 74181 with multiply
    do_AC_add      <= control(6);
    do_AC_sub      <= control(5);
    do_AC_clr      <= control(4); -- reset AC
    do_shr         <= control(3); -- output Q
    do_cmp         <= control(2); -- or output AC
    do_sign_extend <= control(1);
    do_shift       <= control(0);

    do_74181_add   <= do_AC_add or do_add;
    do_74181_sub   <= do_AC_sub or do_sub;
    do_74181_nop   <= do_shr or
                      do_cmp or
                      do_sign_extend;

    do_sign_lock   <= do_shift or do_cmp;

    accumulator_shift <= sign & accumulator(15 downto 1);
    accumulator_case : mux2_16bit port map (
        sel => do_shift,
        if_true => accumulator_shift,
        if_false => alu_sum,
        output => accumulator_0);

    multiplier_lock <= do_AC_add or do_AC_sub or do_cmp;
    multiplier_shift <= accumulator(0) & multiplier(15 downto 1);
    multiplier_case : case3_16bit port map (
        if_a => do_AC_clr,
        a => a,
        if_b => do_shift,
        b => multiplier_shift,
        if_c => multiplier_lock,
        c => multiplier,
        output => multiplier_0);

    multiplicand_mux : mux2_16bit port map (
        sel => do_AC_clr,
        if_true => b,
        if_false => multiplicand,
        output => multiplicand_0);

    alu_a_mux : mux2_16bit port map (
        sel => multiplier_lock,
        if_true => accumulator,
        if_false => a,
        output => alu_a_0);

    alu_b_do_accumulate <= (multiplier(0) and do_AC_add) or do_AC_sub or do_cmp;
    alu_b_mux : mux2_16bit port map (
        sel => alu_b_do_accumulate,
        if_true => multiplicand,
        if_false => b,
        output => alu_b_0);

    sum_mux : mux2_16bit port map (
        sel => do_shr,
        if_true => multiplier,
        if_false => accumulator,
        output => sum_0);

    alu_sign_logic_0 : alu_sign_logic port map (
        clk => clk,
        reset => reset,
        do_lock   => do_sign_lock,
        do_extend => do_sign_extend,
        do_add    => do_AC_add,
        do_sub    => do_AC_sub,
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
        do_nop  => do_74181_nop,
        do_inc  => do_inc,
        do_shl  => do_shl,
        do_add  => do_74181_add,
        do_sub  => do_74181_sub,
        do_dec  => do_dec,
        do_and  => do_and,
        do_clr  => do_clr,
        do_or   => do_or,
        do_xor  => do_xor,
        do_xnor => do_xnor,
        do_nor  => do_nor,
        do_nand => do_nand,
        do_not  => do_not,
        a => alu_a_0,
        b => alu_b_0,
        sum => alu_sum,
        co => co,
        v => v,
        s => s,
        z => z);
    sum <= sum_0;
    counter_4bit_0_reset <= reset or do_AC_clr;
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
    alu_a_1 <= alu_a_0;
    alu_b_1 <= alu_b_0;
end alu_arch;
