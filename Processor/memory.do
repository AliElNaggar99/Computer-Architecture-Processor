vsim -gui work.processor
mem load -filltype value -filldata 10 -fillradix hexadecimal /processor/Instr/ram(0)
mem load -filltype value -filldata 100 -fillradix hexadecimal /processor/Instr/ram(2)
mem load -filltype value -filldata 3A00 -fillradix hexadecimal /processor/Instr/ram(16)
mem load -filltype value -filldata 3B00 -fillradix hexadecimal /processor/Instr/ram(17)
mem load -filltype value -filldata 3C00 -fillradix hexadecimal /processor/Instr/ram(18)
mem load -filltype value -filldata 9101 -fillradix hexadecimal /processor/Instr/ram(19)
mem load -filltype value -filldata 5 -fillradix hexadecimal /processor/Instr/ram(20)
mem load -filltype value -filldata 8100 -fillradix hexadecimal /processor/Instr/ram(21)
mem load -filltype value -filldata 8200 -fillradix hexadecimal /processor/Instr/ram(22)
mem load -filltype value -filldata 8900 -fillradix hexadecimal /processor/Instr/ram(23)
mem load -filltype value -filldata 8A00 -fillradix hexadecimal /processor/Instr/ram(24)
mem load -filltype value -filldata 3D00 -fillradix hexadecimal /processor/Instr/ram(25)
mem load -filltype value -filldata A2A1 -fillradix hexadecimal /processor/Instr/ram(26)
mem load -filltype value -filldata 200 -fillradix hexadecimal /processor/Instr/ram(27)
mem load -filltype value -filldata A1A1 -fillradix hexadecimal /processor/Instr/ram(28)
mem load -filltype value -filldata 202 -fillradix hexadecimal /processor/Instr/ram(29)
mem load -filltype value -filldata 9BA1 -fillradix hexadecimal /processor/Instr/ram(30)
mem load -filltype value -filldata 202 -fillradix hexadecimal /processor/Instr/ram(31)
mem load -filltype value -filldata 9CA1 -fillradix hexadecimal /processor/Instr/ram(32)
mem load -filltype value -filldata 200 -fillradix hexadecimal /processor/Instr/ram(33)
add wave -position insertpoint  \
sim:/processor/clk \
sim:/processor/rst \
sim:/processor/INPort \
sim:/processor/OUTPort
add wave -position insertpoint  \
sim:/processor/StackPointer 
add wave -position insertpoint  \
sim:/processor/PC_OUT 
add wave -position insertpoint  \
sim:/processor/CarryFlag \
sim:/processor/NegativeFlag \
sim:/processor/ZeroFlag 
add wave -position insertpoint  \
sim:/processor/Reg_File/qRegister0 \
sim:/processor/Reg_File/qRegister1 \
sim:/processor/Reg_File/qRegister2 \
sim:/processor/Reg_File/qRegister3 \
sim:/processor/Reg_File/qRegister4 \
sim:/processor/Reg_File/qRegister5 \
sim:/processor/Reg_File/qRegister6 \
sim:/processor/Reg_File/qRegister7 
