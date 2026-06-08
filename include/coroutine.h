#ifndef COROUTINE_H
#define COROUTINE_H

#define MAX_COROUTINES 10

#include <stddef.h>

typedef struct Scheduler Scheduler;
typedef struct Context Context;
typedef void(*coroutine)(Context* ctx);

struct Context
{
    Scheduler* scheduler;
    void* rbp;
    void* rsp;
    void* rip;
};

struct Scheduler
{
    Context ctx[MAX_COROUTINES];
    size_t n_ctx;
    void* rbp;
    void* rsp;
    void* rip;
};

extern void resume(Context* ctx);

extern void yield(Context* ctx);

extern void init_context(Context* ctx, coroutine crt);

void init_scheduler(Scheduler* s);

#endif

