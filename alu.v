module alu(
	input wire clk,
	input wire RST,
	input wire [31:0] src,
	input wire [31:0] src2,
	input wire [3:0] opcode,
    output reg [31:0] result
);

always @(posedge clk) 
begin
    if(!RST)
    begin
        case (opcode)
            4'b0111:    // ADD
            begin
                result <= src + src2;
            end
            4'b1000:    // SUB
            begin
                result <= src - src2;
            end
            4'b1001:    // AND
            begin
                result <= src & src2;
            end
            4'b1010:    // OR
            begin
                result <= src | src2;
            end
            4'b1011:    // XOR
            begin
                result <= src ^ src2;
            end
            4'b1100:    // SHROL
            begin
                result <= 32'b0;
            end
            4'b1101:    // SHROR
            begin
                result <= 32'b0;
            end
        endcase
    end else begin
        result <= 32'b0;
    end
end

endmodule