library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cpu_tb is
end;

architecture bench of cpu_tb is

  component cpu
    generic (
      addr_width : natural;
      data_width : natural
    );
      port (
      clock : in std_logic;
      halt : in std_logic;
      instruction_in : in std_logic_vector(data_width-1 downto 0);
      instruction_addr : out std_logic_vector(addr_width-1 downto 0);
      data_read : out std_logic;
      data_write : out std_logic;
      data_addr : out std_logic_vector(addr_width-1 downto 0);
      data_in : out std_logic_vector((data_width*4)-1 downto 0);
      data_out : in std_logic_vector(data_width-1 downto 0);
      codec_interrupt : out std_logic;
      codec_read : out std_logic;
      codec_write : out std_logic;
      codec_valid : in std_logic;
      codec_data_out : in std_logic_vector(7 downto 0);
      codec_data_in : out std_logic_vector(7 downto 0)
    );
  end component;

  -- Clock period
  constant clk_period : time := 5 ns;
  -- Generics
  constant addr_width : natural := 16;
  constant data_width : natural := 8;

  -- Ports
  signal clock : std_logic;
  signal halt : std_logic;
  signal instruction_in : std_logic_vector(data_width-1 downto 0);
  signal instruction_addr : std_logic_vector(addr_width-1 downto 0);
  signal data_read : std_logic;
  signal data_write : std_logic;
  signal data_addr : std_logic_vector(addr_width-1 downto 0);
  signal data_in : std_logic_vector((data_width*4)-1 downto 0);
  signal data_out : std_logic_vector(data_width-1 downto 0);
  signal codec_interrupt : std_logic;
  signal codec_read : std_logic;
  signal codec_write : std_logic;
  signal codec_valid : std_logic;
  signal codec_data_out : std_logic_vector(7 downto 0);
  signal codec_data_in : std_logic_vector(7 downto 0);

begin

  cpu_inst : cpu
    generic map (
      addr_width => addr_width,
      data_width => data_width
    )
    port map (
      clock => clock,
      halt => halt,
      instruction_in => instruction_in,
      instruction_addr => instruction_addr,
      data_read => data_read,
      data_write => data_write,
      data_addr => data_addr,
      data_in => data_in,
      data_out => data_out,
      codec_interrupt => codec_interrupt,
      codec_read => codec_read,
      codec_write => codec_write,
      codec_valid => codec_valid,
      codec_data_out => codec_data_out,
      codec_data_in => codec_data_in
    );

--   clk_process : process
--   begin
--   clk <= '1';
--   wait for clk_period/2;
--   clk <= '0';
--   wait for clk_period/2;
--   end process clk_process;

end;
