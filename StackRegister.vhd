------------32 bit Register---------------
library ieee;
use ieee.std_logic_1164.all;

entity StackReg_32 is
    port(clk,rst,enable:in std_logic; d: in std_logic_vector (31 downto 0); q: out std_logic_vector (31 downto 0));
end StackReg_32;

architecture a_Reg_32 of StackReg_32 is
begin
process(clk,rst)
begin
    if(rst = '1') then 
    q <= (x"FFFFFFFE");
    elsif falling_edge(clk) then
        if(enable ='1') then
            q<=d;
        end if;
    end if;
    end process;
end a_Reg_32;

