#include <stdio.h>
#include "coroutine.h"

void do_one(Context* ctx)
{
    while(1)
    {
        printf("Do one\n");
        yield(ctx);
    }
}

void do_two(Context* ctx)
{
    while(1)
    {
        printf("do two\n");
        yield(ctx);
    }
}

void do_three(Context* ctx)
{
    while(1)
    {
        printf("do three\n");
        yield(ctx);
    }
}

int main()
{
    Scheduler s;
    init_scheduler(&s);
    Context* a = add_coroutine(&s, do_one);
    Context* b = add_coroutine(&s, do_two);
    Context* c = add_coroutine(&s, do_three);
    run_scheduler(&s);
    return 0;
}

