nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
addi x29, x29, 1 #Begin Behandlungsroutine für Timer-Interrupts (ID: 10)
addi x28, x0, 4
beq x29, x28, 8
#mret
addi x20, x0, 22
lui x21, 106763
sw x20, 0(x21) #Konfiguriere Timer
#mret