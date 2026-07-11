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
};

struct Scheduler
{
    Context ctx[MAX_COROUTINES];
    size_t n_ctx;
    void* rbp;
    void* rsp;
};

void init_scheduler(Scheduler* s);

extern void run_scheduler(Scheduler* s);

extern Context* add_coroutine(Scheduler* s, coroutine crt);

// extern void start_coroutine(Context* context);

extern void yield(Context* ctx);

#endif

