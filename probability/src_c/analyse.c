#include<string.h>
#include "table_mgr.h"

long long c_cache[10000];
long long c_c = 0;

#define mathC(nn,mm) \
do{\
    int n = nn;\
	int m = mm;\
	long long cache = c_cache[n*100+m];\
	if (cache != 0) {\
		c_c = cache;\
		break;\
	}\
	long long a = 1, b = 1;\
	if (n - m < m) m = n - m;\
	if (m == 0)\
	{\
		c_cache[n * 100 + m] = 1;\
		c_cache[n * 100 + (n - m)] = 1;\
		c_c = 1;\
		break;\
	}\
	for (int i = n; i >= n - m + 1; i--)\
		a = a*i;\
	for (int i = 1; i <= m; i++)\
		b = b*i;\
	long long value = a / b;\
	c_cache[n*100+m] = value;\
	c_cache[n * 101-m] = value;\
	c_c = value;\
	break;\
}while(1)

void analyse_init()
{
	memset(c_cache, 0, sizeof(c_cache));
}

long long get_score(char* handcards, char* outcards, struct table* t,int n, int m)
{
    long long score = 0;

    for(int i=0;i<t->num;++i)
    {
        int br = 0;
        char* cards = t->items[i].cards;
        long long c_A_a = 1;
        int total_need = 0;
        for(int card=0;card<27;++card)
        {
            int need = cards[card];
            if(need==0) continue;
            int left = 4 - handcards[card] - outcards[card];
            if(need > left+ handcards[card]){
                br = 1;
                break;
            }
            int lack = need - handcards[card];
            if(lack > 0){
                total_need += lack;
				mathC(left, lack);
				c_A_a *= c_c;
            }
        }
		if (br) {
			continue;
		}
        long long c_need = 1;
		if (m > total_need)
		{
			int x = (n - total_need);
			int y = (m - total_need);
			mathC(x,y);
			c_need = c_c;
		}
		else if (m < total_need) {
			c_need = 0;
		}
	
        score = score + c_A_a * c_need;
    }

    return score;
}

char analyse(char* handcards,char* outcards)
{
    int m = 8;
    int n = 108;
    int sum = 0;
    int out_cards_sum = 0;
    for(int i=0;i<27;++i)
    {
          sum += handcards[i];
          out_cards_sum += outcards[i];
    }

    n = n - sum - out_cards_sum;
    long long max_score = 0;
    int max_card = 0;
    struct table* t = table_mgr_get(sum);
    for(int i=0;i<27;++i)
    {
        if(handcards[i]==0) continue;
    
        --handcards[i];
        ++outcards[i];
        long long score = get_score(handcards,outcards,t,n,m);
		printf("1 card=%2d, score=%I64d\n", i, score);

        if(score>max_score)
        {
            max_score = score;
            max_card = i;
        }
        ++handcards[i];
        --outcards[i];
    }
	return max_card;
}
