library ieee;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;



entity ControlUnit is
  port (
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
  ) ;
end ControlUnit ;

architecture arch of ControlUnit is

signal enable : std_logic;
--TODO: MAKE CONFIGURATION FOR OUTPUTPORT AND INPUTPORT
begin


    enable <= ('0') when (OP ="00000") --NOP
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
    else      ("0000") when ((enable = '1') and (OP = "01000")) --Mov Rsrc,Rdst
    else      ("0001") when ((enable = '1') and (OP = "01001")) --Add Rsrc,Rdst
    else      ("0001") when ((enable = '1') and (OP = "01010")) --IAdd Rdst,Imm 
    else      ("0010") when ((enable = '1') and (OP = "01011")) --Sub Rsrc,Rdst
    else      ("0011") when ((enable = '1') and (OP = "01100")) --And Rsrc,Rdst
    else      ("0100") when ((enable = '1') and (OP = "01101")) --Or Rsrc,Rdst
    else      ("0101") when ((enable = '1') and (OP = "01110")) --SHL Rsrc,Immd
    else      ("0110") when ((enable = '1') and (OP = "01111")); --SHR Rsrc,Immd

    RegisterWriteEnable <= ('1') when (OP /= "00010" or OP /="00001")
    else ('0');

    Shift_Immediate <= ('0') when (OP = "01110" or OP = "01111" )
    else  ('1') when (OP = "01010");

    ReadData2_Immediate <= ('1') when (OP = "01110" or OP = "01111" or OP = "01010" ) --equals 1 when i need immediate
    else  ('0'); -- equals 0 when i need read data2

    OutPort_Enable <= ('1') when (OP = "00110") 
    else  ('0');

    InPort_ALU <= ('1') when (OP = "00111")
    else ('0');



    
    


end architecture ; -- arch