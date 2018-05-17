#include <stdio.h>
#include "table_mgr.h"
#include "analyse.h"

void test_analyse()
{
    char handcards[] = {
      1,1,2,0,1,1,4,0,0,
      0,1,1,0,0,0,2,0,0,
      0,0,0,0,0,0,0,0,0
    };

    char outcards[] = {
      0,0,0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,0,0
    };

    char card = analyse(handcards, outcards);
    printf("选择%d",card);
}

int main()
{
    table_mgr_init();
    printf("加载表格开始\n");
    table_mgr_load();
    printf("加载表格完成\n");
    test_analyse();
    return 0;
}

