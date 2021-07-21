library ieee;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;

entity CU_Jump is
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
end CU_Jump ;

architecture arch of CU_Jump is



begin


    ----Jump Conditions------
    JumpOrNot <= ('1') when ((JumpEnable ='1' and JumpSignal = "00" and ZFlag = '1') 
    or (JumpEnable ='1' and JumpSignal = "01" and NFlag = '1')
    or (JumpEnable ='1' and JumpSignal = "10" and CFlag = '1')
    or (JumpEnable = '1' and JumpSignal = "11"))
    else ('0'); 


    ZFlag_NEW <= ('0') when ((JumpEnable ='1' and JumpSignal = "00" and ZFlag = '1')) 
    else ZFlag;
    
    NFlag_NEW <= ('0') when ((JumpEnable ='1' and JumpSignal = "01" and NFlag = '1'))
    else NFlag;
    
    CFlag_NEW <= ('0') when (JumpEnable ='1' and JumpSignal = "10" and CFlag = '1')
    else CFlag;

    ConditionalJump <= ('1') when (JumpEnable = '1') and (JumpSignal = "00" or JumpSignal = "01" or JumpSignal="10")
    else ('0');
    ---We should check if it is jump immediate then pc counter change immediatly
    --Else in other cases we should check the flags and based on flags we will jump


end architecture ; -- arch