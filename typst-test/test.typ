#import "template.typ": *

// Take a look at the file `template.typ` in the file panel
// to customize this template and discover how it works.
#show: project.with(
  title: "Test Document",
  authors: (
    (name: "Rafael Serrano-Quintero", email: "rafael.serrano@ub.edu", affiliation: "University of Barcelona"  ),
  ),
  // Insert your abstract after the colon, wrapped in brackets.
  // Example: `abstract: [This is my abstract...]`
  date: "September, 2023",
)

= Introduction

This is the first paragraph of a random paper. I'm testing citations as in @acemoglu2001origins which uses the `@` command. Alternatively, I could use the `#cite()` function as in #cite(<rodrik2012convergence>).

The following block of code indents paragraphs, lists, and numbered lists.

```typst
  // Indent first line of paragraphs
  set par(leading: 0.75em, first-line-indent: 20pt)

  // Indent lists
  set list(indent: 20pt)
  set enum(indent: 20pt)
```

Now I test equations:

- Block unnumbered equations:

$ x / (1-x) = integral_0^(inf) log(x-1) d x $

- Inline equations $f(x) = -x$.
- Numbered equations are obtained with the custom function `#neq($ equation $)`.

#neq($ F_n = floor(1 / sqrt(5) phi.alt^n) $) <eq_Fn>

Now we reference an equation numbered with a custom function as equation #eqref(<eq_Fn>). To reference equations properly, the custom command `#eqref(<name_tag>)` is provided in the `template.typ` file.

= Model

Numbered lists are also indented.

+ Item 1
+ Item 2
+ Item 3
+ Item 4
+ Item 5

#bibliography("growth_biblio.bib", style: "chicago-author-date")

