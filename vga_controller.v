module vga_controller(iRST_n,
                      iVGA_CLK,
                      oBLANK_n,
                      oHS,
                      oVS,
                      b_data,
                      g_data,
                      r_data,up,down,left,right,
							 addressRow, addressCol, ADDR, boardPosition);
							 //board);

	
input iRST_n;
input iVGA_CLK;
input up,down,left,right;
//input [64000:0] board;
reg [64000:0] board;
reg [63:0] board2;
output reg oBLANK_n;
output reg oHS;
output reg oVS;
output [7:0] b_data;
output [7:0] g_data;  
output [7:0] r_data;                        
///////// ////                     
output reg [18:0] ADDR;
reg [23:0] bgr_data;
wire VGA_CLK_n;
wire [7:0] index;
wire [23:0] bgr_data_raw;
wire cBLANK_n,cHS,cVS,rst;
////
assign rst = ~iRST_n;
video_sync_generator LTM_ins (.vga_clk(iVGA_CLK),
                              .reset(rst),
                              .blank_n(cBLANK_n),
                              .HS(cHS),
                              .VS(cVS));
////
////Addresss generator
always@(posedge iVGA_CLK,negedge iRST_n)
begin
  if (!iRST_n)
     ADDR<=19'd0;
  else if (cHS==1'b0 && cVS==1'b0)
     ADDR<=19'd0;
  else if (cBLANK_n==1'b1)
     ADDR<=ADDR+1;
end
//////////////////////////
//////INDEX addr.
assign VGA_CLK_n = ~iVGA_CLK;
img_data	img_data_inst (
	.address ( ADDR ),
	.clock ( VGA_CLK_n ),
	.q ( index )
	);
	
/////////////////////////
//////Add switch-input logic here

reg [31:0] pixelWidth;

/*reg [9:0] x_square,y_square;
wire [10:0] addressX,addressY;
//reg [8:0] y;
wire [18:0] address;
assign address = (y_square*10'd640) + x_square;
wire [6:0] width;
assign width = 7'd100;
assign addressX = ADDR % 640;
assign addressY = ADDR / 640;
reg [19:0] count;
*/

output reg [31:0] addressRow, addressCol;
//assign addressRow = ADDR / 640;
//assign addressCol = ADDR % 640; 
output reg [31:0] boardPosition;
reg [31:0] boardValue;
reg [31:0] boardRow;
reg [31:0] boardCol;

reg [7:0] index2;
reg [7:0] color_index;
reg isReadyToDraw;

reg [31:0] boardValue2;

initial begin
	/*x_square = 10'd100;
	y_square = 10'd100;
	count = 20'd0;*/
	
	pixelWidth = 32'd12;
	isReadyToDraw = 1'b1;
	
	
	board[64000-32*(40*10+10)-: 32] = 32'd1;
	board[64000-32*(40*11+10)-: 32] = 32'd1;
	board[64000-32*(40*12+10): 64000-32*(40*12+10)-31] = 32'd1;
	board[64000-32*(40*13+10): 64000-32*(40*13+10)-31] = 32'd1;
	board[64000-32*(40*14+10): 64000-32*(40*14+10)-31] = 32'd1;
	board[64000-32*(40*15+10): 64000-32*(40*15+10)-31] = 32'd1;
	
	board2[63:32] = 32'd1;
end



always@(posedge iVGA_CLK)
begin

	addressRow = ADDR / 640;
	addressCol = ADDR % 640; 
	 
	// check if ADDR is in the game screen (40x40 board)
	if (addressCol < 480) begin
		boardRow = addressRow/pixelWidth;
		boardCol = addressCol/pixelWidth;
		boardPosition = 40*boardRow + boardCol;
		//$display("addr: %d, row: %d, col: %d, boardPos: %d",
		//	ADDR, boardRow, boardCol, boardPosition);
		if (boardPosition == 32'd205) begin
			color_index = 8'd1;
		end
		else begin
			color_index = 8'd4;
		end
		//boardValue = board[64000-32*boardPosition -: 32];
		//boardValue = board[64000-32*boardPosition : 64000-32*boardPosition-31];
		boardValue [31:0] = board2[63:32];
		
		// snake 1 is value 1
		// snake 2 is value 2
		// apple is value 3
		if (boardValue === 32'd1) begin
			color_index = 8'd2;
		end
		else begin
			color_index = 8'd4;
		end
	end

	// draw boundaries of board
	else if (addressCol == 480) begin
		color_index = 8'd0;
	end
	else begin
		color_index = 8'd4;
	end
	
end

/*always@(posedge iVGA_CLK)
begin
	if (count < 20'd1000000) begin
		count = count + 20'd1;
	end 
	else if (count == 20'd1000000) begin
		count = 20'd0;
		if (~up) begin
			y_square = y_square - 10'd1;
		end else if (~down) begin
			y_square = y_square + 10'd1;
		end else if (~left) begin
			x_square = x_square - 10'd1;
		end else if (~right) begin
			x_square = x_square + 10'd1;
		end
	end
	
	if (addressX <= x_square + 10'd99 & addressX >= x_square & addressY <= y_square+10'd99 & addressY >= y_square) begin
		index2 = 8'd2;
	end
	else begin
		index2 = index[7:0];
	end
	
end
*/
	
//////Color table output
img_index	img_index_inst (
	.address ( color_index ),
	.clock ( iVGA_CLK ),
	.q ( bgr_data_raw)
	);	
//////
//////latch valid data at falling edge;
always@(posedge VGA_CLK_n) bgr_data <= bgr_data_raw;
assign r_data = bgr_data[23:16];
assign g_data = bgr_data[15:8];
assign b_data = bgr_data[7:0]; 
///////////////////
//////Delay the iHD, iVD,iDEN for one clock cycle;
always@(negedge iVGA_CLK)
begin
  oHS<=cHS;
  oVS<=cVS;
  oBLANK_n<=cBLANK_n;
end

endmodule
 	















