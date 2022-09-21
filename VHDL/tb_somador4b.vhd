library ieee;
use ieee.std_logic_1164.all;

entity tb_somador4b is
end;

architecture mixed of tb_somador4b is
    signal cin, cout: std_logic;
    signal a, b, s: std_logic_vector(3 downto 0);
begin
    m2: entity work.somador4b(structural)
        port map (a, b, cin, s, cout);
    estimulo_checagem: process is
        type linha_tv is record 
            a, b: std_logic_vector(3 downto 0);
            cin: std_logic;
            s: std_logic_vector(3 downto 0);
            cout: std_logic;
        end record;
        type vet_linha_tv is array(0 to 3) of linha_tv;
        constant tabela_verdade : vet_linha_tv :=
------------a         b    cin?   sum      cout
(       ("0000",   "0000", '0',  "0000",   '0'),              
        ("0011",   "0011", '0',  "0110",   '0'),                 
        ("0101",   "0011", '0',  "1000",   '0'),              
        ("1111",   "0001", '0',  "0000",   '1'));

        begin 
            for i in tabela_verdade'range loop
                a   <= tabela_verdade(i).a  ;
                b   <= tabela_verdade(i).b  ;
                cin <= tabela_verdade(i).cin;
                
                wait for 1 ns;

                assert s = tabela_verdade(i).s report "ERRO NA SOMA";
                assert cout = tabela_verdade(i).cout report "ERRO NO CARRY";
            end loop;
        report "fim de teste";
    wait;
    end process estimulo_checagem;

end;