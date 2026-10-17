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
    signal tmp_cout : std_logic_vector(9 downto 1);
    signal tmp_S0   : std_logic_vector(1 downto 0);
    signal tmp_S1   : std_logic_vector(1 downto 0);
    signal tmp_S2   : std_logic_vector(1 downto 0);
    signal tmp_S3   : std_logic_vector(1 downto 0);
    signal tmp_S4   : std_logic;
    signal tmp_S5   : std_logic;
    signal tmp_S6   : std_logic;
    signal tmp_S7   : std_logic;
    signal tmp_A4   : std_logic;
    signal tmp_B4   : std_logic;
    signal tmp_A5   : std_logic;
    signal tmp_B5   : std_logic;
    signal tmp_A6   : std_logic;
    signal tmp_B6   : std_logic;
    signal tmp_A7   : std_logic;
    signal tmp_B7   : std_logic;

begin

    --- 1st Full Adder (Bit 0)
    FA_0: FA port map(A(0), B(0), Ci, tmp_S0(0), tmp_cout(1));
    reg_s0_0: REG port map(tmp_S0(0), CLK, RSTn, tmp_S0(1));
    reg_s0_1: REG port map(tmp_S0(1), CLK, RSTn, S(0));

    --- 2nd Full Adder (Bit 1)
    FA_1: FA port map(A(1), B(1), tmp_cout(1), tmp_S1(0), tmp_cout(2));
    reg_s1_0: REG port map(tmp_S1(0), CLK, RSTn, tmp_S1(1));
    reg_s1_1: REG port map(tmp_S1(1), CLK, RSTn, S(1));

    --- 3rd Full Adder (Bit 2)
    FA_2: FA port map(A(2), B(2), tmp_cout(2), tmp_S2(0), tmp_cout(3));
    reg_s2_0: REG port map(tmp_S2(0), CLK, RSTn, tmp_S2(1));
    reg_s2_1: REG port map(tmp_S2(1), CLK, RSTn, S(2));

    --- 4th Full Adder (Bit 3)
    FA_3: FA port map(A(3), B(3), tmp_cout(3), tmp_S3(0), tmp_cout(4));
    reg_s3_0: REG port map(tmp_S3(0), CLK, RSTn, tmp_S3(1));
    reg_s3_1: REG port map(tmp_S3(1), CLK, RSTn, S(3));
    reg_cou3: REG port map(tmp_cout(4), CLK, RSTn, tmp_cout(5));

    --- Pipeline Stage Boundary ---

    --- 5th Full Adder (Bit 4)
    reg_A4: REG port map (A(4), CLK, RSTn, tmp_A4);
    reg_B4: REG port map (B(4), CLK, RSTn, tmp_B4);
    FA_4: FA port map(tmp_A4, tmp_B4, tmp_cout(5), tmp_S4, tmp_cout(6));
    reg_s4: REG port map(tmp_S4, CLK, RSTn, S(4));

    --- 6th Full Adder (Bit 5)
    reg_A5: REG port map (A(5), CLK, RSTn, tmp_A5);
    reg_B5: REG port map (B(5), CLK, RSTn, tmp_B5);
    FA_5: FA port map(tmp_A5, tmp_B5, tmp_cout(6), tmp_S5, tmp_cout(7));
    reg_s5: REG port map(tmp_S5, CLK, RSTn, S(5));

    --- 7th Full Adder (Bit 6)
    reg_A6: REG port map(A(6), CLK, RSTn, tmp_A6);
    reg_B6: REG port map(B(6), CLK, RSTn, tmp_B6);
    FA_6: FA port map(tmp_A6, tmp_B6, tmp_cout(7), tmp_S6, tmp_cout(8));
    reg_s6: REG port map(tmp_S6, CLK, RSTn, S(6));

    --- 8th Full Adder (Bit 7)
    reg_A7: REG port map(A(7), CLK, RSTn, tmp_A7);
    reg_B7: REG port map(B(7), CLK, RSTn, tmp_B7);
    FA_7: FA port map(tmp_A7, tmp_B7, tmp_cout(8), tmp_S7, tmp_cout(9));
    reg_s7: REG port map(tmp_S7, CLK, RSTn, S(7));
    reg_cou7: REG port map(tmp_cout(9), CLK, RSTn, Co);

    S(N) <= Co;

end Behavioral;
