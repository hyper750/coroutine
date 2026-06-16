#include "constants.h"

.text
.global init_scheduler
init_scheduler:
    # Scheduler*
    movq $0, (MAX_COROUTINES*SIZE_OF_CONTEXT)(%rdi) 
    ret

.global run_scheduler
run_scheduler:
    # Scheduler*
    push %rbp
    mov %rsp, %rbp
    
    # Store coroutine index
    sub $0x8, %rsp
    movl $0, (%rsp)

    loop:
    mov (%rsp), %rcx
    mov $SIZE_OF_CONTEXT, %rax
    mul %rcx
    # rsi has the Context*
    lea (%rdi, %rax), %rsi
    inc %rcx
    # Avoid index overflow
    mov %rcx, %rax
    mov $MAX_COROUTINES, %rcx
    xor %rdx, %rdx
    div %rcx
    mov %rdx, (%rsp)
    # And switch context to the function
    jmp *0x8(%rsi)
    
    # Never reached
    mov %rbp, %rsp
    pop %rbp
    ret

.global add_coroutine
add_coroutine:
    # Scheduler*, function*
    # Return Context*
    # TODO: Check total number of contexts to avoid overflow and return NULL
    # number of ctx in rax * sizeof context to calculate the context to populate
    mov (MAX_COROUTINES*SIZE_OF_CONTEXT)(%rdi), %rax
    mov $SIZE_OF_CONTEXT, %rdx
    mul %rdx
    lea (%rdi, %rax), %rax
    mov %rdi, STACK_SIZE(%rax)
    mov %rsi, (STACK_SIZE+0x8)(%rax)
    # Store rbp and rsp at the beggining of the Context stack
    lea (%rax), %rcx
    mov %rcx, (STACK_SIZE+0x10)(%rax) 
    mov %rax, (STACK_SIZE+0x18)(%rax) 
    # Increment number of ctxs being used
    incq (MAX_COROUTINES*SIZE_OF_CONTEXT)(%rdi)
    ret

.global yield
yield:
    # Context*
    # Save current state
    mov (%rsp), %rsi
    mov %rsi, (STACK_SIZE+0x8)(%rdi)
    # Remove return address, since it's not used via ret
    pop %rdx
    # Return Scheduler*
    mov (%rdi), %rdi
    # TODO: Move pointer to the original stack pointer
    jmp loop

.global start_coroutine
start_coroutine:
    # Context*
    # Remove frame built, it stores 16 bytes with the Context* and the return address
    mov %rbp, %rsp
    pop %rbp
    # TODO: Point frame to context frame
    jmp *%rdi

