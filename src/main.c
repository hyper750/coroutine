#include <stdio.h>
#include "coroutine.h"

void do_one(Context* ctx)
{
    while(1)
    {
        printf("do one\n");
        yield(ctx);
    }
}

void do_two(Context* ctx)
{
    while(1)
    {
        printf("Do two\n");
        yield(ctx);
    }
}


int main()
{
    Scheduler s;
    init_scheduler(&s);
    add_coroutine(&s, do_one);
    add_coroutine(&s, do_two);
    run_scheduler(&s);
    return 0;
}

