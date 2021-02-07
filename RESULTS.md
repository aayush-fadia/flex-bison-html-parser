# Results

**For each test case, the following information is present:**

* The HTML Code that was  run through the parser
* The Debug Output of the entire parser,m that clearly shows the matched rules, and the Breadth First traversal of the Parsed Tree at the end.
The tree is printed in the format:
tag{property}(content)

for all tags, content is present only in the base level leaves, like noral for normal text, and for <b>, <strong> etc. Properties are present where tags have arguments, like the href for a and the size for font.

## Case 1: Valid HTML Code

HTML:

```html
<html>

<head>
    <title> I'm Title!! </title>
</head>

<body>
    <h1> Hi There! I am Heading! </h1>
    <p> Hi there! I am Paragraph! with some <b> Bold </b> text and a <a href="www.google.com"> hyperlink. </a> </p>
    <p>
        Another Paragraph with <font size=10> BIG TEXT </font>
    </p>
    <ul>
        <li> List Item 1</li>
        <li> List Item 2</li>
    </ul>
    <dl>
        <dt>Coffee</dt>
        <dd>Black hot drink</dd>
        <dt>Milk</dt>
        <dd>White cold drink</dd>
    </dl>
</body>

</html>
```

Parser Output:

```
--accepting rule at line 14 ("<html>")
--accepting rule at line 13 ("

")
--accepting rule at line 16 ("<head>")
--accepting rule at line 13 ("
    ")
--accepting rule at line 20 ("<title>")
--accepting rule at line 13 (" ")
--accepting rule at line 79 ("I'm Title!! ")
--accepting rule at line 21 ("</title>")
--accepting rule at line 13 ("
")
--accepting rule at line 17 ("</head>")
--accepting rule at line 13 ("

")
--accepting rule at line 18 ("<body>")
--accepting rule at line 13 ("
    ")
--accepting rule at line 22 ("<h1>")
--accepting rule at line 13 (" ")
--accepting rule at line 79 ("Hi There! I am Heading! ")
--accepting rule at line 30 ("</h1>")
HEADLINE 1, 1
--accepting rule at line 13 ("
    ")
--accepting rule at line 38 ("<p>")
--accepting rule at line 13 (" ")
--accepting rule at line 79 ("Hi there! I am Paragraph! with some ")
--accepting rule at line 71 ("<b>")
--accepting rule at line 13 (" ")
--accepting rule at line 79 ("Bold ")
--accepting rule at line 75 ("</b>")
--accepting rule at line 13 (" ")
--accepting rule at line 79 ("text and a ")
--accepting rule at line 40 ("<a href="www.google.com">")
--accepting rule at line 13 (" ")
--accepting rule at line 79 ("hyperlink. ")
--accepting rule at line 49 ("</a>")
--accepting rule at line 13 (" ")
--accepting rule at line 39 ("</p>")
--accepting rule at line 13 ("
    ")
--accepting rule at line 38 ("<p>")
--accepting rule at line 13 ("
        ")
--accepting rule at line 79 ("Another Paragraph with ")
--accepting rule at line 50 ("<font size=10>")
Parsed anchor tag with URL 10
--accepting rule at line 13 (" ")
--accepting rule at line 79 ("BIG TEXT ")
--accepting rule at line 59 ("</font>")
--accepting rule at line 13 ("
    ")
--accepting rule at line 39 ("</p>")
--accepting rule at line 13 ("
    ")
--accepting rule at line 60 ("<ul>")
--accepting rule at line 13 ("
        ")
--accepting rule at line 62 ("<li>")
--accepting rule at line 13 (" ")
--accepting rule at line 79 ("List Item 1")
--accepting rule at line 63 ("</li>")
--accepting rule at line 13 ("
        ")
--accepting rule at line 62 ("<li>")
--accepting rule at line 13 (" ")
--accepting rule at line 79 ("List Item 2")
--accepting rule at line 63 ("</li>")
--accepting rule at line 13 ("
    ")
--accepting rule at line 61 ("</ul>")
--accepting rule at line 13 ("
    ")
--accepting rule at line 64 ("<dl>")
--accepting rule at line 13 ("
        ")
--accepting rule at line 65 ("<dt>")
--accepting rule at line 79 ("Coffee")
--accepting rule at line 68 ("</dt>")
--accepting rule at line 13 ("
        ")
--accepting rule at line 66 ("<dd>")
--accepting rule at line 79 ("Black hot drink")
--accepting rule at line 69 ("</dd>")
--accepting rule at line 13 ("
        ")
--accepting rule at line 65 ("<dt>")
--accepting rule at line 79 ("Milk")
--accepting rule at line 68 ("</dt>")
--accepting rule at line 13 ("
        ")
--accepting rule at line 66 ("<dd>")
--accepting rule at line 79 ("White cold drink")
--accepting rule at line 69 ("</dd>")
--accepting rule at line 13 ("
    ")
--accepting rule at line 67 ("</dl>")
--accepting rule at line 13 ("
")
--accepting rule at line 19 ("</body>")
--accepting rule at line 13 ("

")
--accepting rule at line 15 ("</html>")
--(end of buffer or a NUL)
--EOF (start condition 0)
html{}()
head{}()
body{}()
title{}(I'm Title!! )
h{1}()
p{}()
p{}()
ul{}()
ul{}()
normal{}(Hi There! I am Heading! )
normal{}(Hi there! I am Paragraph! with some )
<b>{}(Bold )
normal{}(text and a )
a{www.google.com}(hyperlink. )
normal{}(Another Paragraph with )
font{10}(BIG TEXT )
li{}()
li{}()
dt{}()
dd{}()
dt{}()
dd{}()
normal{}(List Item 1)
normal{}(List Item 2)
normal{}(Coffee)
normal{}(Black hot drink)
normal{}(Milk)
normal{}(White cold drink)

```

The tree bfs traversal is as expected, listing the top level tags first, before their children.

## Case 2: Mismatched Tags

HTML:

```html
<html>

<head>
    <title> I'm Title!! </title>
</head>

<body>
    <h1> Hi There! I am Heading! </h1>
    <p> Hi there! I am Paragraph! with some <b> Bold </strong> text and a <a href="www.google.com"> hyperlink. </a> </p>
    <p>
        Another Paragraph with <font size=10> BIG TEXT </font>
    </p>
    <ul>
        <li> List Item 1</li>
        <li> List Item 2</li>
    </ul>
    <dl>
        <dt>Coffee</dt>
        <dd>Black hot drink</dd>
        <dt>Milk</dt>
        <dd>White cold drink</dd>
    </dl>
</body>

</html>
```

Parser Output:

```
--accepting rule at line 14 ("<html>")
--accepting rule at line 13 ("

")
--accepting rule at line 16 ("<head>")
--accepting rule at line 13 ("
    ")
--accepting rule at line 20 ("<title>")
--accepting rule at line 13 (" ")
--accepting rule at line 79 ("I'm Title!! ")
--accepting rule at line 21 ("</title>")
--accepting rule at line 13 ("
")
--accepting rule at line 17 ("</head>")
--accepting rule at line 13 ("

")
--accepting rule at line 18 ("<body>")
--accepting rule at line 13 ("
    ")
--accepting rule at line 22 ("<h1>")
--accepting rule at line 13 (" ")
--accepting rule at line 79 ("Hi There! I am Heading! ")
--accepting rule at line 30 ("</h1>")
HEADLINE 1, 1
--accepting rule at line 13 ("
    ")
--accepting rule at line 38 ("<p>")
--accepting rule at line 13 (" ")
--accepting rule at line 79 ("Hi there! I am Paragraph! with some ")
--accepting rule at line 71 ("<b>")
--accepting rule at line 13 (" ")
--accepting rule at line 79 ("Bold ")
--accepting rule at line 75 ("</strong>")
Parse error: Opening and Closing Tag Mismatch
```

In this case, the HTML code had non matching tags, so the Parser could not generate a tree. Instead, a useful error message was displayed, stating that the tags were mismatched, with a clear indication of which one, right above.

## Case 3: Mismatched Headers

HTML:

```html
<html>

<head>
    <title> I'm Title!! </title>
</head>

<body>
    <h1> Hi There! I am Heading! </h2>
    <p> Hi there! I am Paragraph! with some <b> Bold </strong> text and a <a href="www.google.com"> hyperlink. </a> </p>
    <p>
        Another Paragraph with <font size=10> BIG TEXT </font>
    </p>
    <ul>
        <li> List Item 1</li>
        <li> List Item 2</li>
    </ul>
    <dl>
        <dt>Coffee</dt>
        <dd>Black hot drink</dd>
        <dt>Milk</dt>
        <dd>White cold drink</dd>
    </dl>
</body>

</html>
```

Parser Output:

```
--accepting rule at line 14 ("<html>")
--accepting rule at line 13 ("

")
--accepting rule at line 16 ("<head>")
--accepting rule at line 13 ("
    ")
--accepting rule at line 20 ("<title>")
--accepting rule at line 13 (" ")
--accepting rule at line 79 ("I'm Title!! ")
--accepting rule at line 21 ("</title>")
--accepting rule at line 13 ("
")
--accepting rule at line 17 ("</head>")
--accepting rule at line 13 ("

")
--accepting rule at line 18 ("<body>")
--accepting rule at line 13 ("
    ")
--accepting rule at line 22 ("<h1>")
--accepting rule at line 13 (" ")
--accepting rule at line 79 ("Hi There! I am Heading! ")
--accepting rule at line 30 ("</h2>")
Parse error: Headers Mismatch
```

In this case, the HTML code had non matching tags, so the Parser could not generate a tree. Instead, a useful error message was displayed, stating that the headers were mismatched, with a clear indication of which one, right above.


## Case 3: Malformed HTML

HTML:

```html
<html>

<head>
    <title> I'm Title!! </title>

<body>
    <h1> Hi There! I am Heading! </h1>
    <p> Hi there! I am Paragraph! with some <b> Bold </strong> text and a <a href="www.google.com"> hyperlink. </a> </p>
    <p>
        Another Paragraph with <font size=10> BIG TEXT </font>
    </p>
    <ul>
        <li> List Item 1</li>
        <li> List Item 2</li>
    </ul>
    <dl>
        <dt>Coffee</dt>
        <dd>Black hot drink</dd>
        <dt>Milk</dt>
        <dd>White cold drink</dd>
    </dl>
</body>

</html>
```

Parser Output:

```
--accepting rule at line 14 ("<html>")
--accepting rule at line 13 ("

")
--accepting rule at line 16 ("<head>")
--accepting rule at line 13 ("
    ")
--accepting rule at line 20 ("<title>")
--accepting rule at line 13 (" ")
--accepting rule at line 79 ("I'm Title!! ")
--accepting rule at line 21 ("</title>")
--accepting rule at line 13 ("

")
--accepting rule at line 18 ("<body>")
Parse error: syntax error, unexpected BO, expecting HC
```

Here the head tag was not closed, and the parser rightly prints out the error message.