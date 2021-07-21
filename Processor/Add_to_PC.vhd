--------------Add to PC Register -------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.all;

entity Add_to_PC is 
	port (
    PC: in std_logic_vector (31 downto 0);
    Add1or2 : in std_logic;
    PC_Added: out std_logic_vector (31 downto 0));
end Add_to_PC;     


architecture my_Add_to_PC of Add_to_PC is
-----Define the components and signals
signal PCinInteger: integer := 0;
signal SumOfThem: integer := 0;

begin

  PCininteger <= to_integer((unsigned(PC)));
  SumOfThem <= PCininteger + 1 when Add1or2 = '0' else PCininteger + 2;
  PC_Added <= std_logic_vector(to_unsigned(SumOfThem,32));


end my_Add_to_PC; 





