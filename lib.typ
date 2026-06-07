#import "@preview/codly:1.3.0": *

#let table-header(..headers) = table.header(
  ..headers
    .pos()
    .map(cell => {
      if cell.func() == table.cell {
        let fields = cell.fields()
        table.cell(
          strong(fields.remove("body")),
          fill: blue.lighten(80%),
          stroke: 1pt + blue.darken(50%).transparentize(40%),
          ..fields,
        )
      } else {
        table.cell(strong(cell), fill: blue.lighten(80%), stroke: 1pt + blue.darken(50%).transparentize(40%))
      }
    }),
)

#let def_text = (
  es: x => [Definición \##x],
  en: x => [Definition \##x],
)

#let definition(word, desc) = {
  block(inset: 1em, width: 100%, radius: 10pt, fill: blue.darken(20%), [#text(white, grid(
    columns: (auto, auto),
    gutter: 0.5cm,
    align: horizon,
    text(weight: "black", size: 1.3em, word),

    text(font: "DejaVu Sans Mono", style: "italic", context {
      let num = def_text.at(text.lang)(counter(<definition>).display())
      num
      [#metadata((word: word, desc: desc, num: num))<def-meta>]
    }),
    grid.cell(colspan: 2, text(desc)),
  ))<definition>])
  
}

#let definitions() = context{
  for e in query(<def-meta>).map(x => x.value).map(x => {grid(
    columns: (auto, auto),
    gutter: 0.5cm,
    align: horizon,
    text(weight: "black", size: 1.3em, x.word),

    text(font: "DejaVu Sans Mono", style: "italic", x.num),
  )
  
  grid(
    columns: (1cm, auto),
    align: horizon,
    [],
    text(x.desc),
  )}) {
    v(1em)
    e
  }
}

#let conf(title: none, subject: none, year: none, authors: (), outline-args: (:), extra-lang: (:), doc) = {
  import "@preview/codly-languages:0.1.10": *
  show: codly-init.with()
  set table(stroke: 0.8pt + gray, fill: (x, y) => if calc.even(y) { gray.transparentize(70%) })

  codly(languages: (:..codly-languages, ..extra-lang), number-format: x => text(
    fill: black.lighten(40%),
    numbering.with("1")(x),
  ))

  let header = grid(
    columns: 2,
    column-gutter: 1fr,
    align: (left + top, right + top),
    emph(subject), emph(title),
  )


  set heading(numbering: "1.")
  set page("a4", numbering: "i", header: context {
    if counter(page).get().first() > 1 {
      header
    }
  })

  set par(justify: true)


  let optional_line(dict, key, map: x => x) = {
    let x = dict.at(key, default: none)
    if (x != none) {
      linebreak()
      map(x)
    }
  }

  set align(center)
  text(17pt, title)
  v(25pt)
  text(14pt, style: "italic", subject)
  linebreak()
  text(12pt, year)
  v(10pt)


  let count = authors.len()
  let ncols = calc.min(count, 3)
  grid(
    columns: (1fr,) * ncols,
    row-gutter: 24pt,
    ..authors.map(author => {
      author.name
      optional_line(author, "number")
      optional_line(author, "email", map: email => link("mailto:" + email))
    }),
  )

  set align(left)

  v(100pt)

  outline(..outline-args)

  pagebreak()
  counter(page).update(1) // Now use arabic numbers

  set page(numbering: "1", header: header)

  doc
}

#let question_count = counter("question")
#let question(q, display: "1.") = {
  v(2em)
  question_count.step()
  context heading(
    grid(
      columns: (auto, 1em, 1fr),
      question_count.display(display), [], q,
    ),
    numbering: none,
    depth: 4,
    outlined: false,
  )
}
#let question_multiple(q, step_all: false, display: "1. a)") = {
  context if step_all or question_count.get().len() <= 1 {
    v(2em)
    question_count.step(level: 1)
  }
  question_count.step(level: 2)
  context heading(
    grid(
      columns: (auto, 1em, 1fr),
      question_count.display(display), [], q,
    ),
    numbering: none,
    depth: 4,
    outlined: false,
  )
}

// #let annex_numbering(..args) = "Anexo " + numbering("A.", ..args)

#let appendix(body) = {
  counter(heading).update(0)
  set heading(numbering: "A.", supplement: [Anexo])
  body
}
