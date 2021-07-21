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
    ---MEM write---------
    MemoryWriteEnable: out std_logic;
    ----------Stack Signals-----------
    SPEnable: out std_logic;
    SelectorSP: out std_logic; --------------add 2 or subtract 2-------------
    SPNewOrOld: out std_logic; -----------Output the Value after Add or before the Add-------------------
    SPOrALUResult: out std_logic; -----------------Memory Write Data------------------------------
    ReadPCAddedOrReadData1: out std_logic; --------------------PCAdded For Call-------------------
    -------Write enable-------------
    RegisterWriteEnable: out std_logic;
    WBValueALUorMemory: out std_logic;
    -- IF_D_Flush : out std_logic;
    -- ID_EX_Flush: out std_logic;
    Shift_Immediate: out std_logic;
    ReadData2_Immediate: out std_logic_vector (1 downto 0); --might be changed later on
    ReadData1_ReadData2: out std_logic_vector (1 downto 0); -- Might be changed later for FU
    OutPort_Enable : out std_logic;
    InPort_ALU : out std_logic;
    -- Jump: out std_logic_vector(2 downto 0);
    -- PC : out std_logic_vector(1 downto 0);
    MEM_Read: out std_logic;
    Stall_The_Pipe: in std_logic;

    ---------------------------------------------------------
    ---------------------Jump Signals ----------------------
    --------------------------------------------------------
  
    JumpSignal : out std_logic_vector(1 downto 0);
    JumpEnable: out std_logic;
    ReturnSignal : out std_logic
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

  Component CU_Jump is
    port (
      ZFlag: in std_logic;
      NFlag: in std_logic;
      CFlag: in std_logic;
      JumpSignal :in std_logic_vector(1 downto 0);
      JumpEnable: in std_logic;
      JumpOrNot : out std_logic;
      ConditionalJump: out std_logic;
      ZFlag_NEW: out std_logic;
      NFlag_NEW: out std_logic;
      CFlag_NEW: out std_logic
    ) ;
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

Component FU is
    port (
      Rsrc1: In std_logic_vector(2 downto 0);
      Rsrc2: In std_logic_vector(2 downto 0);
  
      CU_signal1: In std_logic_vector(1 downto 0);
      CU_signal2: In std_logic_vector(1 downto 0);
  
      AddressExc : In std_logic_vector(2 downto 0);
      WbEnableExc : in std_logic;
  
      AddressMem : In std_logic_vector(2 downto 0);
      WbEnableMem : in std_logic;
  
      mux1_Selector: out std_logic_vector(1 downto 0);
      mux2_Selector: out std_logic_vector(1 downto 0);
      First_Operand_MUX: out std_logic_vector (1 downto 0)
    ) ;
  end Component ;

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
end Component;

------------------Memory Components--------------------
Component DataMemory is
    port(clk                         : in std_logic;     
    WriteEnable                 : in std_logic;
    address                     : in std_logic_vector(31 downto 0);
    datain                      : in std_logic_vector(31 downto 0);
    dataout                     : out std_logic_vector(31 downto 0));
  End Component;

  Component Stack_CU is
    port (
      rst : in std_logic;
      clk : in std_logic;
      SPEnable: in std_logic;
      SelectorSP : in std_logic;
      SPNewOrOld : in std_logic;
      SP : out std_logic_vector(31 downto 0)
    ) ;
  end Component ;
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
    WBWriteEnable_Out: OUT std_logic;

    WBValueALUorMemory_IN: in std_logic;
    WBValueALUorMemory_OUT: out std_logic
    );

end Component;
-----------------Signals Fetch--------------------------
Signal PC_IN:  std_logic_vector (31 downto 0);
signal Stall_PC: std_logic;
Signal PC_OUT:  std_logic_vector (31 downto 0);
Signal ADDED_PC: std_logic_vector (31 downto 0);
signal MemoryIn: std_logic_vector(31 downto 0);
signal MemoryOut: std_logic_vector(31 downto 0);
-----signal For Memory in Reset to extend first 16 bit-----
signal ResetAddress: std_logic_vector (31 downto 0);

-----------------------------------------------
-----------------------------------------------
--------------Signals Decode-------------------
signal Stall_IF_ID: std_logic;
signal Instruction: std_logic_vector (31 downto 0);
signal PC_Added_For_Call: std_logic_vector (31 downto 0);
signal INPORT_Decode: std_logic_vector (31 downto 0);
signal ReadData1: std_logic_vector (31 downto 0);
signal ReadData2: std_logic_vector (31 downto 0);
signal ALUOP_CODE: std_logic_vector (3 downto 0);
signal WriteBackEnableCU: std_logic;
signal Shift_Immed_MUX: std_logic;
signal ReadData2_Immed_MUX: std_logic_vector (1 downto 0);
signal OUTPortEnable: std_logic;
signal INPort_ALU_Result: std_logic;

signal ExtendShiftAmm: std_logic_vector(31 downto 0);
signal ExtendImmed: std_logic_vector (31 downto 0);
signal ImmedOrShift: std_logic_vector (31 downto 0);
signal ALU_Enable_CU: std_logic;
---------Memory Signals In Decode--------
 signal MemoryWriteEnable_Decode: std_logic;
 signal SPEnable_Decode: std_logic;
 Signal SPNewOrOld_Decode: std_logic;
 signal SelectorSP_Decode: std_logic;
 signal SPOrALUResult_Decode: std_logic;
 signal ReadPCAddedOrReadData1_Decode: std_logic;
 signal WBValueALUorMemory_Decode: std_logic;
 signal ReadData1_ReadData2_MUX_Decode: std_logic_vector (1 downto 0);
 signal MEM_Read_Decode: std_logic;
 
---------------------------------------------------
---------------------------------------------------
----------------Execute Stage signal----------------
signal Stall_ID_EX: std_logic;
signal PC_Added_For_Call_ID_EX: std_logic_vector (31 downto 0);
Signal INPORT_ID_EX: std_logic_vector (31 downto 0);
signal ReadData1_ID_EX: std_logic_vector (31 downto 0);
signal ReadData2_ID_EX: std_logic_vector (31 downto 0);
signal ExtendedImmOrShift_ID_EX: std_logic_vector (31 downto 0);
signal ALU_OP_ID_EX: std_logic_vector(3 downto 0);
signal ReadData2_Immediate_ID_EX: std_logic_vector (1 downto 0);
signal AddressForWB_ID_EX: std_logic_vector (2 downto 0);
signal RegisterWriteEnable_ID_EX: std_logic;
signal INPORT_ALU_ID_EXT:  std_logic;
signal OUTPORTEnable_ID_EX_OUT: std_logic;


signal SecondOperandMux_Out: std_logic_vector (31 downto 0);
signal FirstOperandMux_Out: std_logic_vector (31 downto 0);
signal ALUResult: std_logic_vector (31 downto 0);
signal FlagEnable: std_logic;

signal CarryFlag_IN: std_logic;
signal NegativeFlag_IN: std_logic;
signal ZeroFlag_IN: std_logic;

signal CarryFlag: std_logic;
signal NegativeFlag: std_logic;
signal ZeroFlag: std_logic;

signal ALU_Result_OUT: std_logic_vector (31 downto 0);

signal First_Operand_MUX_Selectors: std_logic_vector (1 downto 0);
signal Second_Operand_MUX_Selectors: std_logic_vector (1 downto 0);
signal Src2_FU: std_logic_vector (2 downto 0);

signal ReadData1FromFU_MUX_Selector: std_logic_vector(1 downto 0);
signal ReadData1FromFU_MUXTo_EX_MEM: std_logic_vector (31 downto 0);

---------Memory Signals In Execute Stage--------
signal MemoryWriteEnable_Execute: std_logic;
signal SPEnable_Execute: std_logic;
Signal SPNewOrOld_Execute: std_logic;
signal SelectorSP_Execute: std_logic;
signal SPOrALUResult_Execute: std_logic;
signal ReadPCAddedOrReadData1_Execute: std_logic;
signal WBValueALUorMemory_Execute: std_logic;
signal ReadData1_ReadData2_MUX_Execute: std_logic_vector (1 downto 0);
signal MEM_Read_Execute: std_logic;
-----------------------------------------------------
-----------------------------------------------------
------------------Memory Signals---------------------
signal Stall_EX_MEM: std_logic;
signal PC_ADDED_For_Ret_MEM: std_logic_vector (31 downto 0);
signal ALU_Result_EX_MEM:std_logic_vector (31 downto 0);
signal ReadData1_EX_MEM: std_logic_vector (31 downto 0);
signal WBAddress_EX_MEM: std_logic_vector (2 downto 0);
signal WBWriteEnable_EX_MEM: std_logic;

signal AddressInMemory : std_logic_vector (31 downto 0);
signal WriteDataInMemory: std_logic_vector (31 downto 0);
signal DataOutFromMemory: std_logic_vector (31 downto 0);
signal StackPointer: std_logic_vector (31 downto 0);

--------------------Memory and Stack Signals-----------
signal MemoryWriteEnable_Memory: std_logic;
signal SPEnable_Memory: std_logic;
Signal SPNewOrOld_Memory: std_logic;
signal SelectorSP_Memory: std_logic;
signal SPOrALUResult_Memory: std_logic;
signal ReadPCAddedOrReadData1_Memory: std_logic;
signal WBValueALUorMemory_Memory: std_logic;
signal MEM_Read_Memory: std_logic;

-----------------------------------------------------
----------------WB Signals---------------------------
signal Stall_WE_MEM: std_logic;
signal WriteBackEnable: std_logic;
signal WriteBackDataAddress: std_logic_vector(2 downto 0);
signal WriteBackData: std_logic_vector(31 downto 0);
signal WBValueALUorMemory_WB: std_logic;


signal DataFromMemory_MEM_WB:  std_logic_vector (31 downto 0);
signal ALU_Result_MEM_WB: std_logic_vector (31 downto 0);
signal WBAddress_MEM_WB:  std_logic_vector (2 downto 0);
signal WBWriteEnable_MEM_WB: std_logic;
--------------------Hazard Detection Unit---------------------

component HDU is
    port ( 
      Rdst: in std_logic_vector (2 downto 0);
      Rsrc: in std_logic_vector (2 downto 0);
      RdstInExc: in std_logic_vector(2 downto 0);
      MemReadInEx: in std_logic;
      SignalToStall: out std_logic;
     -----------------JUMP Signals-----------------------
     JumpOrNot: in std_logic;
     ReturnSignal: in std_logic; ------From Memory 
     PCSelector: out std_logic_vector(1 downto 0);
 
     FlushFor_IF_ID : out std_logic
     --FlushFor_ID_EX : out std_logic
    );
  end component ;

  signal Stall_LoadCase: std_logic;
  signal ID_EX_Flush: std_logic;
  signal PC_Selector: std_logic_vector (1 downto 0);
  signal IF_ID_Flush: std_logic;


  --------------------JUMP units Signals wire----------------------
  signal JumpOrNot: std_logic;
  ----------------signals from CU----------------------
  signal JumpSignal_CU: std_logic_vector (1 downto 0);
  signal JumpEnable_CU: std_logic;
  Signal ReturnSignal_CU: std_logic;

  -------------------Signal From ID_EX_Buffers-----------------
  signal JumpSignal_ID_EX: std_logic_vector (1 downto 0);
  signal JumpEnable_ID_EX: std_logic;
  Signal ReturnSignal_ID_EX: std_logic;
  ------------------Signal From MEM Buffers--------------------
  Signal ReturnSignal_EX_MEM: std_logic;
  signal ID_Flush_FromHarzards: std_logic;
  signal PC_From_Selector: std_logic_vector (31 downto 0);


  ---------------Flags Signal---------------------------------
  signal ConditionalJump_From_Jump_CU: std_logic;
  signal ZFlag_NEW_From_Jump_CU: std_logic;
  signal NFlag_NEW_From_Jump_CU: std_logic;
  signal CFlag_NEW_From_Jump_CU: std_logic;
 
  -------------------------------------------------------------
  -------------------New Flags in signals----------------------
  signal Flag_IN_New_Enable   : std_logic;    
  signal Flag_IN_New_Zero     : std_logic; 
  signal Flag_IN_New_Negative : std_logic;
  signal Flag_IN_New_Carry    : std_logic;


  ---------------------------NEW MUX------------------------------------
  component MUX2x1_1bit is 
	port (
    in0: in std_logic;
    in1: in std_logic;
    sel: in std_logic;
    out1: out std_logic);
  end component;     


begin

------------------------Fetch Stage-----------------------------------------------
----------------------------------------------------------------------------------
PC_MUX_Selector: MUX4x1 Port map (ADDED_PC,ReadData1FromFU_MUXTo_EX_MEM,DataOutFromMemory,ADDED_PC,PC_Selector,PC_From_Selector);
------Before Rest PC Mux there should be a 4x1 MUX for the JUMPS------------------
-------------Rest PC or Get the next value form Memory----------------------------
ResetAddress <= std_logic_vector(resize(unsigned(MemoryOut(31 downto 16)), 32));
PC_Rest_MUX: MUX2x1 Port map(PC_From_Selector,ResetAddress,rst,PC_IN); 
----------PC Register ------------------------------------------------------------
PC_Reg: PC_Register Port map (clk,Stall_PC,PC_IN,PC_OUT);
--------PC or zero (rest) input to the memory-------------------------------------
INPUT_TO_MEM: MUX2x1 Port map (PC_OUT,(others => '0'),rst,MemoryIn); 
-------Instructions Memory--------------------------------------------------------
Instr: InstructionMemory port map (MemoryIn,MemoryOut);
-----------------------------------------------------------------------------------
AddToPC: Add_to_PC port map(MemoryIn,MemoryOut(16),ADDED_PC);


----------------------Fetch Decode Buffer------------------------------------------
IF_D: IF_ID_Stage port map (clk,IF_ID_Flush,Stall_IF_ID,ADDED_PC,MemoryOut,INPort,PC_Added_For_Call,Instruction,INPORT_Decode);
-----------------------------------------------------------------------------------


------------------------Decode Stage-----------------------------------------------
-----------------------------------------------------------------------------------

------------------------------Register file and Control Unit-----------------------
Reg_File: RegisterFile port map (rst,clk,Instruction(26 downto 24),Instruction(23 downto 21),ReadData1,ReadData2,WriteBackData,WriteBackDataAddress,'1',WriteBackEnable);
CU: ControlUnit port map (Instruction(31 downto 27) , ALUOP_CODE, MemoryWriteEnable_Decode ,SPEnable_Decode,SPNewOrOld_Decode,SelectorSP_Decode,SPOrALUResult_Decode,
ReadPCAddedOrReadData1_Decode,WriteBackEnableCU ,WBValueALUorMemory_Decode,Shift_Immed_MUX ,ReadData2_Immed_MUX,ReadData1_ReadData2_MUX_Decode
,OUTPortEnable , INPort_ALU_Result,MEM_Read_Decode,Stall_LoadCase,JumpSignal_CU,JumpEnable_CU,ReturnSignal_CU);

--------------------------Extend for the ALU ShiftORIMM-----------------------------
ExtendShiftAmm <= std_logic_vector(resize(unsigned(Instruction(23 downto 19)), 32));
ExtendImmed <= std_logic_vector(resize(unsigned(Instruction(15 downto 0)),32));
ShiftOrImmedMux: MUX2x1 Port map(ExtendShiftAmm,ExtendImmed,Shift_Immed_MUX,ImmedOrShift); 
-------------------------------------------------------------------------------------

--------------------------Decode Execute Buffer--------------------------------------
ID_EX: ID_EX_Stage port map(clk,ID_EX_Flush,Stall_ID_EX,PC_Added_For_Call,INPORT_Decode,ReadData1,ReadData2,ImmedOrShift,ALUOP_CODE,ReadData2_Immed_MUX,Instruction(26 downto 24)
,WriteBackEnableCU,INPort_ALU_Result,OUTPortEnable,OUTPORTEnable_ID_EX_OUT,PC_Added_For_Call_ID_EX,INPORT_ID_EX,ReadData1_ID_EX,ReadData2_ID_EX,ExtendedImmOrShift_ID_EX,ALU_OP_ID_EX
,ReadData2_Immediate_ID_EX,AddressForWB_ID_EX,RegisterWriteEnable_ID_EX,INPORT_ALU_ID_EXT,MemoryWriteEnable_Decode,SPEnable_Decode,SelectorSP_Decode,SPNewOrOld_Decode
,SPOrALUResult_Decode,ReadPCAddedOrReadData1_Decode,WBValueALUorMemory_Decode,ReadData1_ReadData2_MUX_Decode,MemoryWriteEnable_Execute,SPEnable_Execute,SelectorSP_Execute
,SPNewOrOld_Execute,SPOrALUResult_Execute, ReadPCAddedOrReadData1_Execute,WBValueALUorMemory_Execute,ReadData1_ReadData2_MUX_Execute, Instruction (23 downto 21),Src2_FU
,MEM_Read_Decode,MEM_Read_Execute,JumpSignal_CU,JumpEnable_CU,ReturnSignal_CU,JumpSignal_ID_EX,JumpEnable_ID_EX,ReturnSignal_ID_EX); 
-------------------------------------------------------------------------------------

----------------------------------Execute Stage---------------------------------------
--------------------------------------------------------------------------------------

------------------------------------Forward Unit--------------------------------------
ForwardUnit: FU port map (AddressForWB_ID_EX,Src2_FU,ReadData1_ReadData2_MUX_Execute,ReadData2_Immediate_ID_EX,WBAddress_EX_MEM,WBWriteEnable_EX_MEM
,WBAddress_MEM_WB,WBWriteEnable_MEM_WB ,First_Operand_MUX_Selectors ,Second_Operand_MUX_Selectors,ReadData1FromFU_MUX_Selector);

FirstOperand_FU_MUX: MUX4x1 port map (ReadData1_ID_EX , ALU_Result_EX_MEM ,WriteBackData,ReadData2_ID_EX,ReadData1FromFU_MUX_Selector,ReadData1FromFU_MUXTo_EX_MEM); 

---------------------------------FirstOperand Mux------------------------------------
FirstOperand_MUX: MUX4x1 port map (ReadData1_ID_EX , ALU_Result_EX_MEM ,WriteBackData,ReadData2_ID_EX,First_Operand_MUX_Selectors,FirstOperandMux_Out); 

---------------------------------SecondOperand Mux------------------------------------
SecondOperand_MUX: MUX4x1 port map (ReadData2_ID_EX, ExtendedImmOrShift_ID_EX, ALU_Result_EX_MEM ,WriteBackData,Second_Operand_MUX_Selectors,SecondOperandMux_Out);

--------------------------------------ALU--------------------------------------------
MYALU: ALU port map (SecondOperandMux_Out,FirstOperandMux_Out,ALU_OP_ID_EX,ALUResult,FlagEnable,CarryFlag_IN,ZeroFlag_IN,NegativeFlag_IN,rst);

----------------------------------------------Flags MUX-----------------------------------------------------
Flag_Enable_MUX:  MUX2x1_1bit port map (FlagEnable,ConditionalJump_From_Jump_CU,ConditionalJump_From_Jump_CU,Flag_IN_New_Enable);
ZeroFlag_MUX:  MUX2x1_1bit port map (ZeroFlag_IN,ZFlag_NEW_From_Jump_CU ,ConditionalJump_From_Jump_CU,Flag_IN_New_Zero);
CarryFlag_MUX:  MUX2x1_1bit port map (CarryFlag_IN,CFlag_NEW_From_Jump_CU,ConditionalJump_From_Jump_CU,Flag_IN_New_Carry);
NegativeFlag_Mux:   MUX2x1_1bit port map (NegativeFlag_IN,NFlag_NEW_From_Jump_CU,ConditionalJump_From_Jump_CU,Flag_IN_New_Negative);

FLAGS: Flag_Register port map (clk, rst, Flag_IN_New_Enable,Flag_IN_New_Zero,Flag_IN_New_Negative,Flag_IN_New_Carry,ZeroFlag,NegativeFlag,CarryFlag);



ControlUnitFlags: CU_JUMP port map (ZeroFlag,NegativeFlag,CarryFlag,JumpSignal_ID_EX,JumpEnable_ID_EX,JumpOrNot,ConditionalJump_From_Jump_CU
,ZFlag_NEW_From_Jump_CU,NFlag_NEW_From_Jump_CU,CFlag_NEW_From_Jump_CU);




ALU_res_INPUT_MUX:MUX2x1 port map (ALUResult,INPORT_ID_EX,INPORT_ALU_ID_EXT,ALU_Result_OUT);

OUTPORT_REG: Reg_32 port map(clk , rst , OUTPORTEnable_ID_EX_OUT , ReadData1FromFU_MUXTo_EX_MEM ,OUTPort);
--------------------------------------------------------------------------------------



-------------------------------Execute Memory Buffer-----------------------------------
EX_MEM: EX_MEM_Stage port map (clk,rst,Stall_EX_MEM,PC_Added_For_Call_ID_EX,ALU_Result_OUT,ReadData1FromFU_MUXTo_EX_MEM,AddressForWB_ID_EX,RegisterWriteEnable_ID_EX
,PC_ADDED_For_Ret_MEM,ALU_Result_EX_MEM,ReadData1_EX_MEM,WBAddress_EX_MEM,WBWriteEnable_EX_MEM,MemoryWriteEnable_Execute,SPEnable_Execute,SelectorSP_Execute
,SPNewOrOld_Execute,SPOrALUResult_Execute, ReadPCAddedOrReadData1_Execute,WBValueALUorMemory_Execute,MemoryWriteEnable_Memory,SPEnable_Memory,SelectorSP_Memory
,SPNewOrOld_Memory,SPOrALUResult_Memory,ReadPCAddedOrReadData1_Memory,WBValueALUorMemory_Memory,MEM_Read_Execute,MEM_Read_Memory,
ReturnSignal_ID_EX,ReturnSignal_EX_MEM);
---------------------------------------------------------------------------------------
-------------------------------------Memory Stage--------------------------------------
---------------------------------------------------------------------------------------

Stack: Stack_CU port map(rst,clk,SPEnable_Memory,SelectorSP_Memory,SPNewOrOld_Memory,StackPointer);

AddressInMemory_MUX: MUX2x1 port map (StackPointer,ALU_Result_EX_MEM,SPOrALUResult_Memory,AddressInMemory);
DataInMemory_MUX: MUX2x1 port map (PC_ADDED_For_Ret_MEM,ReadData1_EX_MEM,ReadPCAddedOrReadData1_Memory,WriteDataInMemory);

Memory: DataMemory port map(clk,MemoryWriteEnable_Memory,AddressInMemory,WriteDataInMemory,DataOutFromMemory);
---------------------------------------------------------------------------------------


------------------------------------Memory WB Buffer-----------------------------------
MEM_WB: MEM_WE_Stage port map (clk,rst,Stall_WE_MEM,DataOutFromMemory,ALU_Result_EX_MEM,WBAddress_EX_MEM,WBWriteEnable_EX_MEM,DataFromMemory_MEM_WB
,ALU_Result_MEM_WB,WBAddress_MEM_WB,WBWriteEnable_MEM_WB,WBValueALUorMemory_Memory,WBValueALUorMemory_WB);
---------------------------------------------------------------------------------------

-------------------------------------Write Back Stage----------------------------------
---------------------------------------------------------------------------------------

WB_Value_MUX: MUX2x1 port map (DataFromMemory_MEM_WB,ALU_Result_MEM_WB,WBValueALUorMemory_WB,WriteBackData);
WriteBackEnable <= WBWriteEnable_MEM_WB;
WriteBackDataAddress <= WBAddress_MEM_WB;
---------------------------------------------------------------------------------------


HazardDetectionUnit: HDU port map (Instruction(26 downto 24),Instruction(23 downto 21) ,AddressForWB_ID_EX,MEM_Read_Execute,Stall_LoadCase,
JumpOrNot,ReturnSignal_EX_MEM,PC_Selector,ID_Flush_FromHarzards);




IF_ID_Flush <= ID_Flush_FromHarzards or rst;

Stall_WE_MEM <= '0' ;
ID_EX_Flush <=  rst;
Stall_IF_ID <= Stall_LoadCase ;
Stall_PC <= Stall_LoadCase;

end my_Processor; 



