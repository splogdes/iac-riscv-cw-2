addi t1, zero, 0xAB
addi t2, zero, 0xCD 
addi t3, zero, 0xEF 
addi t4, zero, 0x89 
add a2, zero, 0x20 
sb t1, 3(a2)
sb t4, 0(a2)
sb t2, 2(a2)
sb t3, 1(a2)
lw a0, 0(a2)
lw a3, 0(a2)
addi a2, a2, 0x20
addi a2, zero, 0x420
lw a2, 0(a2)
addi a2, zero, 0x20
lw a1, 0(a2)
