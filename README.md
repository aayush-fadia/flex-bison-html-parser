# flex/bison HTML Parser

## What is it?

This flex/bison code generates an HTML parser that can parse a subset of HTML into an n-ary tree. It can also validate an HTML and inform the user if their HTML is not well formed.

## Running

Compile using the `Makefile`

```bash
make clean && make all
```
Then run using 
```bash
./html < test.html
```
## File Details

`html.l` The lexer-generator, makes C code that will parse the HTML input into meaningful specific tokens, and add pass information to the bison code.

`html.y` Specifies the Context Free Grammar that HTML has to follow, and provides hooks when a rule is matched. The tree is created in these hooks.

`tree.c & tree.h` These contain the functions to create, manipulate, and print the tree.

`Makefile` Standard Makefile, contains ommands to build and execute the source.

`test.html` The HTML file used to test the code.
