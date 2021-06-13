------------MEM_WE_Stage---------------
library ieee;
use ieee.std_logic_1164.all;

entity MEM_WE_Stage is
    port(clk,Flush,Stall:in std_logic; 
    DataFromMemory: in std_logic_vector (31 downto 0);
    ALU_Result: in std_logic_vector (31 downto 0);
    WBAddress: in std_logic_vector (2 downto 0);
    WBWriteEnable: in std_logic;

    DataFromMemory_Out: OUT std_logic_vector (31 downto 0);
    ALU_Result_OUT: OUT std_logic_vector (31 downto 0);
    WBAddress_Out: OUT std_logic_vector (2 downto 0);
    WBWriteEnable_Out: OUT std_logic);

end MEM_WE_Stage;

architecture a_MEM_WE_Stage of MEM_WE_Stage is
component MEM_WE_Reg is
    port(clk,rst,enable:in std_logic; d: in std_logic_vector (67 downto 0); q: out std_logic_vector (67 downto 0));
end component;

Signal DataIn: std_logic_vector (67 downto 0);
signal DataOut: std_logic_vector (67 downto 0);
signal Enable: std_logic;

begin
 DataIn <= DataFromMemory & ALU_Result & WBAddress &WBWriteEnable ;
 Enable <= '0' when (Stall = '1') else '1';
 Reg: MEM_WE_Reg port map (clk,Flush,Enable,DataIn,DataOut);
 DataFromMemory_Out <= DataOut (67 downto 36);
 ALU_Result_OUT <= DataOut (35 downto 4);
 WBAddress_Out <= DataOut (3 downto 1);
 WBWriteEnable_Out <= DataOut (0);

end a_MEM_WE_Stage;





