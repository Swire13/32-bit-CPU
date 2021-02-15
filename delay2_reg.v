module delay2_reg(
	input wire clk,
	input wire RST,
	input wire [5:0] dst,
	input wire write_alu,
	output reg [5:0] dst_delay2,
	output reg write_alu_delay2
);

always @(posedge clk) 
begin
	if(!RST)
	begin
    	dst_delay2 <= dst;   
		write_alu_delay2 <= write_alu;
	end
end

endmodule