library ieee;
use ieee.std_logic_1164.all;

entity integrationALU_CU is
  port (
    Rsrc: In std_logic_vector (31 downto 0);
    Rdst: In std_logic_vector (31 downto 0);
    OP: In std_logic_vector (4 downto 0);
    ALUresult : OUT std_logic_vector(31 downto 0);
    CarryOut: Out std_logic;
    ZeroFlag: OUT std_logic;
    NegativeOut: OUT std_logic;
    RegisterWriteEnable: out std_logic;
    -- IF_D_Flush : out std_logic;
    -- ID_EX_Flush: out std_logic;
     Shift_Immediate: out std_logic;
     ReadData2_Immediate: out std_logic; --might be changed later on
     OutPort_Enable : out std_logic;
     InPort_ALU : out std_logic
  ) ;
end integrationALU_CU ;

architecture arch of integrationALU_CU is
component twoOperand is
    port(
    Rsrc: In std_logic_vector (31 downto 0);
    Rdst: In std_logic_vector (31 downto 0);
    OPcode: In std_logic_vector(3 downto 0);
    result : OUT std_logic_vector(31 downto 0);
    flagEnable: out std_logic;
    CarryOut: Out std_logic;
    ZeroFlag: OUT std_logic;
    NegativeOut: OUT std_logic
   
    
  ) ;
  end component;
  component ControlUnit is
    port(
        OP: In std_logic_vector(4 downto 0);
        ALU_Op : out std_logic_vector(3 downto 0);
        -- MemoryReadEnable: out std_logic;
        -- MemoryWriteEnable: out std_logic;
         RegisterWriteEnable: out std_logic;
        -- IF_D_Flush : out std_logic;
        -- ID_EX_Flush: out std_logic;
         Shift_Immediate: out std_logic;
         ReadData2_Immediate: out std_logic; --might be changed later on
         OutPort_Enable : out std_logic;
         InPort_ALU : out std_logic
        -- Jump: out std_logic_vector(2 downto 0);
        -- Stack: out std_logic_vector(4 downto 0);
        -- PC : out std_logic_vector(1 downto 0);
  ) ;
  end component;

Signal rwe,si,rdi,outenable,inalu,fe,cf,zf,nf    : std_logic;
signal ALUOpCode   : std_logic_vector(3 downto 0);
signal result   : std_logic_vector(31 downto 0);
begin
    CU  : ControlUnit port MAP(OP,ALUOpCode,rwe,si,rdi,outenable,inalu);
    ALU : twoOperand  port Map(Rsrc,Rdst,ALUOpCode,result,fe,cf,zf,nf);




ALUResult  <=  (result) when (OP /= "00000")
else (others => '0') ; 
RegisterWriteEnable <= rwe;
Shift_Immediate <= si;
ReadData2_Immediate <= rdi;
OutPort_Enable <= outenable;
InPort_ALU <= inalu;
ZeroFlag <= zf;
NegativeOut <= nf;
CarryOut <= cf;
end architecture ; -- arch