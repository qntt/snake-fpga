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


input [487 : 0] snake_data;							
							
input iRST_n;
input iVGA_CLK;
input up, down, left, right;
output reg oBLANK_n;
output reg oHS;
output reg oVS;
output [7:0] b_data;
output [7:0] g_data;  
output [7:0] r_data;     


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
integer boardRow, boardCol;

 integer head1, head2;
 integer length1, length2;
 integer stage;
 
 integer move1;

integer applePosition;
 
reg [7:0] color_index;


initial begin
	pixelWidth = 12;
	move1 = 2;
	
	applePosition = 40*10+25;
	
end

integer j;
reg isInImage;

integer head1position, head2position;
integer currPosition;
reg [1:0] currDirection;

integer heartsTimer;

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
	head1 = snake_data[391:360];
	head2 = snake_data[423:392];
	
	heartsTimer = snake_data[487:456];
	
	// 3. loop through all directions to see if the current body part has a color
	
	if (stage== 32'd0) begin
		color_index = 8'd2;
	end
	
	
	if (stage == 32'd2) begin
		//color_index = 8'd1;
	
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
				currDirection = snake_data[2*(head1)+1 -:2];
				
				
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
					
						currDirection = snake_data[2*(head1+j)+1 -: 2];
					
						
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
			else if (addressCol == 480) begin
				color_index = 8'd0;
			end
			// area for drawing hearts timer
			else if (addressRow > 60 && addressRow < 80 && addressCol > 520 && addressCol < 600) begin
				if (addressCol*100 < (600-520)*heartsTimer + 520*100) begin
					color_index = 8'd3;
				end
				else begin
					color_index = 8'd4;
				end
			end
			else begin
				color_index = 8'd4;
			end
		
			
	end
	if (stage == 32'd3) begin 
		color_index = 8'd3;
	end
//		else begin
//			color_index = 8'd4;
//		end



	
	
	


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
 	















