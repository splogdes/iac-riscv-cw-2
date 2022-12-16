# Pipelining operation of F1 start lights
There is no observable difference in operation apart from the pipelined version being much slower (because of unnecessary NOPs which I have not yet worked through removing) but this is not a processing heavy workload: gains might well be seen even with only slightly increased clock speed if e.g. multiple simultaneous ALU operations were being used.

For reference, whereas in the main branch lights take approximately half a second to change states in the counting up phase, in pipelining it takes about 2-3 seconds. See the photos of the program operating in the main branch for identical behaviour.

You can also test the program by running the same command as in the main branch:

`./scripts/assemble_test_riscv.sh ./test/startlights_pipelined.riscv.s` after setting up `vbuddy.cfg` correctly.

-Patrick Beart
