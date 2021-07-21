library ieee;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;


entity FU is
  port (
    Rsrc1: In std_logic_vector(2 downto 0);
    Rsrc2: In std_logic_vector(2 downto 0);

    CU_signal1: In std_logic_vector(1 downto 0);
    CU_signal2: In std_logic_vector(1 downto 0);

    AddressExc : In std_logic_vector(2 downto 0);
    WbEnableExc : in std_logic;

    AddressMem : In std_logic_vector(2 downto 0);
    WbEnableMem : in std_logic;
    
    mux1_Selector: out std_logic_vector(1 downto 0);
    mux2_Selector: out std_logic_vector(1 downto 0);
    First_Operand_MUX: out std_logic_vector (1 downto 0)
  ) ;
end FU ;

architecture arch of FU is

---Make special case that if source 2 is immediata forward in Mux 1 not two ----------------

begin
mux1_Selector <= ("01") when (Rsrc1 = AddressExc and WbEnableExc = '1') or (Rsrc2 = AddressExc and WbEnableExc = '1' and CU_signal2 = "01")--Execution to next stage execution forwarding
else             ("10") when (Rsrc1 = AddressMem and WbEnableMem = '1') or (Rsrc2 = AddressMem and WbEnableMem = '1' and CU_signal2 = "01")  --Memory to Execution forwarding
else             (CU_signal1);

mux2_Selector <= ("10") when (Rsrc2 = AddressExc and WbEnableExc = '1') and (CU_signal2 /= "01") --Execution to next stage execution forwarding
else             ("11") when (Rsrc2 = AddressMem and WbEnableMem = '1') and (CU_signal2 /= "01") --Memory to Execution forwarding
else             (CU_signal2);

First_Operand_MUX <= ("01") when (Rsrc1 = AddressExc and WbEnableExc = '1') --Execution to next stage execution forwarding
else             ("10") when (Rsrc1 = AddressMem and WbEnableMem = '1')   --Memory to Execution forwarding
else             ("00") when (CU_signal1 = "11")
else             (CU_signal1);


end architecture ; -- arch