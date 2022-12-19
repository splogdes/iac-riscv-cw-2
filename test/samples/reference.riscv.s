.text
.equ base_pdf, 0x100
.equ base_data, 0x10000
.equ max_count, 200
main:
    JAL     ra, init  #1 jump to init, ra and save position to ra
    JAL     ra, build #2
forever:
    JAL     ra, display #3
    J       forever #4

init:       # function to initialise PDF buffer memory 
    LI      a1, 0x100 #5          # loop_count a1 = 256
_loop1:                         # repeat
    ADDI    a1, a1, -1 #6         #     increment a1
    SB      zero, base_pdf(a1) #7  #     mem[base_pdf+a1) = 0
    BNE     a1, zero, _loop1 #8   # until a1 = 0
    RET #9

build:      # function to build prob dist func (pdf)
    LI      a1, base_data #10      # a1 = base address of data array
    LI      a2, 0 #11              # a2 = offset into of data array 
    LI      a3, base_pdf #12       # a3 = base address of pdf array
    LI      a4, max_count #13      # a4 = maximum count to terminate
_loop2:                         # repeat
    ADD     a5, a1, a2  #14        #     a5 = data base address + offset
    LBU     t0, 0(a5)   #15        #     t0 = data value
    ADD     a6, t0, a3  #16        #     a6 = index into pdf array
    LBU     t1, 0(a6)   #17        #     t1 = current bin count
    ADDI    t1, t1, 1   #18        #     increment bin count
    SB      t1, 0(a6)   #19        #     update bin count
    ADDI    a2, a2, 1   #20        #     point to next data in array
    BNE     t1, a4, _loop2 #21     # until bin count reaches max
    RET    #22

display:    # function send PDF array value to a0 for display
    LI      a0, 5
    LI      a1, 1  #23             # a1 = offset into pdf array
    LI      a2, 255 #24            # a2 = max index of pdf array
_loop3:                         # repeat
    LBU     a0, base_pdf(a1) #25   #   a0 = mem[base_pdf+a1)
    addi    a1, a1, 1   #26        #   incr 
    BNE     a1, a2, _loop3 #27     # until end of pdf array
    RET  #28