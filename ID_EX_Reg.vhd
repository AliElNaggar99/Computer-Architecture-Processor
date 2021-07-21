------------ID_EX  bit Register---------------
library ieee;
use ieee.std_logic_1164.all;

entity ID_EX_Reg is
    port(clk,rst,enable:in std_logic; d: in std_logic_vector (188 downto 0); q: out std_logic_vector (188 downto 0));
end ID_EX_Reg;

architecture a_ID_EX_Reg of ID_EX_Reg is
begin
process(clk,rst)
begin
    if(rst = '1') then 
    q <= (others => '0');
    elsif rising_edge(clk) then
        if(enable ='1') then
            q<=d;
        end if;
    end if;
    end process;
end a_ID_EX_Reg;



