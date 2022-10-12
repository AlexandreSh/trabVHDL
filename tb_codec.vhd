library ieee, std;
use ieee.std_logic_1164.all;
use IEEE.std_logic_textio.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;
use std.textio.all;

entity tb_testearquivo is
end entity;

architecture mixed of tb_testearquivo is
	subtype dados1byte is std_logic_vector(7 downto 0); --vou precisar de declarar aquivo aqui?
	signal interrupt, read_signal, write_signal, valid: std_logic;
	signal codec_data_in, codec_data_out: std_logic_vector(7 downto 0);
	
begin

	codec_uso: entity work.codec(behavioral) 
		port map(interrupt, read_signal, write_signal, valid, codec_data_in, codec_data_out);

	estimulo: process is
        variable L: line;
        file arq_entrada: text is "/home/alex/Documents/LabHardware/T1/trabVHDL/entrada_codec.dat";
        file arq_saida: text is "/home/alex/Documents/LabHardware/T1/trabVHDL/saida_codec.dat";
	--	variable resultado: dados1byte;
		type tab_ver is record
			interrupt, read_signal, write_signal, valid: std_logic;
			codec_data_in, codec_data_out: std_logic_vector(7 downto 0); 
		end record;
		type vet_tab_ver is array (0 to 15) of tab_ver;
		constant tabela_verdade: vet_tab_ver := (
	--	interrupt, read_signal, write_signal, valid, codec_data_in, codec_data_out	
		(	'1'	,	'1'		  ,		'0'		,	'1'	,"00000000"	,  "11111111"	),
		(	'0'	,	'1'		  ,		'0'		,	'1'	,"00000000"	,  "11111111"	),
		(	'1'	,	'1'		  ,		'0'		,	'1'	,"00000000"	,  "11111111"	),
		(	'0'	,	'1'		  ,		'0'		,	'1'	,"00000000"	,  "11111111"	),
		(	'1'	,	'0'		  ,		'1'		,	'1'	,"11111111"	,  "00000000"	),
		(	'0'	,	'0'		  ,		'1'		,	'1'	,"11111111"	,  "00000000"	),
		(	'1'	,	'0'		  ,		'1'		,	'1'	,"11111111"	,  "00000000"	),
		(	'0'	,	'0'		  ,		'1'		,	'1'	,"11111111"	,  "00000000"	),
		(	'1'	,	'1'		  ,		'1'		,	'0'	,"11111111"	,  "00000000"	), --daqui pra baixo testa entradas invalidas
		(	'0'	,	'1'		  ,		'1'		,	'0'	,"11111111"	,  "00000000"	),
		(	'1'	,	'0'		  ,		'0'		,	'0'	,"11111111"	,  "00000000"	),
		(	'0'	,	'0'		  ,		'0'		,	'0'	,"11111111"	,  "00000000"	),
		(	'1'	,	'1'		  ,		'1'		,	'0'	,"11111111"	,  "00000000"	),
		(	'0'	,	'1'		  ,		'1'		,	'0'	,"11111111"	,  "00000000"	),
		(	'1'	,	'0'		  ,		'0'		,	'0'	,"11111111"	,  "00000000"	),
		(	'0'	,	'0'		  ,		'0'		,	'0'	,"11111111"	,  "00000000"	)		);

		begin 
			for i in tabela_verdade'range loop
				interrupt		<=tabela_verdade(i).interrupt;
				read_signal		<=tabela_verdade(i).read_signal;
				write_signal	<=tabela_verdade(i).write_signal;
				wait for 1 ns;
                deallocate(L);
				if i<2 then 			--valida dataout
                    write(L, string'("ERRO NO DATAOUT "));
                    write(L, codec_data_out);
                    write(L, string'(" recebido mas "));
                    write(L, tabela_verdade(i).codec_data_out);
                    write(L, string'(" esperado "));
					assert codec_data_out = tabela_verdade(i).codec_data_out report L.all;
				elsif i>=2 and i<5 then--valida datain
                    write(L, string'("ERRO NO DATAIN "));
                    write(L, codec_data_out);
                    write(L, string'(" recebido mas "));
                    write(L, tabela_verdade(i).codec_data_out);
                    write(L, string'(" esperado "));
					assert codec_data_in = tabela_verdade(i).codec_data_in report l.all;
				end if;
				assert valid = tabela_verdade(i).valid report "ERRO NA VALIDACAO";
			end loop;
		report "fim de teste";
		wait;
	end process;
	

end architecture;