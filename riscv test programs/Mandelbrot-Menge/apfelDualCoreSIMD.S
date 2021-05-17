start:
# fixed point -> x << 8 , except for mult/div
#   32 Bit: 24MSB -> Int-Part, 8LSB -> fraction
# s0 : current four pixels
# s1 : fp_x
# s2 : fp_x_end
# s3 : fp_y
# s4 : fp_y_end
# s5 : fp_tresh
# s6 : max_iter
# s7 : frame_adr
# s9 : bytes per write - 1
li s2, 128

# fp_y = fp_y_start
li s3, -150

li s4, 0
li s5, 1024
li s6, 31
li s7, 0x1C010000
li s9, 3

# read HARTID status register an set computation parameters accordingly
csrrs t0, x0, 0xf14
beq t0, x0, y_loop
li s3, 0
li s4, 150
li s7, 0x1C027700

y_loop:
  # fp_x = fp_x_start
  li s1, -512
  li t0, -511
  iop1 s1, t0, 0
  
x_loop:
  # s10 : iter
  # s11 : x
  # a7  : y
  # a6  : sx
  # a5  : sy
  # s8  : pixel_calculating_flag (1= pixel noch nicht fertig, 0= pixel fertig)
  # init to zero
  add s10, x0, x0
  add s11, x0, x0
  add a7, x0, x0
  add a6, x0, x0
  add a5, x0, x0
  addi s8, x0, 1
  
iter_loop:
  # if (sx+sy) >= fp_tresh then clear the pixel_calculating_flag  
  add a0, a5, a6
  slt t0, a0, s5
  and s8, s8, t0
  
  # if iter >= max_iter then clear the pixel_calculating_flag
  slt t0, s10, s6
  and s8, s8, t0

  # if pixel_calculating_flag not set in either of the register banks then leafe the iter_loop
  bne s8, x0, iter_loop_continue
  iop0 t0, s8, 0
  beq t0, x0, iter_end
  iter_loop_continue:

  # sx = x * x
  add a1, x0, s11
  add a2, x0, s11
  jal ra, fp_mul  
  add a6, a0, x0
  
  # sy = y * y
  add a1, x0, a7
  add a2, x0, a7
  jal ra, fp_mul  
  add a5, a0, x0
  
  # y = 2 * x * y
  add a1, x0, s11
  add a2, x0, a7
  jal ra, fp_mul
  slli a7, a0, 1
  
  # y += fp_y
  add a7, a7, s3
  # x = sx - sy
  sub s11, a6, a5
  # x = x + fp_x
  add s11, s11, s1
  # iter = iter + pixel_calculating_flag
  add s10, s10, s8
  jal x0, iter_loop
  
iter_end:
  # make space for another pixel
  srli s0, s0, 16
  slli s10, s10, 16
  or s0, s0, s10
  iop0 s10, s10, 0
  slli s10, s10, 8
  or s0, s0, s10
  
  #or s0, s0, s10
  
  # don't write if not 4 pixels computed
  addi s9, s9, -2
  bge s9, x0, iter_loop_header
  
  # store
  sw s0, 0(s7)
  # restore pixel cnt
  addi s9, x0, 3
  # incr frame pointer by 4*8 bit pixels
  addi s7, s7, 4
  
iter_loop_header:
  # fp_x += 1
  addi s1, s1, 2
  # if fp_x < fp_x_end then goto x_loop
  blt s1, s2, x_loop
  
  # fp_y = fp_y + fp_y_inc
  addi s3, s3, 1
  # if fp_y < fp_y_end then goto y_loop
  blt s3, s4, y_loop
  
done:
  # display the contents of the RDCYCLE CSR in binary
  csrrs t0, x0, 0xc00
  li t1, 0x1C010000 # pixel address
  li t2, 15 # multiplier
  
  display_cycles_loop:
  andi t3, t0, 1
  mul t3, t3, t2
  sb t3, 0(t1)
  srli t0, t0, 1
  addi t1, t1, 1
  bne t0, x0, display_cycles_loop

  # display pattern below register value for improved readability
  li t0, 15 # loop counter
  li t1, 0x1C010280
  
  display_pattern_loop:
  sh t2, 0(t1)
  addi t1, t1, 2
  addi t0, t0, -1
  bne t0, x0, display_pattern_loop

done_loop:
  jal x0, done_loop

fp_mul:
  mul x10, x11, x12
  
  # return a0 >> 8 (fixed point arithmetic)
  #   2^8*2^8 should be 2^8 (in this fixed point format 1=2^8)
  srai a0, a0, 8
  jalr x0, ra, 0
