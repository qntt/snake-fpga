# s0: stage number
# s1: pointer head of snake 1
# s2: pointer head of snake 2
# s5: direction player 1
# s6: direction player 2

loop:
  addi $t0, $0, 1
  bne $s0, $t0, endstage1
  stage1:
    jal init
    #jal drawStartScreen

  endstage1:
    addi $t0, $0, 2
    bne $s0, $t0, endloop

  stage2:
    #jal drawGameBackground
    jal renderSnake

  endloop:
    j loop


init:
  addi $t0, $0, 2000
  # define apple locations
  addi $t1, $0, 10
  addi $t2, $0, 10
  sw $t1, 0($t0)
  sw $t1, 1($t0)

  addi $t1, $0, 30
  addi $t2, $0, 20
  sw $t1, 2($t0)
  sw $t1, 3($t0) 

  addi $t1, $0, 20
  addi $t2, $0, 5
  sw $t1, 4($t0)
  sw $t1, 5($t0) 

  # define the initial head of the snakes
  addi $s1, $0, 10
  addi $s2, $0, 10
  addi $s3, $0, 30
  addi $s4, $0, 10

  # define initial direction of snakes
  addi $s5, $0, 2
  addi $s6, $0, 2

  # reset the score
  addi $t2, $0, 2400
  sw $0, 0($t2)
  sw $0, 1($t2)

  # set stage to 1
  addi $s0, $0, 1

  jr $ra


renderSnake:
  # length of snake 1 (t1)
  addi $t0, $0, 2402
  lw $t1, 0($t0)
  # tail of snake 1 (t2) 
  add $t2, $s1, $t1
  # lower address of snake 1's body (t3)
  # upper address of snake 1's body (t4)
  addi $t3, $0, 2000
  addi $t4, $0, 2199
  # update tail if tail > upper address
  blt $t2, $t4, skipUpdateTail1
  sub $t2, $t2, $t4
  add $t2, $t2, $t3
  addi $t2, $t2, -1

  skipUpdateTail1:
    # snake moves by 1 square
    # get current position of head (t1)
    lw $t1, 0($s1)
    # head = head-1 (s1)
    addi $s1, $s1, -1
    # get position of snake1 head (t5)
    lw $t5, 0($s1)

  # possible movement directions = up (t6)
  addi $t6, $0, 1
  # move up?
  bne $s5, $t6, checkMoveRight
  # store new position of head (t7)
  addi $t7, $t1, -40
  sw $t7, 0($s1)

  checkMoveRight:
    # possible movement directions = right (t6)
    addi $t6, $0, 2
    # move right?
    bne $s5, $t6, checkMoveDown
    # store new position of head (t7)
    addi $t7, $t1, 1
    sw $t7, 0($s1)

  checkMoveDown:
    # possible movement directions = down (t6)
    addi $t6, $0, 3
    # move down?
    bne $s5, $t6, checkMoveLeft
    # store new position of head (t7)
    addi $t7, $t1, 40
    sw $t7, 0($s1)

  checkMoveLeft:
    # possible movement directions = left (t6)
    addi $t6, $0, 4
    # move left?
    bne $s5, $t6, endMoveSnake
    # store new position of head (t7)
    addi $t7, $t1, -1
    sw $t7, 0($s1)

  endMoveSnake:


  jr $ra

isOutOfBoundsLeftRight:
  div $t0, $a0, $a1
  mul $t1, $t0, $a1
  bne $t0, $t1, modNotEqual
  addi $v0, $0, 1
  jr $ra

  modNotEqual:
    addi $v0, $0, 0
    jr $ra

# delay by $a0 cycles
delay:
  addi $t0, $0, 1
  delayloop1:
    addi $t0, $t0, 1
    bne $t0, $a0, delayloop1
  jr $ra
