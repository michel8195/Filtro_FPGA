library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.filtro_pkg.ALL;

entity top is
	port(
		clk, reset: in std_logic;
		sdata: in std_logic;
		tx_full: out std_logic;
		tx: out std_logic;
		ncs, sclk: out std_logic
	);
end top;
 

  
architecture Behavioral of top is
	signal signal_tick: std_logic;
	signal signal_data: std_logic_vector(11 downto 0);
	signal signal_done: std_logic;
	signal signal_uart: std_logic;
	signal signal_cont: std_logic_vector(4 downto 0);
	signal signal_shiftr: std_logic;
	signal signal_flanco: std_logic;
	signal signal_a: x_t(0 to 19);
	signal signal_filtrada: std_logic_vector(7 downto 0);
begin
 

-- Contador para el test_bench
	cont_test: entity work.contador_M(Behavioral)
	   generic map(N=>5)
		port map(M => to_unsigned(30,5),
					clk => clk,
					reset => reset,
					max_tick => open,
					en => '1',
					q =>  signal_cont   
		);


-- Contador hasta numero  4999 -> Genera pulso con una frecuencia de 20 kHz (frecuencia de sampleo)
	cont_M1: entity work.contador_M(Behavioral)
	   generic map(N=>14)
		port map(M => to_unsigned(5000,14),
					clk => clk,
					reset => reset,
					max_tick => signal_tick,
					en => '1',
					q =>  open   
		);

  
 -- Instancio modulo pmod -> Modulo que registra la senial de audio
  pmod: entity work.PmodMICRefComp(PmodMic)
		port map(clk  => clk,
					rst => reset, 
					--SDATA => sdata,
					SDATA => signal_cont(3),   --Descomentar esta linea y comentar la de arriba para test-bench
					SCLK => sclk,
					nCS => ncs,
					DATA => signal_data,
					START => signal_tick,
					DONE => signal_done
		);


-- Instancio modulo flanco -> Detecta flanco ascendente del modulo pmod
	detflanc: entity work.flanco(Behavioral)
		port map(clk => clk,
					reset => reset,
					done => signal_done,
					tick => signal_flanco
				   ); 
					
					
-- Instancio Shift register -> Acumulo 20 salidas de de pmod
	shift: entity work.shift_register(Behavioral)
	port map(clk => clk,
				reset => reset,
				data => signal_data(11 downto 4),
				start => signal_flanco,
				a => signal_a,
				tick_done => signal_shiftr
		);

-- Instancio modulo filtro_fsmd -> Aplico filtro a una muestra de 20 registros consecutivos
	filtro: entity work.filtro_fsmd(Behavioral)
	port map(clk => clk,
				reset => reset,
				a => signal_a,
				start => signal_shiftr,
				result => signal_filtrada,
				tick_done => signal_uart
		);


	
-- Instancio modulo UART -> Transfiere hacia la PC
  uart: entity work.uart_tx_unit(Behavioral)
		port map(clk  => clk,
					reset => reset, 
					wr_uart => signal_uart,
					w_data => signal_filtrada,
					tx_full => tx_full,
					tx => tx
		);


	
end Behavioral;

