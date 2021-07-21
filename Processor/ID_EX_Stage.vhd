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
    ReadData2_Immediate: in std_logic_vector (1 downto 0);
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
    ReadData2_Immediate_OUT: OUT std_logic_vector (1 downto 0);
    AddressForWB_OUT: OUT std_logic_vector(2 downto 0);
    RegisterWriteEnable_OUT: OUT std_logic;
    INPORT_ALU_OUT: OUT std_logic;
    -------------------------Memory and Stack Control Signals-----------
    MemoryWriteEnable_IN: in std_logic;
    SPEnable_IN: in std_logic;
    SelectorSP_IN: in std_logic; 
    SPNewOrOld_IN: in std_logic; 
    SPOrALUResult_IN: in std_logic; 
    ReadPCAddedOrReadData1_IN: in std_logic; 
    WBValueALUorMemory_IN: in std_logic;
    ReadData1_ReadData2_IN: in std_logic_vector (1 downto 0);

    MemoryWriteEnable_OUT: out std_logic;
    SPEnable_OUT: out std_logic;
    SelectorSP_OUT: out std_logic; 
    SPNewOrOld_OUT: out std_logic; 
    SPOrALUResult_OUT: out std_logic; 
    ReadPCAddedOrReadData1_OUT: out std_logic; 
    WBValueALUorMemory_OUT: out std_logic;
    ReadData1_ReadData2_OUT: out std_logic_vector (1 downto 0);
    ------------------------------Address second operand for FU-------------------
    Rsrc2: in std_logic_vector(2 downto 0);
    Rsrc2_Out: out std_logic_vector(2 downto 0);
    MEM_Read: in std_logic;
    MEM_Read_Out: out std_logic;
    ---------------------------------------------------------
    ---------------------Jump Signals ----------------------
    --------------------------------------------------------
  
    JumpSignal : in std_logic_vector(1 downto 0);
    JumpEnable: in std_logic;
    ReturnSignal : in std_logic;

    JumpSignal_Out : out std_logic_vector(1 downto 0);
    JumpEnable_Out: out std_logic;
    ReturnSignal_Out : out std_logic

    );
end ID_EX_Stage;

architecture a_ID_EX_Stage of ID_EX_Stage is
component ID_EX_Reg is
    port(clk,rst,enable:in std_logic; d: in std_logic_vector (188 downto 0); q: out std_logic_vector (188 downto 0));
end component;

Signal DataIn: std_logic_vector (188 downto 0);
signal DataOut: std_logic_vector (188 downto 0);
signal Enable: std_logic;

begin
 DataIn <= JumpSignal&JumpEnable&ReturnSignal
 &MEM_Read & Rsrc2 & MemoryWriteEnable_IN & SPEnable_IN & SelectorSP_IN & SPNewOrOld_IN & SPOrALUResult_IN & ReadPCAddedOrReadData1_IN & WBValueALUorMemory_IN & ReadData1_ReadData2_IN
 & OUTPORT_ID_EX_IN & PC_Added_1 & INPORT & ReadData1 & ReadData2 & ExtendedImmOrShift & ALU_OP & ReadData2_Immediate & AddressForWB & RegisterWriteEnable & INPORT_ALU;
 
 Enable <= '0' when (Stall = '1') else '1';
 Reg: ID_EX_Reg port map (clk,Flush,Enable,DataIn,DataOut);
 
 JumpSignal_Out <= DataOut(188 downto 187);
 JumpEnable_Out <= DataOut(186);
 ReturnSignal_Out <= DataOut(185);
 MEM_Read_Out <= DataOut(184);
 Rsrc2_Out <= DataOut(183 downto 181);
 MemoryWriteEnable_OUT <= DataOut(180) ;
 SPEnable_OUT <= DataOut(179) ;
 SelectorSP_OUT <= DataOut(178);
 SPNewOrOld_OUT <= DataOut(177) ;
 SPOrALUResult_OUT <= DataOut(176) ;
 ReadPCAddedOrReadData1_OUT <= DataOut(175) ;
 WBValueALUorMemory_OUT <= DataOut(174) ;
 ReadData1_ReadData2_OUT <= DataOut(173 downto 172);

 OUTPORT_ID_EX_OUT <= DataOut(171);
 PC_Added_1_OUT<= DataOut (170 downto 139);
 INPORT_OUT<= DataOut (138 downto 107);
 ReadData1_OUT<= DataOut (106 downto 75);
 ReadData2_OUT<= DataOut (74 downto 43);
 ExtendedImmOrShift_OUT<= DataOut (42 downto 11);
 ALU_OP_OUT<= DataOut (10 downto 7);
 ReadData2_Immediate_OUT<= DataOut (6 downto 5);
 AddressForWB_OUT<= DataOut (4 downto 2);
 RegisterWriteEnable_OUT<= DataOut (1);
 INPORT_ALU_OUT<= DataOut (0);


end a_ID_EX_Stage;



