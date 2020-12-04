module rf(
  //We are asuming always enabled RAM
  input clk, we, rst,
  input [4:0] rs_addr,
  input [4:0] rt_addr,
  input [4:0] rd_addr,
  input [4:0] sw_address,
  input [31:0] rd_data,
  output reg [31:0] rs_data,
  output reg [31:0] rt_data, 
  output  [31:0] testReg
  );
  
  reg [31:0] mem[31:0];
  int i;

  initial begin
    mem[16]= 32'h17; //set up to point $S0 to position 23 of data memory.
  end
  
  always @ (posedge clk)
  begin

      if(rst)
      begin
        for(i = 0; i <= 31; i = i+1)
          mem[i] <= 0;
        mem[16]= 32'h17;
      end
      else if(we)
        begin
          if(rd_addr != 0)
            mem[rd_addr] <= rd_data;
        end
  end
 
    always @(posedge clk) begin
        rs_data <= mem[rs_addr];
        rt_data <= mem[rt_addr];  
    end
  assign testReg = mem[sw_address];

endmodule
