library ieee;
use ieee.std_logic_1164.all;
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

architecture behavioral_cpu of codec is 
begin
    process(halt, rising_edge'clock){
        variable temp_data: std_logic_vector(data_width-1 downto 0);
        variable temp_data1: std_logic_vector(data_width-1 downto 0);
        variable temp_data2: std_logic_vector(data_width-1 downto 0);
        variable temp_data3: std_logic_vector(data_width-1 downto 0);
        variable IP: integer range 0 to addr_width-1 := 0; --ponteiro de instrucao e pilha
        variable SP: integer := 0; --ponteiro de instrucao e pilha
        alias opcode is instruction_in(data_width-1 downto data_width-5);
        alias immediate is instruction_in(data_width-5 downto 0);
        --OUT           instruction_addr, data_addr, codec_data_out
        -- OUT signal   data_read, data_write, codec_interrupt, codec_read, codec_write
    begin;
        if halt = 1 then
            wait;
        end if;
        case opcode is:
            when X"0" =>--halt
                IP += 1;
                wait;

            when X"1" =>--in
                data_write <= '1';
                data_read <= '0';
                codec_read <= '1';
                codec_write <= '0';
                --data_in <= codec_data_out;
                data_in <= std_logic_vector(to_unsigned(to_integer(unsigned(codec_data_out)), (data_width*4)-1));
                SP += 1;
                IP += 1; 
                --wait on clock;?

            when X"2" =>--out
                data_write <= '0';
                data_read <= '1';
                codec_read <= '0';
                codec_write <= '1';
                SP -= 1;
                codec_data_in <= data_out;
                IP += 1;

            when X"3" =>--puship
                data_write <= '1';
                data_read <= '0';
                codec_read <= '0';
                codec_write <= '0';
                data_in <= std_logic_vector(to_unsigned(to_integer(unsigned(instruction_addr)), (data_width*4)-1));
                --wait on clock;?
                SP +=2;
                IP += 1;

            when X"4" =>--pushimm
                data_write <= '1';
                data_read <= '0';
                codec_read <= '0';
                codec_write <= '0';
                data_in <= std_logic_vector(to_unsigned(to_integer(unsigned(immediate)), (data_width*4)-1));
                SP +=1;
                IP += 1;

            when X"5" =>--drop
                SP -= 1;
                IP += 1;

            when X"6" =>--dup
                data_write <= '1';
                data_read <= '0';
                codec_read <= '0';
                codec_write <= '0';
                temp_data := data_out;
                data_in <= std_logic_vector(to_unsigned(to_integer(unsigned(temp_data)), (data_width*4)-1));
                IP += 1;
                SP += 1;

            when X"8" =>--add
                data_write <= '0';
                data_read <= '1';
                codec_read <= '0';
                codec_write <= '1';
                SP -= 1;
                temp_data := data_out;
                wait on rising_edge'clock;
                data_write <= '1';
                data_read <= '0';
                data_in <= std_logic_vector(to_unsigned(to_integer(unsigned(temp_data+data_out)), (data_width*4)-1));
                IP += 1;
                SP += 2;

            when X"9" =>--sub
                data_write <= '0';
                data_read <= '1';
                codec_read <= '0';
                codec_write <= '1';
                SP -= 1;
                temp_data := data_out;
                wait on rising_edge'clock;
                data_write <= '1';
                data_read <= '0';
                data_in <= std_logic_vector(to_unsigned(to_integer(unsigned(temp_data-data_out)), (data_width*4)-1));
                IP += 1;
                SP += 1;

            when X"A" =>--nand
                data_write <= '0';
                data_read <= '1';
                codec_read <= '0';
                codec_write <= '1';
                SP -= 1;
                temp_data := data_out;
                wait on rising_edge'clock;
                data_write <= '1';
                data_read <= '0';
                data_in <= std_logic_vector(to_unsigned(to_integer(unsigned(temp_data nand data_out)), (data_width*4)-1));
                IP += 1;
                SP += 1;

            when X"B" =>--slt
                data_write <= '0';
                data_read <= '1';
                codec_read <= '0';
                codec_write <= '1';
                SP -= 1;
                temp_data := data_out;
                wait on rising_edge'clock;
                data_write <= '1';
                data_read <= '0';
                if (to_unsigned(to_integer(unsigned(temp_data))))<(to_unsigned(to_integer(unsigned(data_out)))) then
                    data_in <= std_logic_vector(1, (data_width*4)-1);
                else
                    data_in <= std_logic_vector(0, (data_width*4)-1);
                end if;
                IP += 1;
                SP += 1;
                
            when X"C" =>--shl
                data_write <= '0';
                data_read <= '1';
                codec_read <= '0';
                codec_write <= '1';
                SP -= 1;
                temp_data := data_out;
                wait on rising_edge'clock;
                data_write <= '1';
                data_read <= '0';
                data_in <= std_logic_vector(to_unsigned(to_integer(unsigned(temp_data sll data_out)), (data_width*4)-1));
                end if;
                IP += 1;
                SP += 1;

            when X"D" =>--shr
                data_write <= '0';
                data_read <= '1';
                codec_read <= '0';
                codec_write <= '1';
                SP -= 1;
                temp_data := data_out;
                wait on rising_edge'clock;
                data_write <= '1';
                data_read <= '0';
                data_in <= std_logic_vector(to_unsigned(to_integer(unsigned(temp_data srl data_out)), (data_width*4)-1));
                end if;
                IP += 1;
                SP += 1;

            when X"E" =>--jeq
                data_write <= '0';
                data_read <= '1';
                codec_read <= '0';
                codec_write <= '1';
                SP -= 1;
                temp_data := data_out;
                wait on rising_edge'clock;
                SP -= 1;
                temp_data1 := data_out;
                wait on rising_edge'clock;
                SP -= 1;
                temp_data2 := data_out;
                wait on rising_edge'clock;
                SP -= 1;
                temp_data3 := data_out;
                wait on rising_edge'clock;
                if temp_data = temp_data1 then
                    IP += to_unsigned(to_integer(unsigned(temp_data3&temp_data2)));
                    SP += 1;
                end if;
                IP += 1;

            when X"F" =>--jmp
                data_write <= '0';
                data_read <= '1';
                codec_read <= '0';
                codec_write <= '1';
                SP -= 1;
                temp_data := data_out;
                wait on rising_edge'clock;
                IP := to_unsigned(to_integer(unsigned(temp_data&data_out)));
        end case;
        instruction_addr <= std_logic_vector(IP, addr_width-1);
        data_addr <= std_logic_vector(SP, addr_width-1);
    end process;
    }


end architecture;