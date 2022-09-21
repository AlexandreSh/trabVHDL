library ieee;
use ieee.std_logic_1164.all;


entity mux4 is 
    port(
        d0,d1,d2,d3,c0,c1 :in  std_ulogic;
        r                 :out std_ulogic
    );
end mux4;

architecture structural of mux4 is
    signal s0, s1: std_ulogic;
begin
    m0: entity work.mux2(dataflow)
        port map(d0 => d0, d1 => d1, c => c0, r => s0);
    m1: entity work.mux2(dataflow)
        port map(d0 => d2, d1 => d3, c => c0, r => s1);
    m2: entity work.mux2(dataflow)
        port map(d0 => s0, d1 => s1, c => c1, r => r);
end structural;
