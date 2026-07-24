module alu#(parameter WIDTH=8)(
    input wire [WIDTH-6:0]   opcode,
    input wire [WIDTH-1:0]    in_a,    
    input wire [WIDTH-1:0]    in_b, 
    output reg [WIDTH-1:0]    alu_out,
    output reg             a_is_zero 
);    
    always @(*) begin
        a_is_zero = (in_a == 0);
            case(opcode)       
              3'b010    : alu_out = in_a+in_b;   
              3'b011    : alu_out = in_a&in_b;
              3'b100    : alu_out = in_a^in_b;
              3'b101    : alu_out = in_b  ;
              default   : alu_out = in_a  ;       
            endcase           
  end

endmodule