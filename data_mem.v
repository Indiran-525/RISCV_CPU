
// data_mem.v - data memory

module data_mem #(parameter DATA_WIDTH = 32, ADDR_WIDTH = 32, MEM_SIZE = 1024) (
    input       clk, wr_en,
    input       [ADDR_WIDTH-1:0] wr_addr,
	input       [DATA_WIDTH-1:0] wr_data,
	 input 		 [2:0] 				funct3,
    output reg  [DATA_WIDTH-1:0] rd_data_mem
);

// array of MEM_SIZE 32-bit words or data
reg [DATA_WIDTH-1:0] data_ram [0:MEM_SIZE-1];


// combinational read logic
// word-aligned memory access
//always@(*) 
//rd_data_mem = data_ram[wr_addr[DATA_WIDTH-1:2] % MEM_SIZE];

// synchronous write logic
always @(posedge clk) begin
    if (wr_en) begin
		case(funct3)
			3'b000: begin
				case(wr_addr[1:0])
					2'b00: data_ram[wr_addr[ADDR_WIDTH-1:2] % MEM_SIZE][7:0] <= wr_data[7:0];
					2'b01: data_ram[wr_addr[ADDR_WIDTH-1:2] % MEM_SIZE][15:8] <= wr_data[7:0];
					2'b10: data_ram[wr_addr[ADDR_WIDTH-1:2] % MEM_SIZE][23:16] <= wr_data[7:0];
					2'b11: data_ram[wr_addr[ADDR_WIDTH-1:2] % MEM_SIZE][31:24] <= wr_data[7:0];
					default: data_ram[wr_addr[ADDR_WIDTH-1:2] % MEM_SIZE][7:0] <= 8'bx;
				endcase
			end
			
			3'b001: begin
				if(!wr_addr[1])  data_ram[wr_addr[ADDR_WIDTH-1:2] % MEM_SIZE][15:0] <= wr_data[15:0];
				else  data_ram[wr_addr[ADDR_WIDTH-1:2] % MEM_SIZE][31:16] <= wr_data[15:0];
			end
			
			3'b010: data_ram[wr_addr[ADDR_WIDTH-1:2] % MEM_SIZE] <= wr_data;
			default: data_ram[wr_addr[ADDR_WIDTH-1:2] % MEM_SIZE] <= 32'bx;
			endcase
	 end
end

always@(*) begin
	case(funct3)
		3'b000: begin
			case(wr_addr[1:0])
				2'b00: rd_data_mem = {{24{data_ram[wr_addr[ADDR_WIDTH-1:2] % MEM_SIZE][7]}},data_ram[wr_addr[ADDR_WIDTH-1:2] % MEM_SIZE][7:0]};
				2'b01: rd_data_mem = {{24{data_ram[wr_addr[ADDR_WIDTH-1:2] % MEM_SIZE][15]}},data_ram[wr_addr[ADDR_WIDTH-1:2] % MEM_SIZE][15:8]};
				2'b10: rd_data_mem = {{24{data_ram[wr_addr[ADDR_WIDTH-1:2] % MEM_SIZE][23]}},data_ram[wr_addr[ADDR_WIDTH-1:2] % MEM_SIZE][23:16]};
				2'b11: rd_data_mem = {{24{data_ram[wr_addr[ADDR_WIDTH-1:2] % MEM_SIZE][31]}},data_ram[wr_addr[ADDR_WIDTH-1:2] % MEM_SIZE][31:24]};
			endcase
		end
		3'b001: begin
			if(!wr_addr[1]) rd_data_mem = {{16{data_ram[wr_addr[ADDR_WIDTH-1:2] % MEM_SIZE][15]}},data_ram[wr_addr[ADDR_WIDTH-1:2] % MEM_SIZE][15:0]};
			else rd_data_mem = {{16{data_ram[wr_addr[ADDR_WIDTH-1:2] % MEM_SIZE][31]}},data_ram[wr_addr[ADDR_WIDTH-1:2] % MEM_SIZE][31:16]};
		end
		3'b010: rd_data_mem = data_ram[wr_addr[ADDR_WIDTH-1:2] % MEM_SIZE];
		
		3'b100: begin
			case(wr_addr[1:0])
				2'b00: rd_data_mem = {24'b0,data_ram[wr_addr[ADDR_WIDTH-1:2] % MEM_SIZE][7:0]};
				2'b01: rd_data_mem = {24'b0,data_ram[wr_addr[ADDR_WIDTH-1:2] % MEM_SIZE][15:8]};
				2'b10: rd_data_mem = {24'b0,data_ram[wr_addr[ADDR_WIDTH-1:2] % MEM_SIZE][23:16]};
				2'b11: rd_data_mem = {24'b0,data_ram[wr_addr[ADDR_WIDTH-1:2] % MEM_SIZE][31:24]};
			endcase
		end
		
		3'b101: begin
			if(!wr_addr[1]) rd_data_mem = {16'b0,data_ram[wr_addr[ADDR_WIDTH-1:2] % MEM_SIZE][15:0]};
			else rd_data_mem = {16'b0,data_ram[wr_addr[ADDR_WIDTH-1:2] % MEM_SIZE][31:16]};
		end
		default: rd_data_mem = 32'bx;
	endcase
end

endmodule

