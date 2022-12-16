# note about pipelining: with 1 hour and 10 minutes left of the project I discovered that an earlier merge had broken quite a lot of functionality in the project: I had to replace the startlights program with startlights_pipelined which does not use srli as that was in the merge which broke things and I didn't have time to implement the lost features from scratch or sort out the merge. Consequently it manually sets a0 rather than shifting. That is also why I manually copied across vbuddy.cpp and the changes to riscv_tb.cpp from the other branch.


# iac-riscv-cw-2
**Coursework for group 2, members Ollie Cosgrove, Patrick Beart, Noor Elsheikh and Jackson Barlow**

# Achieved:
## Verified completion of the single-cycle non-pipelined CPU in branch [main](https://github.com/EIE2-IAC-Labs/iac-riscv-cw-2/tree/main)

## Pipelined CPU (no hazard detection) in branch [pipeline](https://github.com/EIE2-IAC-Labs/iac-riscv-cw-2/tree/pipeline)

## CPU with memory cache and pipelining (no hazard detection) in branch [cache-and-pipelining](https://github.com/EIE2-IAC-Labs/iac-riscv-cw-2/tree/cache-and-pipelining)

# Group Statement:
