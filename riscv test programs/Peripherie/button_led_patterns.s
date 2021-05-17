nop # Interrupt-Behandlungsroutinen
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
nop
nop
nop
nop
j button_interrupt_handler
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
nop
nop
nop
nop
nop
nop

# Reguläre Instruktionen
start:

# Setze INT_CTRL Register (0x1A109004), erlaube nur Taster/Schalter-Interrupts
li t0, 0x1A109004
li t1, 0x00008000
sw t1, 0(t0)

li s1, 1

# Warte auf Button-Interrupts
loop:
j loop

button_interrupt_handler:
li t0, 1
bne s1, t0, start
# t0: Adresse von INT_STATUS
# t1: Inhalt von INT_STATUS
# t2: Bitmaske
# t3: Maskierter Inhalt von INT_STATUS
# t4: Adresse von LED-Register
# t5: Künftiger Inhalt von LED-Register

# Lese INT_STATUS Register (0x1A101018)
li t0, 0x1A101018
lw t1, 0(t0)

# Setze LED-Register-Adresse und -Inhalt
li t4, 0x1A120000
li t5, 0

li t2, 0x00040000 # Lade Bitmaske
and t3, t1, t2 # Wende Bitmaske an
beq t3, zero, button1 # Test, ob Taster-Bit gesetzt
ori t5, t5, 0x00000008# Schalte LED 0 an

button1:
srli t2, t2, 1 # Verschiebe Bitmaske
and t3, t1, t2
beq t3, zero, button2
ori t5, t5, 0x00000004# Schalte LED 1 an

button2:
srli t2, t2, 1 # Verschiebe Bitmaske
and t3, t1, t2
beq t3, zero, button3
ori t5, t5, 0x00000002# Schalte LED 2 an

button3:
srli t2, t2, 1 # Verschiebe Bitmaske
and t3, t1, t2
beq t3, zero, setLEDs
ori t5, t5, 0x00000001# Schalte LED 3 an

setLEDs:
sw t5, 0(t4)

nop #ersetze NOP durch MRET

nop
