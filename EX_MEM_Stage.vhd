------------EX_MEM_Stage---------------
library ieee;
use ieee.std_logic_1164.all;

entity EX_MEM_Stage is
    port(clk,Flush,Stall:in std_logic; 
    PC_Added_1: in std_logic_vector (31 downto 0);
    ALU_Result: in std_logic_vector (31 downto 0);
    ReadData1: in std_logic_vector (31 downto 0);
    WBAddress: in std_logic_vector (2 downto 0);
    WBWriteEnable: in std_logic;

    PC_Added_1_Out: OUT std_logic_vector (31 downto 0);
    ALU_Result_OUT: OUT std_logic_vector (31 downto 0);
    ReadData1_Out: OUT std_logic_vector (31 downto 0);
    WBAddress_Out: OUT std_logic_vector (2 downto 0);
    WBWriteEnable_Out: OUT std_logic);

end EX_MEM_Stage;

architecture a_EX_MEM_Stage of EX_MEM_Stage is
component EX_MEM_Reg is
    port(clk,rst,enable:in std_logic; d: in std_logic_vector (99 downto 0); q: out std_logic_vector (99 downto 0));
end component;

Signal DataIn: std_logic_vector (99 downto 0);
signal DataOut: std_logic_vector (99 downto 0);
signal Enable: std_logic;

begin
 DataIn <= PC_Added_1 & ALU_Result & ReadData1 & WBAddress &WBWriteEnable ;
 Enable <= '0' when (Stall = '1') else '1';
 Reg: EX_MEM_Reg port map (clk,Flush,Enable,DataIn,DataOut);
 PC_Added_1_Out <= DataOut (99 downto 68);
 ALU_Result_OUT <= DataOut (67 downto 36);
 ReadData1_Out <= DataOut (35 downto 4);
 WBAddress_Out <= DataOut (3 downto 1);
 WBWriteEnable_Out <= DataOut (0);

end a_EX_MEM_Stage;




