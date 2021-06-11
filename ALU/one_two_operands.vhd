library ieee;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;


entity twoOperand is
  port (
    Rsrc: In std_logic_vector (31 downto 0);
    Rdst: In std_logic_vector (31 downto 0);
    OPcode: In std_logic_vector(3 downto 0);
    CarryIn : In std_logic;
    result : OUT std_logic_vector(31 downto 0);
    CarryOut: Out std_logic;
    ZeroFlag: OUT std_logic;
    NegativeOut: OUT std_logic
  ) ;
end twoOperand ;

architecture arch of twoOperand is

-- component adder_32bit is
--   port(a,b : IN std_logic_vector(31 downto 0 );
--   cin : IN std_logic;
--   s   : OUT std_logic_vector(31 downto 0 );
--   cout : OUT std_logic);
--   end component;
Signal AdderResult: std_logic_vector(32 downto 0);
Signal CoutAdder: std_logic;
Signal shiftedLeft : std_logic_vector (31 downto 0);
Signal shiftedRight : std_logic_vector (31 downto 0);
Signal subtraction : std_logic_vector (31 downto 0);
signal CarryShiftLeft : std_logic;
signal CarryShiftRight : std_logic;
signal Result_internal : std_logic_vector (32 downto 0);
signal zf : std_logic;
signal nf : std_logic;
signal incrementedRdst : std_logic_vector (31 downto 0);
signal decrementedRdst : std_logic_vector (31 downto 0);
signal incrementCF : std_logic;
signal deccrementCF : std_logic;
signal tempRsrc : std_logic_vector (32 downto 0);
signal tempRdst : std_logic_vector (32 downto 0);


begin
--Adder: adder_32bit port map(Rsrc,Rdst,CarryIn,AdderResult,CoutAdder);
tempRsrc <= '0' & Rsrc;
tempRdst <= '0' & Rdst;

shiftedLeft  <= std_logic_vector(shift_left(unsigned(Rdst), to_integer(unsigned(Rsrc))));
shiftedRight <= std_logic_vector(shift_right(unsigned(Rdst), to_integer(unsigned(Rsrc))));
subtraction  <= std_logic_vector(signed(tempRsrc(31 downto 0)) - signed(tempRdst(31 downto 0)));
AdderResult  <= std_logic_vector(signed(tempRsrc(32 downto 0)) + signed(tempRdst(32 downto 0)));
incrementedRdst  <= std_logic_vector(signed(tempRdst(32 downto 0)) + 1);
decrementedRdst  <= std_logic_vector(signed(tempRdst(32 downto 0)) - 1);


CarryShiftLeft <= Result_internal(31);
CarryShiftRight <= Result_internal(0);


Result_internal <= (Rsrc and Rdst) when OPcode = "0011"
else      (Rsrc or Rdst)  when OPcode = "0100"
else      (AdderResult)   when OPcode = "0001"
else      (Rsrc)          when OPcode = "0000"
else      (shiftedLeft) when OPcode = "0101" --shift left opcode
else      (shiftedRight) when OPcode = "0110"
else      (subtraction) when OPcode = "0010"
else      (incrementedRdst) when OPcode = "1001"
else      (decrementedRdst) when OPcode = "1000"
else      (not Rdst) when OPcode = "1010";


nf <= ('1') when (signed(Result_internal) < 0 and OPcode /= "0000") ;

zf <= ('1') when (signed(Result_internal) = 0 and OPcode /= "0000") ;

CarryOut <= ('1') when OPcode = "1011"
else        ('0') when OPcode = "1100";
else  (Result_internal(32)) when  OPcode /= "0000"


result <= Result_internal;
ZeroFlag <= zf;
NegativeOut <= nf;
end architecture ; -- arch