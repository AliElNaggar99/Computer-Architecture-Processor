library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.all;

entity Stack_CU is
  port (
    rst : in std_logic;
    clk : in std_logic;
    SPEnable: in std_logic;
    SelectorSP : in std_logic;
    SPNewOrOld : in std_logic;
    SP : out std_logic_vector(31 downto 0)
  ) ;
end Stack_CU ;

architecture arch of Stack_CU is
component StackReg_32 is
    port(clk,rst,enable:in std_logic; d: in std_logic_vector (31 downto 0); q: out std_logic_vector (31 downto 0));
end component;
signal StackIn : std_logic_vector(31 downto 0);
signal StackOut: std_logic_vector(31 downto 0);

-------------Push and Call SP -= 2 -------------------
-------------POP and Ret SP += 2 --------------------
begin

    StackIn <= std_logic_vector(to_signed(to_integer(signed(StackOut))+2,32)) when (SelectorSP = '1')----------------------POP and Ret------------
    else      (std_logic_vector(to_signed(to_integer(signed(StackOut))-2,32))) when (SelectorSP = '0');--------------------Push and Call----------


    StackRegister : StackReg_32 port map (clk,rst,SPEnable,StackIn,StackOut);
    
    SP <= --(StackIn)     when(SPNewOrOld = '1') else
          (StackOut);    --  when(SPNewOrOld = '0');
   

    

            




end architecture ; -- arch