--------------MUX4x1 -------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.all;

entity MUX4x1 is 
	port (
    in0: in std_logic_vector (31 downto 0);
    in1: in std_logic_vector (31 downto 0);
    in2: in std_logic_vector (31 downto 0);
    in3: in std_logic_vector (31 downto 0);
    sel: in std_logic_vector (1 downto 0);
    out1: out std_logic_vector (31 downto 0));
end MUX4x1;     


architecture my_MUX4x1 of MUX4x1 is
begin

 out1 <= in0 when sel = "00" 
        else in1 when sel = "01"
        else in2 when sel = "10"
        else in3;

end my_MUX4x1; 







