library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity flanco is
	port(
		clk, reset: in std_logic;
		done: in std_logic;
		tick: out std_logic
	);
end flanco;

architecture Behavioral of flanco is
	type state_type is (s1, s2, s3, s4);
	signal state_reg, state_next: state_type;
begin

-- state_register
	process(clk, reset)
	begin
		if reset='1' then
			state_reg <= s1;
		elsif (clk'event and clk='1') then
			state_reg <= state_next;
		end if;
	end process;
	
-- next_state
	process(state_reg, done)
	begin
		case state_reg is
			when s1 =>
				if done='1' then
					state_next <= s2;
				else
					state_next <= s1;
				end if;
			when s2 =>
				state_next <= s3;
			when s3 =>
				if done='0' then
					state_next <= s4;
				else
					state_next <= s3;
				end if;
			when s4 =>
				state_next <= s1;
		end case;
	end process;

-- output
	
	process(state_reg)
	begin
		tick <= '0';
		case state_reg is
			when s1 =>
				tick <= '0';
			when s2 =>
				tick <= '1';
			when s3 =>
				tick <= '0';
			when s4 =>
				tick <= '0';
		end case;
	end process;

end Behavioral;

