struct table_item {
    char cards[34];
};

struct table {
    struct table_item* items;
    int num;
};

void table_mgr_init();

void table_mgr_load();

struct table* table_mgr_get();
