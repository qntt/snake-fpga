DEPTH = 4096;
WIDTH = 32;
ADDRESS_RADIX = DEC;
DATA_RADIX = BIN;
CONTENT
BEGIN
0000 : 00101100000000000000000000000001; -- addi $s0, $0, 1

0001 : 00101010000000000000000000000001; --   addi $t0, $0, 1

0002 : 00010100000100000000000000000001; --   bne $s0, $t0, endstage1       # Check the value of stage

0003 : 00011000000000000000000000010001; --     jal init

0004 : 00101010000000000000000000000010; --     addi $t0, $0, 2

0005 : 00010100000100000000000000001010; --     bne $s0, $t0, endloop

0006 : 00011000000000000000000000101001; --     jal renderSnake

0007 : 00111100000000000000011100100000; --   sw $s0, 1824($0)

0008 : 00111100010000000000011100100001; --   sw $s1, 1825($0)

0009 : 00111100100000000000011100100010; --   sw $s2, 1826($0)

0010 : 00011000000000000000000001100101; --   jal displaySnake

0011 : 00101010000000000001001110001000; --   addi $t0, $0, 5000

0012 : 00101010010000000000001111101000; --   addi $t1, $0, 1000

0013 : 00000010010100001001000000011000; --   mul $t1, $t0, $t1

0014 : 00101001000000000000000000001001; --   addi $a0, $0, $t1

0015 : 00011000000000000000000001100001; --   jal delay

0016 : 00001000000000000000000000000001; --     j loop

0017 : 00101010000000000000011100001000; --   addi $t0, $0, 1800

0018 : 00101010010000000000000000001010; --   addi $t1, $0, 10

0019 : 00101010100000000000000000001010; --   addi $t2, $0, 10

0020 : 00111010010100000000000000000000; --   sw $t1, 0($t0)

0021 : 00111010100100000000000000001010; --   sw $t2, 10($t0)

0022 : 00101100010000000000000000000000; --   addi $s1, $0, 0           # pointer of snake 1 is 0th position in array

0023 : 00101010000000000000000000010100; --   addi $t0, $0, 20

0024 : 00111010000000000000011001000000; --   sw $t0, 1600($0)

0025 : 00111010000000000000011001110010; --   sw $t0, 1650($0)

0026 : 00101010010000000000000000010101; --   addi $t1, $0, 21

0027 : 00111010000000000000011001000001; --   sw $t0, 1601($0)

0028 : 00111010010000000000011001110011; --   sw $t1, 1651($0)

0029 : 00101010010000000000000000010110; --   addi $t1, $0, 22

0030 : 00111010000000000000011001000010; --   sw $t0, 1602($0)

0031 : 00111010010000000000011001110100; --   sw $t1, 1652($0)

0032 : 00101010100000000000000000000011; --   addi $t2, $0, 3         # store length of snake1

0033 : 00111010100000000000011100011110; --   sw $t2, 1822($0)

0034 : 00101101010000000000000000000010; --   addi $s5, $0, 2

0035 : 00101101100000000000000000000010; --   addi $s6, $0, 2

0036 : 00101010100000000000011100011100; --   addi $t2, $0, 1820

0037 : 00111000000101000000000000000000; --   sw $0, 0($t2)

0038 : 00111000000101000000000000000001; --   sw $0, 1($t2)

0039 : 00101100000000000000000000000010; --   addi $s0, $0, 2

0040 : 00100111110000000000000000000000; --   jr $ra

0041 : 01000010010000000000011100011110; --   lw $t1, 1822($0)

0042 : 00000010101000101001000000000000; --   add $t2, $s1, $t1             # tail1 = head1 + length1

0043 : 00101010000000000000000000000001; --   addi $t0, $0, 1

0044 : 00000010100101001000000000000100; --   sub $t2, $t2, $t0             # tail1 = tail1 - 1

0045 : 00101010000000000000000000110010; --   addi $t0, $0, 50

0046 : 00110010100100000000000000000001; --   blt $t2, $t0, skipUpdateTail1

0047 : 00000010100101001000000000000100; --   sub $t2, $t2, $t0             # tail1 = tail1 - 50

0048 : 00000010110000010001000000000000; --   add $t3, $0, $s1

0049 : 00010100010000000000000000000010; --   bne $s1, $0, head1NotZero         # if (head1==0) head1 = 49;

0050 : 00101100010000000000000000110001; --   addi $s1, $0, 49

0051 : 00001000000000000000000000110110; --   j afterUpdateHead1

0052 : 00101010000000000000000000000001; --   addi $t0, $0, 1

0053 : 00000100011000101000000000000100; --   sub $s1, $s1, $t0

0054 : 00101010000000000000000000000001; --   addi $t0, $0, 1

0055 : 00010101010100000000000000001000; --   bne $s5, $t0, notMoveUp

0056 : 01000010000101100000011001000000; --   lw $t0, 1600($t3)

0057 : 01000010010101100000011001110010; --   lw $t1, 1650($t3)

0058 : 00101010100000000000000000000001; --   addi $t2, $0, 1

0059 : 00000011000100001010000000000100; --   sub $t4, $t0, $t2                 # row = row - 1

0060 : 00111011001000100000011001000000; --   sw $t4, 1600($s1)

0061 : 00110011000000000000000000000001; --   blt $t4, $0, collisionUpTrue1

0062 : 00001000000000000000000001000000; --   j notMoveUp

0063 : 00101101110000000000000000000001; --   addi $s7, $0, 1

0064 : 00101010000000000000000000000010; --   addi $t0, $0, 2

0065 : 00010101010100000000000000001001; --   bne $s5, $t0, notMoveRight

0066 : 01000010000101100000011001000000; --   lw $t0, 1600($t3)

0067 : 01000010010101100000011001110010; --   lw $t1, 1650($t3)

0068 : 00101010100000000000000000000001; --   addi $t2, $0, 1

0069 : 00000011000100101010000000000000; --   add $t4, $t1, $t2                 # col = col + 1

0070 : 00111011001000100000011001110010; --   sw $t4, 1650($s1)

0071 : 00101010000000000000000000100111; --   addi $t0, $0, 39

0072 : 00110010000110000000000000000001; --   blt $t0, $t4, collisionRightTrue1     # if (col > 39)

0073 : 00001000000000000000000001001011; --   j notMoveRight

0074 : 00101101110000000000000000000001; --   addi $s7, $0, 1

0075 : 00101010000000000000000000000011; --   addi $t0, $0, 3

0076 : 00010101010100000000000000001001; --   bne $s5, $t0, notMoveDown

0077 : 01000010000101100000011001000000; --   lw $t0, 1600($t3)

0078 : 01000010010101100000011001110010; --   lw $t1, 1650($t3)

0079 : 00101010100000000000000000000001; --   addi $t2, $0, 1

0080 : 00000011000100001010000000000000; --   add $t4, $t0, $t2                 # row = row + 1

0081 : 00111011001000100000011001000000; --   sw $t4, 1600($s1)

0082 : 00101010000000000000000000100111; --   addi $t0, $0, 39

0083 : 00110010000110000000000000000001; --   blt $t0, $t4, collisionDownTrue1      # if (row > 39)

0084 : 00001000000000000000000001010110; --   j notMoveDown

0085 : 00101101110000000000000000000001; --   addi $s7, $0, 1

0086 : 00101010000000000000000000000100; --   addi $t0, $0, 4

0087 : 00010101010100000000000000001000; --   bne $s5, $t0, notMoveLeft

0088 : 01000010000101100000011001000000; --   lw $t0, 1600($t3)

0089 : 01000010010101100000011001110010; --   lw $t1, 1650($t3)

0090 : 00101010100000000000000000000001; --   addi $t2, $0, 1

0091 : 00000011000100101010000000000100; --   sub $t4, $t1, $t2                 # col = col - 1

0092 : 00111011001000100000011001110010; --   sw $t4, 1650($s1)

0093 : 00110011000000011111111111110111; --   blt $t4, $0, collisionDownTrue1       # if (col < 0)

0094 : 00001000000000000000000001100000; --   j notMoveLeft

0095 : 00101101110000000000000000000001; --   addi $s7, $0, 1

0096 : 00100111110000000000000000000000; --   jr $ra

0097 : 00101010000000000000000000000001; --   addi $t0, $0, 1

0098 : 00101010000100000000000000000001; --     addi $t0, $t0, 1

0099 : 00010010000010011111111111111110; --     bne $t0, $a0, delayloop1

0100 : 00100111110000000000000000000000; --   jr $ra

0101 : 00101010000000000000011001000000; --   addi $t0, $0, 1600

0102 : 00101010010000000000011100111001; --   addi $t1, $0, 1849

0103 : 00110010010100000000000000000001; --   blt $t1, $t0, returnToLoop

0104 : 01111000000100000000000000000000; --   loadSnake $t0

0105 : 00101010000100000000000000000001; --     addi $t0, $t0, 1

0106 : 00100111110000000000000000000000; --   jr $ra

[0107..4095] : 00000000000000000000000000000000;
END;
