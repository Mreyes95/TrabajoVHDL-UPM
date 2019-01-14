
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity  multip4a1 is
	generic(n: natural range 1 to 32 :=8);

	port(	disp1: in std_logic_vector (n - 1 downto 0);
			disp2: in std_logic_vector (n - 1 downto 0);
			disp3: in std_logic_vector (n - 1 downto 0);
			disp4: in std_logic_vector (n - 1 downto 0);
			est: in std_logic_vector(1 downto 0);
			seg: out std_logic_vector (n - 1 downto 0));

end multip4a1;

architecture behavioral of multip4a1 is

	begin
		process(disp1,disp2,disp3,disp4,est)
		begin
			case est IS
				when "00" => seg <= disp1;
				when "01" => seg <= disp2;
				when "10" => seg <= disp3;
				when others => seg <= disp4;
			end case;
		end process;

end behavioral;