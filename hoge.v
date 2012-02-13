`timescale 1ns/10ps

module add(
    input wire [3:0] in1,
    input wire [3:0] in2,
    output reg [3:0]        out,
    output reg              carry);

   reg [8:0]                ret;
   
   always @* begin
      ret = in1 + in2;

      out = ret[3:0];
      carry = ret[4];
      //$display("A=%d, B=%d, c=%b, O=%d",in1,in2,carry,out);
   end

   
endmodule // add

module hoge();

   reg [3:0] A,B;
   wire [3:0] O;
   wire       c;
   
   add add0(.in1(A),.in2(B),.out(O),.carry(c));

   task setVal( input[3:0] a, input[3:0] b);
      begin
         A = a;
         B = b;
         #1 $display("A=%d, B=%d, c=%b, O=%04b",A,B,c,O);
      end
   endtask // setVal
   
   integer i,j;
   
   initial begin
      $display("hello, world\n");

      A=0;
      B=0;
      
      for(i=0; i<16; i=i+1) begin
         for(j=0; j<16; j=j+1) begin
            #100 setVal(i,j);
         end
      end


      $finish;
   end
   
endmodule // hoge
