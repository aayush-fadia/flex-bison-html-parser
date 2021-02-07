#include "tree.h"

node* makeNode(char* type, char* property, char* value) {
    // printf("Making Node with %s, %s, %s\n", type, property, value);
    node* newNode = (node*)malloc(sizeof(node));
    strcpy(newNode->type, type);
    strcpy(newNode->property, property);
    strcpy(newNode->value, value);
    newNode->children = NULL;
    return newNode;
}

child* makeChild(node* value) {
    child* newChild = (child*)malloc(sizeof(child));
    newChild->value = value;
    newChild->next = NULL;
    return newChild;
}

void attachNode(node* parent, node* childNode) {
    child* newChild = makeChild(childNode);
    childNode->parent = parent;
    newChild->next = parent->children;
    parent->children = newChild;
    // child* prevChildren = parent->children;
    // if (parent->children == NULL) {
    //     parent->children = newChild;
    // } else {
    //     child* iter = parent->children;
    //     while (iter->next != NULL) {
    //         iter = iter->next;
    //     }
    //     iter->next = newChild;
    // }
}

void printBreadthFirst(node* root) {
    child* iter = makeChild(root);
    child* tail = iter;
    while (iter != NULL) {
        node* curNode = iter->value;
        child* curNodeIter = curNode->children;
        while (curNodeIter != NULL) {
            child* queueElement = makeChild(curNodeIter->value);
            tail->next = queueElement;
            curNodeIter = curNodeIter->next;
            tail = tail->next;
        }
        printf("%s(%s) ", curNode->type, curNode->value);
        iter = iter->next;
    }
    printf("\n");
}
// int main(int argc, char const* argv[]) {
//     return 0;
// }
