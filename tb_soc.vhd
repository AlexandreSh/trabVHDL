library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity soc_tb is
end;

architecture bench of soc_tb is

  component soc
    generic (
      firmware_filename : string;
      addr_width : natural;
      data_width : natural
    );
      port (
      clock : in std_logic;
      started : in std_logic
    );
  end component;

  -- Clock period
  constant clk_period : time := 5 ns;
  -- Generics
  constant firmware_filename : string := "firmware.bin";
  constant addr_width : natural := 16;
  constant data_width : natural := 8;

  -- Ports
  signal clock : std_logic;
  signal started : std_logic;

begin

  soc_inst : soc
    generic map (
      firmware_filename => firmware_filename,
      addr_width => addr_width,
      data_width => data_width
    )
    port map (
      clock => clock,
      started => started
    );

--   clk_process : process
--   begin
--   clk <= '1';
--   wait for clk_period/2;
--   clk <= '0';
--   wait for clk_period/2;
--   end process clk_process;

end;
