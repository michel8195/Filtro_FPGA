library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.filtro_pkg.ALL;

entity shift_register is
	generic (
				N: natural := 20;
				N_idx : natural := 5
				); 
	port(
		clk, reset : in std_logic;
		-- entradas del filtro: a son datos, cte son las ctes del filtro
		data : in std_logic_vector(Bits_x_t - 1 downto 0);
		--cte : in cte_t(0 to N-1);
		start : in std_logic;
		-- salida
		a : out x_t(0 to N-1);
	   tick_done : out std_logic
		);
end shift_register;


architecture Behavioral of shift_register is
	type state_type is (idle, shift, done);
	signal state_reg, state_next: state_type;
	--signal n_reg, n_next: unsigned(4 downto 0);
	signal a_next, a_reg : x_t(0 to N-1);

begin

-- fsdm and data register
	
	process(clk, reset)
	begin
		if reset='1' then
			state_reg <= idle;
			a_reg <= (others=>(others=>'0'));
			--n_reg <= (others=>'0');
		elsif (clk'event and clk='1') then
			state_reg <= state_next;
			a_reg <= a_next;
			--n_reg <= n_next;
	   end if;
	end process;	
	
-- Logica proximo estado
	process(state_reg, a_reg, start, data)
	begin	
		state_next <= state_reg;
		a_next <= a_reg;
		
		case state_reg is
			when idle =>
				if start='1' then
						state_next <= shift;
				end if;
			when shift =>
				a_next <= data & a_reg(0 to N-2);
				state_next <= done;
			
			when done =>
				state_next <= idle;
				
		end case;
	end process;
	
	
-- Logica de salida
	process(state_reg, a_reg)
	begin
		-- casos por defecto
		a <= a_reg; --(others=>(others=>'0'));
		tick_done <= '0';
		case state_reg is
			when idle =>
			when shift =>
			when done =>
 				--a <= a_reg;
				tick_done <= '1';

		end case;
	 		
   end process;

end Behavioral;

