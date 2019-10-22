LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
use work.filtro_pkg.ALL;

 
ENTITY test_shift_register IS
END test_shift_register;
 
ARCHITECTURE behavior OF test_shift_register IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT shift_register
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         data : IN  std_logic_vector(7 downto 0);
         start : IN  std_logic;
         a : OUT  x_t(0 to 19);
         tick_done : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal data : std_logic_vector(7 downto 0) := (others => '0');
   signal start : std_logic := '0';

 	--Outputs
   signal a : x_t(0 to 19);
   signal tick_done : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: shift_register PORT MAP (
          clk => clk,
          reset => reset,
          data => data,
          start => start,
          a => a,
          tick_done => tick_done
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		reset <= '1';
      wait for 100 ns;	
		
		reset <= '0';
		start <= '1';
		data <= "00110011" ;
      wait for clk_period*10;
		wait for clk_period*10;
		start <= '1';
		data <= "00111111"; 
      wait for clk_period*10;
		wait for clk_period*10;
		
		assert false report "termine" severity failure;
      -- insert stimulus here 
 
      wait;
   end process;

END;
