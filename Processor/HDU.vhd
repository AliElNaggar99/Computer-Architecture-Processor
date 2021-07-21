library ieee;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;

entity HDU is
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
end HDU ;

architecture arch of HDU is


begin
-- if(MemReadInEx == 1)
-- {
    --this means that we are reading from memory in current stage
    --At decode we check if the Source we are using is being changed from the instruction before me
    -- So i have to check if The memory Write Destination in Execution Stage, or Memory Stage is the same as
    -- The source that i need; therefore, i will Stall the pipe two stages assuming that i might need all 5 stages

    --If we sent a signal to stall:
    --   1--->  We should make enable to both First Buffers = 0
    --    2---> Memory and WriteBack buffers should be flushed
    --}

SignalToStall <= ('1') when ((Rsrc = RdstInExc or Rdst = RdstInExc) and MemReadInEx = '1')
else ('0');


----------------------------Jump conditions--------------------------------------
PCSelector <= ("01") when (JumpOrNot = '1' and ReturnSignal = '0')
else          ("10")   when ( ReturnSignal = '1')
else          ("00");

FlushFor_IF_ID <= ('1') when (JumpOrNot = '1' or ReturnSignal = '1' ) ----When there is jump we flush the buffer at the ID/EX
else ('0');

-- FlushFor_ID_EX <= ('1') when (ReturnSignal = '1')
-- else ('0');



end architecture ; -- arch