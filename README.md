# 32-bit-CPU

Design and describe (e.g. in Verilog language) a processor that has the following attributes and performs the following functionality.
Data are 32-bit, addresses of data and addresses of instructions are 32-bit, the instructions are 32-bit as well, and the amount of registers is 64.
Use Harvard architecture, i.e. the processor communicates with 2 memories, data memory and instruction memory. The size of memories is the maximum possible according to the address size for the given memory.

# Top module of the processor has to be named as CPU.

Inputs of CPU are:
 - 1-bit CLK - clock
 - 1-bit RST - reset
 - 32-bit DATA_IN - data coming from data memory
 - 32-bit INSTR_IN - instructions coming from instruction memory
 
Outputs of CPU are:
 - 32-bit DATA_OUT - data for data memory
 - 32-bit DADDR - address for data memory
 - 1-bit DWR - write/read for data memory (1 is write, 0 is read)
 - 1-bit DEN - enable signal for data memory (1 is enabled, 0 is disabled)
 - 32-bit IADDR - address for instruction memory
 - 1-bit IEN - enable signal for instruction memory (1 is enabled, 0 is disabled)


# Instruction set architecture:

BR = Bank of Registers

instruction | full name           | OPCODE  | remaining bits and meaning of the instruction
NOP         | no operation        | 0000000 | 25 bits unused; no operation
ADD         | addition            | 0000001 | 7 bits unused, 6-bit dst register, 6-bit src1 register, 6-bit src2 register; BR[dst] = BR[src1] + BR[src2]
SUB         | substract           | 0000010 | 7 bits unused, 6-bit dst register, 6-bit src1 register, 6-bit src2 register; BR[dst] = BR[src1] - BR[src2]
AND         | bitwise AND         | 0000011 | 7 bits unused, 6-bit dst register, 6-bit src1 register, 6-bit src2 register; BR[dst] = BR[src1] & BR[src2]
OR          | bitwise OR          | 0000100 | 7 bits unused, 6-bit dst register, 6-bit src1 register, 6-bit src2 register; BR[dst] = BR[src1] | BR[src2]
XOR         | bitwise XOR         | 0000101 | 7 bits unused, 6-bit dst register, 6-bit src1 register, 6-bit src2 register; BR[dst] = BR[src1] ^ BR[src2]
SHROL       | shift/rotate left   | 0000110 | 7 bits unused, 6-bit dst register, 6-bit src register, 1-bit rot, 5-bit const constant; BR[dst] = BR[src] << const (if rot == 1 then do rotation, else shift)
SHROR       | shift/rotate right  | 0000111 | 7 bits unused, 6-bit dst register, 6-bit src register, 1-bit rot, 5-bit const constant; BR[dst] = BR[src] >> const (if rot == 1 then do rotation, else shift)
WR          | write to RAM        | 00010   | 15 bits unused, 6-bit addr register, 6-bit src register; data_ram[addr] = BR[src]
RD          | read from RAM       | 00011   | 9 bits unused, 6-bit dst register, 6-bit addr register, 6 bits unused; BR[dst] = data_ram[addr]
LD          | load constant data  | 01      | 12 bits upper half of const constant, 6-bit dst register, 12 bits lower half of const; BR[dst] = {8'h00, const} 
JMP         | jump                | 1       | 31-bit const as address of direct jump (used as the lowest 31 bits of address, while the highest bit is always 0); jump to address const; PC = {1'b0, const}
BEQ         | branch if equal     | 0010    | 16-bit const constant, 6-bit addr register, 6-bit src register; if BR[src] == const then jump to address in register BR[addr]
BNE         | branch if not equal | 0011    | 16-bit const constant, 6-bit addr register, 6-bit src register; if BR[src] != const then jump to address in register BR[addr]

+ see table ISA.pdf + evaluation criteria
