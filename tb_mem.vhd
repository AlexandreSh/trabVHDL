library ieee, std;
use ieee.std_logic_1164.all;
use IEEE.std_logic_textio.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;
use std.textio.all;

entity tb_mem is
    generic (
        addr_width: natural := 16; -- Memory Address Width (in bits)
        data_width: natural := 8 -- Data Width (in bits)
    );
end entity;

architecture mixed of tb_mem is
	signal clock, data_read, data_write: std_logic;
	signal data_addr: std_logic_vector(addr_width-1 downto 0);
    signal data_in  : std_logic_vector(data_width-1 downto 0);
    signal data_out : std_logic_vector((data_width*4)-1 downto 0);
begin

	mem_uso: entity work.memory(behavioral) 
		port map(clock,data_read,data_write,data_addr,data_in,data_out);

	estimulo: process is
		variable message: line;
		type tab_ver is record
			clock, data_read, data_write: std_logic;
			data_addr   : std_logic_vector(addr_width-1 downto 0); --16
            data_in     : std_logic_vector(data_width-1 downto 0); --8
            data_out    : std_logic_vector((data_width*4)-1 downto 0); --64
		end record;
		type vet_tab_ver is array (0 to 10) of tab_ver;
		constant tabela_verdade: vet_tab_ver := (
	-- 	  clock,  data_read, data_write,  data_addr,	data_in,   		 data_out
		(	'1'	,	'0'	  ,		'1'		,X"0000" ,		X"ff"	,  X"00000000"	),  --testa escrita
		(	'0'	,	'0'	  ,		'1'		,X"0000" ,  	X"ff"	,  X"00000000"	),  
		(	'1'	,	'0'	  ,		'1'		,X"0000" ,		X"ff"	,  X"00000000"	),
		(	'0'	,	'0'	  ,		'1'		,X"0001" ,  	X"11"	,  X"00000000"	),  
		(	'1'	,	'0'	  ,		'1'		,X"0001" ,		X"11"	,  X"00000000"	),
		(	'0'	,	'0'	  ,		'1'		,X"0002" ,  	X"00"	,  X"00000000"	),  
		(	'1'	,	'0'	  ,		'1'		,X"0002" ,		X"00"	,  X"00000000"	),
		(	'0'	,	'0'	  ,		'1'		,X"0003" ,  	X"11"	,  X"00000000"	),  
		(	'1'	,	'0'	  ,		'1'		,X"0003" ,		X"11"	,  X"00000000"	),
		(	'0'	,	'1'	  ,		'0'		,X"0000" ,		X"00"	,  X"110011ff"	),  --testa leitura
		(	'0'	,	'1'	  ,		'0'		,X"0000" ,		X"00"	,  X"110011ff"	)		);

		begin 
			for i in vet_tab_ver'range loop
				deallocate(message);
				clock		    <=tabela_verdade(i).clock;
				data_read		<=tabela_verdade(i).data_read;
				data_write	    <=tabela_verdade(i).data_write;
				data_addr	    <=tabela_verdade(i).data_addr;
				data_in	        <=tabela_verdade(i).data_in;
				wait for 1 ns;
				data_out	        <=tabela_verdade(i).data_out;
				wait for 1 ns;
     --           report to_String(i);
				if i>=9 then--valida leitura (e também escrita feita anteriormente)
					write(message, string'("ERRO NO DATAOUT "));
					write(message, data_out);
					write(message, string'(" recebido mas "));
					write(message, tabela_verdade(i).data_out);
					write(message, string'(" esperado "));
					assert data_out = tabela_verdade(i).data_out report message.all;
				end if;
			end loop;
		report "fim de teste";
		wait;
	end process;
	

end architecture;