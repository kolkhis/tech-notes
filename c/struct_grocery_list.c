#include <assert.h>
#include <string.h>
#include <stdlib.h>

/* A "dynamic" array of strings. */
/*     This struct is a *FIXED SIZE* */ 
/*     This is because it doesn't CONTAIN a list. */
/*     It holds a POINTER to a list. */
typedef struct this_is_optional {
    int num_needed;
    char **needed;
    // Or:
    /* int *needed[]; */

    int spent;
    /* int budget; */
} grocery_list_t;

// Strings are null-terminated.
/* void append_to_list(grocery_list_t *list, char *str) { list->size++; } */

int grocery_find_needed(grocery_list_t *g, char *item)
{
    for (int i = 0; i < g->num_needed; i++) {
        /* if (strcmp(g->needed[i], item) == 0) { */
        char *needed_item = g->needed[i];
        if (0 == strcmp(needed_item, item)) {
            return i;
        }
    }
    return -1;
}

void purchase_item(grocery_list_t *g, char *item, int price) {
    // Find the item in needed
    int index = grocery_find_needed(g, item);
    if (index == -1) {
        // TODO: Think about error handling.
        return;
    }
    // Remove the item from needed
    int new_size = g->num_needed - 1;
    char **new_items = malloc(new_size * sizeof(char *)); /* <stdlib.h> */

    // Up to index
    for (int i = 0; i < index; i++) {
        new_items[i] = g->needed[i];
    }

    // After index, to the end
    for (int i = index + i; i < g->num_needed; i++) {
        new_items[i - 1] = g->needed[i];
    }

    // Clean up!!
    char **old_items = g->needed;
    free(old_items);

    g->num_needed--;
    g->needed = new_items;
    g->spent += price;
    // -> is for pointers, . is for structs (struct access).
}


int main() {
    char **items = {0};

    // We can put a grocery list ON THE STACK.
    assert(sizeof(grocery_list_t) == 16);

    // We don't have to free our string_list_t
    // BUT, we do need to free the items.

    return 0;
}

