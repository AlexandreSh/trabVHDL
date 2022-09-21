library ieee;
use ieee.std_logic_1164.all;

entity shiftrotater is
    port (
        din:    in std_logic_vector(3 downto 0);
        desloc: in std_logic_vector(1 downto 0);
        shift:  in std_logic;
        dout:   out std_logic_vector(3 downto 0)
    );
end entity;

architecture structural of shiftrotater is
    signal aux: std_logic_vector(4 downto 1);
    signal auxin: std_logic_vector(3 downto 0);
    signal auxlogic: std_logic_vector(1 to 3);
begin
---1 a1  5
---2 a2  6
---3 a3  7
---4 a4  8
auxlogic(3) <= ((desloc(0) and shift)or(desloc(1) and shift)or(desloc(0) and shift and desloc(1)));
auxlogic(2) <= ((desloc(1) and shift)or(desloc(0) and shift and desloc(1)));
auxlogic(1) <= (desloc(0) and shift and desloc(1));
min1: entity work.mux2(behavioral)
    port map(i0 => din(3), i1 => '0', sel => auxlogic(3), s => auxin(3));
min2: entity work.mux2(behavioral)
    port map(i0 => din(2), i1 => '0', sel => auxlogic(2), s => auxin(2));
min3: entity work.mux2(behavioral)
    port map(i0 => din(1), i1 => '0', sel => auxlogic(1), s => auxin(1));
min4: entity work.mux2(behavioral)
    port map(i0 => din(0), i1 => din(0), sel => shift, s => auxin(0));
m1: entity work.mux2(behavioral)
    port map(i0 => auxin(3), i1 => auxin(2), sel => desloc(0), s => aux(1));
m2: entity work.mux2(behavioral)
    port map(i0 => auxin(2), i1 => auxin(1), sel => desloc(0), s => aux(2));
m3: entity work.mux2(behavioral)
    port map(i0 => auxin(1), i1 => auxin(0), sel => desloc(0), s => aux(3));
m4: entity work.mux2(behavioral)
    port map(i0 => auxin(0), i1 => auxin(3), sel => desloc(0), s => aux(4));
m5: entity work.mux2(behavioral)
    port map(i0 => aux(1), i1 => aux(3), sel => desloc(1), s => dout(3));
m6: entity work.mux2(behavioral)
    port map(i0 => aux(2), i1 => aux(4), sel => desloc(1), s => dout(2));
m7: entity work.mux2(behavioral)
    port map(i0 => aux(3), i1 => aux(1), sel => desloc(1), s => dout(1));
m8: entity work.mux2(behavioral)
    port map(i0 => aux(4), i1 => aux(2), sel => desloc(1), s => dout(0));
end architecture;
