module shift_sipo#(parameter w=20)(
    input wire s,
    input wire clk,
    input wire rw,
    output reg [w-1:0]po
);
reg [w-1:0]tp=0;
    always @(posedge clk) begin
        
        if (rw) begin //read lma rw b 1
            po<=tp;
        end      
        else begin
        tp<= {tp[w-2:0],s};
        end
    end

endmodule

module alu#(parameter wi=20,
            parameter ip=wi-12
            parameter opp=wi-18)(
    input wire [ip-1:0]a,    
    input wire [ip-1:0]b, 
    input wire [opp:0]op,  
    input wire alu_en,
    output reg [wi-13:0]alu_out,
    output reg a_is_zero 
);
assign {alu_en,op[wi-18:0],[wi-13:0]a,[wi-13:0]b}=po; 
assign a==0?a_is_zero=1:a_is_zero=0;
    always @(*) begin
        if (alu_en) begin
            case(op)
              3'b000    : alu_out = a+b;      
              3'b001    : alu_out = a-b;       
              3'b010    : alu_out = a&b;   
              3'b011    : alu_out = a^b;
              3'b100    : alu_out = a|b;
              3'b101    : alu_out = a;
              default  : alu_out=8'b0;       
            endcase
        end   

        else begin
            alu_out=0;
        end         
  end

endmodule 