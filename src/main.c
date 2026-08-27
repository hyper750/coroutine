#include <stdio.h>
#include "coroutine.h"

void do_one(Context* ctx)
{
    int x = 0;
    while(1)
    {
        printf("Do one %d\n", x++);
        if(x % 10 == 0)
        {
            stop(ctx);
        }
        yield(ctx);
    }
}

void do_two(Context* ctx)
{
    int x = 100;
    while(1)
    {
        printf("Do two %d\n", x++);
        if(x % 100 == 0)
        {
            stop(ctx);
        }
        yield(ctx);
    }
}

void do_three(Context* ctx)
{
    int x = 1000;
    while(1)
    {
        printf("Do three %d\n", x++);
        if(x % 1000 == 0)
        {
            stop(ctx);
        }
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

