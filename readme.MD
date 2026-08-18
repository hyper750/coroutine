# Coroutine Assembly/C

Project for learning assembly and make fun a bit (or not).
It uses a fix stack size of 1Kb per coroutine and the schedulers accepts maximum 10 coroutines. It can be modified via constants.h.

## To improve
- Sometimes Printf/puts modifies the original stack frame, not the stack frame of the coroutine, adding a shared library memory address on top of the stack when I have the index of the coroutine that will run and break the scheduler
- Store other registers in the Context??
- Return value via yield, can be added in the Context stack frame and an integer saying how many bytes we are returning

