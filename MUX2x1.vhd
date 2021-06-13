--------------MUX2x1 -------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.all;

entity MUX2x1 is 
	port (
    in0: in std_logic_vector (31 downto 0);
    in1: in std_logic_vector (31 downto 0);
    sel: in std_logic;
    out1: out std_logic_vector (31 downto 0));
end MUX2x1;     


architecture my_MUX2x1 of MUX2x1 is
begin

 out1 <= in0 when sel = '0' else in1;

end my_MUX2x1; 






