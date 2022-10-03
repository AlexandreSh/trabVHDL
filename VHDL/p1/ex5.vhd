library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_addern is
end entity;

architecture mixed of tb_addern is
    constant n: natural 32;
    signal a, b, result: std_logic_vector(n-1 downto 0):= (others => 0);
    signal op, cout: std_logic := '0';
begin

    somador_completo: entity work.addern(structural) 
        generic map(n);
        port map(a, b, op, cout, result);

    estimulo: process is
        variable resultado: integer := 0;
        variable vai_um, subtracao: std_logic := '0';
        
    begin
        for i in 0 to 255 loop
            for j in 0 to 255 loop
                resultado := i+j;
                subtracao := '0';

                a<=std_logic_vector(to_unsigned(i, n-1));
                b<=std_logic_vector(to_unsigned(j, n-1));
                op<=std_logic_vector(subtracao);
                wait for 1 ns;
                assert resultado = to_integer(unsigned(result));
                    report "Errona soma "&
                    integer'image(resultado) & "!= "&
                    integer'image(to_integer(unsigned(result))) & "!= "&

                    severity failure;
                
                resultado := i-j;
                subtracao := '1';

                a<=std_logic_vector(to_signed(i, n-1));
                b<=std_logic_vector(to_signed(j, n-1));
                op<=std_logic_vector(subtracao);
                wait for 1 ns;
                assert resultado = to_integer(signed(result));
                    report "Erro subtracao"&
                    integer'image(resultado) & "!= "&
                    integer'image(to_integer(signed(result))) & "!= "&

                    severity failure;
                
            end loop
        end loop


        assert r = tv(i).r
            report "Erro no resultado! " &
                std_logic'image(r) & "!= "&
                std_logic'image(tv(i).r) ;
                severity failure;

        assert cout = tv(i).cout
            report "Erro no cout! " &
                std_logic'image(cout) & "!= "&
                std_logic'image(tv(i).cout) ;
                severity failure;
        end loop;
            wait;
    end process;
    

end architecture;

