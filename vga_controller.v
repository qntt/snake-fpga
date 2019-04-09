module vga_controller(iRST_n,
                      iVGA_CLK,
                      oBLANK_n,
                      oHS,
                      oVS,
                      b_data,
                      g_data,
                      r_data,
							 //board, 
							 //snake1, snake2, 
							 //head1, head2,
							 //length1, length2,
							 //score1, score2,
							 stage, 
							 isDrawing);

	
input iRST_n;
input iVGA_CLK;
output reg oBLANK_n;
output reg oHS;
output reg oVS;
output [7:0] b_data;
output [7:0] g_data;  
output [7:0] r_data;     



//input [1600:0] board;
//input [200:0] snake1, snake2;
//input [31:0] head1, head2;
//input [31:0] length1, length2;
//input [31:0] score1, score2;
input [31:0] stage;
input isDrawing;

                   
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

integer pixelWidth;

integer addressRow, addressCol;
integer boardPosition;
integer boardValue;
integer boardRow, boardCol;

reg [7:0] color_index;

initial begin
	pixelWidth = 12;
end



// process snake's movement
always@(posedge iVGA_CLK)
begin
	
	if (isDrawing == 1'b1) begin
		//color_index = 8'd2;
		if (stage == 32'd2) begin
			color_index = 8'd1;
			/*
			addressRow = ADDR / 640;
			addressCol = ADDR % 640; 
			 
			// check if ADDR is in the game screen (40x40 board)
			if (addressCol < 480) begin
				boardRow = addressRow/pixelWidth;
				boardCol = addressCol/pixelWidth;
				boardPosition = 40*boardRow + boardCol;
				
				boardValue = board[1600-boardPosition-: 32];
				
				// snake 1 is value 1
				// snake 2 is value 2
				// apple is value 3
					
				case({boardValue})
					31'd1: color_index = 8'd1;
					31'd2: color_index = 8'd2;
					default: color_index = 8'd4;
				endcase
				
			end

			// draw boundaries of board
			else if (addressCol == 480) begin
				color_index = 8'd0;
			end
			else begin
				color_index = 8'd4;
			end
			*/
		end
		else if (stage == 32'd3) begin 
			color_index = 8'd2;
		end
		
	end
	else begin
		color_index = 8'd3;
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
 	















