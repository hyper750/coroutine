#include <stdio.h>
#include "coroutine.h"

void do_one(Context* ctx)
{
    start_coroutine(ctx);
    /*while(1)
    {
        printf("Do one\n");
        yield(ctx);
    }*/
}

void do_two(Context* ctx)
{
    start_coroutine(ctx);
    /*while(1)
    {
        printf("Do two\n");
        yield(ctx);
    }*/
}


int main()
{
    Scheduler s;
    init_scheduler(&s);
    Context* a = add_coroutine(&s, do_one);
    Context* b = add_coroutine(&s, do_two);
    // printf("Scheduler %p\n", &s);
    // printf("Do one: %p\n", do_one);
    // printf("Do two: %p\n", do_two);
    // printf("A->scheduler: %p\n", a->scheduler);
    // printf("A->do_one: %p\n", a->rip);
    // printf("B->scheduler: %p\n", b->scheduler);
    // printf("B->rip: %p\n", b->rip);
    run_scheduler(&s);
    return 0;
}

