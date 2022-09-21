library ieee;
use ieee.std_logic_1164.all;

entity tb_somador1b is
end;

architecture mixed of tb_somador1b is
    signal a, b, cin, sum, cout: std_ulogic;
begin
    m2: entity work.somador1b(behavioural)
        port map (a, b, cin, sum, cout);
    estimulo_checagem: process is
        type linha_tv is record 
            a, b, cin, s, cout: std_ulogic;
        end record;
        type vet_linha_tv is array(0 to 7) of linha_tv;
        constant tabela_verdade : vet_linha_tv :=
---------a       b     cin    sum    cout
(       ('0',   '0',   '0',   '0',   '0'),              
        ('0',   '0',   '1',   '1',   '0'),              
        ('0',   '1',   '0',   '1',   '0'),              
        ('0',   '1',   '1',   '0',   '1'),              
        ('1',   '0',   '0',   '1',   '0'),              
        ('1',   '0',   '1',   '0',   '1'),              
        ('1',   '1',   '0',   '0',   '1'),              
        ('1',   '1',   '1',   '1',   '1'));

        begin 
            for i in tabela_verdade'range loop
                a   <= tabela_verdade(i).a  ;
                b   <= tabela_verdade(i).b  ;
                cin <= tabela_verdade(i).cin;
                
                wait for 1 ns;

                assert sum = tabela_verdade(i).sum report "ERRO NA SOMA";
                assert cout = tabela_verdade(i).cout report "ERRO NO CARRY";
            end loop;
        report "fim de teste";
    wait;
    end process estimulo_checagem;

end;