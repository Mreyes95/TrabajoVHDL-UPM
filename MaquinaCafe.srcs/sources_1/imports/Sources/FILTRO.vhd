
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity filtro is
	generic(n: integer range 0 to 2**5-1 := 8);
	port(	entrada: in std_logic_vector(n - 1 downto 0);
			clk: in std_logic;
			salida: out std_logic_vector(n - 1 downto 0)
	);
end filtro;

architecture Behavioral of filtro is
component antirrebote
	port(
			bot: in std_logic;
			clk_div: in std_logic;
			reset: in std_logic;
			antirreb: out std_logic);
end component;
component flanco
	port(
			boton: in std_logic;
			clk: in std_logic;
			btn_out: out std_logic);
end component;
component divisor_reloj
	generic(tope: integer range 0 to 2**26-1 := 150);
	port(	clk, reset: in std_logic;
			clk_dividido: out std_logic);
end component;

for all: antirrebote use entity work.antirrebote(behavioral);
for all: flanco use entity work.flanco(behavioral);
for all: divisor_reloj use entity work.divisor_reloj(behavioral);

signal p_i: std_logic;
signal aux: std_logic_vector (entrada'range);
begin
	I_clk: divisor_reloj -- 1º.
		generic map (tope=> 500000)  
		port map(
			clk => clk,
			reset => '0',
			clk_dividido => p_i);
	fil: for i IN entrada'range GENERATE
	I_antirrebote: antirrebote port map(  -- 2º.
			Bot => entrada(i),
			clk_div=>p_i,
			reset=> '0',
			antirreb => aux(i));
	I_flanco: flanco port map(   -- 3º.
			boton => aux(i),
			clk => clk,
			btn_out => salida(i));
	end GENERATE;

end Behavioral;