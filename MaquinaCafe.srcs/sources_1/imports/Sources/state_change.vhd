
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity state_change is
	port(	clk_div: in std_logic;
			state: out std_logic_vector(1 downto 0):="00");
end state_change;

architecture behavioral of state_change is
signal contador: natural range 0 to 3 :=0;
begin 
	process(clk_div)
	begin
		if clk_div = '1' and clk_div'event then
			if contador = 0 then state<="00";
				contador<=contador +1 ;
			elsif contador = 1 then 
				state<="01";
				contador<=contador +1;
			elsif contador = 2 then
				state<="10";
				contador<=contador +1;
			else
				state<="11";
				contador<=0;
			end if;
		end if;
	end process;
end behavioral;