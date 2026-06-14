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
    void* rip;
};

struct Scheduler
{
    Context ctx[MAX_COROUTINES];
    size_t n_ctx;
    void* rip;
};

void init_scheduler(Scheduler* s);

extern void run_scheduler(Scheduler* s);

extern Context* add_coroutine(Scheduler* s, coroutine crt);

extern void resume(Context* ctx);

extern void yield(Context* ctx);

#endif

