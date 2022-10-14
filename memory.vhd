library ieee, std;
use ieee.std_logic_1164.all;
use IEEE.std_logic_textio.all;
use std.textio.all;
use ieee.numeric_std.all;

entity memory is
    generic (
        addr_width: natural := 16; -- Memory Address Width (in bits)
        data_width: natural := 8 -- Data Width (in bits)
    );
    port (
        clock: in std_logic; -- Clock signal; Write on Falling-Edge
        data_read       : in std_logic; -- When '1', read data from memory
        data_write      : in std_logic; -- When '1', write data to memory
        -- Data address given to memory
        data_addr       : in std_logic_vector(addr_width-1 downto 0);
        -- Data sent from memory when data_read = '1' and data_write = '0'
        data_in         : in std_logic_vector(data_width-1 downto 0);
        -- Data sent to memory when data_read = '0' and data_write = '1'
        data_out        : out std_logic_vector((data_width*4)-1 downto 0)
    );
end entity;

architecture behavioral of memory is
begin
    process 
        subtype byte        is std_logic_vector(7 downto 0);
        subtype endereco    is integer range addr_width-1 downto 0;
        type t_mem          is array(endereco) of byte;
        variable mem        : t_mem;
        variable aux_out    : std_logic_vector((data_width*4)-1 downto 0);
        variable auxint_endr: integer;
        alias byte_tres     is aux_out(31 downto 24); --"fatia" a saída em 4, como faz se não for tamanho genérico? não faz.
        alias byte_dois     is aux_out(23 downto 16);
        alias byte_um       is aux_out(15 downto 8);
        alias byte_zero     is aux_out(7 downto 0);
    begin
        for i in mem'range loop --inicializa a memoria em 0
            mem(i) := X"00";
        end loop;
        loop  
            
            wait on data_read, data_write, clock;
            if (data_read = '1' and data_write = '0') then  --lê a memoria
                auxint_endr := to_integer(unsigned(data_addr)); --rotina de escrita nas 4 fatias da saída
                byte_zero   := mem(auxint_endr);
                auxint_endr := auxint_endr +1;
                byte_um := mem(auxint_endr);
                auxint_endr := auxint_endr +1;
                byte_dois := mem(auxint_endr);
                auxint_endr := auxint_endr +1;
                byte_tres  := mem(auxint_endr);
                --report to_string(aux_out);
                data_out <= aux_out;           
            elsif (data_read = '0' and data_write = '1' and falling_edge(clock)) then --escreve na memoria
                mem(to_integer(unsigned(data_addr))) := data_in; 
				assert mem(to_integer(unsigned(data_addr))) = data_in report "NAO ESCREVEU"; --testa a escrita
            end if;        
        end loop;

    end process;

end behavioral;