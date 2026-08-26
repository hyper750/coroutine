# Coroutine Assembly/C

Project for learning assembly and make fun a bit (or not).
It uses a fix stack size of 1Kb per coroutine and the schedulers accepts maximum 10 coroutines. It can be modified via constants.h.


## Example
![](docs/example.gif)


## To improve
- Add coroutine will check the number of available coroutines and return NULL or error if exceed the total number of coroutines
- Be able to finish the scheduler loop
- Return value via yield, can be added in the Context stack frame and an integer saying how many bytes we are returning

