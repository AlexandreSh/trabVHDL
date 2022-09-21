library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity addsub is
    generic (
        N: natural := 8
    );
    port (
        A, B: in std_logic_vector(N-1 downto 0);
        operation: in std_logic;
        S: out std_logic_vector(N-1 downto 0)
    );
    
end entity;

architecture behavioral of addsub is
begin

-- SEU CÓDIGO AQUI
--select: entity work.multiplex2x1(behavioral)
--    port map(input0 => A, input1 => B, sel => operation, s => s);
    process is
    variable auxA, auxB, auxS: integer;
    begin    
        auxA := to_integer(signed(A));
        auxB := to_integer(signed(B));
        if operation = '0' then
            auxS :=  auxA+auxB;
        else
            auxS := auxA-auxb;
        end if;
        S <= std_logic_vector(to_signed(auxS,N));
        wait on A, B, operation;
    end process;
end architecture;