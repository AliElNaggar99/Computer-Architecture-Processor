library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use STD.textio.all; -- Required for freading a file

Entity InstructionMemory is
  port(
      PC_value        : in std_logic_vector(31 downto 0);
      Instruction_out : out std_logic_vector(31 downto 0)
      );
End Entity InstructionMemory;

Architecture arch_InstructionMemory Of InstructionMemory Is
  type ram_type is array (0 to 1048576) of std_logic_vector(15 downto 0); 
	signal ram       : ram_type;
	signal rPC_value :  std_logic_vector(19 downto 0);
  BEGIN
       rPC_value<= std_logic_vector(unsigned(PC_value(19 downto 0)) + 1);

	Instruction_out    <= ram(to_integer(unsigned(PC_value(19 downto 0))))& ram(to_integer(unsigned(rPC_value)));
End arch_InstructionMemory; 
