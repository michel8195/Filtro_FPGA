LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
 
ENTITY test_flanco IS
END test_flanco;
 
ARCHITECTURE behavior OF test_flanco IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT flanco
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         done : IN  std_logic;
         tick : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal done : std_logic := '0';

 	--Outputs
   signal tick : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: flanco PORT MAP (
          clk => clk,
          reset => reset,
          done => done,
          tick => tick
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
		done <= '0';
      wait for 100 ns;	
		reset <= '0';
      wait for clk_period*5;
		done <= '0'; 
		wait for clk_period*5;
		done <= '1';
		wait for clk_period*5;
		done <= '1';
		wait for clk_period*5;
		done <= '0';
		wait for clk_period*5;
		done <= '0';
		wait for clk_period*5;
		done <= '1';
		wait for clk_period*5;
		
		assert false report "Funciona" severity failure;
	

      -- insert stimulus here 

      wait;
   end process;

END;
