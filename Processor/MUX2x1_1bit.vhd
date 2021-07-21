--------------MUX2x1_1bit -------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.all;

entity MUX2x1_1bit is 
	port (
    in0: in std_logic;
    in1: in std_logic;
    sel: in std_logic;
    out1: out std_logic);
end MUX2x1_1bit;     


architecture my_MUX2x1_1bit of MUX2x1_1bit is
begin

 out1 <= in0 when sel = '0' else in1;

end my_MUX2x1_1bit; 







