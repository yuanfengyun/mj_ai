#include "table_mgr.h"

int mathC(int n,int m)
{
    int c_n = n;
    int c_m = 1;
    int n_i = 1;
    while(n_i < m)
    {
        c_n = c_n * (n - n_i);
        n_i = n_i + 1;
        c_m = c_m * n_i;
    }
    return c_n/c_m;
}

int get_score(char* outcards,char* handcards,struct table* t,int n, int m)
{
    int score = 0;

    for(int i=0;i<t->num;++i)
    {
        int br = 0;
        char* cards = t->items[i].cards;
        int c_A_a = 1;
        int total_need = 0;
        for(int card=0;card<27;++i)
        {
            int need = cards[card];
            if(need==0) continue;
            int left = 4 - handcards[card] - outcards[card];
            if(need > left){
                br = 1;
                break;
            }
            int lack = need - handcards[card];
            if(lack > 0){
                total_need += lack;
                c_A_a *= mathC(left, lack);
            }
        }
        if(br) continue;
        int c_need = 1;
        if(m>total_need) c_need = mathC(n-total_need, m-total_need);
        else if(m<total_need) c_need = 0;

        score = score + c_A_a * c_need;
    }

    return score;
}

char analyse(char* handcards,char* outcards)
{
    int m = 5;
    int n = 108;
    int sum = 0;
    int out_cards_sum = 0;
    for(int i=0;i<27;++i)
    {
          sum += handcards[i];
          out_cards_sum += outcards[i];
    }

    n = n - sum - out_cards_sum;
    int max_score = 0;
    int max_card = 0;
    struct table* t = table_mgr_get(sum);
    for(int i=0;i<27;++i)
    {
        if(handcards[i]==0) continue;
    
        --handcards[i];
        ++outcards[i];
        int score = get_score(outcards,handcards,t,n,m);
        if(score>max_score)
        {
            max_score = score;
            max_card = i;
        }
        ++handcards[i];
        --outcards[i];
    }
}
