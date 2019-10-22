LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
 
ENTITY test_top IS
END test_top;
 
ARCHITECTURE behavior OF test_top IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT top
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         sdata : IN  std_logic;
         tx_full : OUT  std_logic;
         tx : OUT  std_logic;
         ncs : OUT  std_logic;
         sclk : OUT  std_logic
        );
    END COMPONENT;
        

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal sdata : std_logic := '0';

 	--Outputs
   signal tx_full : std_logic;
   signal tx : std_logic;
   signal ncs : std_logic;
   signal sclk : std_logic;
  
   -- Clock period definitions
   constant clk_period : time := 10 ns;
   constant sclk_period : time := 10 ns;
  
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: top PORT MAP (
          clk => clk,
          reset => reset,
          sdata => sdata,
          tx_full => tx_full,
          tx => tx,
          ncs => ncs,
          sclk => sclk
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 
   sclk_process :process
   begin
		sclk <= '0';
		wait for sclk_period/2;
		sclk <= '1';
		wait for sclk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
		reset <= '1';
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		reset <= '0';
		sdata <= '1';
      wait for clk_period*1000;
		sdata <= '0';
		wait for clk_period*1000;
    	sdata <= '1';
      wait for clk_period*1000;
		sdata <= '0';
		wait for clk_period*1000;
		sdata <= '1'; 
      wait for clk_period*1000;
		sdata <= '0';
		wait for clk_period*1000;
		wait for clk_period*10000000;
		
		assert false report "Funciona" severity failure;

      -- insert stimulus here 

      wait;
   end process;

END;
