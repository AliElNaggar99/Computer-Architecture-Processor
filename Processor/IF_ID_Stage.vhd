------------IF_ID_Stage---------------
library ieee;
use ieee.std_logic_1164.all;

entity IF_ID_Stage is
    port(clk,Flush,Stall:in std_logic; 
    PC_Added_1: in std_logic_vector (31 downto 0);
    Instruction: in std_logic_vector (31 downto 0);
    INPORT: in std_logic_vector (31 downto 0);

    PC_Added_1_Out: OUT std_logic_vector (31 downto 0);
    Instruction_Out: OUT std_logic_vector (31 downto 0);
    INPORT_Out: OUT std_logic_vector (31 downto 0));
end IF_ID_Stage;

architecture a_IF_ID_Stage of IF_ID_Stage is
component IF_ID_Reg is
    port(clk,rst,enable:in std_logic; d: in std_logic_vector (95 downto 0); q: out std_logic_vector (95 downto 0));
end component;

Signal DataIn: std_logic_vector (95 downto 0);
signal DataOut: std_logic_vector (95 downto 0);
signal Enable: std_logic;

begin
 DataIn <= PC_Added_1 & Instruction & INPORT;
 Enable <= '0' when (Stall = '1') else '1';
 Reg: IF_ID_Reg port map (clk,Flush,Enable,DataIn,DataOut);
 PC_Added_1_Out <= DataOut (95 downto 64);
 Instruction_Out <= DataOut (63 downto 32);
 INPORT_Out <= DataOut (31 downto 0);


end a_IF_ID_Stage;



