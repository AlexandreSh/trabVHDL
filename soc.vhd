library ieee;
use ieee.std_logic_1164.all;

entity soc is
generic (
    firmware_filename: string := "firmware.bin"
);
port (
    clock: in std_logic; -- Clock signal
    started: in std_logic -- Start execution when '1'
);
end entity;

architecture structural of soc is
    signal escrita:  std_logic;
    signal leitura:  std_logic;
    signal dado_entrada: std_logic_vector(data_width-1 downto 0);
    signal dado_saida: std_logic_vector(data_width-1 downto 0);
    signal endereco_dado: std_logic_vector(addr_width-1 downto 0);
begin
    codec: entity work.codec(behavioral)
            port map(interrupt, read_signal , write_signal, valid, codec_data_in, codec_data_out);
    cpu: entity work.cpu(behavioral_cpu)
            port map(clock, halt, instruction_in, instruction_addr, data_read => leitura, data_write => escrita, data_addr => endereco_dado, data_in => dado_entrada, 
            data_out => dado_saida, codec_interrupt => interrupt, codec_read, codec_write, codec_valid, codec_data_out, codec_data_in);
    imem: entity work.memory(behavioral)
            port map(clock, data_read => leitura, data_write  => escrita, data_addr => endereco_dado, data_in => dado_entrada, data_out data_out => dado_saida);
    dmem: entity work.memory(behavioral)
            port map(clock, data_read => leitura, data_write => escrita, data_addr => endereco_dado, data_in, data_out);

end architecture;