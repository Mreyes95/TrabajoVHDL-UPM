
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity display is
	port(	display1,display2,display3,display4: in std_logic_vector(7 downto 0);
			clk: in std_logic;
			pantalla: out std_logic_vector(7 downto 0);
			control: out std_logic_vector(3 downto 0));
end display;

architecture Behavioral of display is

	component multip4a1
	generic(n: natural range 1 to 32:=8);
	port(	disp1: in std_logic_vector (n - 1 downto 0);
			disp2: in std_logic_vector (n - 1 downto 0);
			disp3: in std_logic_vector (n - 1 downto 0);
			disp4: in std_logic_vector (n - 1 downto 0);
			est:	in	std_logic_vector(1 downto 0);
			seg: out std_logic_vector (n -1 downto 0));
	end component;
	
	COMPONENT decod2a4
	PORT(
		input : IN std_logic_vector(1 downto 0);
		en: IN std_logic;          
		output : OUT std_logic_vector(3 downto 0)
		);
	END COMPONENT;
	COMPONENT state_change
	PORT(
		clk_div : IN std_logic;          
		state : OUT std_logic_vector(1 downto 0)
		);
	END COMPONENT;
	COMPONENT divisor_reloj
		generic (tope: integer range 0 to 2**26-1 := 10);
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;          
		clk_dividido : OUT std_logic
		);
	END COMPONENT;
		
for all: multip4a1 use entity work.multip4a1(Behavioral);
for all: decod2a4 use entity work.decod2a4(Behavioral);
for all: divisor_reloj use entity work.divisor_reloj(Behavioral);
for all: state_change use entity work.state_change(Behavioral);
	


signal aux1: std_logic_vector(1 downto 0);
signal aux2: std_logic;
begin

I_multip4a1: multip4a1 PORT MAP(-- 3º.
		disp1 => display1,
		disp2 => display2,
		disp3 => display3,
		disp4 => display4,
		est => aux1,
		seg => pantalla
	); 

I_decod2a4: decod2a4 PORT MAP(-- 3º.
		input => aux1,
		en => '0',
		output => control
	);
	
I_state_change: state_change PORT MAP( -- 2º.
		clk_div => aux2,
		state => aux1 -- (sale 00,01,10,11).
	);
	
I_divisor_reloj: divisor_reloj -- 1º.
	generic map( tope => 50000)
	PORT MAP(
		clk => clk,
		reset => '0',
		clk_dividido => aux2
	);


end Behavioral;