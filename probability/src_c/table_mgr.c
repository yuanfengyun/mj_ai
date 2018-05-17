#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "table_mgr.h"

struct table tables[5];

struct table* init_table(int i,int num)
{
    struct table* t = &tables[i];
    t->items = malloc(sizeof(struct table_item)*num);
    memset(t->items,0,sizeof(struct table_item)*num);
    t->num = num;
}

void table_mgr_init()
{
    init_table(0,27);
    init_table(1,1269);
    init_table(2,29718);
    init_table(3,459177);
    init_table(4,5237550);
}

void split(char* cards, int k)
{
    for(int i=8;i>=0;--i)
    {
        int bit = 3*i;
        int n = (k&(7<<bit))>>bit;
        cards[8-i] = n;
    }
}

void load_one(int i)
{
    char filename[256];
    sprintf(filename,"../table/table_%d.tbl",i*3+2);
    FILE* f = fopen(filename, "r");
    if(!f){
      printf("打开文件%s失败\n",filename);
      return;
    }
    struct table* t = &tables[i];
    for(int n=0;n<t->num;++n)
    {
      int k[]={0,0,0};
      fscanf(f,"%ld %ld %ld\n",&k[0],&k[1],&k[2]);
      char* cards = t->items[n].cards;
      for(int i=0;i<3;++i){
        split(cards, i*9);
      }
    }
}

void table_mgr_load()
{
    for(int i=0;i<=4;++i)
    {
        load_one(i);
    }
}

struct table* table_mgr_get(int num)
{
    return &tables[(num-2)/3];
}
