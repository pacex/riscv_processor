# AUIPC
addi x30, x0, 0
auipc x28, 4
lui x29, 4
ori x29, x29, 4
xor x31, x28, x29

addi x30, x0, 1
auipc x28, 654
lui x29, 654
ori x29, x29, 24
xor x31, x28, x29

# JAL
addi x30, x0, 2
addi x28, x0, 666
jal x29, 8
addi x31, x0, 1
addi x28, x0, 1
xori x31, x29, 52
xori x31, x28, 1

# JALR
addi x30, x0, 3
addi x28, x0, 666
jal x20, 4
jalr x29, x20, 8
addi x28, x0, 1     #if all works well this line should be skipped
addi x27, x20, 4
xor x31, x29, x27   #check written return register
xori x31, x28, 666  #check if jump worked

# ADD
addi x30, x0, 4
lui x20, 1048575
ori x20, x20, -10
lui x21, 1048575
ori x21, x21, -10
add x29, x20, x21
lui x28, 1048575
ori x28, x28, -20
xor x31, x29, x28

addi x30, x0, 5
lui x20, 1048575
ori x20, x20, -10
lui x21, 1048575
ori x21, x21, -12
add x29, x20, x21
lui x28, 1048575
ori x28, x28, -22
xor x31, x29, x28

addi x30, x0, 6
lui x20, 1048575
ori x20, x20, -12
lui x21, 1048575
ori x21, x21, -10
add x29, x20, x21
lui x28, 1048575
ori x28, x28, -22
xor x31, x29, x28

addi x30, x0, 7
addi x20, x0, 5
lui x21, 1048575
ori x21, x21, -10
add x29, x20, x21
lui x28, 1048575
ori x28, x28, -5
xor x31, x29, x28

addi x30, x0, 8
lui x20, 1048575
ori x20, x20, -10
addi x21, x0, 10
add x29, x20, x21
xori x31, x29, 0

addi x30, x0, 9
addi x20, x0, 4
addi x21, x0, 10
add x29, x20, x21
xori x31, x29, 14

addi x30, x0, 10
addi x20, x0, 10
addi x21, x0, 4
add x29, x20, x21
xori x31, x29, 14

# SUB
addi x30, x0, 11
lui x20, 1048575
ori x20, x20, -10
lui x21, 1048575
ori x21, x21, -10
sub x29, x20, x21
xori x31, x29, 0

addi x30, x0, 12
lui x20, 1048575
ori x20, x20, -10
lui x21, 1048575
ori x21, x21, -12
sub x29, x20, x21
xori x31, x29, 2

addi x30, x0, 13
lui x20, 1048575
ori x20, x20, -12
lui x21, 1048575
ori x21, x21, -10
sub x29, x20, x21
lui x28, 1048575
ori x28, x28, -2
xor x31, x29, x28

addi x30, x0, 14
addi x20, x0, 5
lui x21, 1048575
ori x21, x21, -10
sub x29, x20, x21
xori x31, x29, 15

addi x30, x0, 15
lui x20, 1048575
ori x20, x20, -10
addi x21, x0, 10
sub x29, x20, x21
lui x28, 1048575
ori x28, x28, -20
xor x31, x29, x28

addi x30, x0, 16
addi x20, x0, 4
addi x21, x0, 10
sub x29, x20, x21
lui x28, 1048575
ori x28, x28, -6
xor x31, x29, x28

addi x30, x0, 17
addi x20, x0, 10
addi x21, x0, 4
sub x29, x20, x21
xori x31, x29, 6

# SLL
addi x30, x0, 18
addi x20, x0, 0
addi x21, x0, 0
sll x29, x20, x21
xori x31, x29, 0

addi x30, x0, 19
addi x20, x0, 1
addi x21, x0, 1
sll x29, x20, x21
xori x31, x29, 2

addi x30, x0, 20
addi x20, x0, 10
addi x21, x0, 4
sll x29, x20, x21
xori x31, x29, 160

# SLT
addi x30, x0, 21
addi x20, x0, 1
slli x20, x20, 30
addi x21, x0, 1
slli x21, x21, 31
slt x29, x20, x21
xori x31, x29, 0

addi x30, x0, 22
addi x20, x0, 1
slli x20, x20, 31
addi x21, x0, 0
slt x29, x21, x20
xori x31, x29, 0

addi x30, x0, 23
addi x20, x0, 1
slli x20, x20, 31
addi x21, x0, 0
slt x29, x20, x21
xori x31, x29, 1

addi x30, x0, 24
addi x20, x0, 0
addi x21, x0, 1
slt x29, x20, x21
xori x31, x29, 1

addi x30, x0, 25
addi x20, x0, 20
addi x21, x0, 50
slt x29, x20, x21
xori x31, x29, 1

addi x30, x0, 26
addi x20, x0, 0
addi x21, x0, 0
slt x29, x20, x21
xori x31, x29, 0

# SLTU
addi x30, x0, 27
addi x20, x0, 1
slli x20, x20, 30
addi x21, x0, 1
slli x21, x21, 31
sltu x29, x20, x21
xori x31, x29, 1

addi x30, x0, 28
addi x20, x0, 1
slli x20, x20, 31
addi x21, x0, 0
sltu x29, x21, x20
xori x31, x29, 1

addi x30, x0, 29
addi x20, x0, 1
slli x20, x20, 31
addi x21, x0, 0
sltu x29, x20, x21
xori x31, x29, 0

addi x30, x0, 30
addi x20, x0, 0
addi x21, x0, 1
sltu x29, x20, x21
xori x31, x29, 1

addi x30, x0, 31
addi x20, x0, 20
addi x21, x0, 50
sltu x29, x20, x21
xori x31, x29, 1

addi x30, x0, 32
addi x20, x0, 0
addi x21, x0, 0
sltu x29, x20, x21
xori x31, x29, 0

# XOR
addi x30, x0, 33
addi x20, x0, 0
addi x21, x0, 0
xor x29, x20, x21
xori x31, x29, 0

addi x30, x0, 34
addi x20, x0, 3
addi x21, x0, 5
xor x29, x20, x21
xori x31, x29, 6

# SRL
addi x30, x0, 35
addi x20, x0, 170
slli x20, x20, 24
addi x21, x0, 2
srl x29, x20, x21
addi x28, x0, 170
slli x28, x28, 22
xor x31, x29, x28

addi x30, x0, 36
addi x20, x0, 0
addi x21, x0, 0
srl x29, x20, x21
xori x31, x29, 0

addi x30, x0, 37
addi x20, x0, 170
addi x21, x0, 2
srl x29, x20, x21
xori x31, x29, 42

# SRA
addi x30, x0, 38
addi x20, x0, 170
slli x20, x20, 24
addi x21, x0, 2
sra x29, x20, x21
addi x28, x0, 938
slli x28, x28, 22
xor x31, x29, x28

addi x30, x0, 39
addi x20, x0, 0
addi x21, x0, 0
sra x29, x20, x21
xori x31, x29, 0

addi x30, x0, 40
addi x20, x0, 170
addi x21, x0, 2
sra x29, x20, x21
xori x31, x29, 42

# OR
addi x30, x0, 41
addi x20, x0, 3
addi x21, x0, 5
or x29, x20, x21
xori x31, x29, 7

# AND
addi x30, x0, 42
addi x20, x0, 3
addi x21, x0, 5
and x29, x20, x21
xori x31, x29, 1

# LUI
addi x30, x0, 43
lui x29, 0
xori x31, x29, 0

addi x30, x0, 44
lui x29, 356
srli x29, x29, 12
xori x31, x29, 356

# ADDI
addi x30, x0, 45
addi x20, x0, 135
addi x29, x20, 121
xori x31, x29, 256

addi x30, x0, 46
addi x20, x0, 13
addi x29, x20, -12
xori x31, x29, 1

addi x30, x0, 47
lui x20, 1048575
ori x20, x20, -35
addi x29, x20, 40
xori x31, x29, 5

addi x30, x0, 48
lui x20, 1048575
ori x20, x20, -42
addi x29, x20, -9
xori x31, x29, -51

# SLTI
addi x30, x0, 49
addi x20, x0, 1675
slti x29, x20, -12
xori x31, x29, 0

addi x30, x0, 50
addi x20, x0, 1675
slti x29, x20, 2000
xori x31, x29, 1

addi x30, x0, 51
addi x20, x0, -1867
slti x29, x20, -465
xori x31, x29, 1

# SLTIU
addi x30, x0, 52
addi x20, x0, 543
sltiu x29, x20, 402
xori x31, x29, 0

addi x30, x0, 53
addi x20, x0, 1
sltiu x29, x20, 420
xori x31, x29, 1

# XORI
addi x30, x0, 54
addi x20, x0, 1100
xori x29, x20, 0
xori x31, x29, 1100

addi x30, x0, 55
addi x20, x0, 16
xori x29, x20, 15
xori x31, x29, 31

addi x30, x0, 56
addi x20, x0, 18
xori x29, x20, 15
xori x31, x29, 29

# ORI
addi x30, x0, 57
addi x20, x0, 1100
ori x29, x20, 0
xori x31, x29, 1100

addi x30, x0, 58
addi x20, x0, 16
ori x29, x20, 15
xori x31, x29, 31

addi x30, x0, 59
addi x20, x0, 18
ori x29, x20, 15
xori x31, x29, 31

# ANDI
addi x30, x0, 60
addi x20, x0, 1100
andi x29, x20, 0
xori x31, x29, 0

addi x30, x0, 61
addi x20, x0, 16
andi x29, x20, 15
xori x31, x29, 0

addi x30, x0, 62
addi x20, x0, 18
andi x29, x20, 15
xori x31, x29, 2

# SLLI
addi x30, x0, 63
addi x20, x0, 2009
slli x29, x20, 0
xori x31, x29, 2009

addi x30, x0, 64
addi x20, x0, 90
slli x29, x20, 1
xori x31, x29, 180

addi x30, x0, 65
addi x20, x0, 25
slli x29, x20, 6
xori x31, x29, 1600

# SRLI
addi x30, x0, 66
addi x20, x0, 1312
srli x29, x20, 0
xori x31, x29, 1312

addi x30, x0, 67
addi x20, x0, 1621
srli x29, x20, 4
xori x31, x29, 101

addi x30, x0, 68
addi x20, x0, 2008
srli x29, x20, 12
xori x31, x29, 0

# SRAI
addi x30, x0, 69
addi x20, x0, 2006
srai x29, x20, 0
xori x31, x29, 2006

addi x30, x0, 70
lui x20, 1048575
ori x20, x20, -41
srai x29, x20, 3
xori x31, x29, -6

addi x30, x0, 71
addi x20, x0, 277
srai x29, x20, 2
xori x31, x29, 69

# BEQ
addi x30, x0, 72
addi x28, x0, 666
addi x20, x0, 1
addi x21, x0, 1
beq x20, x21, 8
addi x31, x0, 1
addi x28, x0, 1
xori x31, x28, 1

addi x30, x0, 73
addi x28, x0, 666
addi x20, x0, 0
addi x21, x0, 1
beq x20, x21, 8
addi x28, x0, 1
xori x31, x28, 1

# BNE
addi x30, x0, 74
addi x28, x0, 666
addi x20, x0, 2
addi x21, x0, 1
bne x20, x21, 8
addi x31, x0, 1
addi x28, x0, 1
xori x31, x28, 1

addi x30, x0, 75
addi x28, x0, 666
addi x20, x0, 1
addi x21, x0, 1
bne x20, x21, 8
addi x28, x0, 1
xori x31, x28, 1

# BLT
addi x30, x0, 76
addi x28, x0, 666
addi x20, x0, 1
addi x21, x0, 2
blt x20, x21, 8
addi x31, x0, 1
addi x28, x0, 1
xori x31, x28, 1

addi x30, x0, 77
addi x28, x0, 666
addi x20, x0, 2
addi x21, x0, 2
blt x20, x21, 8
addi x28, x0, 1
xori x31, x28, 1

# BGE
addi x30, x0, 78
addi x28, x0, 666
addi x20, x0, 2
addi x21, x0, 1
bge x20, x21, 8
addi x31, x0, 1
addi x28, x0, 1
xori x31, x28, 1

addi x30, x0, 79
addi x28, x0, 666
addi x20, x0, 0
addi x21, x0, 1
bge x20, x21, 8
addi x28, x0, 1
xori x31, x28, 1

# BLTU
addi x30, x0, 80
addi x28, x0, 666
addi x20, x0, 1
addi x21, x0, 2
bltu x20, x21, 8
addi x31, x0, 1
addi x28, x0, 1
xori x31, x28, 1

addi x30, x0, 81
addi x28, x0, 666
addi x20, x0, 2
addi x21, x0, 2
bltu x20, x21, 8
addi x28, x0, 1
xori x31, x28, 1

# BGEU
addi x30, x0, 82
addi x28, x0, 666
addi x20, x0, 2
addi x21, x0, 1
bgeu x20, x21, 8
addi x31, x0, 1
addi x28, x0, 1
xori x31, x28, 1

addi x30, x0, 83
addi x28, x0, 666
addi x20, x0, 0
addi x21, x0, 1
bgeu x20, x21, 8
addi x28, x0, 1
xori x31, x28, 1

# SW / LW
addi x30, x0, 84
lui x20, 65536
addi x21, x0, 1337
sw x21, 0(x20)
lw x29, 0(x20)
xori x31, x29, 1337

addi x30, x0, 85
lui x20, 65536
lui x21, 1048575
ori x21, x21, -5
sw x21, 4(x20)
lw x29, 4(x20)
xor x31, x29, x21

addi x30, x0, 86
lui x20, 65536
addi x21, x0, 1
sw x21, 9(x20)
lw x29, 9(x20)
xori x31, x29, 1

nop