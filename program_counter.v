module program_counter(
	input wire clk,
	input wire RST,
    input wire [1:0] ctrl,
	input wire [31:0] jump,
    output reg [31:0] IADDR 
);

always @(posedge clk) begin
	if(!RST) 
    begin 
        case(ctrl)
            2'b00:
            begin
				IADDR <= IADDR + 1'b1;
			end
			2'b01:
            begin
				IADDR <= jump;
			end
        endcase
    end 
    else
    begin
        IADDR <= 32'd0;
    end

end
endmodule