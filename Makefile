all: html

html.tab.c html.tab.h:	html.y
	bison -t -v -d -Wcounterexamples html.y

lex.yy.c: html.l html.tab.h
	flex -d html.l

html: lex.yy.c html.tab.c html.tab.h
	gcc -o html html.tab.c lex.yy.c

clean:
	rm html html.tab.c lex.yy.c html.tab.h html.output
