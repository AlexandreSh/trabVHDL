library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

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
		type tab_ver is record
			clock, data_read, data_write: std_logic;
			data_addr   : std_logic_vector(addr_width-1 downto 0); --16
            data_in     : std_logic_vector(data_width-1 downto 0); --8
            data_out    : std_logic_vector((data_width*4)-1 downto 0); --64
		end record;
		type vet_tab_ver is array (0 to 12) of tab_ver;
		constant tabela_verdade: vet_tab_ver := (
	-- 	  clock,  data_read, data_write,  data_addr,	data_in,   		 data_out
		(	'1'	,	'0'	  ,		'1'		,X"0000" ,		X"00"	,  X"00000000"	),
		(	'0'	,	'0'	  ,		'1'		,X"0000" ,  	X"00"	,  X"00000000"	),  --testa escrita
		(	'1'	,	'0'	  ,		'1'		,X"0000" ,		X"00"	,  X"00000000"	),
		(	'0'	,	'0'	  ,		'1'		,X"0001" ,  	X"11"	,  X"00000000"	),  
		(	'1'	,	'0'	  ,		'1'		,X"0001" ,		X"11"	,  X"00000000"	),
		(	'0'	,	'1'	  ,		'0'		,X"0000" ,		X"00"	,  X"00000010"	),  --testa leitura
		(	'1'	,	'1'	  ,		'0'		,X"0000" ,		X"00"	,  X"00000010"	),
		(	'0'	,	'1'	  ,		'0'		,X"0000" ,		X"00"	,  X"00000010"	), 
		(	'1'	,	'1'	  ,		'0'		,X"0000" ,		X"00"	,  X"00000010"	),
		(	'0'	,	'1'	  ,		'0'		,X"0001" ,		X"00"	,  X"00000011"	),  
		(	'1'	,	'1'	  ,		'0'		,X"0001" ,		X"00"	,  X"00000011"	),
		(	'0'	,	'1'	  ,		'0'		,X"0001" ,		X"00"	,  X"00000011"	),  
		(	'1'	,	'1'	  ,		'0'		,X"0001" ,		X"00"	,  X"00000011"	)		);

		begin 
			for i in vet_tab_ver'range loop
				clock		    <=tabela_verdade(i).clock;
				data_read		<=tabela_verdade(i).data_read;
				data_write	    <=tabela_verdade(i).data_write;
				data_addr	    <=tabela_verdade(i).data_addr;
				data_in	        <=tabela_verdade(i).data_in;
				data_out	        <=tabela_verdade(i).data_out;
				wait for 1 ns;

                report to_String(i);
				if i>=5 then--valida leitura (e também escrita feita anteriormente)
					assert data_out = tabela_verdade(i).data_out report "ERRO";
				end if;
			end loop;
		report "fim de teste";
		wait;
	end process;
	

end architecture;