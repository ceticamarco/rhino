<div align="center">
<h1>Rhino 🦏</h1>
    
<h6><i>Simple markup language for building static websites</i></h6>

[![](https://github.com/ceticamarco/rhino/actions/workflows/build.yml/badge.svg)](https://github.com/ceticamarco/rhino/actions/workflows/build.yml)
[![](https://github.com/ceticamarco/rhino/actions/workflows/tests.yml/badge.svg)](https://github.com/ceticamarco/rhino/actions/workflows/tests.yml)
[![](https://github.com/ceticamarco/rhino/actions/workflows/linter.yml/badge.svg)](https://github.com/ceticamarco/rhino/actions/workflows/linter.yml)

</div>

**Rhino** is a simple markup language for publishing static websites such as blogs, personal portfolio, landing pages or web documents.
Its syntax is somehow similar to Markdown's, making it very easy to learn and to use. To convert Rhino documents to HTML, you can use
the Rhino compiler, which translates your content into a functional webpage starting from a preexisting
template file. This markup language was primarily built to publish [my blog](http://marcocetica.com) due to the fact that I was too tired to manually write HTML when I was just 
trying to write an article, but I've also successfully used it for building other static projects as well.

## Syntax Overview
As mentioned earlier, Rhino's syntax is quite easy to gasp and to remember. For instance, to define a new section with a formatted text, you can
write:

```text
%#Installation%
Be sure %*carefully% read the following statement %_before% installing the program %Ifoo-bar%:

%CTHE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND%
```

which will be compiled to:
```html
<h2 class="post-subtitle">Installation</h2>
<div class="sp"></div>
Be sure <b>carefully</b> read the following statement <i>before</i> installing the program <code class="inline-code">foo-bar</code>:

<blockquote>
<div class="cursor">></div>
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND
</blockquote>
```

In this short snippet, we have defined a new header called _"Installation"_(denoted by the `#` token), an italic and a bold 
formatting(denoted by the `_` and the `*` tokens, respectively) and a blockquote using the `C` token. 

As you see, every element of the Rhino language must be wrapped around a `%` token which denotes the beginning and the end of the formatting. 

## Rhino Markup Language
- **bold formatting**
```text
%*<BOLD TEXT>%
```

- **italic formatting**
```text
%_<ITALIC TEXT>%
```

- **link**
```text
%[<LINK TEXT>](<URL>)%
```

- **picture**
```text
%![<ALT TEXT>](<URL>)%
```

- **heading**
```text
%#<HEAD TEXT>%
```

- **inline code snippet**
```text
%I<INLINE CODE>%
```

- **link to referement**
```text
%><REF_NUMBER>%
```

- **inline math expression**
```text
%m<MATH_EXPRESSION>%
```

- **citation**
```text
%C<CITATION>%
```

- **referement**
```text
%<<REF_NUMBER><REF_TEXT>%
```

- **code block**
```text
%B<LANG_NAME>
<CODE_SNIPPET>
B%
```

- **math expression block**
```text
%M
<MATH_EXPR>
M%
```

- **Special characters**
```
%p% -> %
%$% -> $
```

- **Ordered list**
```text
%O<ITEM>%
%O<ITEM>%
%O<ITEM>%
```

> [!TIP]
> Lists can be nested

- **Unordered list**
```text
%U<ITEM>%
%U<ITEM>%
%U<ITEM>%
```

- **Tables**
```text
%T
HA$B$C$D%
RFirst$Second$Third$Fourth%
RI$II$III$IV%
%
```
where `H` stands for a _new header_ and `R` stands for a _new row_.


- **Div**
```text
%d<DIV_ID>$<DIV_CLASS>$<STYLE>
    <NESTED_CONTENT>
%
```

> [!WARNING]
> `<DIV_ID>`, `<DIV_CLASS>` and `<STYLE>` are optional and can be omitted.
> The parser expects **two** `$` token, though.

## Template file
The Rhino compiler requires an additional HTML document called _template file_, which serves as a skeleton of the output webpage. 
This file defines the structure and the appearance of the final webpage and it's used as a base during the compilation process. 
The template file can be freely structured and stylized but it must includes the following properties:

- `%%TIMESTAMP%%`: Template engine timestamp;  
- `%%DESCRIPTION%%`:`<meta>` _description_ tag;  
- `%%TAGS%%`: `<meta>` _tags_ tag;  
- `%%HEAD_TITLE%%`: Page title;  
- `%%DATE%%`: Post date;  
- `%%CONTENT%%`: The actual content of the page.

There is no required order for listing these properties inside your template file, you can move them wherever you want  according to your needs.
Below, there's a sample template file you can use as a skeleton to create your own:

```html
<!DOCTYPE html>
<html lang="en">
%%TIMESTAMP%%
    <head>
        <!-- Meta attributes -->
        <meta charset="utf-8">
        <meta http-equiv="content-type" content="text/html; charset=utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0" />
        <meta name="description" content="%%DESCRIPTION%%" />
        <meta name="keywords" content="%%TAGS%%" />
        <!-- CSS -->
        <link rel="stylesheet" href="/static/style.css" />
        <!-- Title -->
        <title>%%HEAD_TITLE%% :: My Website</title>
    </head>
    
    <body>
        <h1>%%TITLE%%</h1>
        <div>%%DATE%%</div>
        <div>
            %%CONTENT%%
        </div>
    </body>
</html>
```

## Rhino files
Rhino files are the entrypoint of the compilation process. The compiler converts these files into static HTML pages, using the template file
as a foundation. To specify the page _metadata_(such as the title, date, tags, etc.) you need to define a dedicated section
of the source document called _"header"_. 

The header is a special section of a Rhino document that must includes the following entries:

```text
#+HEAD_TITLE: Head section title
#+TITLE: Body title
#+DESCRIPTION: Meta description tag
#+DATE: 1970-01-01
#+TAGS: foo, bar, biz

```

The first five lines of any Rhino file are reserved for these fields. If you would like to omit one or more
fields(e.g., if the page does not require a date), you can simply leave the field empty, that is:

```text
#+HEAD_TITLE: Head section title
#+TITLE: Body title
#+DESCRIPTION: Meta description tag
#+DATE: 
#+TAGS: foo, bar, biz
```

> [!CAUTION]
> The header section **must always be explicitly defined(in this order)**, regardless 
> of whether you plan to show it on the resulting page
> or not. The Rhino compiler does not provide any default or fallback values for missing header fields.

## Compiler
In this section we will see how to build and how to use the Rhino compiler, which is used to translates Rhino source files
into static HTML documents.

### Installation
The Rhino compiler is written in Haskell. To build it you will need a recent version of the _Glasgow Haskell Compiler_(GHC) and
a recent version of _Cabal_, refer to [this page](https://www.haskell.org/ghcup/) to learn more. 

After that, you will be able to build the Rhino compiler by issuing the following command within the root of this repository:
```sh
$> cabal build
Resolving dependencies...
Build profile: -w ghc-9.6.7 -O1
In order, the following will be built (use -v for more details):
 - rhino-0.1.0.4 (lib:rhino-lib) (first run)
 - rhino-0.1.0.4 (exe:rhino) (first run)
Configuring library 'rhino-lib' for rhino-0.1.0.4...
Preprocessing library 'rhino-lib' for rhino-0.1.0.4...
Building library 'rhino-lib' for rhino-0.1.0.4...
[1 of 5] Compiling Paths_rhino      ( Paths_rhino.o, Paths_rhino.dyn_o )
[2 of 5] Compiling Types            ( src/Types.hs, Types.o, Types.dyn_o )
[3 of 5] Compiling Emitter          ( src/Emitter.hs, Emitter.o, Emitter.dyn_o )
[4 of 5] Compiling Parser           ( src/Parser.hs, Parser.o, Parser.dyn_o )
[5 of 5] Compiling Engine           ( src/Engine.hs, Engine.o, Engine.dyn_o )
Configuring executable 'rhino' for rhino-0.1.0.4...
Preprocessing executable 'rhino' for rhino-0.1.0.4...
Building executable 'rhino' for rhino-0.1.0.4...
[1 of 1] Compiling Main             ( app/Main.hs, Main.o )
[2 of 2] Linking rhino
```

You will find a statically linked binary executable inside the `dist-newstyle` directory. 
To copy it to the root of the repository, exec the following command:
```sh
$> cp "$(cabal exec --offline sh -- -c 'command -v rhino')" .
```

### Usage
The Rhino compiler can be used directly from the command line:
```text
rhino v0.1.0.4 by Marco Cetica (c) 2025

Usage: rhino (-s|--src SRC_DIR) (-o|--output OUT_DIR) (-t|--template TEMPLATE) 
             [-v|--verbose]

  rhino - markup language for building static websites

Available options:
  -s,--src SRC_DIR         Specify source directory
  -o,--output OUT_DIR      Specify output directory
  -t,--template TEMPLATE   Specify template file
  -v,--verbose             Enable verbose mode
  -h,--help                Show this help text
```

Basic usage involves specifying three components: 
1. The source directory(containing one or more Rhino files);  
2. The output directory(where compiled Rhino files will be saved);  
3. An HTML template.

That is:

```sh
$> ./rhino -s src/ -o html/ -t template.html -v
Publishing src/syntax_test...
```

This will create a new directory inside `html` called `syntax_test` containing a file called `index.html`(i.e., the compiled Rhino file). The Rhino compiler generates 
a new directory **for each Rhino file** in the source directory, using the filename as the output directory. For example, consider  a source directory
called `articles` with the following content inside:

```sh
$> tree articles
articles
├── foo
├── bar
├── biz
```

the compiler - when invoked with `./rhino -s articles -o website/posts -t template.html -v` - will generate 
the following directories inside `website/posts/`:
```sh
$> tree website/posts
posts
├── foo
│   └──index.html
├── bar
│   └── index.html
├── biz
│   └── index.html
```

As you can see, each directory contains an unique `index.html` file. This allows users to access each page using only the
page name(i.e., `http://website.com/foo`) instead of the full URI(i.e., `http://example.com/foo/foo_page.html`).

The Rhino compiler can also generate an _index page_. To do this, you need to create a source directory containing a Rhino file
called **index**(without an extension). For example, to generate an index page for the previously mentioned `posts` directory, 
you can create a new source directory containing a single `index` file, that is:

```sh
$> mkdir -p posts
$> touch posts/index # Edit file as needed
$> ./rhino -s posts -o website/posts -t template.html -v
Publishing website/posts/index...
```

This will generate a new file called `index.html` inside `website/posts` **WITHOUT** creating a new directory. That is:
```sh
$> tree website/posts
posts
├── foo
│   └──index.html
├── bar
│   └── index.html
├── biz
│   └── index.html
├── index.html
```

## Error reporting
The Rhino compiler can also detect syntax errors, such as missing closing tokens or misplaced characters, providing the line and the column number
of the error along with suggested fixes. Consider the following Rhino file:

```text
#+HEAD_TITLE: Contact me
#+TITLE: Contact Me
#+DESCRIPTION: Get in touch with me
#+DATE: 1970-01-01
#+TAGS: email, phone, instant-messaging


You can send me an email at the %[following address](mailto:foo@example.com)

I will try to reply as soon as possible!
```

In this example, the link does not include the enclosing character `%`. If we try to compile it, the compiler will yield the following message:
```text
Publishing src/contact...
Error processing file 'src/contact' @ 8:77:
  |
8 | You can send me an email at the %[following address](mailto:foo@example.com)
  |                                                                             ^
unexpected newline
expecting '%'
```

## Custom emitter
By default, Rhino emits HTML tags that are compatible with the CSS classes of my blog. To adapt them to your use cases, you need to modify the
source file `app/Emitter.hs`. For instance, to update the class of the _code_ element from `inline-code` to `myCustomClass`, edit the `headGenerator`
method as follows:
```haskell
icodeGenerator :: Text -> Text
icodeGenerator text = "<code class=\"myCustomClass\">" <> text <> "</code>"
```

> [!WARNING]
> Modifying an existing emitter will cause a unit test to fail. 
> Make sure to update the tests accordingly.

## A complete example
Let's now see a complete example:
```text
#+HEAD_TITLE: Head section title
#+TITLE: Body title
#+DESCRIPTION: Meta description tag
#+DATE: 1970-01-01
#+TAGS: foo, bar, biz

%#Welcome%

%dwelcomeBanner$centered
%![welcome image](/static/welcome.jpg)%

Welcome to my website! To get in touch with me, you can:

%UWrite me an %[email](mailto:john@example.com)%%
%USend me a handwritten letter%
%

TODO list:

%OHouse
%OCleaning%
%OCooking%
%OReading%
%
%OWork
%OBrainstorming%
%ORefactoring%
%OTraining%
%

%*Lorem ipsum% dolor sit amet, consectetur adipiscing elit. Cras ornare urna et eros dictum maximus.
Nunc sit amet eros ac mauris placerat luctus. Integer eget nulla lacus. Nulla finibus non ante eget volutpat.
Maecenas vestibulum mi vitae lectus ultrices vehicula.
Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae;

%#Print on the console%
In Python, you can use %Iprint("Hello World");%, while in Java%>1%, you can say:

%Bjava
public static void main(String[] args) {
    System.out.println("Hello World");
}
B%


%#Lie algebra%
%CA %*Lie algebra% is a vector space %mg% over a %_field% %mF% together with an operation called %*Lie bracket%%

%#Fermat's Last Theorem%
%M
a^n + b^n = c^n
M%


%T
HA$B$C$D%
RFirst$Second$Third$Fourth%
RI$II$III$IV%
%


%#Footnotes%
%<1Define this function inside the %Imain% class%
```

which produces the following HTML page:

```html
<!DOCTYPE html>
<html lang="en">
	<!--
	Powered by Rhino Template Engine(v0.1.0.5)
	Developed by Marco Cetica
	Timestamp: 2025-04-17T09:02:14-->
    <head>
        <!-- Meta attributes -->
        <meta charset="utf-8">
        <meta http-equiv="content-type" content="text/html; charset=utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0" />
        <meta name="description" content="Meta description tag" />
        <meta name="keywords" content="foo, bar, biz" />
        <!-- CSS -->
        <link rel="stylesheet" href="/static/style.css" />
        <!-- Title -->
        <title>Head section title :: My Website</title>
    </head>
    
    <body>
        <h1>Body title</h1>
        <div>1970-01-01</div>
        <div>
            
<h2 id="Welcome" class="post-subtitle">Welcome <a class="head-tag" href="#Welcome">§</a></h2>
<div class="sp"></div>

<div id="welcomeBanner" class="centered">
<img class="post-img" alt="welcome image" src="/static/welcome.jpg" width="800" height="600">

Welcome to my website! To get in touch with me, you can:

<ul>
<li>Write me an <a href="mailto:john@example.com">email</a></li>
<li>Send me a handwritten letter</li>
</ul></div>

TODO list:

<ol>
<li>House
<ol>
<li>Cleaning</li>
<li>Cooking</li>
<li>Reading</li>
</ol></li>
<li>Work
<ol>
<li>Brainstorming</li>
<li>Refactoring</li>
<li>Training</li>
</ol></li>
</ol>
<b>Lorem ipsum</b> dolor sit amet, consectetur adipiscing elit. Cras ornare urna et eros dictum maximus.
Nunc sit amet eros ac mauris placerat luctus. Integer eget nulla lacus. Nulla finibus non ante eget volutpat.
Maecenas vestibulum mi vitae lectus ultrices vehicula.
Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae;

<h2 id="Print_on_the_console" class="post-subtitle">Print on the console <a class="head-tag" href="#Print_on_the_console">§</a></h2>
<div class="sp"></div>
In Python, you can use <code class="inline-code">print("Hello World");</code>, while in Java<sup>[<a id="ref-1" href="#foot-1">1</a>]</sup>, you can say:

<pre>
<code class="language-java">
public static void main(String[] args) {
    System.out.println("Hello World");
}
</code></pre>


<h2 id="Lie_algebra" class="post-subtitle">Lie algebra <a class="head-tag" href="#Lie_algebra">§</a></h2>
<div class="sp"></div>
<blockquote>
<div class="cursor">></div>
A <b>Lie algebra</b> is a vector space \(g\) over a <i>field</i> \(F\) together with an operation called <b>Lie bracket</b>
</blockquote>

<h2 id="Fermat's_Last_Theorem" class="post-subtitle">Fermat's Last Theorem <a class="head-tag" href="#Fermat's_Last_Theorem">§</a></h2>
<div class="sp"></div>
$$
a^n + b^n = c^n
$$


<table>
<thead>
<tr>
<th>A</th>
<th>B</th>
<th>C</th>
<th>D</th>
</tr>
</thead>
<tbody>
<tr>
<td>First</td>
<td>Second</td>
<td>Third</td>
<td>Fourth</td>
</tr>
<tr>
<td>I</td>
<td>II</td>
<td>III</td>
<td>IV</td>
</tr>
</tbody>
</table>


<h2 id="Footnotes" class="post-subtitle">Footnotes <a class="head-tag" href="#Footnotes">§</a></h2>
<div class="sp"></div>
<p id="foot-1">[1]: Define this function inside the <code class="inline-code">main</code> class <a href="#ref-1">&#8617;</a></p>

        </div>
    </body>
</html>
```

## License
This software is released under the GPLv3 license. You can find a copy of the license with this repository or by visiting the [following page](https://choosealicense.com/licenses/gpl-3.0/).
