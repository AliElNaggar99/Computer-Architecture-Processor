vsim -gui work.processor
# vsim -gui work.processor 
# Start time: 16:01:01 on Jun 12,2021
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading ieee.numeric_std(body)
# Loading work.processor(my_processor)
# Loading work.mux2x1(my_mux2x1)
# Loading work.pc_register(my_pc)
# Loading work.reg_32(a_reg_32)
# Loading work.instructionmemory(arch_instructionmemory)
# Loading work.add_to_pc(my_add_to_pc)
# Loading work.if_id_stage(a_if_id_stage)
# Loading work.if_id_reg(a_if_id_reg)
mem load -filltype value -filldata 0000 -fillradix hexadecimal /processor/Instr/ram(0)
mem load -filltype value -filldata 000A -fillradix hexadecimal /processor/Instr/ram(1)
mem load -filltype value -filldata 0000 -fillradix hexadecimal /processor/Instr/ram(10)
mem load -filltype value -filldata 0080 -fillradix hexadecimal /processor/Instr/ram(11)
mem load -filltype value -filldata 0100 -fillradix hexadecimal /processor/Instr/ram(12)
mem load -filltype value -filldata 0180 -fillradix hexadecimal /processor/Instr/ram(13)
add wave -position insertpoint  \
sim:/processor/clk \
sim:/processor/rst \
sim:/processor/Stall_PC \
sim:/processor/PC_OUT \
sim:/processor/MemoryIn \
sim:/processor/MemoryOut \
sim:/processor/Stall_IF_ID \
sim:/processor/Instruction
force -freeze sim:/processor/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/processor/rst 1 0
force -freeze sim:/processor/Stall_PC 0 0
force -freeze sim:/processor/Stall_IF_ID 0 0
run
# ** Warning: NUMERIC_STD.TO_INTEGER: metavalue detected, returning 0
#    Time: 0 ps  Iteration: 0  Instance: /processor/AddToPC
# ** Warning: NUMERIC_STD.TO_INTEGER: metavalue detected, returning 0
#    Time: 0 ps  Iteration: 0  Instance: /processor/Instr
# ** Warning: NUMERIC_STD.TO_INTEGER: metavalue detected, returning 0
#    Time: 0 ps  Iteration: 0  Instance: /processor/Instr
# ** Warning: NUMERIC_STD.TO_INTEGER: metavalue detected, returning 0
#    Time: 0 ps  Iteration: 1  Instance: /processor/Instr
force -freeze sim:/processor/rst 0 0
run
run
run
run