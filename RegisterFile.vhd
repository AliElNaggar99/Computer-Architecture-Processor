library ieee;
Use ieee.std_logic_1164.all;
ENTITY RegisterFile IS

PORT
(rst,clk      :in std_logic;
 Rsrc1,Rsrc2        :in std_logic_vector(2 downto 0); 
 Rsrc1_Out,Rsrc2_Out   :out std_logic_vector(31 downto 0);
 WriteData1   :in  std_logic_vector(31 downto 0);
 WriteReg1    :in std_logic_vector(2 downto 0);
 EnableRead: IN std_logic;
 EnableWrite : In std_logic



);
end ENTITY RegisterFile;
architecture a_RegisterFile of RegisterFile is
component Decoder is 
PORT
(enable: IN std_logic ;
sel : IN std_logic_vector(2 DOWNTO 0);
F : OUT std_logic_vector(7 DOWNTO 0)

);
end component ;

component  my_nDFF is 
generic (n:integer:=32);
PORT( Clk,enable,Rst: IN std_logic ;

d : IN std_logic_vector(n-1 DOWNTO 0);
q : OUT std_logic_vector(n-1 DOWNTO 0)
);
end component;

component TristateBuffer is
Generic  
(n:integer:= 32);
   PORT(
  my_in  : IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
  sel    : IN STD_LOGIC;
  my_out : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0));
end Component ;
Signal qRegister0,qRegister1,qRegister2,qRegister3,qRegister4,qRegister5,qRegister6,qRegister7: std_logic_vector(31 downto 0);
signal DecoderWrite: std_logic_vector (7 downto 0);
signal DecoderRead1: std_logic_vector (7 downto 0);
signal DecoderRead2: std_logic_vector (7 downto 0);
begin

Decoder1Read:Decoder
Port map (EnableRead,Rsrc1,DecoderRead1);

Decoder2Read:Decoder
Port map (EnableRead,Rsrc2,DecoderRead2);

Decoder1Write:Decoder
Port map (EnableWrite,WriteReg1,DecoderWrite);

Register0:my_nDFF 
Port map (clk,DecoderWrite(0),rst,WriteData1,qRegister0);
Register1:my_nDFF
Port map (clk,DecoderWrite(1),rst,WriteData1,qRegister1);
Register2: my_nDFF
Port map (clk,DecoderWrite(2),rst,WriteData1,qRegister2);
Register3: my_nDFF
Port map (clk,DecoderWrite(3),rst,WriteData1,qRegister3);
Register4: my_nDFF
Port map (clk,DecoderWrite(4),rst,WriteData1,qRegister4);
Register5: my_nDFF
Port map (clk,DecoderWrite(5),rst,WriteData1,qRegister5);
Register6: my_nDFF
Port map (clk,DecoderWrite(6),rst,WriteData1,qRegister6);
Register7: my_nDFF
Port map (clk,DecoderWrite(7),rst,WriteData1,qRegister7);


TristateBuffer0Read1:TristateBuffer
Port map (qRegister0,DecoderRead1(0),Rsrc1_Out);

TristateBuffer1Read1:TristateBuffer
Port map (qRegister1,DecoderRead1(1),Rsrc1_Out);

TristateBuffer2Read1:TristateBuffer
Port map(qRegister2,DecoderRead1(2),Rsrc1_Out);

TristateBuffer3Read1:TristateBuffer
Port map(qRegister3,DecoderRead1(3),Rsrc1_Out);

TristateBuffer4Read1:TristateBuffer
Port map (qRegister4,DecoderRead1(4),Rsrc1_Out);

TristateBuffer5Read1:TristateBuffer
Port map (qRegister5,DecoderRead1(5),Rsrc1_Out);

TristateBuffer6Read1:TristateBuffer
Port map(qRegister6,DecoderRead1(6),Rsrc1_Out);

TristateBuffer7Read1:TristateBuffer
Port map(qRegister7,DecoderRead1(7),Rsrc1_Out);





TristateBuffer0Read2:TristateBuffer
Port map (qRegister0,DecoderRead2(0),Rsrc2_Out);

TristateBuffer1Read2:TristateBuffer
Port map (qRegister1,DecoderRead2(1),Rsrc2_Out);

TristateBuffer2Read2:TristateBuffer
Port map(qRegister2,DecoderRead2(2),Rsrc2_Out);

TristateBuffer3Read2:TristateBuffer
Port map(qRegister3,DecoderRead2(3),Rsrc2_Out);

TristateBuffer4Read2:TristateBuffer
Port map (qRegister4,DecoderRead2(4),Rsrc2_Out);

TristateBuffer5Read2:TristateBuffer
Port map (qRegister5,DecoderRead2(5),Rsrc2_Out);

TristateBuffer6Read2:TristateBuffer
Port map(qRegister6,DecoderRead2(6),Rsrc2_Out);

TristateBuffer7Read2:TristateBuffer
Port map(qRegister7,DecoderRead2(7),Rsrc2_Out);




















end architecture ; -- arch