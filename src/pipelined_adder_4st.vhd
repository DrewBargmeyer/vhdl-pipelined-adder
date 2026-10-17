library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity pipelined_adder is
    generic (
        N : integer := 8  -- 8-bit pipelined adder
    );
    port (
        A        : in  STD_LOGIC_VECTOR (N-1 downto 0);
        B        : in  STD_LOGIC_VECTOR (N-1 downto 0);
        Ci       : in  STD_LOGIC;
        S        : out STD_LOGIC_VECTOR (N downto 0);
        CLK, RSTn : in  STD_LOGIC
    );
end pipelined_adder;

architecture Behavioral of pipelined_adder is

    -- Component Declarations
    component FA
        port (
            A, B, Ci : in  STD_LOGIC;
            S, Co    : out STD_LOGIC
        );
    end component;

    component REG
        port (
            D, CLK, RSTn : in  std_logic;
            Q            : out std_logic
        );
    end component;

    -- Signal Declarations
    signal Co       : std_logic;
    signal tmp_cout : std_logic_vector(11 downto 1);
    signal tmp_S0   : std_logic_vector(3 downto 0);
    signal tmp_S1   : std_logic_vector(3 downto 0);
    signal tmp_S2   : std_logic_vector(2 downto 0);
    signal tmp_S3   : std_logic_vector(2 downto 0);
    signal tmp_S4   : std_logic_vector(1 downto 0);
    signal tmp_S5   : std_logic_vector(1 downto 0);
    signal tmp_S6   : std_logic;
    signal tmp_S7   : std_logic;
    signal tmp_A2   : std_logic;
    signal tmp_B2   : std_logic;
    signal tmp_A3   : std_logic;
    signal tmp_B3   : std_logic;
    signal tmp_A4   : std_logic_vector(1 downto 0);
    signal tmp_B4   : std_logic_vector(1 downto 0);
    signal tmp_A5   : std_logic_vector(1 downto 0);
    signal tmp_B5   : std_logic_vector(1 downto 0);
    signal tmp_A6   : std_logic_vector(2 downto 0);
    signal tmp_B6   : std_logic_vector(2 downto 0);
    signal tmp_A7   : std_logic_vector(2 downto 0);
    signal tmp_B7   : std_logic_vector(2 downto 0);

begin

    --- 1st Full Adder (Bit 0)
    FA_0: FA port map (A(0), B(0), Ci, tmp_S0(0), tmp_cout(1));
    reg_s0_0: REG port map(tmp_S0(0), CLK, RSTn, tmp_S0(1));
    reg_s0_1: REG port map(tmp_S0(1), CLK, RSTn, tmp_S0(2));
    reg_s0_2: REG port map(tmp_S0(2), CLK, RSTn, tmp_S0(3));
    reg_s0_3: REG port map(tmp_S0(3), CLK, RSTn, S(0));

    --- 2nd Full Adder (Bit 1)
    FA_1: FA port map(A(1), B(1), tmp_cout(1), tmp_S1(0), tmp_cout(2));
    reg_s1_0: REG port map(tmp_S1(0), CLK, RSTn, tmp_S1(1));
    reg_s1_1: REG port map(tmp_S1(1), CLK, RSTn, tmp_S1(2));
    reg_s1_2: REG port map(tmp_S1(2), CLK, RSTn, tmp_S1(3));
    reg_s1_3: REG port map(tmp_S1(3), CLK, RSTn, S(1));
    reg_cou3: REG port map(tmp_cout(2), CLK, RSTn, tmp_cout(3));

    --- 3rd Full Adder (Bit 2)
    reg_A2: REG port map(A(2), CLK, RSTn, tmp_A2);
    reg_B2: REG port map(B(2), CLK, RSTn, tmp_B2);
    FA_2: FA port map(tmp_A2, tmp_B2, tmp_cout(3), tmp_S2(0), tmp_cout(4));
    reg_s2_0: REG port map(tmp_S2(0), CLK, RSTn, tmp_S2(1));
    reg_s2_1: REG port map(tmp_S2(1), CLK, RSTn, tmp_S2(2));
    reg_s2_2: REG port map(tmp_S2(2), CLK, RSTn, S(2));

    --- 4th Full Adder (Bit 3)
    reg_A3: REG port map(A(3), CLK, RSTn, tmp_A3);
    reg_B3: REG port map(B(3), CLK, RSTn, tmp_B3);
    FA_3: FA port map(tmp_A3, tmp_B3, tmp_cout(4), tmp_S3(0), tmp_cout(5));
    reg_s3_0: REG port map(tmp_S3(0), CLK, RSTn, tmp_S3(1));
    reg_s3_1: REG port map(tmp_S3(1), CLK, RSTn, tmp_S3(2));
    reg_s3_2: REG port map(tmp_S3(2), CLK, RSTn, S(3));
    reg_cou6: REG port map(tmp_cout(5), CLK, RSTn, tmp_cout(6));

    --- 5th Full Adder (Bit 4)
    reg_A4_0: REG port map(A(4), CLK, RSTn, tmp_A4(0));
    reg_B4_0: REG port map(B(4), CLK, RSTn, tmp_B4(0));
    reg_A4_1: REG port map(tmp_A4(0), CLK, RSTn, tmp_A4(1));
    reg_B4_1: REG port map(tmp_B4(0), CLK, RSTn, tmp_B4(1));
    FA_4: FA port map(tmp_A4(1), tmp_B4(1), tmp_cout(6), tmp_S4(0), tmp_cout(7));
    reg_s4_0: REG port map(tmp_S4(0), CLK, RSTn, tmp_S4(1));
    reg_s4_1: REG port map(tmp_S4(1), CLK, RSTn, S(4));

    --- 6th Full Adder (Bit 5)
    reg_A5_0: REG port map(A(5), CLK, RSTn, tmp_A5(0));
    reg_B5_0: REG port map(B(5), CLK, RSTn, tmp_B5(0));
    reg_A5_1: REG port map(tmp_A5(0), CLK, RSTn, tmp_A5(1));
    reg_B5_1: REG port map(tmp_B5(0), CLK, RSTn, tmp_B5(1));
    FA_5: FA port map(tmp_A5(1), tmp_B5(1), tmp_cout(7), tmp_S5(0), tmp_cout(8));
    reg_s5_0: REG port map(tmp_S5(0), CLK, RSTn, tmp_S5(1));
    reg_s5_1: REG port map(tmp_S5(1), CLK, RSTn, S(5));
    reg_cou9: REG port map(tmp_cout(8), CLK, RSTn, tmp_cout(9));

    --- 7th Full Adder (Bit 6)
    reg_A6_0: REG port map(A(6), CLK, RSTn, tmp_A6(0));
    reg_B6_0: REG port map(B(6), CLK, RSTn, tmp_B6(0));
    reg_A6_1: REG port map(tmp_A6(0), CLK, RSTn, tmp_A6(1));
    reg_B6_1: REG port map(tmp_B6(0), CLK, RSTn, tmp_B6(1));
    reg_A6_2: REG port map(tmp_A6(1), CLK, RSTn, tmp_A6(2));
    reg_B6_2: REG port map(tmp_B6(1), CLK, RSTn, tmp_B6(2));
    FA_6: FA port map(tmp_A6(2), tmp_B6(2), tmp_cout(9), tmp_S6, tmp_cout(10));
    reg_s6: REG port map(tmp_S6, CLK, RSTn, S(6));

    --- 8th Full Adder (Bit 7)
    reg_A7_0: REG port map(A(7), CLK, RSTn, tmp_A7(0));
    reg_B7_0: REG port map(B(7), CLK, RSTn, tmp_B7(0));
    reg_A7_1: REG port map(tmp_A7(0), CLK, RSTn, tmp_A7(1));
    reg_B7_1: REG port map(tmp_B7(0), CLK, RSTn, tmp_B7(1));
    reg_A7_2: REG port map(tmp_A7(1), CLK, RSTn, tmp_A7(2));
    reg_B7_2: REG port map(tmp_B7(1), CLK, RSTn, tmp_B7(2));
    FA_7: FA port map(tmp_A7(2), tmp_B7(2), tmp_cout(10), tmp_S7, tmp_cout(11));
    reg_s7: REG port map(tmp_S7, CLK, RSTn, S(7));
    reg_cou12: REG port map(tmp_cout(11), CLK, RSTn, Co);

    S(N) <= Co;

end Behavioral;
