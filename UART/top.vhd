library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top is
	port(
		clk, reset: in std_logic;
		tx_full: out std_logic;
		tx: out std_logic
	);
end top;



architecture Behavioral of top is
	signal signal_tick: std_logic;
	signal signal_data: std_logic_vector(8 downto 0);
begin

-- Contador hasta numero  4999
	cont_M1: entity work.contador_M(Behavioral)
	   generic map(N=>14)
		port map(M => to_unsigned(5000,14),
					clk => clk,
					reset => reset,
					max_tick => signal_tick,
					en => '1',
					q =>  open   
		);  
		
-- Contador hasta numero  1023
	cont_M2: entity work.contador_M(Behavioral)
	   generic map(N=>9)
		port map(M => to_unsigned(256,9),
					clk => clk,
					reset => reset,
					max_tick => open,
					en => signal_tick,
					q =>  signal_data   
		);
				
-- Instancio modulo uart
  uart: entity work.uart_tx_unit(Behavioral)
		port map(clk  => clk,
					reset => reset, 
					wr_uart => signal_tick,
					w_data => signal_data(7 downto 0),
					tx_full => tx_full,
					tx => tx
		);
	
	
end Behavioral;

