module snake (rboard, clock, reset,
	rsnake1, rsnake2,
	rhead1, rhead2,
	rlength1, rlength2,
	rscore1, rscore2,
	rstage,
	move1, move2,
	isDrawing);

input clock, reset;
	
// 1600 integers
output reg [51199:0] rboard;
// 200 integers
output reg [6399:0] rsnake1, rsnake2;
output reg [31:0] rhead1, rhead2;
output reg [31:0] rlength1, rlength2;
output reg [31:0] rscore1, rscore2;
output reg [31:0] rstage;
output reg isDrawing;

 integer board[1600:0];
 integer snake1[200:0], snake2[200:0];
 integer head1, head2;
 integer length1, length2;
 integer score1, score2;
 integer stage;


input [31:0] move1, move2;
integer tail1, tail2;
reg isCollide1;

integer delayCounter;
integer initialCounter;

integer i;

initial begin
	score1 = 32'b0;
	score2 = 32'b0;
	isDrawing = 1'b0;
	
	for (i=0; i<=1600; i=i+1) begin
		board[i] = 1'b0;
	end
	for (i=0; i<=200; i=i+1) begin
		snake1[i] = 0;
		snake2[i] = 0;
	end
	
	stage = 2;
	isCollide1 = 1'b0;
	delayCounter = 0;
	
	length1 = 5;
	length2 = 5;
	head1 = 195;
	head2 = 0;
	board[1600-(40*10+10)] = 1;
	board[1600-(40*10+9)] = 1;
	board[1600-(40*10+8)] = 1;
	board[1600-(40*10+7)] = 1;
	board[1600-(40*10+6)] = 1;
	
	snake1[195] = 40*10+10;
	snake1[196] = 40*10+9;
	snake1[197] = 40*10+8;
	snake1[198] = 40*10+7;
	snake1[199] = 40*10+6;
end

always@(posedge clock)
begin
	stage = 2;
	/*board[1600-(40*10+10)] = 1;
	board[1600-(40*10+9)] = 1;
	board[1600-(40*10+8)] = 1;
	board[1600-(40*10+7)] = 1;
	board[1600-(40*10+6)] = 1;*/

	if (delayCounter == 0) begin
		/*if (stage == 2) begin
			tail1 = head1 + length1 - 1;
			if (tail1 >= 200) begin
				tail1 = (tail1 - 199) - 1;
			end
			
			if (head1 == 0) begin
				head1 = 199;
			end
			else begin
				head1 = head1 -1;
			end
			
			// update tail in board
			board[snake1[tail1]] = 0;


			if (move1 == 32'd1) begin
				snake1[head1] = snake1[head1] - 40;
				if (snake1[head1] < 0) begin 
					isCollide1 = 1'b1;
				end
			end
			else if (move1 == 32'd2) begin
				snake1[head1] = snake1[head1] + 1;
				if (snake1[head1] % 40 == 0) begin 
					isCollide1 = 1'b1;
				end
			end
			else if (move1 == 32'd3) begin
				snake1[head1] = snake1[head1] + 40;
				if (snake1[head1] >= 1600) begin 
					isCollide1 = 1'b1;
				end
			end

			else if (move1 == 32'd4) begin
				snake1[head1] = snake1[head1] -1;
				if (snake1[head1] % 40 == 39) begin 
					isCollide1 = 1'b1;
				end
			end

			// check collisions
			// currently checks if hits itself or hits the other snake
			if (snake1[head1] == 1 || snake1[head1] == 1) begin
				isCollide1 = 1'b1;
			end
			
			// update head in board
			board[snake1[head1]] = 1;
			
			if (isCollide1==1'b1) begin
				//stage = 3;
			end
			
		end
		else if (stage == 3) begin
			if (reset==1'b1) begin
				stage = 2;
			end
		end
		*/
	end
	
	
	
	// store the integer arrays into reg
	
	for (i=0; i<1600; i=i+1) begin
		rboard[32*(i+1)-1 -:32] = board[i];
	end
	for (i=0; i<200; i=i+1) begin
		rsnake1[32*(i+1)-1 -:32] = snake1[i];
		rsnake2[32*(i+1)-1 -:32] = snake2[i];
	end
	rhead1 = head1;
	rhead2 = head2;
	rlength1 = length1;
	rlength2 = length2;
	rscore1 = score1;
	rscore2 = score2;
	for (i=0; i<32; i=i+1) begin
		rstage[i] = stage[i];
	end
	
	
	
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