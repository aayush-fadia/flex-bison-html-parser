%{

#include <stdio.h>
#include <stdlib.h>
#include "tree.h"
extern int yylex();
extern int yyparse();
extern FILE* yyin;

void yyerror(const char* s);
%}

%token C HO HC TO TC BO BC 
%start R

%%

R				: H B
				| H
				| B
				|
				;
H				: HO T HC
				| HO HC
				;
T				: TO C TC
				;
B				: BO C BC
				| BO BC

%%

int main() {
	yyin = stdin;

	do {
		yyparse();
	} while(!feof(yyin));

	return 0;
}

void yyerror(const char* s) {
	fprintf(stderr, "Parse error: %s\n", s);
	exit(1);
}
