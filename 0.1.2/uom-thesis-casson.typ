// Alex Casson
//
// Aim
// Typst template in-line with the University of Manchester presentation of theses policy
//
// Versions
// 03.10.26 - v3 - accessibility fixes so the PDF passes Typst's PDF/UA-1 check (Typst 0.14 and later): the contents entries are styled with set rules so they stay valid outline entries, and the logo has alt text.
//                 Also fixes for figures with no number, appendix numbering, labelled footnotes, and the word count, which now counts the main text only and sits at the bottom of the contents page. Chapters start on a new page, block quotes are indented, sub-figures are supported through uom-subfigures, and the language is British English.
//                 Updated for version 12 of the Presentation of Theses Policy (March 2026): The University on the title page, a degree option, the COVID-19 impact statement, both forms of the declaration, the copyright wording, and pages for the list of thesis revisions, AI declaration and content notification.
//                 Drafting tools: draft mode with DRAFT across each page, uom-todo and uom-missing-figure, and a check that none are left outside draft mode. Short captions for the lists of figures and tables (uom-flex-caption).
//                 Report types: theses, MSc by Research dissertations and taught dissertations, each worded as in its own University document (uom-reports).
// 04.05.25 - v2 - added fixes for Typst 0.13 compatability. outline command changed, and some header spacing changed.
// 30.12.24 - v1 - initial version. Fundamentally complete, but with a number of non-ideal and/or to-do items. Lots of items are hard coded.
//
// TODO
// Space under Contents heading is too small, not like others
// URL style
// Fix table bottom row
// Equation no. in text in wrong mode
// Remove table/fig from LOT/LOF?
// Improve code display
// Add backref if feasible
// Check on heading spacings
// Add terms list for terms and abbreviations
// Find nicer way to enter abstract etc
// Add XMP copyright when can
// Look into heading spacing after the heading. There are a number of manual fixes in the below



// ------ ADD PACKAGES --------------------------------------------------
#import "@preview/wordometer:0.1.6": word-count, total-words
#import "@preview/subpar:0.2.2"



// ------ SHORT CAPTIONS ------------------------------------------------

// A caption with a short form for the lists of figures and tables, like
// \caption[short]{long} in LaTeX:
//   caption: uom-flex-caption([The full caption under the figure.], [Short version])
// The word count can't see inside a context block, so it gets a copy of the
// long caption that is never shown.
#let uom-in-outline = state("uom-in-outline", false)
#let uom-flex-caption(long, short) = [#block(long)<uom-count-only>#context if uom-in-outline.get() { short } else { long }]



// ------ DRAFTING TOOLS ------------------------------------------------

// Notes and placeholders for while the thesis is being written. They are
// allowed in draft mode, uom-thesis(draft: true), which also puts DRAFT across
// every page and a list of what is left at the end. Outside draft mode they
// stop the build, so none are left in the version that is handed in.

// Something still to do, shown in red where it is: #uom-todo[Check this value]
// It is only noted for the list once, not again where a heading or caption is
// repeated in the contents or the list of figures.
#let uom-todo(body) = [#context if not uom-in-outline.get() [#metadata(body)<uom-todo>]#text(fill: rgb("#c00000"), weight: "bold")[To do: #body]]

// A placeholder for a figure that hasn't been made yet. It is numbered and
// listed like any other figure, so references to it work.
#let uom-missing-figure(caption) = figure(
  rect(width: 60%, height: 4cm, stroke: (paint: luma(40%), dash: "dashed"), {
    [#metadata(caption)<uom-missing-figure>]
    align(center + horizon, text(fill: luma(40%))[Missing figure])
  }),
  alt: "Placeholder for a figure that is still to be made",
  caption: caption,
)



// ------ REPORT TYPES --------------------------------------------------

// The wording that changes with the kind of report, picked with the report
// option of uom-thesis. Each follows its own University document:
//   thesis: PhD, MPhil, MD, EngD and the other doctorates. Presentation of
//     Theses Policy, version 12, March 2026 (DocID 7420).
//   research-dissertation: MSc by Research. Presentation of PGR Dissertations
//     Policy, version 4.1, May 2025 (DocID 7441). Its title page statement
//     follows the example title page in its Appendix 1.
//   taught-dissertation: undergraduate and taught masters dissertations, such
//     as BEng and MEng project reports and MSc dissertations. Guidance for the
//     Presentation of Taught Dissertations for UG and PGT Provision, version
//     2.12, January 2016 (DocID 2863).
#let uom-reports = (
  thesis: (
    statement: "A thesis submitted to The University of Manchester for the degree of",
    degree: "Doctor of Philosophy",
    declaration: "I hereby confirm that no portion of the work referred to in the thesis has been submitted in support of an application for another degree or qualification of this or any other university or other institute of learning.",
    rights-title: [Copyright statement],
    rights: (
      [The author of this thesis (including any appendices and/or schedules to this thesis) owns certain copyright or related rights in it (the "Copyright") and they have given the University of Manchester certain rights to use such Copyright, including for administrative purposes.],
      [Copies of this thesis, either in full or in extracts and whether in hard or electronic copy, may be made only in accordance with the Copyright, Designs and Patents Act 1988 (as amended) and regulations issued under it or, where appropriate, in accordance with licensing agreements which the University has from time to time. This page must form part of any such copies made.],
      [The ownership of certain Copyright, patents, designs, trademarks and other intellectual property (the "Intellectual Property") and any reproductions of copyright works in the thesis, for example graphs and tables ("Reproductions"), which may be described in this thesis, may not be owned by the author and may be owned by third parties. Such Intellectual Property and Reproductions cannot and must not be made available for use without the prior written permission of the owner(s) of the relevant Intellectual Property and/or Reproductions.],
      [Further information on the conditions under which disclosure, publication and commercialisation of this thesis, the Copyright and any Intellectual Property and/or Reproductions described in it may take place is available in the University IP Policy, in any relevant Thesis restriction declarations deposited in the University Library, the University Library's regulations and in the University's policy on the Presentation of Theses.],
    ),
    revisions-title: [List of thesis revisions],
  ),
  research-dissertation: (
    statement: "A dissertation submitted to The University of Manchester for the degree of",
    degree: "Master of Science by Research",
    declaration: "I hereby confirm that no portion of the work referred to in the dissertation has been submitted in support of an application for another degree or qualification of this or any other university or other institute of learning.",
    rights-title: [Copyright statement],
    rights: (
      [The author of this dissertation (including any appendices and/or schedules to this dissertation) owns certain copyright or related rights in it (the "Copyright") and they have given the University of Manchester certain rights to use such Copyright, including for administrative purposes.],
      [Copies of this dissertation, either in full or in extracts and whether in hard or electronic copy, may be made only in accordance with the Copyright, Designs and Patents Act 1988 (as amended) and regulations issued under it or, where appropriate, in accordance with licensing agreements which the University has from time to time. This page must form part of any such copies made.],
      [The ownership of certain Copyright, patents, designs, trademarks and other intellectual property (the "Intellectual Property") and any reproductions of copyright works in the dissertation, for example graphs and tables ("Reproductions"), which may be described in this dissertation, may not be owned by the author and may be owned by third parties. Such Intellectual Property and Reproductions cannot and must not be made available for use without the prior written permission of the owner(s) of the relevant Intellectual Property and/or Reproductions.],
      [Further information on the conditions under which disclosure, publication and commercialisation of this dissertation, the Copyright and any Intellectual Property and/or Reproductions described in it may take place is available in the University IP Policy, in any relevant Dissertation restriction declarations deposited in the University Library, the University Library's regulations and in the University's policy on the Presentation of Dissertations.],
    ),
    revisions-title: [List of dissertation revisions],
  ),
  taught-dissertation: (
    statement: "A dissertation submitted to The University of Manchester for the degree of",
    degree: none, // has to be given, such as Bachelor of Engineering
    declaration: "I hereby confirm that this dissertation is my own original work unless referenced clearly to the contrary, and that no portion of the work referred to in the dissertation has been submitted in support of an application for another degree or qualification of this or any other university or other institute of learning.",
    rights-title: [Intellectual property statement],
    rights: (
      [The author of this dissertation (including any appendices and/or schedules to this dissertation) owns certain copyright or related rights in it (the "Copyright") and they have given The University of Manchester certain rights to use such Copyright, including for administrative purposes.],
      [Copies of this dissertation, either in full or in extracts and whether in hard or electronic copy, may be made only in accordance with the Copyright, Designs and Patents Act 1988 (as amended) and regulations issued under it or, where appropriate, in accordance with licensing agreements which the University has entered into. This page must form part of any such copies made.],
      [The ownership of certain Copyright, patents, designs, trademarks and other intellectual property (the "Intellectual Property") and any reproductions of copyright works in the dissertation, for example graphs and tables ("Reproductions"), which may be described in this dissertation, may not be owned by the author and may be owned by third parties. Such Intellectual Property and Reproductions cannot and must not be made available for use without the prior written permission of the owner(s) of the relevant Intellectual Property and/or Reproductions.],
      [Further information on the conditions under which disclosure, publication and commercialisation of this dissertation, the Copyright and any Intellectual Property and/or Reproductions described in it may take place is available in the University IP Policy, in any relevant Dissertation restriction declarations deposited in the University Library, and The University Library's regulations.],
    ),
    revisions-title: [List of dissertation revisions],
  ),
)



// ------ DEFINE ARGUMENTS ----------------------------------------------
// The text of a chapter, section or sub-section heading. It is a block rather
// than a paragraph, because tagged PDF 2.0 (and so PDF/UA-2) does not allow a
// paragraph inside a heading. With above and below set to auto the block is
// spaced like a paragraph, where a block in a heading would otherwise take the
// heading's own spacing and stick to what follows, so nothing moves.
#let uom-heading-text(body) = block(above: auto, below: auto, sticky: false, body)

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
  report: "thesis",
  studentid: none,
  degree: auto,
  covidstatement: none,
  declaration: none,
  revisions: none,
  aideclaration: none,
  contentnotification: none,
  font: "TeX Gyre Termes",
  fontsize: 12pt,
  draft: false,
  body,
) = {
  

  
// ------ SETUP DOCUMENT ------------------------------------------------
  
  // Report type
  assert(report in uom-reports, message: "report should be one of " + uom-reports.keys().join(", "))
  let kind = uom-reports.at(report)
  let degree = if degree == auto { kind.degree } else { degree }
  let taught = report == "taught-dissertation"
  assert(degree != none, message: "give the degree in full for the title page, such as degree: \"Bachelor of Engineering\"")
  assert(not taught or studentid != none, message: "a taught dissertation gives the student ID on the title page instead of the name, so give studentid")
  assert(not taught or fontsize >= 12pt, message: "a taught dissertation needs a font size of at least 12pt")

  // Document meta-data. A taught dissertation leaves the name out, as it goes
  // by student ID.
  state("maincontent").update(true)
  show <uom-count-only>: none // copies of text that only the word count sees (see uom-flex-caption and uom-subfigures)
  set document(author: if taught { () } else { author }, title: if draft { "DRAFT: " + title } else { title })

  // Page size and numbering
  set page(
    paper: "a4",
    margin: (left: 40mm, right: 25mm, top: 15mm, bottom: 15mm),
    number-align: end,
  )

  // DRAFT across each page in draft mode, marked as decoration so screen
  // readers skip it
  set page(background: if draft {
    pdf.artifact(rotate(-45deg, text(100pt, fill: luma(90%), weight: "bold")[DRAFT]))
  })

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
      uom-heading-text("Chapter " + counter(heading).display("1") + "\n" + it.body)
      v(-0.5em)
    } else {
      uom-heading-text(it.body)
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
      uom-heading-text(counter(heading).display("1.1") + " " + it.body)
    } else {
      uom-heading-text(it.body)
    }    
    //v(0.77em)
  }

  // Level 3 for Sub-sections
  show heading.where(level: 3): it => {
    v(1.1em)
    set align(left)
    set text(1.1em, weight: "bold")
    uom-heading-text(counter(heading).display("1.1") + " " + it.body)
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



// ------ LIST OF THESIS REVISIONS --------------------------------------

  // For a resubmitted thesis or dissertation only. It goes before the title
  // page and any COVID-19 impact statement, and is taken out of the final
  // version after the re-examination (policy 8.1h). Like the impact statement
  // it has no page number.
  if revisions != none {
    heading(outlined: false, bookmarked: true, numbering: none, level: 1, kind.revisions-title)
    v(-5em) // as for the preliminary pages below
    revisions
    pagebreak()
    counter(page).update(1) // the title page is still page 1 (policy 7.4)
  }



// ------ COVID-19 IMPACT STATEMENT -------------------------------------

  // Optional. It goes immediately before the title page, has no page number,
  // and is taken out of the final version after the examination (policy 8.1a,
  // 7.5 and section 10).
  if covidstatement != none {
    heading(outlined: false, bookmarked: true, numbering: none, level: 1, [COVID-19 impact statement])
    v(-5em) // as for the preliminary pages below
    covidstatement
    pagebreak()
    counter(page).update(1) // the title page is still page 1 (policy 7.4)
  }



// ------ TTILE PAGE ----------------------------------------------------

  place(dx: -40mm+14.279mm, dy:-15mm+14.279mm,
    image("uom_logo.svg", width: 40.006mm, alt: "The University of Manchester logo")
  )
  v(2fr)
  set align(center)
  text(1.44em, weight: "bold", title)
  v(1fr)
  text(1em, kind.statement + " \n " + degree + " \n in the Faculty of ")
  text(1em, faculty)
  v(1fr)
  text(1em, year)
  v(1fr)  
  if taught {
    // The student ID instead of the name, or one ID per line for a group
    let ids = if type(studentid) == array { studentid } else { (studentid,) }
    text(1em, ids.map(id => [#id]).join(linebreak()))
  } else {
    text(1em, author)
  }
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
  show outline: it => { uom-in-outline.update(true); it; uom-in-outline.update(false) } // for uom-flex-caption
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
  
  // Declaration of originality. The policy (8.1f) gives two forms. The
  // standard text below is the first, for when no part of the work has been
  // submitted for another degree. If part of it has, give declaration instead,
  // saying which part, including any jointly authored work.
  pagebreak()
  heading(outlined: true, numbering: none, level: 1,[Declaration of originality])
  v(-5em) // added for Typst 0.13. Somewhat hacky. Not clear why spacing doesn't come from the heading correct without this. Will look at at some point
  if declaration != none {
    declaration
  } else {
    kind.declaration
  }
  
  // Copyright statement, or intellectual property statement for a taught
  // dissertation, worded as in the document for the report type (see
  // uom-reports at the top)
  pagebreak()
  heading(outlined: true, numbering: none, level: 1, kind.rights-title)
  v(-5em) // added for Typst 0.13. Somewhat hacky. Not clear why spacing doesn't come from the heading correct without this. Will look at at some point
  set enum(numbering: "i.")
  enum(..kind.rights)
  pagebreak()

  // Optional pages (policy 9.1). Acknowledgements and similar have to come
  // after the compulsory pages.

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

  if aideclaration != none {
    heading(outlined: true, numbering: none, level: 1,[AI declaration])
    v(-5em) // added for Typst 0.13. Somewhat hacky. Not clear why spacing doesn't come from the heading correct without this. Will look at at some point
    aideclaration
    pagebreak()
  }

  if contentnotification != none {
    heading(outlined: true, numbering: none, level: 1,[Content notification])
    v(-5em) // added for Typst 0.13. Somewhat hacky. Not clear why spacing doesn't come from the heading correct without this. Will look at at some point
    contentnotification
    pagebreak()
  }


  
// ------ MAIN BODY ---------------------------------------------

  set text(hyphenate: true)
  show: word-count.with(exclude: <uom-appendices>)
  body

  // In draft mode, list the to-dos and missing figures at the end. Outside it,
  // stop the build if there are any left.
  context {
    let left = query(selector(<uom-todo>).or(<uom-missing-figure>))
    let pages = left.map(it => str(counter(page).at(it.location()).first())).dedup()
    if draft and left.len() > 0 {
      heading(outlined: false, bookmarked: true, numbering: none, level: 1, [Still to do])
      for it in left {
        let what = if it.label == <uom-todo> [To do] else [Missing figure]
        [- #link(it.location())[Page #counter(page).at(it.location()).first()]: #what: #it.value]
      }
    }
    let where = (if pages.len() == 1 { "on page " } else { "on pages " }) + pages.join(", ", last: " and ")
    assert(draft or left.len() == 0, message: "the thesis still has to-dos or missing figures, " + where + ". Finish them, or use draft: true in uom-thesis while it is still being written")
  }
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
      uom-heading-text("Appendix " + counter(heading).display("A") + "\n" + it.body)
    } else {
      uom-heading-text(it.body)
    }  
    v(0.22em)
  }
    show heading.where(level: 2): it => {
    v(1.3em)
    set align(left)
    set text(1.3em, weight: "bold")
    if it.numbering != none {
      uom-heading-text(counter(heading).display("A.1") + " " + it.body)
    } else {
      uom-heading-text(it.body)
    }    
    v(0.77em)
  }

  show heading.where(level: 3): it => {
    v(1.1em)
    set align(left)
    set text(1.1em, weight: "bold")
    uom-heading-text(counter(heading).display("A.1") + " " + it.body)
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
