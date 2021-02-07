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
%token<txt> AO C FO
%token<txt> MTO MTC H1O H1C
// D-Document (html) H-Head B-Body And the rest of the names are simply tag followed by O for opening and C for close. 
// LST type names hold collections of nodes, which they pass up to parent nodes.
%token DO DC HO HC TO TC BO BC PO PC AC ULO ULC LIO LIC FC DTO DTC DDO DDC DLO DLC
%start I
%type<treeNode> R H T B I CNT H1 P A SC UL LSTI MT F DT DD DLSTI DL
%type<nodeList> CNTM SCM LST DLST
%%
// The making of the tree:
// The tree is generated bottom up, as each tag becomes the parent of the tag below it, and passes itself upwards to be parented by anpother tag.
//Initial State, to pass param back to main.
I				: R				{
								*nodeDest = $1;
								}
				;
R				: DO H B DC			{
								//printf("Making Root Node with Body and Head\n");
								node* rootNode = makeNode("html", "", "");
								attachNode(rootNode, $3);
								attachNode(rootNode, $2);
								$$ = rootNode;
								}
				| DO H DC		{
								//printf("Making Root Node with Head Only\n");
								node* rootNode = makeNode("root", "", "");
								attachNode(rootNode, $2);
								$$ = rootNode;
								}
				| DO B DC		{
								//printf("Making Root Node with Body Only\n");
								node* rootNode = makeNode("root", "", "");
								attachNode(rootNode, $2);
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
								node* titleNode = makeNode("title", "", $2);
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
				| DL
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
								if(strcmp($1, $3) == 0){
								printf("HEADLINE %s, %s\n", $1, $3);
								node* bodyNode = makeNode("h", $1, "");
								child* iter = $2;
								while(iter!=NULL){
									//printf("Iter! ");
									attachNode(bodyNode, iter->value);
									iter = iter->next;
								}
								$$ = bodyNode;
								}else{
									yyerror(nodeDest, "Headers Mismatch");
								}
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
DL				: DLO DLST DLC	{
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
DLST			: DLSTI			{
								//printf("Making List of Nodes\n");
								$$ = makeChild($1);
								}
				| DLSTI DLST	{
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
DLSTI			: DT 
				| DD			
				;
DT				: DTO SCM DTC	{
								node* bodyNode = makeNode("dt", "", "");
								child* iter = $2;
								while(iter!=NULL){
									//printf("Iter! ");
									attachNode(bodyNode, iter->value);
									iter = iter->next;
								}
								$$ = bodyNode;
								}
				;
DD				: DDO SCM DDC	{
								node* bodyNode = makeNode("dd", "", "");
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
				| F
				| MT
				;
A				: AO C AC		{
								//printf("Making A Node.\n");
								node* aNode = makeNode("a", $1, $2);
								$$ = aNode;
								}
				;
F				: FO C FC		{
								//printf("Making A Node.\n");
								node* aNode = makeNode("font", $1, $2);
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
