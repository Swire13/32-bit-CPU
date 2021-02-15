module delay_reg(
	input wire clk,
	input wire RST,
	input wire [5:0] dst,
	input wire write_alu,
	output reg [5:0] dst_delay,
	output reg write_alu_delay
);

always @(posedge clk) 
begin
	if(!RST)
	begin
		dst_delay <= dst;   
		write_alu_delay <= write_alu;
	end
end

endmodule