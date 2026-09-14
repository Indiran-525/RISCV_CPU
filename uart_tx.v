
module uart_tx(
    input clk_50,
    input parity_type,tx_start,
    input [7:0] data,
    output reg tx, tx_done
);

initial begin
    tx = 1'b1;
    tx_done = 1'b0;
end

 
reg[10:0] baud_count = 11'b0;
reg[10:0] baud_tick = 11'b0;
reg[3:0] i = 3'd7;

localparam[2:0] IDLE = 3'b000, START_BIT = 3'b001, DATA = 3'b010, PARITY = 3'b011, STOP = 3'b100, DONE = 3'b101;
reg[2:0] current = IDLE,next = START_BIT;

always@(posedge(clk_50)) begin
    current <= next;
    if(current == next) baud_count <= baud_count + 1;
    else baud_count <= 0;
    if(current == DATA) begin
        if(baud_tick == 433) baud_tick <= 0;
        else baud_tick <= baud_tick + 1;
    end
end

always@(*) begin
    case (current)
        IDLE: next = tx_start ? START_BIT : IDLE;
        START_BIT: next = (baud_count == 433) ? DATA : START_BIT;
        DATA: next = (i >= 7 && baud_tick == 433) ? PARITY : DATA;
        PARITY: next = (baud_count == 433) ? STOP : PARITY;
        STOP: next = (baud_count == 433) ? DONE : STOP;
        DONE: next = (baud_count == 0) ? IDLE : DONE;
        default: next = IDLE;
    endcase
end

always@(posedge clk_50) begin
    case (current)
        IDLE: begin
            tx <= 1'b1;
			tx_done <= 1'b0;
            i <= 3'd0;
        end
        START_BIT: begin
            tx <= 1'b0;
            tx_done <= 1'b0;
            i <= 3'd0;
        end
        DATA: begin
            if(baud_tick == 11'd0) begin
                tx <= data[i];
                i <= i + 1'b1;
            end
            
            tx_done <= 1'b0;
        end
        PARITY: begin
            tx <= ^data[7:0] ^ parity_type;
            tx_done <= 1'b0;
            i <= 3'd0;
        end
        STOP: begin 
            tx <= 1'b1;
            tx_done <= 1'b0;
            i <= 3'd0;
        end
		DONE: begin 
            tx_done <= 1'b1;
            tx <= 1'b1;
            i <= 3'd0;
          end
        default: begin 
            tx <= 1'b1;
            tx_done <= 1'b0;
            i <= 3'd0;
        end
    endcase
end

endmodule