
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decod2a4 is

	generic(var: bit := '0');
	
	port (	input: in std_logic_vector(1 downto 0);
				en: in std_logic;
				output: out std_logic_vector (3 downto 0));

end decod2a4;

architecture Behavioral of decod2a4 is
begin
	process(input,en)
	variable noen: std_logic;
	variable output_i: std_logic_vector (output'range);
	begin
		noen := not (en); 
		if noen = '0' then output_i:= "0000";   
			elsif input="00" then output_i:="0001";  
			elsif input="01" then output_i:="0010"; 
			elsif input="10" then output_i:="0100"; 
			else output_i:="1000";
		end if;
		if var='0' then output<=not (output_i); -- Salida negada displays.
			else output<= output_i;
		end if;
	end process;
end Behavioral;
