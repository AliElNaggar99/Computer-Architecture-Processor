--------------Processor -------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.all;

entity Processor is 
	port (
    clk: in std_logic;
    rst: in std_logic;
    INPort: in std_logic_vector (31 downto 0);
    OUTPort: out std_logic_vector (31 downto 0));
end Processor;     


architecture my_Processor of Processor is
-----Define the components and signals


-----------------Fetch Stage-------------------
-----------------PC Register-------------------
component PC_Register is
    port (
    clk: in std_logic;
    stall: in std_logic;
    PC_IN: in std_logic_vector (31 downto 0);
    PC_OUT: out std_logic_vector (31 downto 0)
    );
end component;

component Add_to_PC is 
port (
    PC: in std_logic_vector (31 downto 0);
    Add1or2 : in std_logic;
    PC_Added: out std_logic_vector (31 downto 0));
end component;

component MUX2x1 is 
	port (
    in0: in std_logic_vector (31 downto 0);
    in1: in std_logic_vector (31 downto 0);
    sel: in std_logic;
    out1: out std_logic_vector (31 downto 0));
end component;     

component MUX4x1 is 
	port (
    in0: in std_logic_vector (31 downto 0);
    in1: in std_logic_vector (31 downto 0);
    in2: in std_logic_vector (31 downto 0);
    in3: in std_logic_vector (31 downto 0);
    sel: in std_logic_vector (1 downto 0);
    out1: out std_logic_vector (31 downto 0));
end component;     

Component InstructionMemory is
    port(
    PC_value        : in std_logic_vector(31 downto 0);
    Instruction_out : out std_logic_vector(31 downto 0));
End Component ;

Component IF_ID_Stage is
    port(
    clk,Flush,Stall:in std_logic; 
    PC_Added_1: in std_logic_vector (31 downto 0);
    Instruction: in std_logic_vector (31 downto 0);
    INPORT: in std_logic_vector (31 downto 0);

    PC_Added_1_Out: OUT std_logic_vector (31 downto 0);
    Instruction_Out: OUT std_logic_vector (31 downto 0);
    INPORT_Out: OUT std_logic_vector (31 downto 0));
end Component;

------------------Decode Stage Components---------------
Component RegisterFile IS
    PORT(
     rst,clk      :in std_logic;
     Rsrc1,Rsrc2        :in std_logic_vector(2 downto 0); 
     Rsrc1_Out,Rsrc2_Out   :out std_logic_vector(31 downto 0);
     WriteData1   :in  std_logic_vector(31 downto 0);
     WriteReg1    :in std_logic_vector(2 downto 0);
     EnableRead: IN std_logic;
     EnableWrite : In std_logic);
end Component;

Component ControlUnit is
    port(
      OP: In std_logic_vector(4 downto 0);
      ALU_Op : out std_logic_vector(3 downto 0);
      -- MemoryReadEnable: out std_logic;
      -- MemoryWriteEnable: out std_logic;
       RegisterWriteEnable: out std_logic;
      -- IF_D_Flush : out std_logic;
      -- ID_EX_Flush: out std_logic;
       Shift_Immediate: out std_logic;
       ReadData2_Immediate: out std_logic; --might be changed later on
       OutPort_Enable : out std_logic;
       InPort_ALU : out std_logic
      -- Jump: out std_logic_vector(2 downto 0);
      -- Stack: out std_logic_vector(4 downto 0);
      -- PC : out std_logic_vector(1 downto 0);
      );
  end Component ;

  ------Register for the Output Port--------------------
  Component Reg_32 is
    port(clk,rst,enable:in std_logic; d: in std_logic_vector (31 downto 0); q: out std_logic_vector (31 downto 0));
  end Component;


----------------------Execute Componenets---------------
Component ID_EX_Stage is
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

end Component;

Component ALU is
    port(
      Rsrc: In std_logic_vector (31 downto 0);
      Rdst: In std_logic_vector (31 downto 0);
      OPcode: In std_logic_vector(3 downto 0);
      result : OUT std_logic_vector(31 downto 0);
      flagEnable: out std_logic;
      CarryOut: Out std_logic;
      ZeroFlag: OUT std_logic;
      NegativeOut: OUT std_logic;
      reset: in std_logic);
  end Component ;

Component Flag_Register is
    port(clk,rst,enable:in std_logic; 
    ZeroFlag: in std_logic;
    NegativeFlag: in std_logic;
    CarryFlag: in std_logic;

    ZeroFlag_Out: Out std_logic;
    NegativeFlag_Out: Out std_logic;
    CarryFlag_Out: Out std_logic);
end Component;


-----------------Memory Componenets---------------------
Component EX_MEM_Stage is
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
end Component;


-----------------Write Back Components------------------

Component MEM_WE_Stage is
    port(clk,Flush,Stall:in std_logic; 
    DataFromMemory: in std_logic_vector (31 downto 0);
    ALU_Result: in std_logic_vector (31 downto 0);
    WBAddress: in std_logic_vector (2 downto 0);
    WBWriteEnable: in std_logic;

    DataFromMemory_Out: OUT std_logic_vector (31 downto 0);
    ALU_Result_OUT: OUT std_logic_vector (31 downto 0);
    WBAddress_Out: OUT std_logic_vector (2 downto 0);
    WBWriteEnable_Out: OUT std_logic);

end Component;
-----------------Signals Fetch--------------------------
Signal PC_IN:  std_logic_vector (31 downto 0);
signal Stall_PC: std_logic;
Signal PC_OUT:  std_logic_vector (31 downto 0);
Signal ADDED_PC: std_logic_vector (31 downto 0);
signal MemoryIn: std_logic_vector(31 downto 0);
signal MemoryOut: std_logic_vector(31 downto 0);


--------------Signals Decode-----------------
signal Stall_IF_ID: std_logic;
signal Instruction: std_logic_vector (31 downto 0);
signal PC_Added_For_Call: std_logic_vector (31 downto 0);
signal INPORT_Decode: std_logic_vector (31 downto 0);
signal ReadData1: std_logic_vector (31 downto 0);
signal ReadData2: std_logic_vector (31 downto 0);
signal ALUOP_CODE: std_logic_vector (3 downto 0);
signal WriteBackEnableCU: std_logic;
signal Shift_Immed_MUX: std_logic;
signal ReadData2_Immed_MUX: std_logic;
signal OUTPortEnable: std_logic;
signal INPort_ALU_Result: std_logic;

signal ExtendShiftAmm: std_logic_vector(31 downto 0);
signal ExtendImmed: std_logic_vector (31 downto 0);
signal ImmedOrShift: std_logic_vector (31 downto 0);
signal ALU_Enable_CU: std_logic;

----------------Execute Stage signal----------------
signal Stall_ID_EX: std_logic;
signal PC_Added_For_Call_ID_EX: std_logic_vector (31 downto 0);
Signal INPORT_ID_EX: std_logic_vector (31 downto 0);
signal ReadData1_ID_EX: std_logic_vector (31 downto 0);
signal ReadData2_ID_EX: std_logic_vector (31 downto 0);
signal ExtendedImmOrShift_ID_EX: std_logic_vector (31 downto 0);
signal ALU_OP_ID_EX: std_logic_vector(3 downto 0);
signal ReadData2_Immediate_ID_EX: std_logic;
signal AddressForWB_ID_EX: std_logic_vector (2 downto 0);
signal RegisterWriteEnable_ID_EX: std_logic;
signal INPORT_ALU_ID_EXT:  std_logic;
signal OUTPORTEnable_ID_EX_OUT: std_logic;


signal SecondOperandMux: std_logic_vector (31 downto 0);
signal ALUResult: std_logic_vector (31 downto 0);
signal FlagEnable: std_logic;

signal CarryFlag_IN: std_logic;
signal NegativeFlag_IN: std_logic;
signal ZeroFlag_IN: std_logic;

signal CarryFlag: std_logic;
signal NegativeFlag: std_logic;
signal ZeroFlag: std_logic;

signal ALU_Result_OUT: std_logic_vector (31 downto 0);

------------------Memory Signals---------------------
signal Stall_EX_MEM: std_logic;
signal PC_ADDED_For_Ret_MEM: std_logic_vector (31 downto 0);
signal ALU_Result_EX_MEM:std_logic_vector (31 downto 0);
signal ReadData1_EX_MEM: std_logic_vector (31 downto 0);
signal WBAddress_EX_MEM: std_logic_vector (2 downto 0);
signal WBWriteEnable_EX_MEM: std_logic;

signal DataOutFromMemory: std_logic_vector (31 downto 0);

----------------WB Signals---------------------------
signal Stall_WE_MEM: std_logic;
signal WriteBackEnable: std_logic;
signal WriteBackDataAddress: std_logic_vector(2 downto 0);
signal WriteBackData: std_logic_vector(31 downto 0);

signal DataFromMemory_MEM_WB:  std_logic_vector (31 downto 0);
signal ALU_Result_MEM_WB: std_logic_vector (31 downto 0);
signal WBAddress_MEM_WB:  std_logic_vector (2 downto 0);
signal WBWriteEnable_MEM_WB: std_logic;

begin

------------------------Fetch Stage-----------------------------------------------
----------------------------------------------------------------------------------

------Before Rest PC Mux there should be a 4x1 MUX for the JUMPS------------------
-------------Rest PC or Get the next value form Memory----------------------------
PC_Rest_MUX: MUX2x1 Port map(ADDED_PC,MemoryOut,rst,PC_IN); 
----------PC Register ------------------------------------------------------------
PC_Reg: PC_Register Port map (clk,Stall_PC,PC_IN,PC_OUT);
--------PC or zero (rest) input to the memory-------------------------------------
INPUT_TO_MEM: MUX2x1 Port map (PC_OUT,(others => '0'),rst,MemoryIn); 
-------Instructions Memory--------------------------------------------------------
Instr: InstructionMemory port map (MemoryIn,MemoryOut);
-----------------------------------------------------------------------------------
AddToPC: Add_to_PC port map(MemoryIn,MemoryOut(16),ADDED_PC);


----------------------Fetch Decode Buffer------------------------------------------
IF_D: IF_ID_Stage port map (clk,rst,Stall_IF_ID,ADDED_PC,MemoryOut,INPort,PC_Added_For_Call,Instruction,INPORT_Decode);
-----------------------------------------------------------------------------------


------------------------Decode Stage-----------------------------------------------
-----------------------------------------------------------------------------------

------------------------------Register file and Control Unit-----------------------
Reg_File: RegisterFile port map (rst,clk,Instruction(26 downto 24),Instruction(23 downto 21),ReadData1,ReadData2,WriteBackData,WriteBackDataAddress,'1',WriteBackEnable);
CU: ControlUnit port map (Instruction(31 downto 27) , ALUOP_CODE , WriteBackEnableCU , Shift_Immed_MUX , ReadData2_Immed_MUX , OUTPortEnable , INPort_ALU_Result);

--------------------------Extend for the ALU ShiftORIMM-----------------------------
ExtendShiftAmm <= std_logic_vector(resize(signed(Instruction(23 downto 19)), 32));
ExtendImmed <= std_logic_vector(resize(signed(Instruction(15 downto 0)),32));
ShiftOrImmedMux: MUX2x1 Port map(ExtendShiftAmm,ExtendImmed,Shift_Immed_MUX,ImmedOrShift); 
-------------------------------------------------------------------------------------

--------------------------Decode Execute Buffer--------------------------------------
ID_EX: ID_EX_Stage port map(clk,rst,Stall_ID_EX,PC_Added_For_Call,INPORT_Decode,ReadData1,ReadData2,ImmedOrShift,ALUOP_CODE,ReadData2_Immed_MUX,Instruction(26 downto 24)
,WriteBackEnableCU,INPort_ALU_Result,OUTPortEnable,OUTPORTEnable_ID_EX_OUT,PC_Added_For_Call_ID_EX,INPORT_ID_EX,ReadData1_ID_EX,ReadData2_ID_EX,ExtendedImmOrShift_ID_EX,ALU_OP_ID_EX
,ReadData2_Immediate_ID_EX,AddressForWB_ID_EX,RegisterWriteEnable_ID_EX,INPORT_ALU_ID_EXT); 
-------------------------------------------------------------------------------------

----------------------------------Execute Stage---------------------------------------
--------------------------------------------------------------------------------------
ReadData2_ImmMUX: MUX2x1 port map (ReadData2_ID_EX,ExtendedImmOrShift_ID_EX,ReadData2_Immediate_ID_EX,SecondOperandMux);
MYALU: ALU port map (SecondOperandMux,ReadData1_ID_EX,ALU_OP_ID_EX,ALUResult,FlagEnable,CarryFlag_IN,ZeroFlag_IN,NegativeFlag_IN,rst);

FLAGS: Flag_Register port map (clk, rst, FlagEnable,ZeroFlag_IN,NegativeFlag_IN,CarryFlag_IN,ZeroFlag,NegativeFlag,CarryFlag);

ALU_res_INPUT_MUX:MUX2x1 port map (ALUResult,INPORT_ID_EX,INPORT_ALU_ID_EXT,ALU_Result_OUT);

OUTPORT_REG: Reg_32 port map(clk , rst , OUTPORTEnable_ID_EX_OUT , ReadData1_ID_EX ,OUTPort);
---------------------------------------------------------------------------------------



-------------------------------Execute Memory Buffer-----------------------------------
EX_MEM: EX_MEM_Stage port map (clk,rst,Stall_EX_MEM,PC_Added_For_Call_ID_EX,ALU_Result_OUT,ReadData1_ID_EX,AddressForWB_ID_EX,RegisterWriteEnable_ID_EX
,PC_ADDED_For_Ret_MEM,ALU_Result_EX_MEM,ReadData1_EX_MEM,WBAddress_EX_MEM,WBWriteEnable_EX_MEM);
---------------------------------------------------------------------------------------

-------------------------------------Memory Stage--------------------------------------
---------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------


------------------------------------Memory WB Buffer-----------------------------------
MEM_WB: MEM_WE_Stage port map (clk,rst,Stall_WE_MEM,DataOutFromMemory,ALU_Result_EX_MEM,WBAddress_EX_MEM,WBWriteEnable_EX_MEM,DataFromMemory_MEM_WB
,ALU_Result_MEM_WB,WBAddress_MEM_WB,WBWriteEnable_MEM_WB);
---------------------------------------------------------------------------------------


-------------------------------------Write Back Stage----------------------------------
---------------------------------------------------------------------------------------
WriteBackEnable <= WBWriteEnable_MEM_WB;
WriteBackDataAddress <= WBAddress_MEM_WB;
WriteBackData <= ALU_Result_MEM_WB; -------For now next process it will be a mux it value may make it Reg write value w khalas
---------------------------------------------------------------------------------------


Stall_WE_MEM  <= '0' ;
Stall_ID_EX <= '0' ;
Stall_ID_EX <= '0' ;
Stall_IF_ID <= '0' ;

end my_Processor; 



