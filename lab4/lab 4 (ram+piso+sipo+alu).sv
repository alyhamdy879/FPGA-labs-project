module ram #(parameter d_w=20,
             parameter a_w=8 )(
    input wire clk,
    input wire rst_n,
    input wire wr_en,
    input wire rd_en,
    input wire [a_w-1:0] addr, 
    input wire [d_w-1:0] din,
    output reg [d_w-1:0] dout,
    output reg valid  
);
    reg[d_w-1:0] mem [0:(1<<a_w)-1]; // 1<<a_w == 2^8 
    
    always@(posedge clk or negedge rst_n) begin
        
        if (!rst_n) begin
            dout  <= 0;
            valid <= 0;
        end
        else begin 
            if(wr_en) begin
                mem[addr] <= din;
            end
            if(rd_en) begin
                dout  <= mem[addr];
                valid <= 1; 
            end 
            else begin
                valid <= 0;
            end   
        end
    end

endmodule 

module shift_piso#(parameter w=20)(
    input wire [w-1:0]p,
    input wire clk,
    input wire rst_n,
    input wire rvalid,
    output reg valid,
    output reg en,
    output reg s
);
    reg [w-1:0]tp;
    reg [5:0] c=0;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            en <= 1;            //req data from ram
            valid <= 0;
            s <= 0;
            c <= 0;
            tp <= 0;
        end
        else begin
            if(rvalid)begin    //write lma rvalid b 1
                valid<= 1 ;
                tp   <= p << 1;
                s    <= p[w-1];
                c    <= 1 ;
                en   <= 0 ;
            end
            else if (valid) begin 
                s  <= tp[w-1];
                tp <= tp << 1;

                if (c<w-1)begin
                    c<=c+1;
                end
                else begin
                    valid <= 0 ;
                    c     <= 0 ;
                    en    <= 1 ;
                end  
            end      
            else begin
            s  <= 0;
            en <= 0; 
            end     
        end
    end
endmodule

module shift_sipo#(parameter w=20)(
    input wire s,
    input wire clk,
    input wire rst_n,
    input wire shift_en,
    output reg [w-1:0]po
);
    always @(posedge clk or negedge rst_n) begin

        if (!rst_n) begin
            po<=0;
        end
        else begin
            if (shift_en) begin //read lma shift_en b 0 
                po<= {po[w-2:0],s};
            end      
        end
    end

endmodule

module alu#(parameter w=20,
            parameter ip=w-12,
            parameter opp=w-17)(
    input wire             alu_en,
    input wire [opp-1:0]   op,
    input wire [ip-1:0]    a,    
    input wire [ip-1:0]    b, 
    output reg [ip-1:0]    alu_out,
    output reg             a_is_zero 
);    
    always @(*) begin
        a_is_zero = (a == 0);

        if (alu_en) begin
            case(op)
              3'b000    : alu_out = a+b;      
              3'b001    : alu_out = a-b;       
              3'b010    : alu_out = a&b;   
              3'b011    : alu_out = a^b;
              3'b100    : alu_out = a|b;
              3'b101    : alu_out = a  ;
              default   : alu_out = 0  ;       
            endcase
        end   
        else begin
            alu_out=0;
        end         
  end

endmodule 

module lab_4 #(parameter w=20,
               parameter a_w=8,
               parameter ip=w-12,
               parameter opp=w-17)(

    input wire clk,
    input wire rst_n,
    input wire wr_en,
    input wire  [a_w-1:0] addr, 
    input wire  [w-1:0]   din,
    output wire [w-13:0]  alu_out,
    output wire a_is_zero 

);
    wire [w-1:0]  d1out;
    wire          d2out;
    wire [w-1:0]  po;
    wire          rd_en, rvalid,valid;
    
    
    ram        #(.d_w(w), .a_w(a_w) )           ram1  (
                                                        .clk(clk),
                                                        .rst_n(rst_n),
                                                        .wr_en(wr_en),
                                                        .rd_en(rd_en),
                                                        .addr (addr),
                                                        .din  (din),
                                                        .dout (d1out),
                                                        .valid(rvalid) 
                                                        );
    shift_piso #(.w(w))                         piso1 (
                                                        .clk(clk),
                                                        .rst_n (rst_n),
                                                        .p     (d1out),
                                                        .rvalid(rvalid),
                                                        .valid (valid),
                                                        .en    (rd_en),
                                                        .s     (d2out)
                                                        );
    shift_sipo #(.w(w))                         sipo1 ( 
                                                        .clk(clk),
                                                        .rst_n   (rst_n),
                                                        .s       (d2out),
                                                        .shift_en(valid),
                                                        .po      (po)
                                                        );
    alu        #(.w(w), .ip(ip), .opp(opp))     alu1  ( 
                                                        .alu_en(po[w-1]),           
                                                        .op(po[w-2    : w-4]),             
                                                        .a (po[(ip*2) : ip ]),               
                                                        .b (po[ip-1   : 0  ]),              
                                                        .alu_out(alu_out),
                                                        .a_is_zero(a_is_zero)
                                                        );
 
endmodule 