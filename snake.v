module snake (board, clock, reset,
	snake1, snake2,
	head1, head2,
	length1, length2,
	score1, score2,
	stage,
	move1, move2,
	isDrawing);

input clock, reset;
	
output integer board[1600:0];
output integer snake1[200:0], snake2[200:0];
output integer head1, head2;
output integer length1, length2;
output integer score1, score2;
output integer stage;
output reg isDrawing;

input [31:0] move1, move2;
integer tail1, tail2;
reg isCollide1;

integer delayCounter;

integer i;

initial begin
	move1 = 2;
	score1 = 0;
	score2 = 0;
	
	for (i=0; i<=1600; i=i+1) begin
		board[i] = 1'b0;
	end
	for (i=0; i<=200; i=i+1) begin
		snake1[i] = 1'b0;
		snake2[i] = 1'b0;
	end
	
	stage = 2;
	isCollide = 1'b0;
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

	if (delayCounter == 0) begin
		if (stage == 2) begin
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
				stage = 3;
			end
			
		end
		else if (stage == 3) begin
			if (reset==1'b1) begin
				stage = 2;
			end
		end
	end
	
	// delay by 1M cycles after each frame
	if (delayCounter == 1000000) begin
		delayCounter = 0;
		isDrawing = 1'b0;
	end
	else begin
		delayCounter = delayCounter + 1;
		isDrawing = 1'b1;
	end
end

	
endmodule 