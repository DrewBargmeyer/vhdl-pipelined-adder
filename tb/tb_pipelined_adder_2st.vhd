library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_pipelined_adder is
    generic(
        N : integer := 8  -- 8-bit pipelined adder
    );
    Port ();
end tb_pipelined_adder;

architecture Behavioral of tb_pipelined_adder is

    component pipelined_adder is
        generic(
            N : integer := 8
        );
        Port (
            A         : in  STD_LOGIC_VECTOR (N-1 downto 0);
            B         : in  STD_LOGIC_VECTOR (N-1 downto 0);
            Ci        : in  STD_LOGIC;
            S         : out STD_LOGIC_VECTOR (N downto 0);
            Co        : out STD_LOGIC;
            CLK, RSTn : in  STD_LOGIC
        );
    end component;

    -- Signals
    signal A, B : std_logic_vector (N-1 downto 0) := (others => '0');
    signal Ci   : std_logic := '0';
    signal clk  : std_logic := '0';
    signal rst  : std_logic := '1';
    signal Sum  : std_logic_vector (N downto 0);
    signal Co   : std_logic;

    -- Clock & Pipeline Parameters
    constant clk_period : time := 144 ns; -- Minimum clock period for Case 1
    constant P          : integer := 2;   -- Number of pipeline stages

begin

    -- Instantiate Device Under Test
    UUT: pipelined_adder 
        generic map (N => 8) 
        port map (
            A    => A, 
            B    => B, 
            Ci   => Ci, 
            S    => Sum, 
            CLK  => clk, 
            RSTn => rst
        );

    -- Clock Process
    clk_process: process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- Stimulus Process
    stim_proc: process
    begin
        -- Reset state
        rst <= '1';
        A   <= "00000000";
        B   <= "00000000";
        Ci  <= '0';
        wait for clk_period;

        -- Test Case 1: 37 + 121, Ci = 0
        rst <= '0';
        A   <= "00100101"; -- 37
        B   <= "01111001"; -- 121
        Ci  <= '0';
        wait for (P) * clk_period;

        -- Test Case 2: 37 + 121, Ci = 1
        rst <= '0';
        A   <= "00100101"; -- 37
        B   <= "01111001"; -- 121
        Ci  <= '1';
        wait for (P) * clk_period;

        -- Test Case 3: 37 + 249, Ci = 0
        rst <= '0';
        A   <= "00100101"; -- 37
        B   <= "11111001"; -- 249
        Ci  <= '0';
        wait for (P) * clk_period;

        -- Test Case 4: 37 + 249, Ci = 1
        rst <= '0';
        A   <= "00100101"; -- 37
        B   <= "11111001"; -- 249
        Ci  <= '1';
        wait for (P) * clk_period;

        -- Test Case 5: 211 + 121, Ci = 0
        rst <= '0';
        A   <= "11010011"; -- 211
        B   <= "01111001"; -- 121
        Ci  <= '0';
        wait for (P) * clk_period;

        -- Test Case 6: 211 + 121, Ci = 1
        rst <= '0';
        A   <= "11010011"; -- 211
        B   <= "01111001"; -- 121
        Ci  <= '1';
        wait for (P) * clk_period;

        -- Test Case 7: 211 + 249, Ci = 0
        rst <= '0';
        A   <= "11010011"; -- 211
        B   <= "11111001"; -- 249
        Ci  <= '0';
        wait for (P) * clk_period;

        -- Test Case 8: 211 + 249, Ci = 1
        rst <= '0';
        A   <= "11010011"; -- 211
        B   <= "11111001"; -- 249
        Ci  <= '1';
        wait for (P) * clk_period;

        std.env.finish;
    end process;

end Behavioral;
