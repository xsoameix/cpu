library ieee;
use ieee.std_logic_1164.all;
use work.lib.all;

entity alu_74181_4bit is port (
    control : in  std_logic_vector(7 downto 0);

    a, b    : in  std_logic_vector(3 downto 0);
    cin     : in  std_logic;

    g, p    : out std_logic;
    sum     : out std_logic_vector(3 downto 0);

    -- overflow flag
    v       : out std_logic);
end alu_74181_4bit;

architecture alu_74181_4bit_arch of alu_74181_4bit is
    component block_carry_lookahead_generator is port (
        cin    : in  std_logic;
        g, p   : in  std_logic_vector(3 downto 0);
        c      : out std_logic_vector(2 downto 0);
        co     : out std_logic;
        go, po : out std_logic);
    end component;

    signal g_internal : std_logic_vector(3 downto 0);
    signal p_internal : std_logic_vector(3 downto 0);
    signal c          : std_logic_vector(2 downto 0);
    signal co         : std_logic;

    signal do_arith               : std_logic;
    signal do_and_sub_xnor        : std_logic;
    signal do_add_xor_nand        : std_logic;
    signal do_shl_clr_nor_dec_not : std_logic;
    signal do_inc_nop_and_shl_clr : std_logic;
    signal do_or_add_xor          : std_logic;
    signal do_sub_xnor_nor        : std_logic;
    signal do_nand_dec_not        : std_logic;
    signal do_cin                 : std_logic;
begin
    do_arith               <= control(7);
    do_and_sub_xnor        <= control(6);
    do_add_xor_nand        <= control(5);
    do_shl_clr_nor_dec_not <= control(4);
    do_inc_nop_and_shl_clr <= control(3);
    do_or_add_xor          <= control(2);
    do_sub_xnor_nor        <= control(1);
    do_nand_dec_not        <= control(0);
    g_internal <= --((do_inc  or do_nop  or do_or) and '0') or
                  (repeat(do_and_sub_xnor, 4) and a and not(b)) or
                  (repeat(do_add_xor_nand, 4) and a and b) or
                  (repeat(do_shl_clr_nor_dec_not, 4) and a);
    p_internal <= (repeat(do_inc_nop_and_shl_clr, 4) and a) or
                  (repeat(do_or_add_xor, 4) and (a or b)) or
                  (repeat(do_sub_xnor_nor, 4) and (a or not(b))) or
                  (repeat(do_nand_dec_not, 4));
    block_carry_lookahead_generator_0 : block_carry_lookahead_generator port map (
        cin => cin,
        g => g_internal,
        p => p_internal,
        c => c,
        co => co,
        go => g,
        po => p);
    sum <= g_internal xor
           p_internal xor
           ((c & cin) and repeat(do_arith, 4));
    v <= co xor c(2);
end alu_74181_4bit_arch;
