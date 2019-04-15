module vga_controller(iRST_n,
                      iVGA_CLK,
                      oBLANK_n,
                      oHS,
                      oVS,
                      b_data,
                      g_data,
                      r_data, up, down, left, right,
							 snake_data);
							 //board, 
							 //snake1, snake2, 
							 //head1, head2,
							 //length1, length2,
							 //score1, score2,
							 //stage, 
							 //isDrawing);

	
input iRST_n;
input iVGA_CLK;
input up, down, left, right;
output reg oBLANK_n;
output reg oHS;
output reg oVS;
output [7:0] b_data;
output [7:0] g_data;  
output [7:0] r_data;     

input [359 : 0] snake_data;

integer counter;



//input [1600:0] board;
//input [200:0] snake1, snake2;
//input [31:0] head1, head2;
//input [31:0] length1, length2;
//input [31:0] score1, score2;
                   
///////// ////                     
reg [18:0] ADDR;
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
  else if (cBLANK_n==1'b1) begin
     ADDR<=ADDR+1;
	end
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

integer pixelWidth;

integer addressRow, addressCol;
integer boardPosition;
integer boardValue;
integer boardRow, boardCol;

reg [31:0] isDrawing;
integer delayCounter;
integer initialCounter;

 //integer board[1600:0];
 //integer snake1[49:0], snake2[49:0];
 integer head1, head2;
 integer length1, length2;
 integer score1, score2;
 reg [31:0] stage;
 integer oldHead1, oldHead2;
 
 integer move1;

integer tail1, tail2;
integer isCollide1; 

integer applePosition;
 
reg [7:0] color_index;

integer i;

initial begin
	pixelWidth = 12;
	delayCounter = 0;
	initialCounter = 0;
	move1 = 2;
	
	applePosition = 40*10+25;
	
	score1 = 0;
	score2 = 0;
	isDrawing = 32'd0;
	
	stage = 2;
	isCollide1 = 0;
	
	counter = 0;
	
//	length1 = 10;
//	length2 = 5;
//	head1 = 40;
//	head2 = 0;
	/*
	for (i=0; i<=49; i=i+1) begin
		snake1[i] = 0;
		snake2[i] = 0;
	end
	
	snake1[40] = 40*10+15;
	snake1[41] = 40*10+14;
	snake1[42] = 40*10+13;
	snake1[43] = 40*10+12;
	snake1[44] = 40*10+11;
	snake1[45] = 40*10+10;
	snake1[46] = 40*10+9;
	snake1[47] = 40*10+8;
	snake1[48] = 40*10+7;
	snake1[49] = 40*10+6;
	*/
	
end

integer j;
integer position1;
reg isInImage;

integer rowSnake1, colSnake1, snakePosition1;

integer head1position, head2position;
integer currPosition;
reg [1:0] currDirection;

// process snake's movement
always@(posedge iVGA_CLK)
begin

	// TODO: uncomment the following line
	//stage = snake_data[(1824-1600+1)*32-1 -:32];
	//stage = 2;
	
	
	// 1. get the stage
	stage = snake_data[359:328];
	
	// 2. get the position of head and length
	head1position = snake_data[231:200];
	length1 = snake_data[295:264];
	head2position = snake_data[263:232];
	length2 = snake_data[327:296];
	
	// 3. loop through all directions to see if the current body part has a color
	
	

	if (stage == 32'd2) begin
			addressRow = ADDR / 640;
			addressCol = ADDR % 640; 
			 
			// check if ADDR is in the game screen (40x40 board)
			if (addressCol < 480) begin
				boardRow = addressRow/pixelWidth;
				boardCol = addressCol/pixelWidth;
				boardPosition = 40*boardRow + boardCol;
				
				isInImage = 1'b0;
				
				currPosition = head1position;
				
				if (currPosition == boardPosition) begin
					color_index = 8'd1;
					isInImage = 1'b1;
				end
				currDirection = snake_data[1:0];
				
				
				for (j=1; j<50; j=j+1) begin
					if (j <= length1) begin 
					
						if (currDirection == 2'b00) begin
							currPosition = currPosition - 40;
						end
						else if (currDirection == 2'b01) begin
							currPosition = currPosition + 1;
						end
						else if (currDirection == 2'b10) begin
							currPosition = currPosition + 40;
						end
						else if (currDirection == 2'b11) begin
							currPosition = currPosition - 1;
						end
					
						currDirection = snake_data[2*j+1 -: 2];
					
						
						if (currPosition == boardPosition) begin
							color_index = 8'd1;
							isInImage = 1'b1;
						end
					end
				end
				
				if (boardPosition == applePosition) begin
					color_index = 8'd3;
					isInImage = 1'b1;
				end
				if (isInImage == 1'b0) begin
					color_index = 8'd4;
				end
				
				// TODO: display snake 2's positions
				
				
			end

			// draw boundaries of board
			if (addressCol == 480) begin
				color_index = 8'd0;
			end
//			else begin
//				color_index = 8'd4;
//			end
			
		end
		if (stage == 32'd3) begin 
			color_index = 8'd2;
		end
//		else begin
//			color_index = 8'd4;
//		end



	
	
	
	if (up==1'b0 && move1 != 3) begin
		move1 = 1;
	end
	else if (right==1'b0 && move1 != 4) begin
		move1 = 2;
	end
	else if (down==1'b0 && move1 != 1) begin
		move1 = 3;
	end
	else if (left==1'b0 && move1 != 2) begin
		move1 = 4;
	end

end



	
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
 	















