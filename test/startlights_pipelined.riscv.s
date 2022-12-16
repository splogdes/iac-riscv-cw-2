
main:
lui a0,0x10
nop
nop
nop
addi a0,a0,-256 # 0xff00
nop
nop
nop
addi x29, x29, 0b11111111 # Use x29 to store what the value of a0 will be once the lights have counted up to full (i.e. all lights are 1)
nop
nop
nop
addi a2, x0, 0

# a0: light output
# a1: parameter to subroutine_wait_a1, number of cycles to wait
# tp: interrupt source
# a2: cycles before button pressed used for PRNG
nop
nop
nop

wait_start:
nop
nop
nop
addi a2, a2, 1
nop
nop
nop
beq tp, x0, wait_start
nop
nop
nop
chop_up:
nop
nop
nop
slli a2, a2, 29 # chop off all but bottom 3 bits of delay timer, now a2 has max value of 7
nop
nop
nop
srli a2, a2, 29
nop
nop
nop
addi a1, x0, 10 # count up cycle count
nop
nop
nop

count_lights_down:
nop
nop
nop
call subroutine_wait_a1
nop
nop
nop
# srli a0, a0, 1 # shift lights over - srli not implemented on this branch!
addi a0, x0, 0b10000000
nop
nop
nop
call subroutine_wait_a1
nop
nop
nop
addi a0, x0, 0b11000000
nop
nop
nop
call subroutine_wait_a1
nop
nop
nop
addi a0, x0, 0b11100000
nop
nop
nop
call subroutine_wait_a1
nop
nop
nop
addi a0, x0, 0b11110000
nop
nop
nop
call subroutine_wait_a1
nop
nop
nop
addi a0, x0, 0b11111000
nop
nop
nop
call subroutine_wait_a1
nop
nop
nop
addi a0, x0, 0b11111100
nop
nop
nop
call subroutine_wait_a1
nop
nop
nop
addi a0, x0, 0b11111110
nop
nop
nop
call subroutine_wait_a1
nop
nop
nop
addi a0, x0, 0b11111111
nop
nop
nop
call subroutine_wait_a1
nop
nop
nop
final_lightsout_random_wait:
nop
nop
nop
addi a1, a2, 1 # copy a2 into a1 and add 2 for a lower bound
nop
nop
nop
add a1, a1, a1 # double
nop
nop
nop
jal ra, subroutine_wait_a1 # wait for lights off
nop
nop
nop
addi a0, x0, 0b0 # turn off lights
nop
nop
nop
end:
nop
nop
nop
jal x0, end
nop
nop
nop
subroutine_wait_a1:
nop
nop
nop
addi x28, a1, 0
nop
nop
nop
dec_x28:
nop
nop
nop
addi x28, x28, -1
nop
nop
nop
bne x28, x0, dec_x28
nop
nop
nop
ret