module memory(
    input [31:0] Address, w_data,
	input [6:0] sw_addr,
    input clk, we, re,
    output reg  [31:0] mem_data, out_data
);

    reg [31:0] mem_space [128:0];

	initial begin
		mem_space[24] = 32'h00000010;
		mem_space[25] = 32'h00000001;
		mem_space[26] = 32'h00000005;
		mem_space[64] = 32'h20110000;
		mem_space[65] = 32'h20080002;
		mem_space[66] = 32'h0228482A;
		mem_space[67] = 32'h1120000E;
		mem_space[68] = 32'h22310001;
		mem_space[69] = 32'h20120000;
		mem_space[70] = 32'h0248502A;
		mem_space[71] = 32'h1140FFFA;
		mem_space[72] = 32'h224b0001;
		mem_space[73] = 32'h01705820;
		mem_space[74] = 32'h8D6C0000;
		mem_space[75] = 32'h8D6D0001;
		mem_space[76] = 32'h01AC702A;
		mem_space[77] = 32'h11C00002;
		mem_space[78] = 32'hAD6D0000;
		mem_space[79] = 32'hAD6C0001;
		mem_space[80] = 32'h22520001;
		mem_space[81] = 32'h08000042;
		 
	end

	  always @ (posedge clk)
		  begin
				if(we)
					 mem_space[Address] <= w_data;
				//else if(re)
				//	 mem_data <= mem_space[Address];
		  end
		
		assign mem_data = re ? mem_space[Address] : 'Z;
		assign out_data = mem_space[sw_addr];

endmodule