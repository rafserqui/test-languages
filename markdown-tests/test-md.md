# A Markdown Test and Tutorial

## Italics and Bold

- Underscores (`_word_`) are for _italics_.
- Asterisks (`**word**`) are for **bold**.
- We can use both at the same time: *_both italics and bold_*.

## Headers

Headers are denoted with asterisks `#`,additional asterisks denote different levels of headers.

~~~~markdown
# Header 1
## Header 2
### Header 3
#### Header 4
...
~~~~

We can italicize some words in a header as follows:

`#### A Header with _Italic Words_`

which would look like:

### A Header with _Italic Words_

## Links

To make links to websites we use square and round brackets. Square brackets are for the words linking to the website and the round brackets for the link itself. Here's a [link to GitHub](www.github.com).

`[link to GitHub](www.github.com)`

We can also make links to websites using tags. Suppose we want to reference several times the World Bank Database. We can create a tag for it `[worldbank database]: data.worldbank.org`. Here's the result.

We want to link to the [World Bank][worldbank database] several times. Now we reference it again [World Bank Database][worldbank database].

[worldbank database]: data.worldbank.org

## Images

Images also have two styles, just like links, and both of them render the exact same way. The difference between links and images is that images are prefaced with an exclamation point (`!`).

The first image style is called an inline image link. To create an inline image link, enter an exclamation point (`!`), wrap the alt text in brackets (`[ ]`), and then wrap the link in parenthesis (`( )`). (Alt text is a phrase or sentence that describes the image for the visually impaired.)

For example, to create an inline image link to [https://octodex.github.com/images/bannekat.png](https://octodex.github.com/images/bannekat.png), with an alt text that says, Benjamin Bannekat, you'd write this in Markdown: `![Benjamin Bannekat](https://octodex.github.com/images/bannekat.png)`. Here it is

![Benjamin Bannekat](https://octodex.github.com/images/bannekat.png)

As before, we can create tags for images.

Here's the World Bank Logo

![World Bank logo][WB Logo]

[WB Logo]:https://media-exp1.licdn.com/dms/image/C560BAQHaSQcYJGhexg/company-logo_200_200/0?e=2159024400&v=beta&t=dH3D0_ZTXZWMiB8wMoyXrfO04Mk-d88vquJBDUGfhB8

And here again without copying the link:

![WBlogo][WB Logo]

## Block Quotes

We can create block quotes using `>`.

~~~~ markdown
> Un Anillo para gobernarlos a todos. Un Anillo para encontrarlos, un Anillo para atraerlos a todos y atarlos en las tinieblas.
~~~~

> Un Anillo para gobernarlos a todos. Un Anillo para encontrarlos, un Anillo para atraerlos a todos y atarlos en las tinieblas.

## Lists

Unordered lists:

~~~~ markdown
* Milk
* Eggs
* Salmon
* Butter
~~~~

- Milk
- Eggs
- Salmon
- Butter

With sublists:

~~~~ markdown
- Shopping list:
  - Milk
  - Eggs
  - Salmon
  - Butter
- Other stuff:
  - Stuff 1
  - Stuff 2
~~~~

- Shopping list:
  - Milk
  - Eggs
  - Salmon
  - Butter
- Other stuff:
  - Stuff 1
  - Stuff 2

Ordered lists:

~~~~ markdown
1. Element 1
2. Element 2
3. Element 3
4. Element 4
~~~~

1. Element 1
2. Element 2
3. Element 3
4. Element 4

Ordered sublists just indent with 4 spaces (1 tab)

1. Dog
    1. German Shepherd
    2. Belgian Shepherd
        1. Malinois
        2. Groenendael
        3. Tervuren
2. Cat
    1. Siberian
    2. Siamese
