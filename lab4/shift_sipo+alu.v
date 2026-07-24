module shift_sipo#(parameter w=4)(
    input wire [w-1:0]p,
    input wire clk,
    input wire rw,
    output reg s
);
reg [w-1:0]tp=0;
    always @(posedge clk) begin
        
        if (rw) begin //read lma rw b 1
            s<=tp[0];
	    tp <= tp >> 1;  
        end      
        else begin
        tp <= p;
        end
    end

endmodule