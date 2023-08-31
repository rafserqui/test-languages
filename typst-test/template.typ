// The project function defines how your document looks.
// It takes your content and some metadata and formats it.
// Go ahead and customize it to your liking!
#let project(
  title: "",
  abstract: [],
  authors: (),
  date: none,
  body,
) = {
  // Set the document's basic properties.
  set document(author: authors.map(a => a.name), title: title)
  set page(numbering: "1", number-align: center)
  set text(font: "Linux Libertine", lang: "en")

  // Equations
  // The following line numbers all equations
  //set math.equation(numbering: "(1)", supplement: [Eq.])

  // Set paragraph spacing.
  show par: set block(above: 1.2em, below: 1.2em)

  set heading(numbering: "1.1")

  // Set run-in subheadings, starting at level 3.
  show heading: it => {
    if it.level > 2 {
      parbreak()
      text(11pt, style: "italic", weight: "regular", it.body + ".")
    } else {
      it
    }
  }

  // Indent first line of paragraphs
  set par(leading: 0.75em)

  // Indent lists
  set list(indent: 0.65em)
  set enum(indent: 0.65em)
 
  // Title row.
  align(center)[
    #block(text(weight: 700, 1.75em, title))
    #v(1.2em, weak: true)
    #date
  ]

  // Author information.
  pad(
    top: 0.8em,
    bottom: 0.8em,
    x: 2em,
    grid(
      columns: (1fr,) * calc.min(3, authors.len()),
      gutter: 1em,
      ..authors.map(author => align(center)[
        *#author.name* \
        #author.email \
        #author.affiliation
      ]),
    ),
  )

  // Main body.
  set par(justify: true, first-line-indent: 0.65em)

  heading(outlined: false, numbering: none, text(0.85em, smallcaps[Abstract]))
  abstract

  body

}

// As recommended in the docs
#show par: set block(spacing: 0.65em)

#let eqref(x) = [(#ref(x, supplement: none))]

#let neq(content) = math.equation(
  block: true,
  numbering: "(1)",
  supplement: none,
  content,
)
