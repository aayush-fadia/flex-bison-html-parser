#include "tree.h"

node* makeNode(char* type, char* property, char* value) {
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
    if (parent->children == NULL) {
        parent->children = newChild;
    } else {
        child* iter = parent->children;
        while (iter->next != NULL) {
            iter = iter->next;
        }
        iter->next = newChild;
    }
}

// int main(int argc, char const* argv[]) {
//     return 0;
// }
