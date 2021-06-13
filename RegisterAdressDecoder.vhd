library ieee;
Use ieee.std_logic_1164.all;
ENTITY Decoder IS

PORT
(enable: IN std_logic ;
sel : IN std_logic_vector(2 DOWNTO 0);
F : OUT std_logic_vector(7 DOWNTO 0)

);
end Decoder;
ARCHITECTURE
a_Decoder OF Decoder is 
begin 
F<= "00000001"when enable = '1' and sel(2 downto 0) ="000"
else "00000010" when enable = '1' and sel (2 downto 0)="001"
else "00000100" when enable = '1' and sel (2 downto 0)="010"
else "00001000" when enable = '1' and sel (2 downto 0)="011"
else "00010000" when enable = '1' and sel (2 downto 0)="100"
else "00100000" when enable = '1' and sel (2 downto 0)="101"
else "01000000" when enable = '1' and sel (2 downto 0)="110"
else "10000000" when enable = '1' and sel (2 downto 0)="111"
else "00000000";

end a_Decoder;
