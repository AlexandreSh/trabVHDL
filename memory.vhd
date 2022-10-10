--tá dando problema pro testbench na parte de concatenar para o data_out (linha 37 daqui), talvez o erro esteja na linha 21

library ieee;
use ieee.std_logic_1164.all;
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
        subtype byte is std_logic_vector(7 downto 0);
        type bytes is array (byte'range) of std_logic_vector; 
        variable mem    : bytes(open)((addr_width*4)-1 downto 0);
    begin
        loop     
            wait on data_read, data_write, clock;
            if (data_read = '1' and data_write = '0') then  --lê a memoria

                data_out <= mem(to_integer(unsigned(data_addr)) + 3) & 
                            mem(to_integer(unsigned(data_addr)) + 2) & 
                            mem(to_integer(unsigned(data_addr)) + 1) & 
                            mem(to_integer(unsigned(data_addr)) + 0);

            elsif (data_read = '0' and data_write = '1' and falling_edge(clock)) then --escreve na memoria
              --  for i in data_in'range loop  
                    mem(to_integer(unsigned(data_addr))) := data_in; --compilou assim, mas acho que este loop é muita coisa só pra um ciclo de clock
            --    end loop;
           --     mem(to_integer(unsigned(data_addr))) := data_in(data_width-1 downto 0); --isso aqui não vai compilar
            end if;        

        end loop;
    end process;

end behavioral;