------------ID_EX_Stage---------------
library ieee;
use ieee.std_logic_1164.all;

entity ID_EX_Stage is
    port(clk,Flush,Stall:in std_logic; 
    PC_Added_1: in std_logic_vector (31 downto 0);
    INPORT: in std_logic_vector (31 downto 0);
    ReadData1: in std_logic_vector (31 downto 0);
    ReadData2: in std_logic_vector (31 downto 0);
    ExtendedImmOrShift: in std_logic_vector (31 downto 0);
    ALU_OP: in  std_logic_vector(3 downto 0);
    ReadData2_Immediate: in std_logic;
    AddressForWB: in std_logic_vector(2 downto 0);
    RegisterWriteEnable: in std_logic;
    INPORT_ALU: in std_logic;
    OUTPORT_ID_EX_IN: in std_logic;

    OUTPORT_ID_EX_OUT: out std_logic;
    PC_Added_1_OUT: OUT std_logic_vector (31 downto 0);
    INPORT_OUT: OUT std_logic_vector (31 downto 0);
    ReadData1_OUT: OUT std_logic_vector (31 downto 0);
    ReadData2_OUT: OUT std_logic_vector (31 downto 0);
    ExtendedImmOrShift_OUT: OUT std_logic_vector (31 downto 0);
    ALU_OP_OUT: OUT  std_logic_vector(3 downto 0);
    ReadData2_Immediate_OUT: OUT std_logic;
    AddressForWB_OUT: OUT std_logic_vector(2 downto 0);
    RegisterWriteEnable_OUT: OUT std_logic;
    INPORT_ALU_OUT: OUT std_logic);
   

end ID_EX_Stage;

architecture a_ID_EX_Stage of ID_EX_Stage is
component ID_EX_Reg is
    port(clk,rst,enable:in std_logic; d: in std_logic_vector (170 downto 0); q: out std_logic_vector (170 downto 0));
end component;

Signal DataIn: std_logic_vector (170 downto 0);
signal DataOut: std_logic_vector (170 downto 0);
signal Enable: std_logic;

begin
 DataIn <= OUTPORT_ID_EX_IN & PC_Added_1 & INPORT & ReadData1 & ReadData2 & ExtendedImmOrShift & ALU_OP & ReadData2_Immediate & AddressForWB & RegisterWriteEnable & INPORT_ALU;
 Enable <= '0' when (Stall = '1') else '1';
 Reg: ID_EX_Reg port map (clk,Flush,Enable,DataIn,DataOut);

 OUTPORT_ID_EX_OUT <= DataOut(170);
 PC_Added_1_OUT<= DataOut (169 downto 138);
 INPORT_OUT<= DataOut (137 downto 106);
 ReadData1_OUT<= DataOut (105 downto 74);
 ReadData2_OUT<= DataOut (73 downto 42);
 ExtendedImmOrShift_OUT<= DataOut (41 downto 10);
 ALU_OP_OUT<= DataOut (9 downto 6);
 ReadData2_Immediate_OUT<= DataOut (5);
 AddressForWB_OUT<= DataOut (4 downto 2);
 RegisterWriteEnable_OUT<= DataOut (1);
 INPORT_ALU_OUT<= DataOut (0);


end a_ID_EX_Stage;



