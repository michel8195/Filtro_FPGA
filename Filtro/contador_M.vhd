library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity contador_M is
	generic(
			  N : integer := 14
	);
	port(
		clk, reset, en : in std_logic;
		M : in unsigned(N-1 downto 0);
		max_tick : out std_logic;
		q : out std_logic_vector(N-1 downto 0)
	);
end contador_M;

architecture Behavioral of contador_M is
	signal r_reg : unsigned(N-1 downto 0);
	signal r_next: unsigned(N-1 downto 0);
	--signal restart: std_logic;
	signal r_max: std_logic;

begin

 -- registro
	process(clk, reset)
	begin
		if (reset='1') then
			r_reg <= (others=>'0');			
		elsif (clk'event and clk='1') then
			r_reg <= r_next;
		end if;
	end process;
	
 -- logica de prox estado 
	r_next <= (others=>'0') when r_reg = M else				
				 r_reg + 1 when en='1' else
				 r_reg;
				 
 -- logica de salida
	r_max <= '1' when (r_reg < 9) else
					'0'; 
	--restart <= '1' when (r_reg = 4999) else
	--				'0'; 
	 
	q <= std_logic_vector(r_reg);
	max_tick <= r_max;
end Behavioral;

