library ieee;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;


entity ALU is
  port (
    Rsrc: In std_logic_vector (31 downto 0);
    Rdst: In std_logic_vector (31 downto 0);
    OPcode: In std_logic_vector(3 downto 0);
    result : OUT std_logic_vector(31 downto 0);
    flagEnable: out std_logic;
    CarryOut: Out std_logic;
    ZeroFlag: OUT std_logic;
    NegativeOut: OUT std_logic;
    reset: in std_logic
  ) ;
end ALU ;

architecture arch of ALU is

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
Signal subtraction : std_logic_vector (32 downto 0);
signal CarryShiftLeft : std_logic;
signal CarryShiftRight : std_logic;
signal Result_internal : std_logic_vector (31 downto 0);
signal zf : std_logic;
signal nf : std_logic;
signal cf : std_logic;
signal incrementedRdst : std_logic_vector (32 downto 0);
signal decrementedRdst : std_logic_vector (32 downto 0);
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
subtraction  <= std_logic_vector(signed(tempRsrc(32 downto 0)) - signed(tempRdst(32 downto 0)));
AdderResult  <= std_logic_vector(signed(tempRsrc(32 downto 0)) + signed(tempRdst(32 downto 0)));
incrementedRdst  <= std_logic_vector(signed(tempRdst(32 downto 0)) + 1);
decrementedRdst  <= std_logic_vector(signed(tempRdst(32 downto 0)) - 1);


CarryShiftLeft <= Result_internal(31);
CarryShiftRight <= Result_internal(0);


Result_internal <= (Rsrc and Rdst) when OPcode = "0011"
else      (Rsrc or Rdst)  when OPcode = "0100"
else      (AdderResult(31 downto 0))   when OPcode = "0001"
else      (Rsrc)          when OPcode = "0000"
else      (shiftedLeft) when OPcode = "0101" --shift left opcode
else      (shiftedRight) when OPcode = "0110"
else      (subtraction(31 downto 0)) when OPcode = "0010"
else      (incrementedRdst(31 downto 0)) when OPcode = "1001"
else      (decrementedRdst(31 downto 0)) when OPcode = "1000"
else      (not Rdst) when OPcode = "1010"
else       (others =>'0') when OPcode = "0111";


nf <= ('1') when (signed(Result_internal) < 0 and (OPcode /= "0000" and OPcode /= "0111" )) 
else (nf) when (OPcode = "0000" or OPcode = "0111" )
else ('0') when (reset ='1')
else ('0');

zf <= ('1') when (signed(Result_internal) = 0 and (OPcode /= "0000" and OPcode /= "0111" and OPcode /= "1011" and OPcode /= "1100" )) 
else (zf) when (OPcode = "0000" or OPcode = "0111" or OPcode = "1011" or OPcode = "1100" )
else ('0') when (reset ='1')
else ('0');

cf <=       ('1') when OPcode = "1011"
else        ('0') when OPcode = "1100"
else  (AdderResult(32)) when  OPcode = "0001"
else  ('1') when((OPcode = "0010") and ((signed(tempRsrc(31 downto 0))) > (signed(tempRdst(31 downto 0)))))
else  ('0') when((OPcode = "0010") and ((signed(tempRsrc(31 downto 0))) < (signed(tempRdst(31 downto 0)))))
else  (incrementedRdst(32)) when OPcode = "1001"
else  ('1') when ((OPcode = "1000") and ((signed(tempRdst(31 downto 0))) > 1))
else  ('0') when ((OPcode = "1000") and ((signed(tempRdst(31 downto 0))) <= 1))
else ('0') when (reset ='1')
else  (CarryShiftLeft) when OPcode = "0101"
else  (CarryShiftRight) when OPcode = "0110"
else  (cf) when  (OPcode = "0000" or OPcode = "0111" );

flagEnable <= ('0') when (OPcode = "0000" or OPcode = "0111")
else ('1');

result <= Result_internal(31 downto 0);
ZeroFlag <= zf;
NegativeOut <= nf;
CarryOut <=  cf;
end architecture ; -- arch