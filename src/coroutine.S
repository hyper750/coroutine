#include "constants.h"

.text
.global init_scheduler
init_scheduler:
    # Scheduler*
    movq $0, (MAX_COROUTINES*SIZE_OF_CONTEXT)(%rdi) 
    movq $0, (MAX_COROUTINES*SIZE_OF_CONTEXT+0x8)(%rdi)
    movq $0, (MAX_COROUTINES*SIZE_OF_CONTEXT+0x10)(%rdi)
    ret

.global run_scheduler
run_scheduler:
    # Scheduler*
    push %rbp
    mov %rsp, %rbp
    
    # Store coroutine index
    sub $0x8, %rsp
    movq $0, (%rsp)
    # Store Scheduler frame
    mov %rbp, (MAX_COROUTINES*SIZE_OF_CONTEXT+0x8)(%rdi)
    mov %rsp, (MAX_COROUTINES*SIZE_OF_CONTEXT+0x10)(%rdi)

    scheduler_loop:
    # TODO: Second coroutine it will have 16 bytes more? Where does it come from? start coroutine will fix it?
    # TODO: SIGSEGV $rsp is pointing to the correct memory address but the value is overrided with a pointer _dl_runtime_resolve_xsavec
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
    # and $-0x10, %rdx  # Align 16 bytes
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

# .global start_coroutine
# start_coroutine:
#     # Context*
#     # Remove frame built from the original function, it stores 16 bytes with the Context* and the return address
#     mov (%rsp), %rsi
#     mov %rbp, %rsp
#     pop %rbp
#     # Point frame to context frame
#     mov (STACK_SIZE+0x10)(%rdi), %rbp
#     mov (STACK_SIZE+0x18)(%rdi), %rsp
#     jmp *%rsi
# 
