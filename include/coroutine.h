#ifndef COROUTINE_H
#define COROUTINE_H

#include "constants.h"
#include <stddef.h>

typedef struct Scheduler Scheduler;
typedef struct Context Context;
typedef void(*coroutine)(Context* ctx);

struct Context
{
    char stack[STACK_SIZE];
    Scheduler* scheduler;
    void* rip;
    void* rbp;
    void* rsp;
    bool is_running;
};

struct Scheduler
{
    Context ctx[MAX_COROUTINES];
    size_t n_ctx;
    void* rbp;
    void* rsp;
};

extern void init_scheduler(Scheduler* s);

extern void run_scheduler(Scheduler* s);

extern Context* add_coroutine(Scheduler* s, coroutine crt);

extern void yield(Context* ctx);

extern void stop(Context* ctx);

#endif

