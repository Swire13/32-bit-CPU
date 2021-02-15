module CPU(
	input wire clk,
	input wire RST,
	input wire [31:0] DATA_IN,
	input wire [31:0] INSTR_IN,
	output wire [31:0] DATA_OUT,
	output wire [31:0] DADDR, 
	output wire DWR, 
	output wire DEN, 
	output wire [31:0] IADDR,
	output wire IEN 
);

// DELAY REGISTERS VARS

// delay 1 clk
wire [5:0] dst_dr;
wire write_alu_dr;

// delay 2 clk
wire [5:0] dst_d2r;
wire write_alu_d2r;

// DELAY REGISTERS VARS

// DECODER

wire [5:0] dst_decoder; 
wire [5:0] dstLd_decoder; 
wire [5:0] src2_decoder; 
wire [5:0] src_decoder;
wire [30:0] const_decoder; 
wire [3:0] opcode_decoder;
wire [31:0] jump_decoder;
wire [1:0] ctrl_PC_decoder;
wire ld_decoder;
wire write_BR_decoder;
wire read_BR_decoder;
wire write_alu_decoder;

decoder Decoder(
    .INSTR_IN (INSTR_IN),
	.RST (RST),
	.clk (clk),
	.dst (dst_decoder),
	.dstLd (dstLd_decoder),
	.src2 (src2_decoder),
	.src (src_decoder),
	.const (const_decoder),
	.opcode (opcode_decoder),
    .jump (jump_decoder),
    .ctrl_PC (ctrl_PC_decoder),
	.write_BR (write_BR_decoder),
	.read_BR (read_BR_decoder),
	.write_ALU (write_alu_decoder),
	.ld (ld_decoder)
);

// END DECODER

// BANK_REGISTER
 
wire [31:0] src_alu_br;
wire [31:0] src2_alu_br;
wire [3:0] ctrl_alu_br;
wire [31:0] result_alu;
wire [31:0] data_out_br;
wire [31:0] daddr_br;

bank_register BR(
	.DATA_IN (DATA_IN),
    .clk(clk),
	.RST (RST),
    .result (result_alu),
	.src_in (src_decoder),
	.src2_in (src2_decoder),
    .dst_in (dst_d2r),
    .dstLd_in (dstLd_decoder),
	.const_in (const_decoder),
	.opcode (opcode_decoder),
	.ld (ld_decoder),
	.write (write_BR_decoder),
	.read (read_BR_decoder),
	.write_ALU (write_alu_d2r),
	.src_alu (src_alu_br),
	.src2_alu (src2_alu_br),
	.ctrl_alu (ctrl_alu_br),
	.DATA_OUT (DATA_OUT),
	.DADDR (DADDR),
	.DWR (DWR)
);

// END BANK_REGISTER

// PROGRAM_COUNTER

program_counter PC(
	.IADDR (IADDR),
	.ctrl (ctrl_PC_decoder),
	.jump (jump_decoder),
	.RST (RST),
	.clk (clk)
);

// END PROGRAM_COUNTER

// ALU

alu Alu(
	.RST (RST),
	.clk (clk),
    .src (src_alu_br),
    .src2 (src2_alu_br),
    .opcode (ctrl_alu_br),
    .result (result_alu)
);

// END ALU

// DELAY REGISTER

delay_reg DR(
	.clk (clk),
	.RST (RST),
	.dst (dst_decoder),
	.write_alu (write_alu_decoder),
	.dst_delay (dst_dr),
	.write_alu_delay (write_alu_dr)
);

// END DELAY REGISTER

// DELAY2 REGISTER

delay2_reg D2R(
	.clk (clk),
	.RST (RST),
	.dst (dst_dr),
	.write_alu (write_alu_dr),
	.dst_delay2 (dst_d2r),
	.write_alu_delay2 (write_alu_d2r)
);

// END DELAY2 REGISTER

endmodule