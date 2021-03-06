module datapath (
        input clk, rst, PCEn, debug,
        input IorD, MemRead, MemWrite, MemtoReg,
        IRWrite, RegWrite, RegDst, ALUSrcA,
        input [1:0] PCSource, ALUSrcB,
        input [2:0] ALUSel,
        input [6:0] sw_addr,
        input [31:0] debug_inst,
        output [5:0] opcode,func,
		  output zero,
          output [31:0] pc, out_data
    );
    

	wire [31:0] alu_res, alu_out, alu_inA, alu_inB;
wire [4:0] write_register;
    wire [31:0] write_data, rf_A, rf_B;

    wire [31:0] next_pc, curr_pc;
    wire [25:0] jmp_offset;

    wire [31:0] inst_32b;

    assign pc = curr_pc;
    /******** MEMORY *************/
    wire [4:0] rs_addr, rt_addr;
    wire [15:0] instruction;
    wire [31:0] mem_data, data, mem_addr;
    
    //Signals for debugging with testbench
    wire [31:0] full_inst;
    //assign full_inst = debug ? debug_inst : mem_data;
    // the instruction is built upon the code in switches[8:7]
    // the parameters are set in switches[6:0] 
    wire [31:0] manual_inst;
    always@(*)
    begin
        case(debug_inst[8:7])
            2'h0: manual_inst = {28'h2010000,debug_inst[3:0]};  //addi in $S0
            2'h1: manual_inst = {28'h2011000,debug_inst[3:0]};  //addi in $S1 
            2'h2: manual_inst = 32'h02309020;  //add $S0 and $S1  in $S2            
            2'h3: manual_inst = {24'hAC1200,1'b0,debug_inst[6:0]};  //sw $S2 en switches            
            default: manual_inst = 32'hAC120020;
        endcase
    end

    assign full_inst = debug ? manual_inst : mem_data;
    



    assign func = instruction[5:0];

    assign mem_addr = IorD ? alu_out : curr_pc;



    memory RAM(.clk(clk), .we(MemWrite), .re(MemRead),.Address(mem_addr), .w_data(rf_B),  .mem_data(mem_data), .sw_addr(sw_addr), .out_data(out_data));

    instruction_reg IR(.clk(clk), .dataIn(full_inst), .IRWrite(IRWrite),
        .opcode(opcode), .rs_addr(rs_addr), .rt_addr(rt_addr), .instruction(instruction));
    data_reg DR(.clk(clk), .dataIn(full_inst), .dataOut(data));

    /************* REGISTER FILE ***************/
    

    //MUXES
    assign write_data = MemtoReg ? data : alu_out;
    assign write_register = RegDst ? instruction[15:11] : rt_addr;
    
    rf RF(.clk(clk), .rst(rst), .we(RegWrite), .rs_addr(rs_addr), .rt_addr(rt_addr), 
    .rd_addr(write_register), .rd_data(write_data), .rs_data(rf_A), .rt_data(rf_B));


    /************** ALU **************************/

    

    assign alu_inA = ALUSrcA ? rf_A : curr_pc;
	 
    assign alu_inB = (ALUSrcB == 0) ? rf_B :
                    (ALUSrcB == 1) ? 32'b1 : inst_32b;

    alu ALU(.A(alu_inA), .B(alu_inB),  .sel(ALUSel), .out(alu_res), .zero(zero));

    //assign out_data = alu_res;

    data_reg ALUOut(.clk(clk), .dataIn(alu_res), .dataOut(alu_out));


    /***************** PC *********************/


    assign jmp_offset = {rs_addr, rt_addr, instruction};

    assign next_pc = (PCSource == 0) ? alu_res :
                      (PCSource == 1) ? alu_out : {curr_pc[31:26] , jmp_offset};

    pc PC(.clk(clk), .rst(rst), .pc_en(PCEn), .next_inst(next_pc), .curr_inst(curr_pc));

    /***************** SIGN EXTEND ***************/


    sign_extend SE32(.signal_in(instruction), .signal_out(inst_32b));

endmodule