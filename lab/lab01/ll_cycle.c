#include <stddef.h>
#include "ll_cycle.h"

int ll_has_cycle(node *head) {
    /* your code here */
    node* rabbit = head;
    node* turtle = head;
    while (turtle != NULL && rabbit != NULL && rabbit->next != NULL) {
        rabbit = rabbit->next->next;
        turtle = turtle->next;
        if (turtle == rabbit) return 1;
    }
    return 0;
}
