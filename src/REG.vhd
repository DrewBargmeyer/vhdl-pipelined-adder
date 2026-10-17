--- REGISTER
library ieee;
use ieee.std_logic_1164.all;

entity REG is
port(
    D, CLK, RSTn : in std_logic;
    Q            : out std_logic
);
end entity;

architecture behaviour of REG is
begin
    process(CLK)
    begin
        if (rising_edge(CLK)) then
            if(RSTn = '1') then
                Q <= '0';
            else
                Q <= D;
            end if;
        end if;
    end process;
end architecture;
