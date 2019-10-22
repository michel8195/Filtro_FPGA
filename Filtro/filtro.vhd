library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.filtro_pkg.ALL;

entity filtro_fsmd is
	generic (
				N: natural := 20;
				N_idx : natural := 5
				); 
	port(
		clk, reset : in std_logic;
		-- entradas del filtro: a son datos, cte son las ctes del filtro
		a : in x_t(0 to N-1);
		start : in std_logic;
		-- salida
		result : out std_logic_vector(Bits_x_t -1 downto 0);
	   tick_done : out std_logic
		);
end filtro_fsmd;

architecture Behavioral of filtro_fsmd is
	type state_type is (idle, op, done);
	signal state_reg, state_next: state_type;
	signal n_reg, n_next: unsigned(4 downto 0);
	signal x_t_reg, x_t_next: x_t(0 to N-1);
	signal cte_reg, cte_next: cte_t(0 to N-1); 
	signal acum_reg, acum_next: signed(Bits_x_t + Bits_cte_t downto 0); 
begin

-- fsdm and data register
	
	process(clk, reset)
	begin
		if reset='1' then
			state_reg <= idle;
			x_t_reg <= (others=>(others=>'0'));
			cte_reg <= (others=>(others=>'0'));
			n_reg <= (others=>'0');
			acum_reg <= (others=>'0');
		elsif (clk'event and clk='1') then
			state_reg <= state_next;
			x_t_reg <= x_t_next;
			cte_reg <= cte_next;
			n_reg <= n_next;
			acum_reg <= acum_next;
		end if;
	end process;	

-- logica proximo estado

	process(state_reg, x_t_reg, cte_reg, n_reg, acum_reg, a,  start)
	begin	
		state_next <= state_reg;
		x_t_next <= x_t_reg;
		cte_next <= cte_reg;
		n_next <= n_reg;
		acum_next <= acum_reg;
		
                                                       
		
		case state_reg is
			when idle =>
				if start='1' then
					state_next <= op;
					x_t_next <= a;
					n_next <= "00001";
				   cte_next(0) <= "11111111111100";                                                       
					cte_next(1) <= "00000000011100";                                                        
					cte_next(2) <= "00000000000100";                                                        
					cte_next(3) <= "11111101110000";                                                        
					cte_next(4) <= "00000000000110";                                                        
					cte_next(5) <= "00000111011001";                                                        
					cte_next(6) <= "11111111100010";                                                        
					cte_next(7) <= "11101011011000";                                                        
					cte_next(8) <= "00000000111001";                                                        
					cte_next(9) <= "01001111000100";                                                        
					cte_next(10) <="01111110111100";                                                        
					cte_next(11) <="01001111000100";                                                        
					cte_next(12) <="00000000111001";                                                        
					cte_next(13) <="11101011011000";                                                        
					cte_next(14) <="11111111100010";                                                        
					cte_next(15) <="00000111011001";                                                        
					cte_next(16) <="00000000000110";                                                        
					cte_next(17) <="11111101110000";                                                        
					cte_next(18) <="00000000000100";                                                        
					cte_next(19) <="00000000011100"; 
					acum_next <= (others=>'0');
				end if;
			
			when op =>
				acum_next <= acum_reg + signed('0' & x_t_reg(0))*signed(cte_reg(0));
				
				x_t_next <= x_t_reg(1 to N-1) & x_t_reg(0);
				cte_next <= cte_reg(1 to N-1) & cte_reg(0);				
				
				if n_reg = N then
					state_next <= done;
				else
					n_next <=  n_reg + 1;
				end if;
			
			when done =>
				state_next <= idle;
		end case;
	end process;

-- logica de salida
	process(state_reg, acum_reg)
	begin
		-- casos por defecto
		result <= (others=>'0');
		tick_done <= '0';
		case state_reg is
			when idle =>
			when op =>
			when done =>
				result <= std_logic_vector(acum_reg(Bits_x_t + Bits_cte_t  - 1 downto Bits_x_t + Bits_cte_t - Bits_x_t));
				tick_done <= '1';

		end case;
	 		
   end process;

end Behavioral;

