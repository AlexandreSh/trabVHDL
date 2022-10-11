library ieee, std;
use ieee.std_logic_1164.all;
use std.textio.all;

entity codec is
port (
interrupt: in std_logic; -- Interrupt signal
read_signal: in std_logic; -- Read signal
write_signal: in std_logic; -- Write signal
valid: out std_logic; -- Valid signal

-- Byte written to codec
codec_data_in : in std_logic_vector(7 downto 0);
-- Byte read from codec
codec_data_out : out std_logic_vector(7 downto 0)
);
end entity;
--como sabemos que arquivo iremos ler? ele tem só um byte? 
architecture behavioral of codec is
begin 
    process(interrupt)
        subtype dados1byte is std_logic_vector(7 downto 0); 
        type entrada_codec is file of dados1byte;
        type saida_codec is file of dados1byte;
        variable aux1b          : dados1byte; --variavel auxiliar que guarda os dados
        file arq_carga_in       : entrada_codec open read_mode is "/caminho/do/codec/entrada_codec.dat";
        file arq_carga_out      : saida_codec open write_mode is "/caminho/do/codec/entrada_codec.dat";
  --      variable nome_arquivo   : string(1 to 50);
  --      variable tam_nome_arq   : natural;
        variable status         : file_open_status;
        begin

            if ((read_signal = '1')and(write_signal = '0')) then      --instrução IN (read)
                file_open(status, arq_carga_in, "/caminho/do/codec/entrada_codec.dat", read_mode);
                if status /= open_ok then
                    report "ERRO NA LEITURA DO ARQUIVO" severity warning;
                elsif not endfile(arq_carga_in) then
                    read(arq_carga_in, aux1b);  --lê o arquivo e salva na variavel auxiliar
                    codec_data_out <= aux1b; --disponibiliza os dados na variavel de saída
                    valid <= '1';            --sinaliza leitura com sucesso
                end if;
                file_close(arq_carga_in);
            elsif ((read_signal = '0')and(write_signal = '1')) then   --instrução OUT (write)
                file_open(status, arq_carga_out, "/caminho/do/codec/entrada_codec.dat", write_mode);
                if status /= open_ok then
                    report "ERRO NA ESCRITA DO ARQUIVO" severity warning;
                else
                    aux1b := codec_data_in;
                    write(arq_carga_out, aux1b); --escreve os dados de aux1b no arquivo
                    valid <= '1'; --sinaliza escrita com sucesso
                end if;
                file_close(arq_carga_out);
            else
                valid <= '0';                                       --em caso de pedido não esperado
            end if;

        end process;


end behavioral;