-- repositório pode ser acessado em https://github.com/AlexandreSh/trabVHDL.git
library ieee, std;
use ieee.std_logic_1164.all;
use IEEE.std_logic_textio.all;
use std.textio.all;
use ieee.numeric_std.all;


entity cpu is
    generic (
        addr_width: natural := 16; -- Memory Address Width (in bits)
        data_width: natural := 8 -- Data Width (in bits)
    );
    port (
        clock: in std_logic; -- Clock signal
        halt : in std_logic; -- Halt processor execution when '1'

        ---- Begin Memory Signals ---
        -- Instruction byte received from memory
        instruction_in : in std_logic_vector(data_width-1 downto 0);
        -- Instruction address given to memory
        instruction_addr: out std_logic_vector(addr_width-1 downto 0);

        data_read : out std_logic; -- When '1', read data from memory
        data_write: out std_logic; -- When '1', write data to memory
        -- Data address given to memory
        data_addr : out std_logic_vector(addr_width-1 downto 0);
        -- Data sent from memory when data_read = '1' and data_write = '0'
        data_in : out std_logic_vector((data_width*4)-1 downto 0);
        -- Data sent to memory when data_read = '0' and data_write = '1'
        data_out : in std_logic_vector(data_width-1 downto 0);
        ---- End Memory Signals ---

        ---- Begin Codec Signals ---
        codec_interrupt: out std_logic; -- Interrupt signal
        codec_read: out std_logic; -- Read signal
        codec_write: out std_logic; -- Write signal
        codec_valid: in std_logic; -- Valid signal

        -- Byte written to codec
        codec_data_out : in std_logic_vector(7 downto 0);
        -- Byte read from codec
        codec_data_in : out std_logic_vector(7 downto 0)
        ---- End Codec Signals ---
    );
end entity;

architecture behavioral_cpu of cpu is 
    signal masked_clock: std_logic := '0';--clock secundário necessário para gerenciar o halt
begin
    masked_clock <= '0' when (halt = '1' or instruction_in(7 downto 4) = X"0") else clock when halt = '0'; 
    process(halt, masked_clock)
        variable temp_data: std_logic_vector(data_width-1 downto 0); --variáveis usadas em instruções que usam mais de um bloco de dados
        variable temp_data1: std_logic_vector(data_width-1 downto 0);
        variable temp_data2: std_logic_vector(data_width-1 downto 0);
        variable temp_data3: std_logic_vector(data_width-1 downto 0);
        variable auxcont: integer:= 0; --variável usada para sincronia em instruções que nevessitam ler mais de um endereço
        variable IP: integer range 0 to addr_width-1 := 0; --ponteiro de instrucao 
        variable SP: integer := 0; --ponteiro de pilha
        alias opcode is instruction_in(data_width-1 downto data_width-4); --instrução fatiada entre opcode e immediate (só funciona em data widths com 4 bits de opcode)
        alias immediate is instruction_in(data_width-4 downto 0);
    begin 
        if halt = '1' then
            SP := 0;
            IP := 0;
        elsif masked_clock = '1' then
            case opcode is
                when X"0" =>--halt
                    SP := 0;
                    IP := 0;
                when X"1" =>--in
                    data_write <= '1';
                    data_read <= '0';
                    codec_read <= '1';
                    codec_write <= '0';
                    data_in <= std_logic_vector(to_unsigned(to_integer(unsigned(codec_data_out)), (data_width*4)-1));
                    SP := SP + 1;
                    IP := IP + 1; 
                when X"2" =>--out
                    data_write <= '0';
                    data_read <= '1';
                    codec_read <= '0';
                    codec_write <= '1';
                    SP := SP - 1;
                    codec_data_in <= data_out;
                    IP := IP + 1;
                when X"3" =>--puship
                    data_write <= '1';
                    data_read <= '0';
                    codec_read <= '0';
                    codec_write <= '0';
                    data_in <= std_logic_vector(to_unsigned(to_integer(unsigned(instruction_addr)), (data_width*4)-1));
                    SP := SP + 2;
                    IP := IP + 1;
                when X"4" =>--pushimm
                    data_write <= '1';
                    data_read <= '0';
                    codec_read <= '0';
                    codec_write <= '0';
                    data_in <= std_logic_vector(to_unsigned(to_integer(unsigned(immediate)), (data_width*4)-1));
                    SP := SP + 1;
                    IP := IP + 1;
                when X"5" =>--drop
                    SP := SP - 1;
                    IP := IP + 1;
                when X"6" =>--dup
                    data_write <= '1';
                    data_read <= '0';
                    codec_read <= '0';
                    codec_write <= '0';
                    temp_data := data_out;
                    data_in <= std_logic_vector(to_unsigned(to_integer(unsigned(temp_data)), (data_width*4)-1));
                    IP := IP + 1;
                    SP := SP + 1;
                when X"8" =>--add
                    codec_read <= '0';
                    codec_write <= '1';
                    if auxcont = 0 then
                        data_write <= '0';
                        data_read <= '1';
                        SP := SP - 1;
                        temp_data := data_out;
                        auxcont := 1;
                    else
                        data_write <= '1';
                        data_read <= '0';
                        data_in <= std_logic_vector(unsigned(data_out)+unsigned(temp_data));
                        IP := IP + 1;
                        SP := SP + 2;
                        auxcont := 0;
                    end if;
                when X"9" =>--sub
                    codec_read <= '0';
                    codec_write <= '1';
                    if auxcont = 0 then
                        data_write <= '0';
                        data_read <= '1';
                        SP := SP - 1;
                        temp_data := data_out;
                        auxcont := 1;
                    else 
                        data_write <= '1';
                        data_read <= '0';
                        data_in <= std_logic_vector(to_unsigned(to_integer(unsigned(temp_data)-(unsigned(data_out))), (data_width*4)-1));
                        IP := IP + 1;
                        SP := SP + 1;
                        auxcont := 0;
                    end if;
                when X"A" =>--nand
                    codec_read <= '0';
                    codec_write <= '1';
                    if auxcont = 0 then 
                        data_write <= '0';
                        data_read <= '1';
                        SP := SP - 1;
                        temp_data := data_out;
                        auxcont := 1;
                    else
                        data_write <= '1';
                        data_read <= '0';
                        data_in <= (std_logic_vector(to_unsigned(to_integer(unsigned(temp_data)), (data_width*4)-1)) nand data_out);
                        IP := IP + 1;
                        SP := SP + 1;
                        auxcont := 0;
                    end if;
                when X"B" =>--slt
                    codec_read <= '0';
                    codec_write <= '1';
                    if auxcont = 0 then
                        data_write <= '0';
                        data_read <= '1';
                        SP := SP - 1;
                        temp_data := data_out;
                        auxcont := 1;
                    else            
                        data_write <= '1';
                        data_read <= '0';
                        if unsigned(temp_data)<unsigned(data_out) then
                            data_in <= X"1";
                        else
                            data_in <= X"0";
                        end if;
                        IP := IP + 1;
                        SP := SP + 1;
                        auxcont := 1;
                    end if;
                when X"C" =>--shl
                    codec_read <= '0';
                    codec_write <= '1';
                    if auxcont = 0 then
                        data_write <= '0';
                        data_read <= '1';
                        SP := SP - 1;
                        temp_data := data_out;
                        auxcont := 1;
                    else
                        data_write <= '1';
                        data_read <= '0';
                        data_in <= std_logic_vector(shift_left(unsigned(temp_data), to_integer(unsigned(data_out))));
                        IP := IP + 1;
                        SP := SP + 1;
                        auxcont := 0;
                    end if;
                when X"D" =>--shr
                    codec_read <= '0';
                    codec_write <= '1';
                    if auxcont = 0 then
                        data_write <= '0';
                        data_read <= '1';
                        SP := SP - 1;
                        temp_data := data_out;
                        auxcont := 1;
                    else       
                        data_write <= '1';
                        data_read <= '0';
                        data_in <= std_logic_vector(shift_right(unsigned(temp_data), to_integer(unsigned(data_out))));
                        IP := IP + 1;
                        SP := SP + 1;
                        auxcont := 0;
                    end if;
                when X"E" =>--jeq
                    data_write <= '0';
                    data_read <= '1';
                    codec_read <= '0';
                    codec_write <= '1';
                    if auxcont = 0 then
                        SP := SP - 1;
                        temp_data := data_out;
                        auxcont := 1;
                    elsif auxcont = 1 then
                        SP := SP - 1;
                        temp_data1 := data_out;
                        auxcont := 2;
                    elsif auxcont = 2 then
                        SP := SP - 1;
                        temp_data2 := data_out;
                        auxcont := 3;
                    elsif auxcont = 3 then
                        SP := SP - 1;
                        temp_data3 := data_out;
                        auxcont := 4;
                    elsif auxcont = 4 then    
                        if temp_data = temp_data1 then
                            IP := IP+to_integer(unsigned(temp_data3&temp_data2));
                            SP := SP + 1;
                        end if;
                        IP := IP + 1;
                        auxcont := 0;
                    end if;
                when X"F" =>--jmp
                    data_write <= '0';
                    data_read <= '1';
                    codec_read <= '0';
                    codec_write <= '1';
                    if auxcont = 0 then
                        SP := SP - 1;
                        temp_data := data_out;
                        auxcont := 1;
                    else    
                        IP := to_integer(unsigned(temp_data&data_out));
                        auxcont := 0;
                    end if;
                when others => --noop?
                    IP := IP+1;
            end case;
        end if;
        instruction_addr <= std_logic_vector(to_unsigned(IP, addr_width));
        data_addr <= std_logic_vector(to_unsigned(SP,  addr_width));
    end process;
end architecture;
