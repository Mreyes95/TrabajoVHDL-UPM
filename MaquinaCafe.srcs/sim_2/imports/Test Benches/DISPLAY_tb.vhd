
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY display_tb IS
END display_tb;
 
ARCHITECTURE behavioral OF display_tb IS 
 
    COMPONENT display
    PORT(
         display1 : IN  std_logic_vector(7 downto 0);
         display2 : IN  std_logic_vector(7 downto 0);
         display3 : IN  std_logic_vector(7 downto 0);
         display4 : IN  std_logic_vector(7 downto 0);
         clk : IN  std_logic;
         pantalla : OUT  std_logic_vector(7 downto 0);
         control : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    
   signal display1 : std_logic_vector(7 downto 0) := (others => '0');
   signal display2 : std_logic_vector(7 downto 0) := (others => '0');
   signal display3 : std_logic_vector(7 downto 0) := (others => '0');
   signal display4 : std_logic_vector(7 downto 0) := (others => '0');
   signal clk : std_logic := '0';

   signal pantalla : std_logic_vector(7 downto 0);
   signal control : std_logic_vector(3 downto 0);

   constant clk_period : time := 20 ns;
 
BEGIN
 
   uut: display PORT MAP (
          display1 => display1,
          display2 => display2,
          display3 => display3,
          display4 => display4,
          clk => clk,
          pantalla => pantalla,
          control => control
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

		wait for 40 ns;
		display1<="00110001";--P
		display2<="00110001";--P
		display3<="00110001";--P
		display4<="00110001";--P

      wait;
   end process;

END;
