#let conf(title: none, subject: none, year: none, authors: (), doc) = {
	import "@preview/codly:1.3.0": *
  import "@preview/codly-languages:0.1.1": *
	show: codly-init.with()

  codly(languages: codly-languages, )

	let header = grid(columns: 2, column-gutter: 1fr, align: (left+top, right+top),
				emph(subject),
				emph(title)
	)
	
	
	set heading(numbering: "1.")
	set page("a4", numbering: "i", header: context {
		if counter(page).get().first() > 1 {
			header
		}
	} )

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

	outline()

	pagebreak()
	counter(page).update(1) // Now use arabic numbers

	set page(numbering: "1", header: header)

	doc
}

#let question_count = counter("question")
#let question(q, display: "1.") = {
	v(2em)
	question_count.step()
	context heading(grid(columns: (auto, 1em, 1fr), question_count.display(display),[], q), numbering: none, depth: 4, outlined: false)
}
#let question_multiple(q, step_all: false, display: "1. a)") = {
	context if step_all or question_count.get().len() <= 1 {
		v(2em)
		question_count.step(level: 1)
	}
	question_count.step(level: 2)
	context heading(grid(columns: (auto, 1em, 1fr), question_count.display(display),[], q), numbering: none, depth: 4, outlined: false)
}

// #let annex_numbering(..args) = "Anexo " + numbering("A.", ..args)

#let appendix(body) = {

	counter(heading).update(0)
  set heading(numbering: "A.", supplement: [Anexo])
  body
}