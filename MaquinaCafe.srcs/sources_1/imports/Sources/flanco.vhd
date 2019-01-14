
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity flanco is

	port(
	     	boton,clk: in std_logic;
			btn_out: out std_logic:='0');
end flanco;

architecture behavioral of flanco is
signal boton_1,boton_2: std_logic;  -- Salidas de los biestables.
begin

biestable_D1:	process(clk,boton)
		begin
			if (clk'event and clk='1') then
				boton_1<=boton;
			end if;
		end process;

biestable_D2: process(clk,boton_1)
		begin
			if(clk'event and clk='1') then
				boton_2<=boton_1;
			end if;
		end process;
btn_out<=boton_1 and (not boton_2);

end behavioral;
