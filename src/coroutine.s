.text
.global init_scheduler
init_scheduler:
    # Scheduler*
    movq $0, (0xA*0x10)(%rdi) 
    # Store return address
    mov %rsp, (0xA*0x10+0x8)(%rdi)
    ret

.global run_scheduler
run_scheduler:
    # Scheduler*
    push %rbp
    mov %rsp, %rbp
    
    # Store the Scheduler and coroutine index
    sub 0x16, %rsp
    mov %rdi, -0x8(%rsp)

    mov $0, %rcx
    mov $0x10, %rax
    mul %rcx
    # rsi has the Context*
    lea (%rdi, %rax), %rsi
    inc %rcx
    mov %rcx, (%rsp)
    # Store scheduler rip
    lea (%rip), %rdx
    mov %rdx, (0xA*0x10+0x8)(%rdi) 
    # And switch context to the function
    jmp *0x8(%rsi)

    mov %rbp, %rsp
    pop %rbp
    ret

.global add_coroutine
add_coroutine:
    # Scheduler*, function*
    # Return Context*
    # number of ctx in rax * sizeof context to calculate the context to populate
    mov (0xA*0x10)(%rdi), %rax
    mov $0x10, %rdx
    mul %rdx
    lea (%rdi, %rax), %rax
    mov %rdi, (%rax)
    mov %rsi, 0x8(%rax)
    # Increment number of ctxs being used
    incq (0xA*0x10)(%rdi)
    ret

.global yield
yield:
    # Context*
    # Store return addres
    ret

.global resume
resume:
    # Context*
    # Store scheduler context until we reach yield
    ret


