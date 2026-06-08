.text
.global init_scheduler
init_scheduler:
    # Scheduler*
    movq $0, 10*20(%rdi) 
    movq $0, (10*20+8)(%rdi)
    movq $0, (10*20+16)(%rdi)
    # TODO: RSP contains the return address
    # TODO: 10 from MAX_COROUTINES definition
    mov %rsp, (10*20+24)(%rdi)
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


