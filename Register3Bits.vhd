------------3 bits Register---------------
library ieee;
use ieee.std_logic_1164.all;

entity Reg_3 is
    port(clk,rst,enable:in std_logic; d: in std_logic_vector (2 downto 0); q: out std_logic_vector (2 downto 0));
end Reg_3;

architecture a_Reg_3 of Reg_3 is
begin
process(clk,rst)
begin
    if(rst = '1') then 
    q <= (others => '0');
    elsif falling_edge(clk) then
        if(enable ='1') then
            q<=d;
        end if;
    end if;
    end process;
end a_Reg_3;



