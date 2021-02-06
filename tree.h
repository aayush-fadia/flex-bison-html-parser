#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#ifndef TREE_H
#define TREE_H

struct childrenLLNode;
typedef struct treeNode {
    char* type;
    char* property;
    char* value;
    struct childrenLLNode* children;
    struct treeNode* parent;
} node;

typedef struct childrenLLNode {
    struct childrenLLNode* next;
    node* value;
} child;

node* makeNode(char* type, char* property, char* value);

child* makeChild(node* value);

void attachNode(node* parent, node* childNode);

#endif