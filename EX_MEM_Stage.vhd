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
    WBWriteEnable_Out: OUT std_logic;
    -------------------------Memory and Stack Control Signals-----------
    MemoryWriteEnable_IN: in std_logic;
    SPEnable_IN: in std_logic;
    SelectorSP_IN: in std_logic; 
    SPNewOrOld_IN: in std_logic; 
    SPOrALUResult_IN: in std_logic; 
    ReadPCAddedOrReadData1_IN: in std_logic; 
    WBValueALUorMemory_IN: in std_logic;

    MemoryWriteEnable_OUT: out std_logic;
    SPEnable_OUT: out std_logic;
    SelectorSP_OUT: out std_logic; 
    SPNewOrOld_OUT: out std_logic; 
    SPOrALUResult_OUT: out std_logic; 
    ReadPCAddedOrReadData1_OUT: out std_logic; 
    WBValueALUorMemory_OUT: out std_logic;
    MEM_Read: in std_logic;
    MEM_Read_Out: out std_logic;
      ---------------------------------------------------------
    ---------------------Jump Signals ----------------------
    -------------------------------------------------------
    ReturnSignal : in std_logic;
    ReturnSignal_Out : out std_logic
    );

end EX_MEM_Stage;

architecture a_EX_MEM_Stage of EX_MEM_Stage is
component EX_MEM_Reg is
    port(clk,rst,enable:in std_logic; d: in std_logic_vector (108 downto 0); q: out std_logic_vector (108 downto 0));
end component;

Signal DataIn: std_logic_vector (108 downto 0);
signal DataOut: std_logic_vector (108 downto 0);
signal Enable: std_logic;

begin
 DataIn <= ReturnSignal & MEM_Read & 
 MemoryWriteEnable_IN & SPEnable_IN & SelectorSP_IN & SPNewOrOld_IN & SPOrALUResult_IN & ReadPCAddedOrReadData1_IN & WBValueALUorMemory_IN
 & PC_Added_1 & ALU_Result & ReadData1 & WBAddress &WBWriteEnable ;


 Enable <= '0' when (Stall = '1') else '1';
 Reg: EX_MEM_Reg port map (clk,Flush,Enable,DataIn,DataOut);
 ReturnSignal_Out <= DataOut(108);
 MEM_Read_Out <= DataOut(107);
 MemoryWriteEnable_OUT <= DataOut(106) ;
 SPEnable_OUT <= DataOut(105) ;
 SelectorSP_OUT <= DataOut(104);
 SPNewOrOld_OUT <= DataOut(103) ;
 SPOrALUResult_OUT <= DataOut(102) ;
 ReadPCAddedOrReadData1_OUT <= DataOut(101) ;
 WBValueALUorMemory_OUT <= DataOut(100);

 PC_Added_1_Out <= DataOut (99 downto 68);
 ALU_Result_OUT <= DataOut (67 downto 36);
 ReadData1_Out <= DataOut (35 downto 4);
 WBAddress_Out <= DataOut (3 downto 1);
 WBWriteEnable_Out <= DataOut (0);

end a_EX_MEM_Stage;




