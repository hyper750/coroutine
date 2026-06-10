.text
.global init_scheduler
init_scheduler:
    # Scheduler*
    # n_ctxs and rip
    movq $0, (0xA*0x20)(%rdi) 
    # Store return address
    mov %rsp, (0xA*0x20+0x8)(%rdi)
    ret

.global run_scheduler
run_scheduler:
    ret

.global add_coroutine
add_coroutine:
    # Context*, function*
    mov %rsi, 0x10(%rdi)
    ret

.global yield
yield:
    # Store return addres
    # lea %rsp, %rip
    ret

.global resume
resume:
    # Context*
    # Store scheduler context until we reach yield
    ret


