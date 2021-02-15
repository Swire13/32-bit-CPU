module decoder(
	input wire [31:0] INSTR_IN,
	input wire clk,
	input wire RST,
	output reg [5:0] dst,
	output reg [5:0] dstLd,
	output reg [5:0] src,
	output reg [5:0] src2,
	output reg [30:0] const,
	output reg [3:0] opcode,
	output reg [31:0] jump,
	output reg [1:0] ctrl_PC,
	output reg write_BR,
	output reg read_BR,
	output reg write_ALU,
	output reg ld
);

always @(posedge clk)
begin
    if(!RST)
    begin
        write_BR <= 0;
        ld = 0;
        write_ALU = 0;
        read_BR <= 0;
        ctrl_PC <= 0;
        casex(INSTR_IN[31:25])
            7'b0000000:     // NOP
                begin
                    opcode <= 0;
	        	end
            7'b1XXXXXX:     // JMP
                begin
                    opcode <= 1;
                    const <= INSTR_IN[30:0];
                    jump <= {1'b0,INSTR_IN[30:0]};
                    ctrl_PC <= 1;
                end
            7'b01XXXXX:     // LD
                begin   
                    opcode <= 2;
                    const <= {6'b0,INSTR_IN[29:18], INSTR_IN[11:0]};
                    dstLd <= INSTR_IN[17:12];
                    ld = 1;
                end
            7'b00010XX:     // WR
                begin
                    opcode <= 3;
	    		    src <= INSTR_IN [5:0];
                    src2 <= INSTR_IN [11:6];
                    write_BR <= 1;
                end
            7'b00011XX:     // RD
                begin
                    opcode <= 4;
                    src2 <= INSTR_IN [11:6];
                    dst <= INSTR_IN [17:12];
                    read_BR <= 1;
                end
            7'b0010XXX:     // BEQ
                begin
                    opcode <= 5;
                    const <= INSTR_IN[27:12];
                    src2 <= INSTR_IN[11:6];
                    src <= INSTR_IN[5:0];
                end
            7'b0011XXX:     // BNE
                begin
                    opcode <= 6;
                    const <= INSTR_IN[27:12];
                    src2 <= INSTR_IN[11:6];
                    src <= INSTR_IN[5:0];
                end
            // ALU INSTRUCTION DECODERING
            7'b0000001:     // ADD
                begin
                    opcode <= 7;
                    src <= INSTR_IN[5:0];
                    src2 <= INSTR_IN[11:6];
                    dst <= INSTR_IN[17:12];
                    write_ALU = 1;
                end
            7'b0000010:     // SUB
                begin
                    opcode <= 8;
                    src <= INSTR_IN[5:0];
                    src2 <= INSTR_IN[11:6];
                    dst <= INSTR_IN[17:12];
                    write_ALU = 1;
                end
            7'b0000011:     // AND
                begin
                    opcode <= 9;
                    src <= INSTR_IN[5:0];
                    src2 <= INSTR_IN[11:6];
                    dst <= INSTR_IN[17:12];
                    write_ALU = 1;
                end
            7'b0000100:     // OR
                begin
                    opcode <= 10;
                    src <= INSTR_IN[5:0];
                    src2 <= INSTR_IN[11:6];
                    dst <= INSTR_IN[17:12];
                    write_ALU = 1;
                end
            7'b0000101:     // XOR
                begin
                    opcode <= 11;
                    src <= INSTR_IN[5:0];
                    src2 <= INSTR_IN[11:6];
                    dst <= INSTR_IN[17:12];
                    write_ALU = 1;
                end
            7'b0000110:     // SHROL
                begin
                    opcode <= 12;
                    src <= INSTR_IN[5:0];
                    src2 <= INSTR_IN[11:6];
                    dst <= INSTR_IN[17:12];
                    write_ALU = 1;
                end
            7'b0000111:     // SHROR
                begin
                    opcode <= 13;
                    src <= INSTR_IN[5:0];
                    src2 <= INSTR_IN[11:6];
                    dst <= INSTR_IN[17:12];
                    write_ALU = 1;
                end
            default: begin end
            // END ALU INSTRUCTION DECODERING
        endcase
    end else begin
        write_BR <= 0;
        ld = 0;
        write_ALU = 0;
        read_BR <= 0;
        ctrl_PC <= 0;
        opcode <= 4'b0;
        src <= 6'b0;
        src2 <= 6'b0;
        dst <= 6'b0;
        dstLd <= 6'b0;
        jump <= 30'b0;
        const <= 30'b0;
    end
end

endmodule