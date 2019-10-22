LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE ieee.numeric_std.ALL;
 
ENTITY test_contm1 IS
END test_contm1;
 
ARCHITECTURE behavior OF test_contm1 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT contador_M
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         en : IN  std_logic;
         M : IN  integer;
         max_tick : OUT  std_logic;
         q : OUT  std_logic_vector(12 downto 0)
        );
    END COMPONENT;
    
  
   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal en : std_logic := '0';
   signal M : integer := 4999;
 
 	--Outputs
   signal max_tick : std_logic;
   signal q : std_logic_vector(12 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: contador_M PORT MAP (
          clk => clk,
          reset => reset,
          en => en,
          M => M,
          max_tick => max_tick,
          q => q
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
		en <= '1';
		reset <= '0';
      wait for clk_period*11000;
		assert false report "Funciona" severity failure;

      -- insert stimulus here 

      wait;
   end process;

END;
