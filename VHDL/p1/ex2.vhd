library ieee;
use ieee.std_logic_1164.all;

entity tb_adder1 is
end entity;

architecture mixed of tb_adder1 is
    signal a, b, cin, r, cout: std_logic := '0';
begin

    somador: entity work.adder1(dataflow)
        port map(a, b, cin, r, cout);

    estimulo: process is
    begin
        type linha_tv  is record
            a, b, cin, r, cout: std_logic;
        end record
        type vetor_tv is array (0 to 7) of linha_tv;
        constant tv : vetor_tv := (
            ('0', '0', '0', '0', '0'),
            ('0', '0', '1', '1', '0'),
            ('0', '1', '0', '1', '0'),
            ('0', '1', '1', '0', '1'),
            ('1', '0', '0', '1', '0'),
            ('1', '0', '1', '0', '1'),
            ('1', '1', '0', '0', '1'),
            ('1', '1', '1', '1', '1'),
        )        
    begin
        for i in tv'range loop
            a <= tv(i).a;
            b <= tv(i).b;
            cin <= tv(i).cin;
            wait for 1 ns;

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

