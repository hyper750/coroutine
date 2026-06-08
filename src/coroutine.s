.text
.global init_context
init_context:
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

.global init_scheduler
init_scheduler:
    # Scheduler*
    # Context ctx[MAX_COROUTINES];
    # size_t n_ctx;
    # void* rbp;
    # void* rsp;
    # void* rip;
    movq $0, 0x20(%rdi) 
    movq $0, 0x28(%rdi)
    movq $0, 0x30(%rdi)
    # TODO: RSP contains the return address
    mov %rsp, 0x38(%rdi)
    ret

