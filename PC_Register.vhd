--------------PC Registers -------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.all;

entity PC_Register is 
	port (
    clk: in std_logic;
    stall: in std_logic;
    PC_IN: in std_logic_vector (31 downto 0);
    PC_OUT: out std_logic_vector (31 downto 0));
end PC_Register;     


architecture my_PC of PC_Register is
-----Define the components and signals
component Reg_32 is
    port(clk,rst,enable:in std_logic; d: in std_logic_vector (31 downto 0); q: out std_logic_vector (31 downto 0));
end component;

signal DataIN: std_logic_vector (31 downto 0);
signal DataOut: std_logic_vector (31 downto 0);
signal Enable: std_logic;

begin

PC_Reg: Reg_32 Port map (clk,'0',Enable,DataIN,DataOut);
Enable <= '0' when (stall = '1') else '1';
DataIN <= PC_IN;
PC_OUT <= DataOut;



end my_PC; 




