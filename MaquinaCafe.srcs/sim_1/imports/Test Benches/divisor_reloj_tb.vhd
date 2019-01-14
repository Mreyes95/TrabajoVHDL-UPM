
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity divisor_reloj_tb is
end divisor_reloj_tb;

architecture behavioral of divisor_reloj_tb is

component divisor_reloj is
	port(	clk,reset: in std_logic;
			clk_dividido: out std_logic);
end component;

signal clk: std_logic :='0';
signal reset: std_logic :='0';

signal clk_dividido: std_logic;

begin

uut: divisor_reloj port map(
	clk=> clk,
	reset=> reset,
	clk_dividido=> clk_dividido);


P_RESET: process
			begin
				reset<='0';
				wait for 33 ns;
				reset<='1';
				wait for 89 ns;
				reset<='0';
				assert false report "puesto el reset" severity note;
				wait; -- Espera para siempre.
			end process;

P_Clk: Process
			begin
				clk <= '1';
				wait for 10 ns;
				clk <= '0';
				wait for 10 ns;
			end process;

end behavioral;
