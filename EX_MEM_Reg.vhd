------------EX_MEM bit Register---------------
library ieee;
use ieee.std_logic_1164.all;

entity EX_MEM_Reg is
    port(clk,rst,enable:in std_logic; d: in std_logic_vector (99 downto 0); q: out std_logic_vector (99 downto 0));
end EX_MEM_Reg;

architecture a_EX_MEM_Reg of EX_MEM_Reg is
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
end a_EX_MEM_Reg;


