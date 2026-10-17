library ieee;
use ieee.std_logic_1164.all;

entity FA is
    port (
        A, B, Ci : in  std_logic;
        S, Co    : out std_logic
    );
end entity;

architecture behaviour of FA is
begin
    S <= A xor B xor Ci
    -- pragma synthesis_off
        after 35 ns
    -- pragma synthesis_on
    ;

    Co <= (A and B) or (Ci and A) or (Ci and B)
    -- pragma synthesis_off
        after 30 ns
    -- pragma synthesis_on
    ;
end architecture;
