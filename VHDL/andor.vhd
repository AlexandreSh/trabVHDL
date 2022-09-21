library ieee;
use ieee.std_logic_1164.all;

entity andor is
    generic (
        N: natural := 6
    );
    port (
        A, B: in std_logic_vector(N-1 downto 0);
        operation: in std_logic;
        S: out std_logic_vector(N-1 downto 0)
    );
end entity;

architecture behavioral of andor is
begin

-- SEU CODIGO AQUI
process is
    variable auxS: std_logic_vector;
    begin    
        if operation = '0' then
            auxS :=  auxA and auxB;
        else
            auxS := auxA or auxb;
        end if;
        S <= auxS;
        wait on A, B, operation;
    end process;
end architecture;
