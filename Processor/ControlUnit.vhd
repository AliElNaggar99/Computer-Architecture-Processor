library ieee;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;



entity ControlUnit is
  port (
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
    --IF_D_Flush : out std_logic;
    --ID_EX_Flush: out std_logic;
    Shift_Immediate: out std_logic;
    ReadData2_Immediate: out std_logic_vector (1 downto 0); --might be changed later on
    ReadData1_ReadData2: out std_logic_vector(1 downto 0); -- Might be changed later for FU
    OutPort_Enable : out std_logic;
    InPort_ALU : out std_logic;
    -- Jump: out std_logic_vector(2 downto 0);
    -- PC : out std_logic_vector(1 downto 0);
    MEM_Read: out std_logic;
    Stall_The_Pipe: in std_logic;

      --------------------------------------------------------
    ---------------------Jump Signals ----------------------
    --------------------------------------------------------

    JumpSignal : out std_logic_vector(1 downto 0);
    JumpEnable: out std_logic;
    ReturnSignal : out std_logic
  ) ;
end ControlUnit ;

architecture arch of ControlUnit is

signal enable : std_logic;
--TODO: MAKE CONFIGURATION FOR OUTPUTPORT AND INPUTPORT
begin


    enable <= ('0') when (OP ="00000" or Stall_The_Pipe = '1') --NOP
    else ('1');
    --  ONE operand 
    -----------------------------------------------------------------------------
    ALU_Op <= ("1011") when ((enable = '1') and (OP = "00001")) --Set carryFlag
    else      ("1100") when ((enable = '1') and (OP = "00010")) --Clear carryFlag
    else      ("1010") when ((enable = '1') and (OP = "00011")) --Not Rdst
    else      ("1001") when ((enable = '1') and (OP = "00100")) --Inc Rdst
    else      ("1000") when ((enable = '1') and (OP = "00101")) --Decc Rdst
    -------------------------------------------------------------------------------
    --Two OPerand
    --------------------------------------------------------------------------------
    else      ("0000") when ((enable = '1') and (OP = "01000" or OP = "10010")) --Mov Rsrc,Rdst ------ LDM Imm,RDst just like move
    else      ("0001") when ((enable = '1') and (OP = "01001")) --Add Rsrc,Rdst
    else      ("0001") when ((enable = '1') and (OP = "01010")) --IAdd Rdst,Imm 
    else      ("0010") when ((enable = '1') and (OP = "01011")) --Sub Rsrc,Rdst
    else      ("0011") when ((enable = '1') and (OP = "01100")) --And Rsrc,Rdst
    else      ("0100") when ((enable = '1') and (OP = "01101")) --Or Rsrc,Rdst
    else      ("0101") when ((enable = '1') and (OP = "01110")) --SHL Rsrc,Immd
    else      ("0110") when ((enable = '1') and (OP = "01111")) --SHR Rsrc,Immd
    else      ("1111") when ((enable = '1') and (OP = "10011" or OP = "10100" ))  ----Add for Memory Operations
    else      ("0111"); ----------NOP and anyother Operation
    
    -------------One Operand-----
    RegisterWriteEnable <= ('1') when (OP = "00011" or OP = "00100" or OP = "00101" or OP = "00111"
    --------------Two Operand---
    or OP = "01000" or OP = "01001"  or OP = "01010" or OP = "01011" or OP = "01100" or OP = "01101"  or OP = "01110" or OP = "01111" 
    -------------Memory------
    or OP = "10001" or OP = "10010" or OP = "10011" 
    ) and (Stall_The_Pipe /= '1')
    else ('0');

    ----Extend Shift or Immediate Value-----------------
    Shift_Immediate <= ('0') when (OP = "01110" or OP = "01111" )
    else  ('1') ; -----when (OP = "01010") Extend Immad if there is no shift;

    OutPort_Enable <= ('1') when (OP = "00110") and (Stall_The_Pipe /= '1')
    else  ('0');

    InPort_ALU <= ('1') when (OP = "00111")
    else ('0');

    -----Memory Operations
    MemoryWriteEnable <= ('1') when (OP = "10000" or OP = "10100" or OP = "11100") and (Stall_The_Pipe /= '1')
    else ('0');

    -----------MUXes before ALU
    ReadData2_Immediate <= ("01") when (OP = "01110" or OP = "01111" or OP = "01010" or OP = "10010" or OP = "10011" or OP = "10100") --equals 1 when i need immediate
    else  ("00"); -- equals 0 when i need read data2
    
    ReadData1_ReadData2 <= ("11") when (OP = "10011" or OP = "10100")
    else ("00");

    WBValueALUorMemory <= ('0') when (OP = "10001" or OP = "10011")
    else ('1');

    -------------Stack Operations-------------------------------------
    SPEnable <= ('1') when (OP = "10000" or OP = "10001" or OP = "11100" or OP = "11101") and (Stall_The_Pipe /= '1')
    else ('0');

    SelectorSP <= ('1') when (OP = "10001" or OP = "11101")
    else ('0'); --------------add (1) 2 or (0) subtract 2-------------

    SPNewOrOld <= ('1') when (OP = "10001" or OP = "11101")
    else('0') ; -----------Output the Value after Add (0) or before the Add (1)-------------------

    SPOrALUResult <= ('0') when (OP = "10000" or OP = "10001" or OP = "11100" or OP = "11101")
    else ('1'); -----------------Memory Write Data------------------------------

    ReadPCAddedOrReadData1 <= ('0') when (OP = "11100")
    else ('1'); --------------------PCAdded For Call-------------------

    MEM_Read <= ('1') when (OP = "10011" or OP = "10001") and (Stall_The_Pipe /= '1')
    else ('0');


    ----Jump Conditions------
    JumpEnable <= ('1') when (OP ="11000" or OP ="11001" or OP ="11010" or OP="11011" or OP = "11100" or OP = "11101") and (Stall_The_Pipe /= '1')--This is for flag jumps
    else ('0');

    JumpSignal <= ("00") when (OP = "11000") --Jmp Zero
    else    ("01") when (OP = "11001")  -- Jmp Negative
    else    ("10") when (OP = "11010")  -- Jmp Carry
    else    ("11") when (OP = "11011" or OP = "11100" or OP = "11101"); -- Jmp Immediate,Call,Ret
    
    ReturnSignal <= ('1') when (OP = "11101")
    else ('0');

    ---We should check if it is jump immediate then pc counter change immediatly
    --Else in other cases we should check the flags and based on flags we will jump


end architecture ; -- arch