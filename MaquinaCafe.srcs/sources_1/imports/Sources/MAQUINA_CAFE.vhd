
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity maquina_cafe is
    Port ( clk : in  STD_LOGIC;
           Pulsador : in  STD_LOGIC_VECTOR (3 downto 0);
           salida_final : out  STD_LOGIC_VECTOR (7 downto 0);
           control_salida : out  STD_LOGIC_VECTOR (3 downto 0);
           led : out  STD_LOGIC_VECTOR (7 downto 0)
	      );
end maquina_cafe;

architecture Behavioral of maquina_cafe is

	component filtro is
		generic(n: integer range 0 to 2**5-1 := 8);
		port(	entrada: in std_logic_vector(n - 1 downto 0);
				clk: in std_logic;
				salida: out std_logic_vector(n - 1 downto 0)
		);
	end component;

	component cafetera
	port(
		clk : IN std_logic;
		boton : IN std_logic_vector(3 downto 0);          
		display1 : OUT std_logic_vector(7 downto 0);
		display2 : OUT std_logic_vector(7 downto 0);
		display3 : OUT std_logic_vector(7 downto 0);
		display4 : OUT std_logic_vector(7 downto 0);
		led : OUT std_logic_vector(7 downto 0)
		
		);
	end component;

	component display
	port(
		display1 : IN std_logic_vector(7 downto 0);
		display2 : IN std_logic_vector(7 downto 0);
		display3 : IN std_logic_vector(7 downto 0);
		display4 : IN std_logic_vector(7 downto 0);
		clk : IN std_logic;          
		pantalla : OUT std_logic_vector(7 downto 0);
		control : OUT std_logic_vector(3 downto 0)
		);
	end component;

signal aux: std_logic_vector(3 downto 0);
signal display1,display2,display3,display4: std_logic_vector(7 downto 0);

begin

	I_filtro: filtro
		generic map(n=>4)
		port map(
			entrada => Pulsador,
			clk => clk,
			salida =>aux 
	);

	I_cafetera: cafetera port map(
		clk => clk,
		boton => aux,
		display1 => display1,
		display2 => display2,
		display3 => display3,
		display4 => display4,
		led => led
		
	);

	I_display: display port map(
		display1 => display1,
		display2 => display2,
		display3 => display3,
		display4 => display4,
		clk => clk,
		pantalla => salida_final,
		control => control_salida
	);


end Behavioral;