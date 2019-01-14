
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY MAQUINA_CAFE_tb IS
END MAQUINA_CAFE_tb;
 
ARCHITECTURE behavior OF MAQUINA_CAFE_tb IS 
 
    COMPONENT maquina_cafe
    PORT(
         clk : IN  std_logic;
         Pulsador : IN  std_logic_vector(3 downto 0);
         salida_final : OUT  std_logic_vector(7 downto 0);
         control_salida : OUT  std_logic_vector(3 downto 0);
         led : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    
   signal clk : std_logic := '0';
   signal Pulsador : std_logic_vector(3 downto 0) := (others => '0');

   signal salida_final : std_logic_vector(7 downto 0);
   signal control_salida : std_logic_vector(3 downto 0);
   signal led : std_logic_vector(7 downto 0);

   constant clk_period : time := 10 ns;
 
BEGIN
 
   uut: maquina_cafe PORT MAP (
          clk => clk,
          Pulsador => Pulsador,
          salida_final => salida_final,
          control_salida => control_salida,
          led => led
        );

   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   stim_proc: process
   begin		
     
      wait for 100 ns;	
			
      wait for clk_period*10;
		
     
					Pulsador<="0100";
					wait for 40 ns;
					Pulsador<="0001";
	
      wait;
   end process;

END;
