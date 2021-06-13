------------Flag Register---------------
library ieee;
use ieee.std_logic_1164.all;

entity Flag_Register is
    port(clk,rst,enable:in std_logic; 
    ZeroFlag: in std_logic;
    NegativeFlag: in std_logic;
    CarryFlag: in std_logic;

    ZeroFlag_Out: Out std_logic;
    NegativeFlag_Out: Out std_logic;
    CarryFlag_Out: Out std_logic);
end Flag_Register;

architecture a_Flag_Register of Flag_Register is
    component Reg_3 is
        port(clk,rst,enable:in std_logic; d: in std_logic_vector (2 downto 0); q: out std_logic_vector (2 downto 0));
    end component;
    
    Signal DataIn: std_logic_vector (2 downto 0);
    signal DataOut: std_logic_vector (2 downto 0);
begin
   DataIn <= ZeroFlag & NegativeFlag & CarryFlag;
   Flags: Reg_3 port map(clk,rst,enable,DataIn,DataOut);

   ZeroFlag_Out<= DataOut(2);
   NegativeFlag_Out<= DataOut(1);
   CarryFlag_Out<= DataOut(0);

end a_Flag_Register;


