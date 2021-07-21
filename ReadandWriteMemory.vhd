library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Entity DataMemory is
  port(clk                         : in std_logic;     
       WriteEnable                 : in std_logic;
       address                     : in std_logic_vector(31 downto 0);
       datain                      : in std_logic_vector(31 downto 0);
       dataout                     : out std_logic_vector(31 downto 0)
      );
End Entity DataMemory;

Architecture arch_DataMemory of DataMemory IS
  type ram_data is array (0 to 1048575) of std_logic_vector(15 downto 0) ;   
  signal dataMemory       : ram_data;
  BEGIN
      
       process(clk,address,WriteEnable,datain) is
	     begin
	          if falling_edge(clk) then
		           if (WriteEnable = '1') then
	              dataMemory(to_integer(unsigned(address(19 downto 0)))) <= datain (15 downto 0);
	              dataMemory(to_integer(unsigned(address(19 downto 0)) + 1)) <= datain (31 downto 16);
               end if;
            end if;
	end process;

dataout <=  dataMemory(to_integer(unsigned(address(19 downto 0)) + 1)) & dataMemory(to_integer(unsigned(address(19 downto 0)))); --(Highest Memory)(Lowest Meomory )
End arch_DataMemory;    

