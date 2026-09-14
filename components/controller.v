
// controller.v - controller for RISC-V CPU

module controller (
    input [6:0]  op,
    input [2:0]  funct3,
    input        funct7b5,
    input        Zero, ALUResult31b, carry,
    output       [1:0] ResultSrc,
    output       MemWrite,
    output       PCSrc, ALUSrc,
    output       RegWrite, Jump, jalr,
    output [2:0] ImmSrc,
    output [3:0] ALUControl
);

wire [2:0] ALUOp;
wire       Branch;
wire 		  Branch_taken;

main_decoder    md (op, ResultSrc, MemWrite, Branch,
                    ALUSrc, RegWrite, Jump, jalr, ImmSrc, ALUOp);

alu_decoder     ad (op[5], funct3, funct7b5, ALUOp, ALUControl);

branch_logic 	 bl (ALUResult31b, Zero, carry, Branch, funct3, Branch_taken);
// for jump and branch
assign PCSrc = Branch_taken | Jump;

endmodule

