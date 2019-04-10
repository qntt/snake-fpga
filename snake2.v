    
module snake2 (clock,
	rstage,
	isDrawing);

input clock;

output reg [31:0] rstage;
output reg isDrawing;

integer delayCounter;
integer initialCounter;

integer i;
integer stage;

initial begin
	isDrawing = 1'b0;
	
	delayCounter = 0;
end

always@(posedge clock)
begin
	stage = 2;
	
	// store the integer arrays into reg
	rstage = stage;


	
	// delay by 1M cycles after each frame
	if (delayCounter >= 1000000) begin
		delayCounter = 0;
		isDrawing = 1'b0;
	end
	else begin
		delayCounter = delayCounter + 1;
		isDrawing = 1'b1;
	end
end

	
endmodule 