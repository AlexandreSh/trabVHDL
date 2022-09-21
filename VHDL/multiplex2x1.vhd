library ieee;
use ieee.std_logic_1164.all;

entity multiplex2x1 is
    generic (
        N: natural := 4
    );
    port (
        input0, input1: in std_logic_vector(N-1 downto 0);
        sel: in std_logic;
        output: out std_logic_vector(N-1 downto 0)
    );
end entity;

architecture behavioral of multiplex2x1 is
begin
    select: process is 
    begin 
        if select = '0' then
            output <= input0;
        else
            output <= input1;
        end if;
        wait on input0, input1, sel;
    end process sel;
end behavioral;
