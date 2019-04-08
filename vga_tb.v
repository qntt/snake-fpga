`timescale 1 ns / 100 ps

module vga_tb();

	 integer CYCLE_LIMIT = 1000;
	 
    // inputs to the proc are reg type
    reg            clock, reset;

							 
	reg iRST_n;
reg iVGA_CLK;
reg up,down,left,right;
wire oBLANK_n;
wire oHS;
wire oVS;
wire [7:0] b_data;
wire [7:0] g_data;  
wire [7:0] r_data;                        
///////// ////                     
wire [18:0] ADDR;
wire [31:0] addressRow, addressCol, boardPosition;

    //skeleton dut (clock, reset);
	 
	 
	 vga_controller dut (iRST_n,
                      iVGA_CLK,
                      oBLANK_n,
                      oHS,
                      oVS,
                      b_data,
                      g_data,
                      r_data,up,down,left,right,
							 addressRow, addressCol, ADDR, boardPosition);
	 
	 /*
	 
	 // branch testing
	 wire [1:0] pc_branch_select = dut.my_processor.pc_branch_select;
	 wire isBranch = dut.my_processor.isBranch;
	 wire [31:0] branch_value = dut.my_processor.branch_value;
	 wire [31:0] alu_input_1 = dut.my_processor.alu_input_1;
	 wire [31:0] alu_input_2 = dut.my_processor.alu_input_2;
	 */
	 
	 
    initial
    begin
        $display($time, "<< Starting the Simulation >>");
        iVGA_CLK = 1'b0;    // at time 0
		  iRST_n = 1'b1;
		  
		  iRST_n = 1'b0;
			#20
			iRST_n = 1'b1;
		  
		  // processor output monitor
		  //$monitor("pc: %d, address_imem: %d, ctrl_readRegA: %d, ctrl_readRegB: %d, data_writeReg: %d, ctrl_writeReg: %d, ctrl_writeEnable: %d, address_dmem: %d, data: %d, wren: %d", 
		  //pc, address_imem, ctrl_readRegA, ctrl_readRegB, data_writeReg, ctrl_writeReg, ctrl_writeEnable, address_dmem, data, wren);
		  
		  $monitor("ADDR: %d, addressRow: %d, addressCol: %d, boardPosition: %d",
		  ADDR, addressRow, addressCol, boardPosition);
		  
		  #(20*(CYCLE_LIMIT+1.5))

        $stop;
    end

    // Clock generator
    always
         #10     iVGA_CLK = ~iVGA_CLK;
endmodule