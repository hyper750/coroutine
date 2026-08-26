#include "constants.h"

.text
.global init_scheduler
init_scheduler:
    # Scheduler*
    xor %rsi, %rsi
    movq %rsi, (MAX_COROUTINES*SIZE_OF_CONTEXT)(%rdi)
    movq %rsi, (MAX_COROUTINES*SIZE_OF_CONTEXT+0x8)(%rdi)
    movq %rsi, (MAX_COROUTINES*SIZE_OF_CONTEXT+0x10)(%rdi)
    ret

.global run_scheduler
run_scheduler:
    # Scheduler*
    push %rbp
    mov %rsp, %rbp
    
    # Store coroutine index
    sub $0x8, %rsp
    xor %rsi, %rsi
    movq %rsi, (%rsp)
    # Store Scheduler frame
    mov %rbp, (MAX_COROUTINES*SIZE_OF_CONTEXT+0x8)(%rdi)
    mov %rsp, (MAX_COROUTINES*SIZE_OF_CONTEXT+0x10)(%rdi)

    scheduler_loop:
    mov (%rsp), %rcx
    mov $SIZE_OF_CONTEXT, %rax
    mul %rcx
    # rsi has the Context*
    lea (%rdi, %rax), %rsi
    inc %rcx
    # Avoid index overflow
    mov %rcx, %rax
    # Number of contexts from the scheduler
    mov (MAX_COROUTINES*SIZE_OF_CONTEXT)(%rdi), %rcx
    xor %rdx, %rdx
    div %rcx
    mov %rdx, (%rsp)
    # Switch to coroutine frame
    mov (STACK_SIZE+0x10)(%rsi), %rbp
    mov (STACK_SIZE+0x18)(%rsi), %rsp
    # Continue coroutine flow
    mov %rsi, %rdi
    jmp *(STACK_SIZE+0x8)(%rsi)
    
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
    # Store frame
    mov $STACK_SIZE-1, %rdx
    lea (%rax, %rdx), %rdx
    mov %rdx, (STACK_SIZE+0x10)(%rax)
    and $-0x10, %rdx  # Align 16 bytes
    mov %rdx, (STACK_SIZE+0x18)(%rax) 
    # Increment number of ctxs being used
    incq (MAX_COROUTINES*SIZE_OF_CONTEXT)(%rdi)
    ret

.global yield
yield:
    # Context*
    # Save current state
    # Remove return address, since it's not used via ret
    pop %rdx
    mov %rdx, (STACK_SIZE+0x8)(%rdi)
    mov %rbp, (STACK_SIZE+0x10)(%rdi)
    mov %rsp, (STACK_SIZE+0x18)(%rdi)
    # Return Scheduler* 
    mov (STACK_SIZE)(%rdi), %rdi
    # Move frame to the original one from the scheduler
    mov (MAX_COROUTINES*SIZE_OF_CONTEXT+0x8)(%rdi), %rbp
    mov (MAX_COROUTINES*SIZE_OF_CONTEXT+0x10)(%rdi), %rsp
    jmp scheduler_loop

