LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;

ENTITY TristateBuffer IS
GENERIC (n:integer:= 32);
    PORT(
        my_in  : IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
        sel    : IN STD_LOGIC;
        my_out : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0));
END TristateBuffer;

ARCHITECTURE a_TristateBuffer OF TristateBuffer IS
BEGIN
my_out<=my_in when(sel='1')
else (others=>'Z');

  
END Architecture;