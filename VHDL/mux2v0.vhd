library ieee;
use ieee.std_logic_1164.all;


entity mux2 is 
    port(
        d0,d1,c :in  std_ulogic;
        r       :out std_ulogic
    );
end mux2;

architecture dataflow of mux2 is
begin
    r <= d0 when c = '0' else d1;
end dataflow;


architecture algorythm of mux2 is 
begin
    sel: process is
    begin
        if c = '0' then
            r <= d0;
        else
            r <= d1;
        end if;
        wait on d0, d1, c;
    end process sel;
end algorythm;            