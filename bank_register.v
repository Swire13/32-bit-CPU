module bank_register(
	input wire clk,
	input wire RST,
    input wire [31:0] DATA_IN,
    input wire [31:0] result,
    input wire [5:0] src_in,
    input wire [5:0] src2_in,
    input wire [5:0] dst_in,
    input wire [5:0] dstLd_in,
    input wire [30:0] const_in,
    input wire [3:0] opcode,
    input wire ld,
    input wire write,
    input wire read,
    input wire write_ALU,
    output reg [31:0] src_alu,
    output reg [31:0] src2_alu,
    output reg [3:0] ctrl_alu,
	output reg [31:0] DATA_OUT,
    output reg [31:0] DADDR,
    output reg DWR
);

integer i;
integer counter = 0;
integer read_bit = 0;

reg [31:0] REGISTERS [63:0];

always @(posedge clk) 
begin
        
    DWR <= 0;
    if(!RST)
    begin
        src_alu <= REGISTERS[src_in];
        src2_alu <= REGISTERS[src2_in];
        ctrl_alu <= opcode[3:0];

        if(ld)
        begin
            REGISTERS[dstLd_in] <= {1'b0,const_in};
            DATA_OUT <= {1'b0,const_in};
        end

        if(write_ALU)
        begin
            REGISTERS [dst_in] <= result;
	    	// DATA_OUT <= result;
        end

        if (write)
        begin
            DATA_OUT <= REGISTERS[src_in];
            DADDR <= REGISTERS[src2_in];
            DWR <= 1;
        end

        if(read)
        begin
            DADDR <= REGISTERS[src2_in];
            read_bit = 1;
        end

        if(read_bit)
        begin
            counter = counter+1;
            if(counter==3)
            begin
                counter=0;
                read_bit=0;
                REGISTERS[dst_in] <= DATA_IN; //oneskorit o 2 cykly
            end
        end
    end 
    else
    begin
        for(i=0;i<64;i=i+1)
        begin
            REGISTERS[i] <= 32'b0;
        end
        src_alu <= 0;
        src2_alu <= 0;
        ctrl_alu <= 0;
        DATA_OUT <= 32'b0;
        DADDR <= 32'b0;
        DWR <= 0;
    end
end

endmodule