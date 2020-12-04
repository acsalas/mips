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
		mem_space[64] = 32'h20110000; //addi $17, $0, 0
		mem_space[65] = 32'h20080002; //addi $8, $0, 2
		mem_space[66] = 32'h0228482A; //L1:	   slt $9, $17, $8
		mem_space[67] = 32'h1120000E; //beq $9, $0, END
		mem_space[68] = 32'h22310001; //addi $17, $17, 1
		mem_space[69] = 32'h20120000; //addi $18, $0, 0
		mem_space[70] = 32'h0248502A; //L2:	   slt $10,$18,$8
		mem_space[71] = 32'h1140FFFA; //beq $10, $0, L1
		mem_space[72] = 32'h224b0001; //addi $11, $18, 1
		mem_space[73] = 32'h01705820; //add $11, $11, $16
		mem_space[74] = 32'h8D6C0000; //lw $12, 0($11)
		mem_space[75] = 32'h8D6D0001; // lw $13, 1($11)
		mem_space[76] = 32'h01AC702A; //slt $14,$13,$12
		mem_space[77] = 32'h11C00002; // beq $14, $0, 2
		mem_space[78] = 32'hAD6D0000; //sw $13, 0($11)
		mem_space[79] = 32'hAD6C0001; //sw $12, 1($11)
		mem_space[80] = 32'h22520001; //ELSE:   addi $18, $18, 1
		mem_space[81] = 32'h08000042; // j 64
		 
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