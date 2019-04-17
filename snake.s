# s0: stage number
# s1: snake 1 head pointer
# s2: snake 2 head pointer
# s5: direction player 1
# s6: direction player 2

# TODO: set stage 3 when collide1 is true

addi $s0, $0, 1

loop:
  addi $t0, $0, 1
  bne $s0, $t0, endstage1       # Check the value of stage
  stage1:
    jal init

  endstage1:
    addi $t0, $0, 2
    bne $s0, $t0, endloop

  stage2:
    jal renderSnake

  #### BEGIN DRAWING ON VGA
  # save head positions
  lw $t1, 2000($s1)
  lw $t2, 2050($s2)
  sw $t1, 100($0)
  sw $t2, 101($0)

  # save length
  lw $t0, 1822($0)
  lw $t1, 1823($0)
  sw $t0, 102($0)
  sw $t1, 103($0)

  # save stage
  sw $s0, 104($0)

  # save head pointers
  sw $s1, 105($0)
  sw $s2, 106($0)

  jal displaySnake

  # delay by 5M cycles
  addi $t0, $0, 5000
  addi $t1, $0, 500
  mul $t1, $t0, $t1
  add $a0, $0, $t1
  jal delay

  endloop:
    j loop

init:
  # define apple locations (10,25)
  addi $t1, $0, 425
  sw $t1, 1800($0)
  
  # initial values of snake is (20,20), (20,21), (20,22)
                    # define the initial head of the snakes
  addi $s1, $0, 0           # pointer of snake 1 is 0th position in array
  addi $t0, $0, 20
  # Define the first 3 nodes of snake 1
  sw $t0, 1602($0)
  sw $t0, 1652($0)
  
  addi $t1, $0, 21
  sw $t0, 1601($0)
  sw $t1, 1651($0)

  addi $t1, $0, 22
  sw $t0, 1600($0)
  sw $t1, 1650($0)

  # initialize the board
  addi $t0, $0, 1
  sw $t0, 822($0)
  sw $t0, 821($0)
  sw $t0, 820($0)

  # initialize the board position of snake parts
  addi $t0, $0, 820
  sw $t0, 2002($0)
  addi $t0, $0, 821
  sw $t0, 2001($0)
  addi $t0, $0, 822
  sw $t0, 2000($0)

  # initialize direction of each snake part
  addi $t0, $0, 3
  sw $t0, 0($0)
  sw $t0, 1($0)
  sw $t0, 2($0)

  addi $t2, $0, 3         # store length of snake1
  sw $t2, 1822($0)

  # define initial direction of snakes
  addi $s5, $0, 2
  addi $s6, $0, 2

  # reset the score
  addi $t2, $0, 1820
  sw $0, 0($t2)
  sw $0, 1($t2)

  # set stage to 2
  addi $s0, $0, 2

  jr $ra


renderSnake:
  # length of snake 1 (t1)
  lw $t1, 1822($0)
  # tail of snake 1 (t2) 
  add $t2, $s1, $t1             # tail1 = head1 + length1
  addi $t0, $0, 1
  sub $t2, $t2, $t0             # tail1 = tail1 - 1
  
  # tail may wrap over array (update if tail1 >= 50) (t2)
  addi $t0, $0, 49
  blt $t2, $t0, skipUpdateTail1
  addi $t0, $0, 50
  sub $t2, $t2, $t0             # tail1 = tail1 - 50

  skipUpdateTail1:

  # store old value of head pointer (t3)
  add $t3, $0, $s1

  bne $s1, $0, head1NotZero         # if (head1==0) head1 = 49;
  addi $s1, $0, 49
  j afterUpdateHead1

  head1NotZero:                 # else head1 = head1 - 1;
  addi $t0, $0, 1
  sub $s1, $s1, $t0

  afterUpdateHead1:

  # change board at tail position
  lw $t4, 2000($t2)   # board position of snake1
  sw $0, 2100($t4)     # board[snake1[tail1]] = 0;


  # move1 == 1?
  addi $t0, $0, 1
  bne $s5, $t0, notMoveUp
  # load snake1[oldHead1] ROW (t0)
  lw $t0, 1600($t3)
  # load snake1[oldHead1] COL (t1)
  lw $t1, 1650($t3)
  # snake1[head1] = snake1[oldHead1] + deltaChange;
  # deltaChange = (-1, 0)
  addi $t2, $0, 1
  sub $t4, $t0, $t2                 # row = row - 1
  sw $t4, 1600($s1)

  # board position changes by -40
  addi $t5, $0, 40
  lw $t6, 2000($t3)
  sub $t7, $t6, $t5
  sw $t7, 2000($s1)

  # direction[head1] = 2
  addi $t0, $0, 2
  sw $t0, 0($s1)

  # check collision with wall
  blt $t4, $0, collisionUpTrue1
  j notMoveUp

  collisionUpTrue1:
  addi $s7, $0, 1

  notMoveUp:

  # move1 == 2?
  addi $t0, $0, 2
  bne $s5, $t0, notMoveRight
  # load snake1[oldHead1] ROW (t0)
  lw $t0, 1600($t3)
  # load snake1[oldHead1] COL (t1)
  lw $t1, 1650($t3)
  # snake1[head1] = snake1[oldHead1] + deltaChange;
  # deltaChange = (0, 1)
  addi $t2, $0, 1
  add $t4, $t1, $t2                 # col = col + 1
  sw $t4, 1650($s1)

  # board position changes by 1
  addi $t5, $0, 1
  lw $t6, 2000($t3)
  add $t7, $t6, $t5
  sw $t7, 2000($s1)

  # direction[head1] = 3
  addi $t0, $0, 3
  sw $t0, 0($s1)

  # check collision with wall
  addi $t0, $0, 39
  blt $t0, $t4, collisionRightTrue1     # if (col > 39)
  j notMoveRight

  collisionRightTrue1:
  addi $s7, $0, 1
  
  notMoveRight:

  # move1 == 3?
  addi $t0, $0, 3
  bne $s5, $t0, notMoveDown
  # load snake1[oldHead1] ROW (t0)
  lw $t0, 1600($t3)
  # load snake1[oldHead1] COL (t1)
  lw $t1, 1650($t3)
  # snake1[head1] = snake1[oldHead1] + deltaChange;
  # deltaChange = (1, 0)
  addi $t2, $0, 1
  add $t4, $t0, $t2                 # row = row + 1
  sw $t4, 1600($s1)

  # board position changes by +40
  addi $t5, $0, 40
  lw $t6, 2000($t3)
  add $t7, $t6, $t5
  sw $t7, 2000($s1)

  # direction[head1] = 0
  addi $t0, $0, 0
  sw $t0, 0($s1)

  # check collision with wall
  addi $t0, $0, 39
  blt $t0, $t4, collisionDownTrue1      # if (row > 39)
  j notMoveDown

  collisionDownTrue1:
  addi $s7, $0, 1

  notMoveDown:

  # move1 == 4?
  addi $t0, $0, 4
  bne $s5, $t0, notMoveLeft
  # load snake1[oldHead1] ROW (t0)
  lw $t0, 1600($t3)
  # load snake1[oldHead1] COL (t1)
  lw $t1, 1650($t3)
  # snake1[head1] = snake1[oldHead1] + deltaChange;
  # deltaChange = (0, -1)
  addi $t2, $0, 1
  sub $t4, $t1, $t2                 # col = col - 1
  sw $t4, 1650($s1)

  # board position changes by -1
  addi $t5, $0, 1
  lw $t6, 2000($t3)
  sub $t7, $t6, $t5
  sw $t7, 2000($s1)

  # direction[head1] = 1
  addi $t0, $0, 1
  sw $t0, 0($s1)

  # check collision with wall
  blt $t4, $0, collisionDownTrue1       # if (col < 0)
  j notMoveLeft

  collisionLeftTrue1:
  addi $s7, $0, 1

  notMoveLeft:

  # change board at head position for snake 1
  addi $t5, $0, 1
  lw $t4, 2000($s1)   # board position of snake1
  sw $t5, 2100($t4)    # board[snake1[head1]] = 1;


  # check if snake eats apple
  #    if (snake1[head1] == applePosition) begin
  #      length1 = length1 + 1;
  #    end
  lw $t0, 2000($s1)     # snake1[head1]
  lw $t1, 1800($0)      # apple position
  bne $t0, $t1, noEatApple
  lw $t1, 1822($0)      # length of snake 1 (t1)
  addi $t1, $t1, 1
  sw $t1, 1822($0)

  noEatApple:

  # handles collision
    #       if (isCollide1==1) begin
    #           stage = 3;
    #           isCollide1 = 0;
    #       end
    addi $t0, $0, 1
    bne $s7, $t0, noCollision
    addi $s0, $0, 3
    addi $s7, $0, 0

    noCollision:

  jr $ra


# delay by $a0 cycles
delay:
  addi $t0, $0, 1
  delayloop1:
    addi $t0, $t0, 1
    bne $t0, $a0, delayloop1
  jr $ra


displaySnake:
  addi $t0, $0, 0
  addi $t1, $0, 107

  displayLoop:
  
  blt $t1, $t0, returnToLoop
    add $0, $0, $0    # loadSnake $t0
    addi $t0, $t0, 1
  j displayLoop
  
  returnToLoop:
  jr $ra
