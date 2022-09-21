library ieee;
use ieee.std_logic_1164.all;

entity tb_mux4 is
end;

architecture mixed of tb_mux4 is
    signal a, b, c, d, sel1, sel2, result: std_ulogic;
begin
    m2 : entity work.mux4(structural)
        port map (a, b, c, d, sel1, sel2, result);
    estimulo_checagem: process is
        type linha_tv is record
            a, b, c, d, sel1, sel2, result: std_ulogic;
        end record;
        type vet_linha_tv is array (0 to 15) of linha_tv;
        constant tabela_verdade : vet_linha_tv :=
--------d0     d1    d2    d3    s1    s2     r
(       ('0',  '0',  '0',  '0',  '0',  '0',  '0'), --0        
        ('0',  '0',  '0',  '1',  '0',  '1',  '0'), --1       
        ('0',  '0',  '1',  '0',  '1',  '0',  '1'), --2       
        ('0',  '0',  '1',  '1',  '1',  '1',  '1'), --3       
        ('0',  '1',  '0',  '0',  '0',  '0',  '0'), --0       
        ('0',  '1',  '0',  '1',  '0',  '1',  '1'), --1       
        ('0',  '1',  '1',  '0',  '1',  '0',  '1'), --2       
        ('0',  '1',  '1',  '1',  '1',  '1',  '1'), --3       
        ('1',  '0',  '0',  '0',  '0',  '0',  '1'), --0       
        ('1',  '0',  '0',  '1',  '0',  '1',  '0'), --1       
        ('1',  '0',  '1',  '0',  '1',  '0',  '1'), --2       
        ('1',  '0',  '1',  '1',  '1',  '1',  '1'), --3       
        ('1',  '1',  '0',  '0',  '0',  '0',  '1'), --0       
        ('1',  '1',  '0',  '1',  '0',  '1',  '1'), --1       
        ('1',  '1',  '1',  '0',  '1',  '0',  '1'), --2       
        ('1',  '1',  '1',  '1',  '1',  '1',  '1'));--3
            
    begin

        for i in tabela_verdade'range loop
            a   <= tabela_verdade(i).a   ;
            b   <= tabela_verdade(i).b   ;
            c   <= tabela_verdade(i).c   ;
            d   <= tabela_verdade(i).d   ;
            sel1<= tabela_verdade(i).sel1;
            sel2<= tabela_verdade(i).sel2;
            
            wait for 1 ns;

            assert result = tabela_verdade(i).result report "Erro:" ;-- &  "entradas" &
--            std_ulogic'image(a) & "," &
  --          std_ulogic'image(b) & "," &
    --        std_ulogic'image(sel) & "," &
      --      "saida " &
        --    std_ulogic'image(result) & "," & "diferente" &
          --  std_ulogic'image(tabela_verdade(i).result);
        end loop;

        report "Fim dos testes";


        wait;
    end process estimulo_checagem;
end;