// Alex Casson
//
// Aim
// Typst template in-line with the University of Manchester presentation of theses policy
//
// Versions
// 03.10.26 - v3 - accessibility fixes so the PDF passes Typst's PDF/UA-1 check (Typst 0.14 and later): the contents entries are styled with set rules so they stay valid outline entries, and the logo has alt text.
// 04.05.25 - v2 - added fixes for Typst 0.13 compatability. outline command changed, and some header spacing changed.
// 30.12.24 - v1 - initial version. Fundamentally complete, but with a number of non-ideal and/or to-do items. Lots of items are hard coded.
//
// TODO
// Space under Contents heading is too small, not like others
// URL style
// Fix table bottom row
// Equation no. in text in wrong mode
// Remove table/fig from LOT/LOF?
// Add support for short captions for LOT/LOF
// Improve code display
// Add backref if feasible
// Check on heading spacings
// Add terms list for terms and abbreviations
// Add ability to overrule declaration of originality
// Find nicer way to enter abstract etc
// Add XMP copyright when can
// Look into heading spacing after the heading. There are a number of manual fixes in the below



// ------ ADD PACKAGES --------------------------------------------------
#import "@preview/wordometer:0.1.6": word-count, total-words
#import "@preview/subpar:0.2.2"



// ------ DEFINE ARGUMENTS ----------------------------------------------
#let uom-thesis(
  title: "",
  abstract: [],
  publications: none,
  termsandabbreviations: none,
  layabstract: none,
  acknowledgements: none,
  theauthor: none,
  chapterbreak: true,
  author: "",
  faculty: none,
  year: none,
  school: none,
  departmentordivision: none,
  font: "TeX Gyre Termes",
  fontsize: 12pt,
  body,
) = {
  

  
// ------ SETUP DOCUMENT ------------------------------------------------
  
  // Document meta-data
  state("maincontent").update(true)
  show <uom-count-only>: none // copies of text that only the word count sees (see uom-subfigures)
  set document(author: author, title: title)

  // Page size and numbering
  set page(
    paper: "a4",
    margin: (left: 40mm, right: 25mm, top: 15mm, bottom: 15mm),
    number-align: end,
  )

  // Fonts
  // Note the guidelines say "a font type and size which ensures readability must be used ... in a font such as Arial, Verdana, Tahoma,Trebuchet, Calibri, Times, Times New Roman, Palatino or Garamond". Only Times and Palatino are built in to Typst online. Roboto and Noto sans are added as options here which should satisfy this
  let roboto = "Roboto"
  let times = "TeX Gyre Termes"
  let palatino = "TeX Gyre Pagella"
  let noto_sans = "Noto Sans"
  let font_actual = times
  if font == "roboto" {
    font_actual = roboto
  } else if font == "palatino" {
    font_actual = palatino
  } else if font == "noto_sans" {
    font_actual = noto_sans
  }
  
  // Basic formatting
  set text(
    font: font_actual, 
    size: fontsize,
    lang: "en",
    region: "GB", // British English, for screen readers and the bibliography
  )
  set heading(numbering: "1.1")
  set par(leading: 1.2em) // line spacing
  set par(spacing: 2em) // space between paragraphs

  
  
// ------ HEADING STYLES ------------------------------------------------

  // Level 1 for Chapters, each on a new page. A page break can't go inside a
  // box, block or grid, so chapterbreak: false turns this off for a thesis
  // that needs a chapter heading inside one (and uom-appendix takes it too).
  show heading.where(level: 1): it => {
    if chapterbreak { pagebreak(weak: true) }
    v(2*2.26em)
    set align(left)
    set text(2.26em, weight: "bold")
    if it.numbering != none {
      text("Chapter " + counter(heading).display("1") + "\n" + it.body)
      v(-0.5em)
    } else {
      text(it.body)
      v(1em)
    }
    //v(1em)
  }
  show heading.where(level: 1): set heading(supplement: [Chapter])

  // Level 2 for Sections
  show heading.where(level: 2): it => {
    v(1.3em)
    set align(left)
    set text(1.3em, weight: "bold")
    if it.numbering != none {
      text(counter(heading).display("1.1") + " " + it.body)
    } else {
      text(it.body)
    }    
    //v(0.77em)
  }

  // Level 3 for Sub-sections
  show heading.where(level: 3): it => {
    v(1.1em)
    set align(left)
    set text(1.1em, weight: "bold")
    text(counter(heading).display("1.1") + " " + it.body)
  }

  // Not numbered below level 3
  show heading.where(level: 4): it =>[
    #block(it.body)
  ]
  show heading.where(level: 5): it =>[
    #parbreak()
    #text(weight: "bold", it.body)
  ]
  show heading.where(level: 6): it =>[
    #text(style: "italic", weight: "bold", it.body)
  ]



// ------ FIGURES, TABLES, AND EQUATIONS --------------------------------

  // Reset counters each chapter to allow Ch.Sect type references
  show heading.where(level: 1): it => {
    counter(math.equation).update(0)
    counter(figure.where(kind: image)).update(0)
    counter(figure.where(kind: table)).update(0)
    counter(figure.where(kind: raw)).update(0)
    it
  }
  
  // All display item formatting
  show figure.caption: set text(size: 0.9em)
  show figure.caption: set align(center)
  
  // Table captions
  // Only the top line of a table is added at the moment. Should do under the header and the last line of the table to be in IEEE style
  show figure.where(kind: table): set figure.caption(position: top)  
  set table(stroke: (_, y) => if y == 0 { 
    (top: 1.5pt) // should do bottom too 
  } else if y == 0 { // doesn't work atm
    (bottom: 1.5pt) 
  })

  // Figure captions
  let figure-supplement = [Fig.]
  show figure: set block(spacing: 2em)
  show figure: set place(clearance: 1em)
  show figure.where(kind: image): set figure(supplement: figure-supplement)
  set figure(numbering: num =>
    numbering("1.1", counter(heading).get().first(), num)
  )

  // Caption labels, such as "Fig. 1.1." and "Table 1.1.", in bold. This is a
  // caption rule rather than a figure rule, so that a figure with no number
  // works, and so that subpar can label the parts of a sub-figure itself.
  show figure.caption: it => {
    if it.numbering == none { return it.body }
    let prefix = (
      if it.kind == table [Table]
      else if it.kind == image [#figure-supplement]
      else [#it.supplement]
    )
    let numbers = numbering(it.numbering, ..it.counter.at(it.location()))
    [#text(prefix + " " +  numbers + ".", weight: "bold") #it.body]
  }

  // Equation numbering
  set math.equation(supplement: none)
  set math.equation(numbering: num =>
    numbering("(1.1)", counter(heading).get().first(), num)
  )


  
// ------ QUOTE FORMATTING ----------------------------------------------

  show quote.where(block: false): it => {
    ["] + h(0pt, weak: true) + emph(it.body) + h(0pt, weak: true) + ["]
    if it.attribution != none [ #it.attribution]
  }
  show quote.where(block: true): it => pad(x: 2.5em, { // indented both sides, as in LaTeX
    ["] + h(0pt, weak: true) + emph(it.body) + h(0pt, weak: true) + ["]
    if it.attribution != none [ #it.attribution]
  })


// ------ START OF DISPLAYED ITEMS --------------------------------------



// ------ TTILE PAGE ----------------------------------------------------

  place(dx: -40mm+14.279mm, dy:-15mm+14.279mm,
    image("uom_logo.svg", width: 40.006mm, alt: "The University of Manchester logo")
  )
  v(2fr)
  set align(center)
  text(1.44em, weight: "bold", title)
  v(1fr)
  text(1em, "A thesis submitted to the University of Manchester for the degree of \n Doctor of Philosophy \n in the Faculty of ")
  text(1em, faculty)
  v(1fr)
  text(1em, year)
  v(1fr)  
  text(1em, author)
  v(1em, weak: true)
  text(1em, school)
  v(1em, weak: true)
  text(1em, departmentordivision)
  v(1fr)
  set align(left)
  pagebreak()
  set page(numbering: "1")


  
// ------ LISTS OF CONTENTS ---------------------------------------------

  // Set contents formatting
  // Contents. Chapter entries are bold, with no dot leaders and a gap above.
  // These are set rules rather than a show rule that wraps each entry, so
  // the entries stay valid outline entries for screen readers (PDF/UA-1).
  show outline: set heading(outlined: true, numbering: none, level: 1)
  {
    show outline.entry.where(level: 1): set outline.entry(fill: none)
    show outline.entry.where(level: 1): set block(above: 1.2em)
    show outline.entry.where(level: 1): set text(weight: "bold")
    outline(depth: 3, indent: auto)
  }

  // Word count, at the bottom of the contents page (policy 8.1c). It counts
  // the main text only (policy 4.6): the chapters, including footnotes, but
  // not the preliminary pages, the bibliography or the appendices. The count
  // is taken from the body at the end of this function.
  align(right + bottom, block[
    #text("Word count: ",  weight: "bold")
    #text(total-words)
  ])

  // List of figures
  pagebreak()
  outline(
    depth: 3, indent: auto,
    title: [List of figures],
    target: figure.where(kind: image),
  )

  // List of tables
  pagebreak()
  outline(
    depth: 3, indent: auto,
    title: [List of tables],
    target: figure.where(kind: table),
  )

  // List of publications
  if publications != none {
    pagebreak()
    heading(outlined: true, numbering: none, level: 1, [List of publications])
    v(-5em) // added for Typst 0.13. Somewhat hacky. Not clear why spacing doesn't come from the heading correct without this. Will look at at some point
    text(1em, publications)
  }

  // Terms and abbreviations
  if termsandabbreviations != none {
    pagebreak()
    heading(outlined: true, numbering: none, level: 1, [Terms and abbreviations])
    v(-5em) // added for Typst 0.13. Somewhat hacky. Not clear why spacing doesn't come from the heading correct without this. Will look at at some point
    text(1em, termsandabbreviations)
  }
   
  // Abstract
  pagebreak()
  heading(outlined: true, numbering: none, level: 1, [Abstract])
  v(-5em) // added for Typst 0.13. Somewhat hacky. Not clear why spacing doesn't come from the heading correct without this. Will look at at some point
  abstract

  if layabstract != none {
    pagebreak()
    heading(outlined: true, numbering: none, level: 1,[Lay abstract])
    v(-5em) // added for Typst 0.13. Somewhat hacky. Not clear why spacing doesn't come from the heading correct without this. Will look at at some point
    layabstract
  }
  
  // Declaration of originality
  pagebreak()
  heading(outlined: true, numbering: none, level: 1,[Declaration of originality])
  v(-5em) // added for Typst 0.13. Somewhat hacky. Not clear why spacing doesn't come from the heading correct without this. Will look at at some point
  "I hereby confirm that no portion of the work referred to in the thesis has been submitted in support of an application for another degree or qualification of this or any other university or other institute of learning."
  
  // Copyright statement
  pagebreak()
  heading(outlined: true, numbering: none, level: 1,[Copyright statement])
  v(-5em) // added for Typst 0.13. Somewhat hacky. Not clear why spacing doesn't come from the heading correct without this. Will look at at some point
  set enum(numbering: "i.")
  enum[The author of this thesis (including any appendices and/or schedules to this thesis) owns certain copyright or related rights in it (the "Copyright") and s/he has given The University of Manchester certain rights to use such Copyright, including for administrative purposes.][Copies of this thesis, either in full or in extracts and whether in hard or electronic copy, may be made _only_ in accordance with the Copyright, Designs and Patents Act 1988 (as amended) and regulations issued under it or, where appropriate, in accordance with licensing agreements which the University has from time to time. This page must form part of any such copies made.][The ownership of certain Copyright, patents, designs, trademarks and other intellectual property (the "Intellectual Property") and any reproductions of copyright works in the thesis, for example graphs and tables ("Reproductions"), which may be described in this thesis, may not be owned by the author and may be owned by third parties. Such Intellectual Property and Reproductions cannot and must not be made available for use without the prior written permission of the owner(s) of the relevant Intellectual Property and/or Reproductions.][Further information on the conditions under which disclosure, publication and commercialisation of this thesis, the Copyright and any Intellectual Property and/or Reproductions described in it may take place is available in the University IP Policy (see #link("http://documents.manchester.ac.uk/DocuInfo.aspx?DocID=24420")), in any relevant Thesis restriction declarations deposited in the University Library, The University Library’s regulations (see #link("http://www.library.manchester.ac.uk/about/regulations/")) and in The University’s policy on Presentation of Theses.]
  pagebreak()

  if acknowledgements != none {
    heading(outlined: true, numbering: none, level: 1,[Acknowledgements])
    v(-5em) // added for Typst 0.13. Somewhat hacky. Not clear why spacing doesn't come from the heading correct without this. Will look at at some point
    acknowledgements
    pagebreak()
  }

  if theauthor != none {
    heading(outlined: true, numbering: none, level: 1,[The author])
    v(-5em) // added for Typst 0.13. Somewhat hacky. Not clear why spacing doesn't come from the heading correct without this. Will look at at some point
    theauthor
    pagebreak()
  }


  
// ------ MAIN BODY ---------------------------------------------

  set text(hyphenate: true)
  show: word-count.with(exclude: <uom-appendices>)
  body
}



// ------ APPENDIX FORMATTING -------------------------------------------

// The label on the whole of the appendices keeps them out of the word count.
// chapterbreak: false stops each appendix starting on a new page, as for the
// chapters in uom-thesis.
#let uom-appendix(body, chapterbreak: true) = [#{
  state("appendix").update(true)

  // Change figure and equation numbering to use a letter. Anything before
  // the first appendix heading is just numbered 1, 2 and so on.
  set figure(numbering: it => {
    let alph = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    let hdr = counter(heading).get().at(0)
    if hdr == 0 { [#it] } else { [#alph.at(hdr - 1).#it] }
  })
  set math.equation(numbering: num => {
    let hdr = counter(heading).get().first()
    if hdr == 0 { numbering("(1)", num) } else { numbering("(A.1)", hdr, num) }
  })

  // Set headings to use Appendix letters
  // This can probably be tidied up, is largely a copy of what is above
  set heading(numbering: "A.1", supplement: [Appendix])
  show heading.where(level: 1): set heading(supplement: [Appendix]) // otherwise references say Chapter A
  counter(heading).update(0)
  state("appendix").update(true)

  show heading.where(level: 1): it => {
    if chapterbreak { pagebreak(weak: true) }
    v(2*2.26em)
    set align(left)
    set text(2.26em, weight: "bold")
    if it.numbering != none {
      text("Appendix " + counter(heading).display("A") + "\n" + it.body)
    } else {
      text(it.body)
    }  
    v(0.22em)
  }
    show heading.where(level: 2): it => {
    v(1.3em)
    set align(left)
    set text(1.3em, weight: "bold")
    if it.numbering != none {
      text(counter(heading).display("A.1") + " " + it.body)
    } else {
      text(it.body)
    }    
    v(0.77em)
  }

  show heading.where(level: 3): it => {
    v(1.1em)
    set align(left)
    set text(1.1em, weight: "bold")
    text(counter(heading).display("A.1") + " " + it.body)
    v(0.9em)
  }

  // Reset counters for the per-appendix references. This has to come after
  // the heading styles above: it then runs first and passes the heading on to
  // them, whereas a rule before them is never reached.
  show heading.where(level: 1): hdr => {
    counter(math.equation).update(0)
    counter(figure.where(kind: image)).update(0)
    counter(figure.where(kind: table)).update(0)
    counter(figure.where(kind: raw)).update(0)
    hdr
  }

  // Add appendicies heading and then add the content
  heading(outlined: true, numbering: none, level: 1,[Appendices])
  pagebreak()
  body
} <uom-appendices>]



// ------ SUB-FIGURES ---------------------------------------------------

// A figure made of several parts, using the subpar package. It is numbered
// like any other figure (Fig. 1.2, or Fig. A.2 in an appendix), the parts are
// labelled (a), (b) and so on, and a reference to a part reads Fig. 1.2a. It
// takes the same arguments as subpar.grid.
#let uom-subfigures(..args) = {
  // Numbers that follow the chapter, or the appendix letter
  let by-chapter(main, appendix, before-appendix) = (..num) => {
    let chapter = counter(heading).get().first()
    if state("appendix").get() != true { numbering(main, chapter, ..num) }
    else if chapter == 0 { numbering(before-appendix, ..num) }
    else { numbering(appendix, chapter, ..num) }
  }
  let kind = args.named().at("kind", default: image)

  // subpar draws the figure inside a context block, which the word count
  // can't see into, so the word count gets a copy of the captions here.
  // The copy is never shown.
  [#block({
    for part in args.pos() { if type(part) == content { part } }
    args.named().at("caption", default: none)
  })<uom-count-only>]

  subpar.grid(
    numbering: by-chapter("1.1", "A.1", "1"),
    numbering-sub-ref: by-chapter("1.1a", "A.1a", "1a"),
    ..if kind == image { (supplement: [Fig.]) },
    ..args,
  )
}