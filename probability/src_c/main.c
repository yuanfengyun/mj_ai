#include <stdio.h>
#include <time.h>
#include "table_mgr.h"
#include "analyse.h"

void test_analyse()
{
    char handcards[] = {
      0,0,0,0,1,1,4,0,0,
      0,1,1,0,0,0,2,0,0,
      1,1,2,0,0,0,0,0,0
    };

    char outcards[] = {
      0,0,0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,0,0
    };

	int begin = time(NULL);
    char card = analyse(handcards, outcards);
	int end = time(NULL);
    printf("card=%d, use %d seconds\n",card, end-begin);
	getchar();
}

int main()
{
    table_mgr_init();
	analyse_init();
    printf("load table begin\n");
    table_mgr_load();
    printf("load table finish\n");
    test_analyse();
    return 0;
}

