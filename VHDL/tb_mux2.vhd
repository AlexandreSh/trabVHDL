library ieee;
use ieee.std_logic_1164.all;

entity tb_mux2 is
end;

architecture mixed of tb_mux2 is
    signal a, b, sel, result: std_ulogic;
begin
    m2 : entity work.mux2(dataflow)
        port map (a, b, sel, result);
    estimulo_checagem: process is
        type linha_tv is record
            a, b, sel, result: std_ulogic;
        end record;
        type vet_linha_tv is array (0 to 7) of linha_tv;
        constant tabela_verdade : vet_linha_tv :=
--------d0     d1    c     r
(      ('0',  '0',  '0',  '0'),        
       ('0',  '0',  '1',  '0'),        
       ('0',  '1',  '0',  '0'),        
       ('0',  '1',  '1',  '1'),        
       ('1',  '0',  '0',  '1'),        
       ('1',  '0',  '1',  '0'),        
       ('1',  '1',  '0',  '1'),        
       ('1',  '1',  '1',  '1'));
       
    begin

        for i in tabela_verdade'range loop
            a   <= tabela_verdade(i).a  ;
            b   <= tabela_verdade(i).b  ;
            sel <= tabela_verdade(i).sel;
            
            wait for 1 ns;

            assert result = tabela_verdade(i).result report "Erro: " &  "entradas" &
            std_ulogic'image(a) & "," &
            std_ulogic'image(b) & "," &
            std_ulogic'image(sel) & "," &
            "saida " &
            std_ulogic'image(result) & "," & "diferente" &
            std_ulogic'image(tabela_verdade(i).result);
        end loop;

        report "Fim dos testes";


        wait;
    end process estimulo_checagem;
end;    
