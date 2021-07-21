vsim -gui work.processor
add wave -position insertpoint  \
sim:/processor/clk \
sim:/processor/rst \
sim:/processor/INPort \
sim:/processor/OUTPort
add wave -position insertpoint  \
sim:/processor/StackPointer
add wave -position insertpoint  \
sim:/processor/PC_IN \
sim:/processor/PC_OUT
add wave -position insertpoint  \
sim:/processor/Instruction
add wave -position insertpoint  \
sim:/processor/ALUResult
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
mem load -filltype value -filldata 0010 -fillradix hexadecimal /processor/Instr/ram(0)
mem load -filltype value -filldata 3900 -fillradix hexadecimal /processor/Instr/ram(16)
mem load -filltype value -filldata 3A00 -fillradix hexadecimal /processor/Instr/ram(17)
mem load -filltype value -filldata 3B00 -fillradix hexadecimal /processor/Instr/ram(18)
mem load -filltype value -filldata 3C00 -fillradix hexadecimal /processor/Instr/ram(19)
mem load -filltype value -filldata 8400 -fillradix hexadecimal /processor/Instr/ram(20)
mem load -filltype value -filldata D900 -fillradix hexadecimal /processor/Instr/ram(21)
mem load -filltype value -filldata 2100 -fillradix hexadecimal /processor/Instr/ram(22)
mem load -filltype value -filldata 6520 -fillradix hexadecimal /processor/Instr/ram(48)
mem load -filltype value -filldata C200 -fillradix hexadecimal /processor/Instr/ram(49)
mem load -filltype value -filldata 0800 -fillradix hexadecimal /processor/Instr/ram(50)
mem load -filltype value -filldata C100 -fillradix hexadecimal /processor/Instr/ram(80)
mem load -filltype value -filldata D300 -fillradix hexadecimal /processor/Instr/ram(81)
mem load -filltype value -filldata 1D00 -fillradix hexadecimal /processor/Instr/ram(82)
mem load -filltype value -filldata 3E00 -fillradix hexadecimal /processor/Instr/ram(83)
mem load -filltype value -filldata CE00 -fillradix hexadecimal /processor/Instr/ram(84)
mem load -filltype value -filldata 2100 -fillradix hexadecimal /processor/Instr/ram(85)
mem load -filltype value -filldata 1000 -fillradix hexadecimal /processor/Instr/ram(256)
mem load -filltype value -filldata 6000 -fillradix hexadecimal /processor/Instr/ram(257)
mem load -filltype value -filldata 3600 -fillradix hexadecimal /processor/Instr/ram(258)
mem load -filltype value -filldata 0800 -fillradix hexadecimal /processor/Instr/ram(512)
mem load -filltype value -filldata 8E00 -fillradix hexadecimal /processor/Instr/ram(513)
mem load -filltype value -filldata E600 -fillradix hexadecimal /processor/Instr/ram(514)
mem load -filltype value -filldata 2600 -fillradix hexadecimal /processor/Instr/ram(515)
mem load -filltype value -filldata 0000 -fillradix hexadecimal /processor/Instr/ram(516)
mem load -filltype value -filldata 0000 -fillradix hexadecimal /processor/Instr/ram(517)
mem load -filltype value -filldata 4E60 -fillradix hexadecimal /processor/Instr/ram(768)
mem load -filltype value -filldata 4A20 -fillradix hexadecimal /processor/Instr/ram(769)
mem load -filltype value -filldata E800 -fillradix hexadecimal /processor/Instr/ram(770)
mem load -filltype value -filldata 0800 -fillradix hexadecimal /processor/Instr/ram(771)
mem load -filltype value -filldata 0000 -fillradix hexadecimal /processor/Instr/ram(1280)
mem load -filltype value -filldata 0000 -fillradix hexadecimal /processor/Instr/ram(1281)
force -freeze sim:/processor/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/processor/rst 1 0
run
force -freeze sim:/processor/rst 0 0
force -freeze sim:/processor/INPort 00000030 0
run
force -freeze sim:/processor/INPort 00000050 0
run
force -freeze sim:/processor/INPort 00000100 0
run
force -freeze sim:/processor/INPort 00000300 0
run
force -freeze sim:/processor/INPort 00000200 0
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run

