%code requires{
#include <stdlib.h>
#include <string.h>
#include "tree.h"
}
%{
#include <stdio.h>
extern int yylex();
extern int yyparse();
extern FILE* yyin;
#include "tree.h"

void yyerror(node** nodeDest, const char* s);
%}
%define parse.error detailed
%parse-param {node** nodeDest}
%union{
	node* treeNode;
	char txt[500];
	child* nodeList;
}
%token<txt> AO C
%token<txt> MTO MTC
%token HO HC TO TC BO BC PO PC H1O H1C AC ULO ULC LIO LIC
%start I
%type<treeNode> R H T B I CNT H1 P A SC UL LSTI MT
%type<nodeList> CNTM SCM LST
%%
I				: R				{
								*nodeDest = $1;
								}
				;
R				: H B			{
								//printf("Making Root Node with Body and Head\n");
								node* rootNode = makeNode("root", "", "");
								attachNode(rootNode, $1);
								attachNode(rootNode, $2);
								$$ = rootNode;
								}
				| H				{
								//printf("Making Root Node with Head Only\n");
								node* rootNode = makeNode("root", "", "");
								attachNode(rootNode, $1);
								$$ = rootNode;
								}
				| B				{
								//printf("Making Root Node with Body Only\n");
								node* rootNode = makeNode("root", "", "");
								attachNode(rootNode, $1);
								$$ = rootNode;
								}
				;
H				: HO T HC		{
								//printf("Passing Up Head Node %s %s\n", $2->type, $2->value);
								node* headNode = makeNode("head", "", "");
								attachNode(headNode, $2);
								$$ = headNode;
								}
				| HO HC			{
								//printf("Passing Up Empty Head Node\n");
								node* headNode = makeNode("head", "", "");
								$$ = headNode;
								}
				;
T				: TO C TC		{
								node* titleNode = makeNode("title", $2, "");
								$$ = titleNode;
								}
				;
B				: BO CNTM BC	{
								// printf("Passing Up Body Node %s %s\n", $2->type, $2->value);
								node* bodyNode = makeNode("body", "", "");
								child* iter = $2;
								while(iter!=NULL){
									//printf("Iter! ");
									attachNode(bodyNode, iter->value);
									iter = iter->next;
								}
								$$ = bodyNode;
								}
				| BO BC			{
								//printf("Passing Up Empty Body Node\n");
								node* bodyNode = makeNode("body", "", "");
								$$ = bodyNode;
								}
				;
CNTM			: CNT			{
								//printf("Making List of Nodes\n");
								$$ = makeChild($1);
								}
				| CNT CNTM		{
								//printf("Expanding List of Content\n");
								child* iter = $2;
								while(iter->next!=NULL){
									iter=iter->next;
								}
								child* newChild = makeChild($1);
								iter->next = newChild;
								$$ = $2;
								}
				;
CNT				: P
				| H1
				| UL
				;
				;
P				: PO SCM PC		{
								node* bodyNode = makeNode("p", "", "");
								child* iter = $2;
								while(iter!=NULL){
									//printf("Iter! ");
									attachNode(bodyNode, iter->value);
									iter = iter->next;
								}
								$$ = bodyNode;
								}
				;
H1				: H1O SCM H1C	{
								node* bodyNode = makeNode("h1", "", "");
								child* iter = $2;
								while(iter!=NULL){
									//printf("Iter! ");
									attachNode(bodyNode, iter->value);
									iter = iter->next;
								}
								$$ = bodyNode;
								}
				;
UL				: ULO LST ULC	{
								node* ulNode = makeNode("ul", "", "");
								child* iter = $2;
								while(iter!=NULL){
									//printf("Iter! ");
									attachNode(ulNode, iter->value);
									iter = iter->next;
								}
								$$ = ulNode;
								}
				;
LST				: LSTI			{
								//printf("Making List of Nodes\n");
								$$ = makeChild($1);
								}
				| LSTI LST		{
								//printf("Expanding List of LI Nodes.\n");
								child* iter = $2;
								while(iter->next!=NULL){
									iter=iter->next;
								}
								child* newChild = makeChild($1);
								iter->next = newChild;
								$$ = $2;
								}
				;
LSTI			: LIO SCM LIC	{
								node* bodyNode = makeNode("li", "", "");
								child* iter = $2;
								while(iter!=NULL){
									//printf("Iter! ");
									attachNode(bodyNode, iter->value);
									iter = iter->next;
								}
								$$ = bodyNode;
								}
				;
SCM				: SC			{
								//printf("Making List of Stylized Content\n");
								$$ = makeChild($1);
								}
				| SC SCM		{
								//printf("Expanding List of Stylized Content\n");
								child* iter = $2;
								while(iter->next!=NULL){
									iter=iter->next;
								}
								child* newChild = makeChild($1);
								iter->next = newChild;
								$$ = $2;
								}
				;
SC				: C				{
								$$ = makeNode("normal", "", $1);
								}
				| A
				| MT
				;
A				: AO C AC		{
								//printf("Making A Node.\n");
								node* aNode = makeNode("a", $1, $2);
								$$ = aNode;
								}
				;	
MT				: MTO C MTC		{
								if(strcmp($1 + 1, $3 + 2) == 0){
									node* mtNode = makeNode($1, "", $2);
									$$ = mtNode;
								}else{
									yyerror(nodeDest, "Opening and Closing Tag Mismatch");
								}
								}
%%

int main() {
	yyin = stdin;
	node* nodeDest;
	yyparse(&nodeDest);
	/* printf("YYParse Called!\n"); */
	printBreadthFirst(nodeDest);
	/* do {
		yyparse(&nodeDest);
	} while(!feof(yyin)); */
	return 0;
}

void yyerror(node** nodeDest, const char* s) {
	fprintf(stderr, "Parse error: %s\n", s);
	exit(1);
}
