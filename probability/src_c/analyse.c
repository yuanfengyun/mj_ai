#include "table_mgr.h"

long long mathC(int n,int m)
{
	long long a = 1, b = 1;
	if (n - m < m) m = n - m;
	if (n == 0)
		return 1;
	for (int i = n; i >= n - m + 1; i--)
		a = a*i;
	for (int i = 1; i <= m; i++)
		b = b*i;

	return a / b;
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
                c_A_a *= mathC(left, lack);
            }
        }
		if (br) {
			continue;
		}
        long long c_need = 1;
        if(m>total_need) c_need = mathC(n-total_need, m-total_need);
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
