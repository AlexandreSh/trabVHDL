library ieee, std;
use ieee.std_logic_1164.all;
use IEEE.std_logic_textio.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;
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
architecture behavioral of codec is
begin 
    process(interrupt)
        file arq_entrada: text is "/home/alex/Documents/LabHardware/T1/trabVHDL/entrada_codec.dat";
        file arq_saida: text open write_mode is "/home/alex/Documents/LabHardware/T1/trabVHDL/saida_codec.dat";
        variable linha_dados_in: line;
        variable linha_dados_out: line;
        variable aux: std_logic_vector(7 downto 0);
    begin
        deallocate(linha_dados_out);--limpa as variaveis auxiliares
        deallocate(linha_dados_in);
        if ((read_signal = '1')and(write_signal = '0')and(rising_edge(interrupt))) then      --instrução IN (read)
            if not endfile(arq_entrada) then
                readline(arq_entrada, linha_dados_in);  --lê o arquivo e salva na variavel auxiliar
                hread(linha_dados_in, aux);
                report linha_dados_in.all;
                codec_data_out <= std_logic_vector(aux); --disponibiliza os dados na variavel de saída
                valid <= '1';            --sinaliza leitura com sucesso
            else
                report "ERRO NA LEITURA DO ARQUIVO" severity warning;
            end if;
        elsif ((read_signal = '0')and(write_signal = '1')and(rising_edge(interrupt))) then   --instrução OUT (write)
            
            write(linha_dados_out, codec_data_out);
            report linha_dados_out.all;
--            linha_dados_out := to_string(codec_data_in);
            writeline(arq_saida, linha_dados_out); --escreve os dados de linha_dados_out no arquivo
            valid <= '1'; --sinaliza escrita com sucesso
        else
            valid <= '0';                                       --em caso de pedido não esperado
        end if;

        end process;
end behavioral;