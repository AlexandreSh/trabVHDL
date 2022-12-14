library ieee, std;
use ieee.std_logic_1164.all;
use IEEE.std_logic_textio.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;
use std.textio.all;

entity tb_codec is
end entity;

architecture mixed of tb_codec is
	subtype dados1byte is std_logic_vector(7 downto 0); 
	signal interrupt, read_signal, write_signal, valid: std_logic;
	signal codec_data_in, codec_data_out: std_logic_vector(7 downto 0);
	
begin

	codec_uso: entity work.codec(behavioral) 
		port map(interrupt, read_signal, write_signal, valid, codec_data_in, codec_data_out);

	estimulo: process is
        variable message: line;
        file arq_entrada: text is "caminho/do/projeto/entrada_codec.dat"; --precisa colocar o caminho completo dos arquivos
        file arq_saida: text open write_mode is "caminho/do/projeto/saida_codec.dat"; 
		variable resultado: dados1byte;
		type tab_ver is record
			interrupt, read_signal, write_signal, valid: std_logic;
			codec_data_in, codec_data_out: std_logic_vector(7 downto 0); 
		end record;
		type vet_tab_ver is array (0 to 15) of tab_ver;
		constant tabela_verdade: vet_tab_ver := (
	--	interrupt, read_signal, write_signal, valid, codec_data_in, codec_data_out	
		(	'1'	,	'0'		  ,		'1'		,	'1'	,"00110011"	,  "11111111"	),
		(	'0'	,	'0'		  ,		'1'		,	'1'	,"00110011"	,  "11111111"	),
		(	'1'	,	'0'		  ,		'1'		,	'1'	,"00000000"	,  "11111111"	),
		(	'0'	,	'0'		  ,		'1'		,	'1'	,"00000000"	,  "11111111"	),
		(	'1'	,	'1'		  ,		'0'		,	'1'	,"00000000"	,  "00000000"	),
		(	'0'	,	'1'		  ,		'0'		,	'1'	,"00000000"	,  "00000000"	),
		(	'1'	,	'1'		  ,		'0'		,	'1'	,"00000000"	,  "00000000"	),
		(	'0'	,	'1'		  ,		'0'		,	'1'	,"00000000"	,  "00000000"	),
		(	'1'	,	'1'		  ,		'1'		,	'0'	,"11111111"	,  "00000000"	), --daqui pra baixo testa pedidos invalidos
		(	'0'	,	'1'		  ,		'1'		,	'0'	,"11111111"	,  "00000000"	),
		(	'1'	,	'0'		  ,		'0'		,	'0'	,"11111111"	,  "00000000"	),
		(	'0'	,	'0'		  ,		'0'		,	'0'	,"11111111"	,  "00000000"	),
		(	'1'	,	'1'		  ,		'1'		,	'0'	,"11111111"	,  "00000000"	),
		(	'0'	,	'1'		  ,		'1'		,	'0'	,"11111111"	,  "00000000"	),
		(	'1'	,	'0'		  ,		'0'		,	'0'	,"11111111"	,  "00000000"	),
		(	'0'	,	'0'		  ,		'0'		,	'0'	,"11111111"	,  "00000000"	)		);

		begin 
			interrupt <= '0';
			wait for 100 ns;
			for i in tabela_verdade'range loop
				interrupt		<=tabela_verdade(i).interrupt;
				read_signal		<=tabela_verdade(i).read_signal;
				write_signal	<=tabela_verdade(i).write_signal;
				codec_data_out	<=tabela_verdade(i).codec_data_out;
				codec_data_in 	<=tabela_verdade(i).codec_data_in;
				wait for 1 ns;
				if ((i mod 2) = 1) then
					deallocate(message);
					if i<5 then 			--valida datain
						write(message, string'("ERRO NO DATAIN "));
						write(message, codec_data_in);
						write(message, string'(" recebido mas "));
						write(message, tabela_verdade(i).codec_data_in);
						write(message, string'(" esperado "));
						assert codec_data_in = tabela_verdade(i).codec_data_in report message.all;
					elsif i>=5 and i<9 then--valida datain
						write(message, string'("ERRO NO DATAOUT "));
						write(message, codec_data_out);
						write(message, string'(" recebido mas "));
						write(message, tabela_verdade(i).codec_data_out);
						write(message, string'(" esperado "));
						assert codec_data_out = tabela_verdade(i).codec_data_out report message.all;
					end if;
					assert valid = tabela_verdade(i).valid report "ERRO NA VALIDACAO (ESPERADO A PARTIR DE T=110)"; --erro esperado ap??s a 9a linha
				end if;
			end loop;
		report "fim de teste";
		wait;
	end process;
	

end architecture;