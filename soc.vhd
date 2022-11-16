library ieee;
use ieee.std_logic_1164.all;

entity soc is
generic (
    firmware_filename: string := "firmware.bin";
    addr_width: natural := 16; -- Memory Address Width (in bits)
    data_width: natural := 8 -- Data Width (in bits)
);
port (
    clock: in std_logic; -- Clock signal
    started: in std_logic -- Start execution when '1'
);
end entity;

architecture structural of soc is
    signal escrita_dmem: std_logic;
    signal leitura_imem: std_logic;
    signal instruction_in_aux: std_logic_vector(data_width-1 downto 0);
    signal instruction_addr_aux: std_logic_vector(data_width-1 downto 0);
    signal data_read_aux: std_logic;
    signal data_write_aux: std_logic;
    signal data_addr_aux: std_logic_vector(addr_width-1 downto 0);
    signal data_in_aux: std_logic_vector((data_width*4)-1 downto 0);
    signal data_out_aux: std_logic_vector(data_width-1 downto 0);
    signal codec_interrupt_aux: std_logic;
    signal codec_read_aux: std_logic;
    signal codec_write_aux: std_logic;
    signal codec_valid_aux: std_logic;
    signal codec_data_out_aux: std_logic_vector(7 downto 0);
    signal codec_data_in_aux: std_logic_vector(7 downto 0);
begin
    cpu: entity work.cpu(behavioral_cpu)
            port map(clock => clock, halt, instruction_in => instruction_in_aux, instruction_addr => instruction_addr_aux, 
                     data_read => data_read_aux, data_write => data_write_aux, data_addr => data_addr_aux, data_in => data_in_aux, 
                     data_out => data_out_aux, codec_interrupt => codec_interrupt_aux, codec_read => codec_read_aux, codec_write => codec_write_aux,
                     codec_valid => codec_valid_aux, codec_data_out => codec_data_out_aux, codec_data_in => codec_data_in_aux);
    imem: entity work.memory(behavioral)
            port map(clock => clock, data_read => '1', data_write  => '0', data_addr => instruction_addr_aux, data_in => instruction_in_aux, data_out => data_out_aux);
    dmem: entity work.memory(behavioral)
            port map(clock, data_read => '0', data_write => '1', data_addr => data_addr_aux, data_in => data_in_aux, data_out => data_out_aux);
    codec: entity work.codec(behavioral)
            port map(interrupt => codec_interrupt_aux, read_signal => codec_read_aux , write_signal => codec_write_aux, valid => codec_valid_aux, 
                     codec_data_in => codec_data_out_aux, codec_data_out => codec_data_in_aux);

end architecture;