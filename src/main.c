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
    Context ctxs[2] = {0, 0};
    init_context(&ctxs[0], do_one);
    init_context(&ctxs[1], do_two);
    for(int i = 0; i < 2; i++)
    {
        resume(&ctxs[i]);
    }
    return 0;
}

