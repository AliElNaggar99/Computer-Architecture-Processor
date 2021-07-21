# starts sim and adds clock
startSim = ['vsim -gui work.processor']
startingLines = [
    'add wave -position insertpoint  \\',
    'sim:/processor/clk \\',
    'sim:/processor/rst \\',
    'sim:/processor/INPort \\',
    'sim:/processor/OUTPort',
    'add wave -position insertpoint  \\',
    'sim:/processor/StackPointer ',
    'add wave -position insertpoint  \\',
    'sim:/processor/PC_OUT ',
    'add wave -position insertpoint  \\',
    'sim:/processor/CarryFlag \\',
    'sim:/processor/NegativeFlag \\',
    'sim:/processor/ZeroFlag ',
    'add wave -position insertpoint  \\',
    'sim:/processor/Reg_File/qRegister0 \\',
    'sim:/processor/Reg_File/qRegister1 \\',
    'sim:/processor/Reg_File/qRegister2 \\',
    'sim:/processor/Reg_File/qRegister3 \\',
    'sim:/processor/Reg_File/qRegister4 \\',
    'sim:/processor/Reg_File/qRegister5 \\',
    'sim:/processor/Reg_File/qRegister6 \\',
    'sim:/processor/Reg_File/qRegister7 '

]
# mapping from instruction to op Code and ALU OPCode
opToOpCodeOneOperand = {
    'NOP': '00000', 'SETC': '00001',
    'CLRC': '00010', 'NOT': '00011',
    'INC': '000100', 'DEC': '00101',
    'OUT': '00110', 'IN': '00111'
}
opToOpCodeTwoOperand = {
    'MOV': '01000', 'ADD': '01001',
    'IADD': '01010', 'SUB': '01011',
    'AND': '01100', 'OR': '01101',
    'SHL': '01110', 'SHR': '01111',
}
opToOpCodeMemory = {
    'PUSH': '10000', 'POP': '10001',
    'LDM': '10010', 'LDD': '10011',
    'STD': '10100',
}
opToOpCodeBranch = {
    'JZ': '11000', 'JN': '11001',
    'JC': '11010', 'JMP': '11011',
    'CALL': '11100', 'RET': '11101',
}

registerAddress = {
    'R0': '000',
    'R1': '001',
    'R2': '010',
    'R3': '011',
    'R4': '100',
    'R5': '101',
    'R6': '110',
    'R7': '111'
}
# file name
rootDir = ''
fileName = 'branch'
# instructions in the end
instructions = []
instructionsOrder = []
currentMemoryIndex = None

# reading file
with open(rootDir + fileName + '.asm', 'r') as f:
    lines = f.readlines()
    for line in lines:
        # removes spaces
        lineNoSpaces = ' '.join(line.split()).upper()
        # skips commented and empty lines
        if(lineNoSpaces.startswith('#') or lineNoSpaces == ''):
            continue
        # removes comments from line
        lineNoComments = lineNoSpaces[0: lineNoSpaces.find(
            '#') - 1] if (lineNoSpaces.find('#') != -1) else lineNoSpaces
        # split line intro individual components
        # 'OUT R1' -> ['OUT' , 'R1']
        lineArray = lineNoComments.split(' ')
        # handles org instruction
        if(lineArray[0] == '.ORG'):
            currentMemoryIndex = int(lineArray[1], 16)
            continue
        # One operand instructions
        if (lineArray[0] in opToOpCodeOneOperand.keys()):
            # getting opcode and alu opcode
            opCodeTemp = opToOpCodeOneOperand[lineArray[0]]

            # check if instructions is something like SETC
            # i.e no register address
            if(len(lineArray) == 1):
                registerDst = '000'
            else:
                # if not we get the address
                registerDst, registerAddress2 = registerAddress[lineArray[1]
                                                                ], registerAddress[lineArray[1]]
            # add instruction instruction list
            instructions.append(
                opCodeTemp + registerDst + '000' + '0' + '0000')
        elif (lineArray[0] in opToOpCodeTwoOperand.keys()):
          # getting opcode and alu opcode
            opCodeTemp = opToOpCodeTwoOperand[lineArray[0]]
            # getting the two operands from instruction
            # getting address of first register
            operationOperands = lineArray[1].split(',')
            registerAddress1 = registerAddress[operationOperands[0]]
            # checks if the 2nd instruction has an immediate or not
            if (operationOperands[1] in registerAddress.keys()):
                registerAddress2 = registerAddress[operationOperands[1]]
                immediateTemp = None
                instructions.append(
                    opCodeTemp + registerAddress2 + registerAddress1 + '0' + '0000')
            elif (lineArray[0] in ['IADD']):
                immediateTemp = operationOperands[1]
                registerAddress2 = '000'
                instructions.append(
                    opCodeTemp + registerAddress1 + registerAddress2 + '0' + '0001')
            else:
                temp = operationOperands[1]
                registerAddress2 = bin(
                    int('0x' + temp.lower(), 16))[2:]
                if (int(temp) < 2):
                    registerAddress2 = '0000' + registerAddress2
                elif (int(temp) < 4):
                    registerAddress2 = '000' + registerAddress2
                elif (int(temp) < 8):
                    registerAddress2 = '00' + registerAddress2
                elif (int(temp) < 16):
                    registerAddress2 = '0' + registerAddress2
                immediateTemp = None
                instructions.append(
                    opCodeTemp + registerAddress1 + registerAddress2 + '000')
            # adds instruction 1 to instructions list

            # if there's an immediate add it to the list
            if (immediateTemp != None):
                instructions.append(bin(int('0x' + immediateTemp.lower(), 16)))
                instructionsOrder.append(currentMemoryIndex)
                currentMemoryIndex += 1

        elif (lineArray[0] in opToOpCodeMemory.keys()):
            # get alu op code and op code
            opCodeTemp = opToOpCodeMemory[lineArray[0]]
            operationOperands = lineArray[1].split(',')
            registerAddress1 = registerAddress[operationOperands[0]]
            if (lineArray[0] in ['POP', 'PUSH']):
                instructions.append(
                    opCodeTemp + registerAddress1 + '000' + '0000' + '0')
            elif (lineArray[0] in ['STD', 'LDD']):
                operandTwoComponents = operationOperands[1].split('(')
                immediateTemp = operandTwoComponents[0]
                registerAddress2 = registerAddress[operandTwoComponents[1][:-1]]
                # add instruction to instructions list
                instructions.append(
                    opCodeTemp + registerAddress1 + registerAddress2 + '0000'+'1')
                # add immediate
                instructions.append(bin(int('0x' + immediateTemp.lower(), 16)))
                # add instruction order and increment
                instructionsOrder.append(currentMemoryIndex)
                currentMemoryIndex += 1
            elif (lineArray[0] == 'LDM'):

                instructions.append(
                    opCodeTemp + registerAddress1 + '000' + '0000' + '1')
                immediateTemp = operationOperands[1]
                # add immediate
                instructions.append(bin(int('0x' + immediateTemp.lower(), 16)))
                # add instruction order and increment
                instructionsOrder.append(currentMemoryIndex)
                currentMemoryIndex += 1

        elif (lineArray[0] in opToOpCodeBranch.keys()):

            opCodeTemp = opToOpCodeBranch[lineArray[0]]
            if (lineArray[0] == 'RET'):
                instructions.append(
                    opCodeTemp + '0000000000' + '0')
            else:
                registerAddress1 = registerAddress[lineArray[1]]
                instructions.append(
                    opCodeTemp + registerAddress1 + '0000000' + '0')

        else:
            # for the instruction after org
            instructions.append(bin(int('0x' + lineArray[0].lower(), 16)))

        instructionsOrder.append(currentMemoryIndex)
        # increment memroy address to write into after instruction
        if(currentMemoryIndex != None):
            currentMemoryIndex += 1

instructionsHex = [hex(int(i, 2)).upper()[2:] for i in instructions]


with open(rootDir + fileName + '.do', 'w') as f:

    for line in startSim:
        f.write(line)
        f.write('\n')

    for (instruction, instructionOrder) in zip(instructionsHex, instructionsOrder):
        f.write('mem load -filltype value -filldata {} -fillradix hexadecimal /processor/Instr/ram({})'.format(instruction, instructionOrder))
        f.write('\n')

    for line in startingLines:
        f.write(line)
        f.write('\n')
