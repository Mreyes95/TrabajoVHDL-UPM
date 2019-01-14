
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity antirrebote is
    Port(
    	bot : in std_logic; 
		clk_div : in std_logic;
		reset : in std_logic;
		antirreb : out std_logic 
		  );
end antirrebote;

architecture behavioral of antirrebote is

signal temp: std_logic :='0';

begin

antirreb <= temp;

process (clk_div,bot,reset)
begin
	if reset = '1' then temp <= '0';
	elsif clk_div = '1' and clk_div'event then 
		temp <= bot;
	end if;
end process;

end behavioral;