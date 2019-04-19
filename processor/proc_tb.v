`timescale 1 ns / 100 ps

module proc_tb();

	 integer CYCLE_LIMIT = 50000;
	 
    // inputs to the proc are reg type
    reg            clock, reset;
	 reg [31:0] move1;
	 

    skeleton_proc dut (clock, reset, move1);//, snake, d_mw_out, o_mw_out, isLoadSnake_w_out, a_in_dx_out, b_in_dx_out);

    wire[31:0] pc = dut.my_processor.pc;
	 
	 wire [11:0] address_imem = dut.my_processor.address_imem;

    // Dmem
    wire [11:0] address_dmem = dut.my_processor.address_dmem;
    wire [31:0] data = dut.my_processor.data;
    wire wren = dut.my_processor.wren;

    // Regfile
    wire ctrl_writeEnable = dut.my_processor.ctrl_writeEnable;
    wire [4:0] ctrl_writeReg = dut.my_processor.ctrl_writeReg;
	 wire [4:0] ctrl_readRegA = dut.my_processor.ctrl_readRegA;
	 wire [4:0] ctrl_readRegB = dut.my_processor.ctrl_readRegB;
    wire [31:0] data_writeReg = dut.my_processor.data_writeReg;
	 
	 wire isLW_x = dut.my_processor.isLW_x;
	 wire [31:0] ir_dx = dut.my_processor.ir_dx;
	 wire [31:0] ir_xm = dut.my_processor.ir_xm;
	 
	 wire [455:0] snake = dut.my_processor.snake;
	 wire [1:0] dir1 = snake[1:0];
	 wire [31:0] head1 = snake[231:200];
	 wire [31:0] stage = snake[359:328];
	 
	 wire [31:0] s7 = dut.my_regfile.read_output[32*(23+1)-1: 32*23];
	 
	 wire isBranch = dut.my_processor.isBranch;
	 wire [31:0] branch_value = dut.my_processor.branch_value;
	 
	 wire isB1 = dut.my_processor.isBranch1;
	 wire isB2 = dut.my_processor.isBranch2;
	 wire isB3 = dut.my_processor.isBranch3;
	 wire isB4 = dut.my_processor.isBranch4;
	 
	
	 
    initial
    begin
        $display($time, "<< Starting the Simulation >>");
        clock = 1'b0;    // at time 0
		  
		  move1 = 32'd2;
		  
		  // processor output monitor
		  $monitor("pc: %d, ctrl_readRegA: %d, ctrl_readRegB: %d, data_writeReg: %d, ctrl_writeReg: %d, ctrl_writeEnable: %d, address_dmem: %d, data: %d, wren: %d, s7: %d", 
		  pc, ctrl_readRegA, ctrl_readRegB, data_writeReg, ctrl_writeReg, ctrl_writeEnable, address_dmem, data, wren, s7);
		  
		  
		  //$monitor("clock: %d, snake: %d, d_mw: %d, o_mw: %d, isLoadSnake: %b", clock, snake, d_mw_out, o_mw_out, isLoadSnake_w_out, a_in_dx_out, b_in_dx_out);
		  
		  // processor output monitor
		  //$monitor("pc: %d, data_writeReg: %d, ctrl_writeReg: %d, ctrl_writeEnable: %d, address_dmem: %d, data: %d, wren: %d, dir1: %b, head1: %d, isLoadSnake_w: %b, stage: %d, d_mw: %d, o_mw: %d, d_mw(binary): %b", 
		  //pc, data_writeReg, ctrl_writeReg, ctrl_writeEnable, address_dmem, data, wren, dir1, head1, isLoadSnake_w, stage, d_mw, o_mw, d_mw);
		  
		  
		  // isloadtoALU monitor
		  //$monitor("pc: %d, isLoadToALU: %d, isLW_x: %d, ir_dx: %b, ir_xm: %b", 
		  //pc, isLoadToALU, isLW_x, ir_dx, ir_xm);
		  
		  // processor output monitor
		  //$monitor("pc: %d, ctrl_readRegA: %d, ctrl_readRegB: %d, data_writeReg: %d, ctrl_writeReg: %d, ctrl_writeEnable: %d, address_dmem: %d, data: %d, wren: %d, isBranch: %d, isStillMultDiv: %d,  isLoadToALU: %d", 
		  //pc, ctrl_readRegA, ctrl_readRegB, data_writeReg, ctrl_writeReg, ctrl_writeEnable, address_dmem, data, wren, isBranch, isStillMultDiv, isLoadToALU);
		  
		  
		  // snake board
		  //$monitor("pc: %d, data_writeReg: %d, ctrl_writeReg: %d, ctrl_writeEnable: %d, address_dmem: %d, data: %d, wren: %d, snake: %b, d_mw: %d, o_mw: %d, isLoadSnake_w: %d", 
		  //pc, data_writeReg, ctrl_writeReg, ctrl_writeEnable, address_dmem, data, wren, snake, d_mw, o_mw, isLoadSnake_w);
		  
		  
		  // multdiv
		  //$monitor("pc: %d, alu_input_1: %d, alu_input_2: %d, ctrl_MULT: %d, data_resultRDY: %d, multdiv_result: %d, isStillMultDiv: %d, data_writeReg: %d, isLW2ALU: %d",
		  //pc, alu_input_1, alu_input_2, ctrl_MULT, data_resultRDY, multdiv_result, isStillMultDiv, data_writeReg, isLoadToALU);
		  
		  // WB bypass to D
		  //$monitor("pc: %d, data_writeReg: %d, ctrl_writeReg: %d, a_out_regfile: %d, b_out_regfile: %d, match_write_rs: %d",
		  //pc, data_writeReg, ctrl_writeReg, a_out_regfile, b_out_regfile, match_write_rs);
		  
		  // multdiv with branching
		  //$monitor("clock: %d, pc: %d, address_imem: %d, ctrl_readRegA: %d, ctrl_readRegB: %d, data_writeReg: %d, ctrl_writeReg: %d, ctrl_writeEnable: %d, isBranch, %d, branch_value: %d", 
		  //clock, pc, address_imem, ctrl_readRegA, ctrl_readRegB, data_writeReg, ctrl_writeReg, ctrl_writeEnable, isBranch, branch_value);
		  
		  // multdiv
		  //$monitor("clock: %d, pc: %d, data_a: %d, data_b: %d, result_mult: %d, ctrl_MULT: %d, data_resultRDY: %d, multdiv_result: %d, o_in_x_sel: %d, isStillMultDiv: %d",
		  //clock, pc, data_a, data_b, result_mult, ctrl_MULT, data_resultRDY, multdiv_result, o_in_x_sel, isStillMultDiv);

		  // branching monitor
		  //$monitor("pc: %d, alu_1: %d, alu_2: %d, isBranch: %d, branch_value: %d, pc_branch_sel: %d, isBex_x: %d, bne_alu: %d, ctrl_writeEnable: %d, ctrl_writeReg: %d, data_writeReg: %d, sel_alu_input1: %d",
		  //pc, alu_input_1, alu_input_2, isBranch, branch_value, pc_branch_select, isBex_x, bne_alu, ctrl_writeEnable, ctrl_writeReg, data_writeReg, sel_alu_input1);
		  
		  // processor output monitor
		  //$monitor("pc: %d, address_imem: %d, ctrl_readRegA: %d, ctrl_readRegB: %d, data_writeReg: %d, ctrl_writeReg: %d, ctrl_writeEnable: %d, address_dmem: %d, data: %d, wren: %d", 
		  //pc, address_imem, ctrl_readRegA, ctrl_readRegB, data_writeReg, ctrl_writeReg, ctrl_writeEnable, address_dmem, data, wren);
		  
		  //$monitor("pc: %d, address_imem: %d, ctrl_readRegA: %d, ctrl_readRegB: %d, data_writeReg: %d, ctrl_writeReg: %d, ctrl_writeEnable: %d, address_dmem: %d, data: %d, wren: %d, isBranch: %d, branch_value: %d, alu_out: %d\n\n\n", pc, address_imem, ctrl_readRegA, ctrl_readRegB, data_writeReg, ctrl_writeReg, ctrl_writeEnable, address_dmem, data, wren, isBranch, branch_value, alu_out);
        
      //$monitor("clock: %d, pc: %d, a_dx: %d, o_xm: %b, isI_x: %d, signextend: %b, alu_input_2: %b", clock, pc, a_dx, o_xm, isI_x, signextend, alu_input_2);
		  
		  //$monitor("pc: %d, b_out_regfile: %d, sel2_mx: %d, o_xm: %d, b_xm: %d, d_mw: %d, MX1: %d, WX1: %d, MX2: %d, WX2: %d", pc, b_out_regfile, sel2_mx, o_xm, b_xm, d_mw, MX1, WX1, MX2, WX2);
		  
		  #(20*(CYCLE_LIMIT+1.5))

        $stop;
    end
	 
	 always
		#1000 move1 = 3;

    // Clock generator
    always
         #10     clock = ~clock;
endmodule