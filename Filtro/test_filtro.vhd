LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
use work.filtro_pkg.ALL;

ENTITY test_filtro IS
END test_filtro;
 
ARCHITECTURE behavior OF test_filtro IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT filtro_fsmd
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         a : IN  x_t(0 to 19);
 --        cte : IN cte_t(0 to 19);
         start : IN  std_logic;
         result : OUT  std_logic_vector(7 downto 0);
         tick_done : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal a : x_t(0 to 19) := (others => (others => '0'));
 --  signal cte : cte_t(0 to 19) := (others => (others => '0'));
   signal start : std_logic := '0';

 	--Outputs
   signal result : std_logic_vector(7 downto 0);
   signal tick_done : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: filtro_fsmd PORT MAP (
          clk => clk,
          reset => reset,
          a => a,
 --         cte => cte,
          start => start,
          result => result,
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
		
		wait for 100 ns;
		 
--		cte(0) <= "11111111111111111111100";                                                       
--		cte(1) <= "00000000000000000011100";                                                        
--		cte(2) <= "00000000000000000000100";                                                        
--		cte(3) <= "11111111111111101110000";                                                        
--		cte(4) <= "00000000000000000000110";                                                        
--		cte(5) <= "00000000000000111011001";                                                        
--		cte(6) <= "11111111111111111100010";                                                        
--		cte(7) <= "11111111111101011011000";                                                        
--		cte(8) <= "00000000000000000111001";                                                        
--		cte(9) <= "00000000001001111000100";                                                        
--		cte(10) <= "00000000001111110111100";                                                        
--		cte(11) <= "00000000001001111000100";                                                        
--		cte(12) <= "00000000000000000111001";                                                        
--		cte(13) <= "11111111111101011011000";                                                        
--		cte(14) <= "11111111111111111100010";                                                        
--		cte(15) <= "00000000000000111011001";                                                        
--		cte(16) <= "00000000000000000000110";                                                        
--		cte(17) <= "11111111111111101110000";                                                        
--		cte(18) <= "00000000000000000000100";                                                        
--		cte(19) <= "00000000000000000011100"; 
        
		a <= (others => "00000001");
		--a(0) <= "00000001";
		--a(1 to Bits_x_t) <=  (others => (others => '0'));
		wait for 100 ns; 
		wait for clk_period*10000;
		assert false report "termine" severity failure;
      -- insert stimulus here 
  
      wait;
   end process;

END;
