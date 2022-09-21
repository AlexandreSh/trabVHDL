library ieee;
use ieee.std_logic_1164.all;

entity mux2 is
    port (
        i0, i1: in std_logic;
        sel: in std_logic;
        s: out std_logic
    );
end entity;

architecture dataflow of mux2 is 
begin
        r<= i0 when sel = '0' else i1
end dataflow;

architecture behavioral of mux2 is 
begin
    sel: process is 
    begin 
        if sel = '0' then
            s <= i0;
        else
            s <= i1;
        end if;
        wait on i0, i1, sel;
    end process sel;
end behavioral;

end architecture;
