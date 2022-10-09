library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_codec is
end entity;

architecture mixed of tb_codec is
	subtype dados1byte is std_logic_vector(7 downto 0); --vou precisar de declarar aquivo aqui?
	signal interrupt, read_signal, write_signal, valid: std_logic;
	signal codec_data_in, codec_data_out: std_logic_vector(7 downto 0);
	
begin

	codec_uso: entity work.codec(behavioral) 
		port map(interrupt, read_signal, write_signal, valid, codec_data_in, codec_data_out);

	estimulo: process is
		variable resultado: dados1byte;
		type tab_ver is record
			interrupt, read_signal, write_signal, valid: std_logic;
			codec_data_in, codec_data_out: std_logic_vector(7 downto 0); --onde é que eu coloco os arquivosssS??????
		end record;
		type vet_tab_ver is array (0 to 7) of tab_ver;
		constant tabela_verdade: vet_tab_ver := (
	--	interrupt, read_signal, write_signal, valid, codec_data_in, codec_data_out	
		(	'1'	,	'1'		  ,		'0'		,	'1'	,"00000000"	,  "11111111"	), --Não faço a mínima ideia como validar arquivos, enviei email pro professor pedindo atendimento e estou aguardando resposta
		(	'1'	,	'1'		  ,		'0'		,	'1'	,"00000000"	,  "11111111"	),
		(	'1'	,	'0'		  ,		'1'		,	'1'	,"11111111"	,  "00000000"	),
		(	'1'	,	'0'		  ,		'1'		,	'1'	,"11111111"	,  "00000000"	),
		(	'1'	,	'1'		  ,		'1'		,	'0'	,"11111111"	,  "00000000"	), --daqui pra baixo testa entradas invalidas
		(	'1'	,	'0'		  ,		'0'		,	'0'	,"11111111"	,  "00000000"	),
		(	'0'	,	'1'		  ,		'1'		,	'0'	,"11111111"	,  "00000000"	),
		(	'0'	,	'0'		  ,		'0'		,	'0'	,"11111111"	,  "00000000"	),

		)

		begin 
			for i in tabela_verdade'range loop
				interrupt		<=tabela_verdade(i).interrupt
				read_signal		<=tabela_verdade(i).read_signal
				write_signal	<=tabela_verdade(i).write_signal
				wait for 1 ns;
				if i<2 then 			--valida dataout
					assert codec_data_out = tabela_verdade(i).codec_data_out report "ERRO NO DATAOUT";
				else if i>=2 and i<5 then--valida datain
					assert codec_data_in = tabela_verdade(i).codec_data_in report "ERRO NO DATAIN";
				end if;
				assert valid = tabela_verdade(i).valid report "ERRO NA VALIDACAO";
			end loop;
		report "fim de teste";

	end process;
	

end architecture;