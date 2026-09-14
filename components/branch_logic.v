//branch logic file

module branch_logic(
		input 		ALUResult31b, zero, carry, branch,
		input [2:0] funct3,
		output reg 	branch_taken
);

always@(*) begin
	if(branch) begin
		case(funct3)
			3'b000: branch_taken = zero ? 1'b1 : 1'b0;
			3'b001: branch_taken = zero ? 1'b0 : 1'b1;
			3'b100: branch_taken = (ALUResult31b) ? 1'b1 : 1'b0;
			3'b101: branch_taken = ((!ALUResult31b) || zero) ? 1'b1 : 1'b0;
			3'b110: branch_taken = (carry) ? 1'b1 : 1'b0;
			3'b111: branch_taken = !carry ? 1'b1 : 1'b0;
			default: branch_taken = 1'b0;
		endcase
	end
	else branch_taken = 1'b0;
end
	

endmodule