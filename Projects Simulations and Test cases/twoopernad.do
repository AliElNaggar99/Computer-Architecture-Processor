vsim -gui work.processor
mem load -filltype value -filldata 10 -fillradix hexadecimal /processor/Instr/ram(0)
mem load -filltype value -filldata 100 -fillradix hexadecimal /processor/Instr/ram(2)
mem load -filltype value -filldata 3900 -fillradix hexadecimal /processor/Instr/ram(16)
mem load -filltype value -filldata 3A00 -fillradix hexadecimal /processor/Instr/ram(17)
mem load -filltype value -filldata 3B00 -fillradix hexadecimal /processor/Instr/ram(18)
mem load -filltype value -filldata 3C00 -fillradix hexadecimal /processor/Instr/ram(19)
mem load -filltype value -filldata 4560 -fillradix hexadecimal /processor/Instr/ram(20)
mem load -filltype value -filldata 4C20 -fillradix hexadecimal /processor/Instr/ram(21)
mem load -filltype value -filldata 5CA0 -fillradix hexadecimal /processor/Instr/ram(22)
mem load -filltype value -filldata 64C0 -fillradix hexadecimal /processor/Instr/ram(23)
mem load -filltype value -filldata 6940 -fillradix hexadecimal /processor/Instr/ram(24)
mem load -filltype value -filldata 7210 -fillradix hexadecimal /processor/Instr/ram(25)
mem load -filltype value -filldata 7A18 -fillradix hexadecimal /processor/Instr/ram(26)
mem load -filltype value -filldata 5201 -fillradix hexadecimal /processor/Instr/ram(27)
mem load -filltype value -filldata FFFF -fillradix hexadecimal /processor/Instr/ram(28)
mem load -filltype value -filldata 4A20 -fillradix hexadecimal /processor/Instr/ram(29)
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
