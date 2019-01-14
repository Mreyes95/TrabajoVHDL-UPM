
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity divisor_reloj is
	generic (tope: integer range 0 to 2**26-1 := 10);
	port(	clk,reset: in std_logic;
			clk_dividido: out std_logic);
end divisor_reloj;

-- Divisor de frecuencia.
architecture behavioral of divisor_reloj is
signal contador: natural range 0 to 2**26-1 := 0;
			
begin

divisor:	process(clk,reset)
			begin
				if reset = '1' then
					contador<=0;
					clk_dividido<='0';
				elsif clk'event and clk='1' then
					if contador >= tope - 1 then
						clk_dividido<='1';
						contador<=0;
					else
						clk_dividido<='0';
						contador<=contador + 1;
					end if;
				end if;
			end process;
end behavioral;