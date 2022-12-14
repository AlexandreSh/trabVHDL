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
        data_read : in std_logic; -- When '1', read data from memory
        data_write: in std_logic; -- When '1', write data to memory
        -- Data address given to memory
        data_addr : in std_logic_vector(addr_width-1 downto 0);
        -- Data sent from memory when data_read = '1' and data_write = '0'
        data_in : in std_logic_vector(data_width-1 downto 0);
        -- Data sent to memory when data_read = '0' and data_write = '1'
        data_out : out std_logic_vector((data_width*4)-1 downto 0)
    );
end entity;

architecture behavioral of memory is
begin
    process(data_read, data_write, clock)
        subtype byte is integer in range 0 to 8;
        type mem is array (byte) of std_logic;
        variable memoria: mem;

        begin
            if(data_read = '1' and data_write = '0') then -- LEITURA
                data_out <= memoria(to_integer(unsigned(data_addr)) + 3) & memoria(to_integer(unsigned(data_addr)) + 2) & memoria(to_integer(unsigned(data_addr)) + 1) & memoria(to_integer(unsigned(data_addr)));
            else if(data_read = '0' and data_write = '1'  and falling_edge(clock)) then -- ESCRITA   
                memoria(to_integer(unsigned(data_addr))) := data_in;
            end if;

    end process proc_name;

end architecture;