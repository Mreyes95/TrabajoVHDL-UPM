
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity cafetera is
	generic(	
	            t1: integer range 0 to 2**8 - 1 := 10;  -- Tiempo de apagado cuando no hay actividad seleccion cafe  (en segundos).
				t2: integer range 0 to 2**8 - 1 := 10; -- Tiempo de espera para el nivel de azucar.
				t3: integer range 0 to 2**8 - 1 := 15;
				t4: integer range 0 to 2**8 - 1 := 10; -- Tiempo cafe corto.
				t5: integer range 0 to 2**8 - 1 := 20; -- Tiempo cafe largo.
				t6: integer range 0 to 2**8 - 1 := 25; -- Tiempo si no se selecciona complemento.
				t7: integer range 0 to 2**8 - 1 := 5; -- Tiempo de leche.
				t8: integer range 0 to 2**8 - 1 := 7); -- Tiempo seleccion edulcorante.
	port(	
	        boton: in std_logic_vector(3 downto 0);
			clk: in std_logic;
			display1, display2, display3, display4: out std_logic_vector(7 downto 0); 
			led: out std_logic_vector(7 downto 0)
			);
end cafetera;

architecture Behavioral of cafetera is


type estado is (E0, E1, E2, E3, E4, E5, E6);
signal estado_actual, estado_siguiente: estado:=E0;
constant second: integer:= 50000000; 
signal contador: integer range 0 to 2**26 - 1 := 0;
signal tiempo: integer range 0 to 60 := 0; -- En segundos
signal tiempo_restante: integer range 0 to 60 :=0;


signal nivel_dulce: integer range 0 to 3 :=2;
type edulcorante is (azucar,sacarina);
signal tipo_edulc: edulcorante:=azucar;
type cafe is (corto, largo);
signal tipo_cafe: cafe:=corto;
type complemento1 is (leche_en, leche_sem, leche_des, soja, sin);
signal tipo_complemento1: complemento1:=sin;


begin		
clock: process(clk) -- Actualizamos el estado en función del reloj.
			begin
			if (clk'event and clk='1') then
				estado_actual <= estado_siguiente;
			end if;
			end process;
			

Estados: process(clk) -- Definimos los sucesos de cada estado.
		begin
			if clk='1' and clk'event then
			case estado_actual is
				when E0 => -- Estado inicial o de reposo.
						 -- Empieza a contar el tiempo, va sumando al contador en microsegundos y cuando es mayor que 50000000 suma uno al tiempo en segundos.
							contador<= contador+1;
							if contador >= second then --mayor que
								tiempo<=tiempo + 1;
								contador<=0;
							end if;
						-- Pulsando cualquier botón salimos del estado de reposo, pasando al estado 1.
						
						if boton/="0000" then estado_siguiente<=E1;
							contador<=0; tiempo<=0;
						end if;
						
				when E1 => -- Selección del tipo de café.
							contador<= contador+1;
							if contador >= second then 
								tiempo<=tiempo + 1;
								contador<=0;
							end if;
						-- Pulsar para el tipo de cafe
						if boton="1000" then tipo_cafe<= corto;
								estado_siguiente<=E2; contador<=0; tiempo<=0;
						elsif boton="0001" then tipo_cafe<= largo;
								estado_siguiente<=E2; contador<=0; tiempo<=0;
						elsif tiempo >= t1 then
								estado_siguiente<=E0; contador<=0; tiempo<=0;
						end if;
						
				when E2 => -- Selección del tipo de edulcorante.
							contador<= contador+1;
							if contador >= second then 
								tiempo<=tiempo + 1;
								contador<=0;
							end if;
						-- Pulsar para el tipo de edulcorante.
						if boton="1000" then tipo_edulc<= azucar;
								estado_siguiente<=E3; contador<=0; tiempo<=0;
						elsif boton="0001" then tipo_edulc<= sacarina;
								estado_siguiente<=E3; contador<=0; tiempo<=0;
						elsif tiempo >= t8 then
								estado_siguiente<=E3; contador<=0; tiempo<=0;
						end if;
						
				when E3 => -- Selección del nivel de edulcorante.
							contador<= contador+1;
							if contador >= second then 
								tiempo<=tiempo + 1;
								contador<=0;
							end if;
						-- Pulsar para elegir el nivel de edulcorante.
						if boton="0001" then nivel_dulce<=3; estado_siguiente<=E4; contador<=0; tiempo<=0;
						elsif boton="0010" then nivel_dulce<=2; estado_siguiente<=E4; contador<=0; tiempo<=0;
						elsif boton="0100" then nivel_dulce<=1;estado_siguiente<=E4; contador<=0; tiempo<=0;
						elsif boton="1000" then nivel_dulce<=0;estado_siguiente<=E4; contador<=0; tiempo<=0;
						elsif tiempo >= t2 then
								estado_siguiente<=E4; contador<=0; tiempo<=0; 
						end if;
						
				when E4=> -- Cuenta atrás y proceso del café.
							contador<= contador+1;
							if contador >= second then 
								tiempo<=tiempo + 1;
								contador<=0;
							end if;
						-- Espera el tiempo para activación de la bomba.
						
						if tipo_cafe=corto then
								tiempo_restante<= t4 - tiempo;
						elsif tipo_cafe=largo then
								tiempo_restante<= t5 -tiempo;
						end if;
						if tipo_cafe=corto and tiempo >= t4 then
								estado_siguiente<=E5; contador<=0; tiempo<=0; 
						elsif tipo_cafe=largo and tiempo >= t5 then
								estado_siguiente<=E5; contador<=0; tiempo<=0; 
						end if;
						
				when E5 => -- Selección del tipo de leche.   
							contador<= contador+1;
							if contador >= second then 
								tiempo<=tiempo + 1;
								contador<=0;
							end if;
						-- Pulsar para elegir la leche.
						if boton="1000" then tipo_complemento1<= leche_en;
								estado_siguiente<=E6; contador<=0; tiempo<=0;
						elsif boton="0100" then tipo_complemento1<= leche_sem;
								estado_siguiente<=E6; contador<=0; tiempo<=0;
						elsif boton="0010" then tipo_complemento1<= leche_des;
								estado_siguiente<=E6; contador<=0; tiempo<=0;
						elsif boton="0001" then tipo_complemento1<= soja;
								estado_siguiente<=E6; contador<=0; tiempo<=0;
						elsif tiempo >= t6 then tipo_complemento1<=sin;
								estado_siguiente<=E1; contador<=0; tiempo<=0;
						end if;
						
				when E6 => -- Cuenta atrás y proceso de la leche.
							contador<= contador+1;
							if contador >= second then 
								tiempo<=tiempo + 1;
								contador<=0;
							end if;
						-- Espera el tiempo para la leche.
						
						if tipo_complemento1=leche_en then tiempo_restante<= t7 - tiempo;
						elsif tipo_complemento1=leche_sem then tiempo_restante<= t7 - tiempo;
						elsif tipo_complemento1=leche_des then tiempo_restante<= t7 - tiempo;
						elsif tipo_complemento1=soja then tiempo_restante<=t7 - tiempo;
						end if;
						
						if tipo_complemento1=leche_en and tiempo >= t7 then
								estado_siguiente<=E1; contador<=0; tiempo<=0;
						elsif tipo_complemento1=leche_sem and tiempo >= t7 then
								estado_siguiente<=E1; contador<=0; tiempo<=0;
						elsif tipo_complemento1=leche_des and tiempo >= t7 then
								estado_siguiente<=E1; contador<=0; tiempo<=0;
						elsif tipo_complemento1=soja and tiempo >= t7 then
								estado_siguiente<=E1; contador<=0; tiempo<=0;
						end if;
						end case;
			end if;			
		end process;
	
displays: process(clk) -- Modificamos lo que muestra el display en función del estado en el que nos encontremos.
	begin
		if clk'event and clk='1' then
		case estado_actual is
			when E0 => led<="00000000";  -- Estado de reposo.
							 display1<= "10001001"; --H
							 display2<= "11000000"; --O
							 display3<= "11000111"; --L
							 display4<= "10001000"; --A
							 
			when E1 => led<="00000001";  -- Tipo de café.
					         display1<= "11000110"; --C
					         display2<= "11111111"; --apagado
					         display3<= "11111111"; --apagado
					         display4<= "11000111"; --L
							
			when E2 => led<="00000010";  -- Selección del edulcorante.
							display1<= "10001000"; --A
							display2<= "11111111"; --apagado
							display3<= "11111111"; --apagado
							display4<= "10010010"; --S
							
			when E3 => led<="00000100";  -- Intensidad del edulcorante.
							display1<= "11111001"; --1
							display2<= "10100100"; --2
							display3<= "10110000"; --3
							display4<= "10011001"; --4
							
			when E4 => led<="10001000";  -- Tipo de café/cuenta atrás.
							case tipo_cafe is
								when corto => display1<="11000110"; 
								when others => display1<="11000111";
							end case;
							
							display2<="10111111";
							
							case tiempo_restante is
								when 0 to 9 =>display3<="11000000";
								when 10 to 19 =>display3<="11111001";
								when 20=> display3<="10100100";
								when others => display3<= "01111111";
							end case;
							
							case tiempo_restante is
								when 0 | 10 | 20 =>display4<= "11000000";
								when 1 | 11 =>display4<= "11111001";
								when 2 | 12 =>display4<= "10100100";
								when 3 | 13 =>display4<= "10110000";
								when 4 | 14 =>display4<= "10011001";
								when 5 | 15 =>display4<= "10010010";
								when 6 | 16 =>display4<= "10000010";
								when 7 | 17 =>display4<= "11111000";
								when 8 | 18 =>display4<= "10000000";
								when 9 | 19 =>display4<= "10011000";
								when others =>display4<= "01111111";
							end case;


			when E5 => led<="00010000";  -- Muestra tipos de leche.
							case tiempo is
								when  0 | 1 | 2 | 3  => 
											display1<= "11111001";
											display2<= "10000110";
											display3<= "10101011";
											display4<= "10000111";
								when 4 | 5 | 6 | 7 => 
											display1<= "10100100";
											display2<= "10010010";
											display3<= "10000110";
											display4<= "11111111";
								when 8 | 9 | 10 | 11 => 
											display1<= "10110000";
											display2<= "10100001";
											display3<= "10000110";
											display4<= "10010010";
								when 12 | 13 | 14 | 15 => 
											display1<= "10011001";
											display2<= "10010010";
											display3<= "11000000";
											display4<= "11100001";
								when others => 
											display1<= "01111111";
											display2<= "01111111";
											display3<= "01111111";
											display4<= "01111111";
							end case;
							
			when E6 => led<="10100000";  -- Tipo de leche/cuenta atrás.
							display2<="10111111";
							case tipo_complemento1 is
								when leche_en =>
									 display1<= "10000110";	
								when leche_sem =>
									 display1<= "10010010";	
								when leche_des =>
									 display1<= "10100001";	
								when soja =>
									 display1<= "11100001";
								when others =>
									 display1<="01111111";
							end case;
							display3<="10111111";

							case tiempo_restante is
								when 0 	=>display4<= "11000000";
								when 1  =>display4<= "11111001";
								when 2  =>display4<= "10100100";
								when 3  =>display4<= "10110000";
								when 4  =>display4<= "10011001";
								when 5 	=>display4<= "10010010";
								when others =>display4<= "01111111";
							end case;
			
			
		end case;
		end if;
	end process;
	
		
end Behavioral;