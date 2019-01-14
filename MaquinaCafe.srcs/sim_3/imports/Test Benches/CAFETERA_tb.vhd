
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY cafetera_tb IS
END cafetera_tb;
 
ARCHITECTURE behavioral OF cafetera_tb IS 
 
    COMPONENT cafetera
    PORT(
         clk : IN  std_logic;
         boton : IN  std_logic_vector(3 downto 0);
         display1 : OUT  std_logic_vector(7 downto 0);
         display2 : OUT  std_logic_vector(7 downto 0);
         display3 : OUT  std_logic_vector(7 downto 0);
         display4 : OUT  std_logic_vector(7 downto 0);
         led : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;

   signal clk : std_logic := '0';
   signal boton : std_logic_vector(3 downto 0) := (others => '0');


   signal display1 : std_logic_vector(7 downto 0);
   signal display2 : std_logic_vector(7 downto 0);
   signal display3 : std_logic_vector(7 downto 0);
   signal display4 : std_logic_vector(7 downto 0);
   signal led : std_logic_vector(7 downto 0);

   constant clk_period : time := 10 ns;
 
BEGIN
 
   uut: cafetera PORT MAP (
          clk => clk,
          boton => boton,
          display1 => display1,
          display2 => display2,
          display3 => display3,
          display4 => display4,
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

		boton<="0001";
		wait for 40 ns;
		boton<="0000";

      wait;
   end process;

END;