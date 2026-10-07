# Typst PhD thesis template for the University of Manchester

Typst template based upon [The University of Manchester Presentation of Theses Policy](https://documents.manchester.ac.uk/display.aspx?DocID=7420) which relates to the examination of doctoral and MPhil degrees at The University of Manchester and applies to full-time and part-time postgraduate research students of the following degrees: Doctoral degrees: Doctor of Philosophy (PhD); Doctor of Medicine (MD) Doctor of Business Administration (DBA); Professional, Engineering and Enterprise Doctorates; Master of Philosophy (MPhil). This version has been updated for version 12 of the policy (March 2026). Responsibility for ensuring compliance with the University of Manchester Presentation of Theses Policy remains with the candidate.


The template needs Typst 0.14 or later.

## Using the template on typst.app
The template is on [Typst Universe](https://typst.app/universe/package/casson-uom-thesis) as casson-uom-thesis. Create an account at [Typst.app](https://typst.app/) and start a new project by clicking on Start from template and searching for casson-uom-thesis.

Alternatively, you can download files from the template repository and upload them to your project folder. If doing this, in main.typ comment out

  `#import "@preview/casson-uom-thesis:0.1.2": *`

and instead uncomment

  `//#import "casson-uom-thesis.typ": *`


## Local installation
If Typst Universe is online, the template will be downloaded automatically to

  `$CACHEDIR/typst/packages/preview/casson-uom-thesis/$VERSION/`

when you run the command

  `typst init @preview/casson-uom-thesis:$VERSION thesis_project_name`

$VERSION should be 0.1.2. The value $CACHEDIR for your OS can be discovered from [https://docs.rs/dirs/latest/dirs/fn.cache_dir.html](https://docs.rs/dirs/latest/dirs/fn.cache_dir.html).

You should then be able to run

  `typst compile main.typ`

or

 `typst compile --pdf-standard a-2b main.typ`

to compile the document .


## Accessible PDFs
With Typst 0.14 or later the template passes Typst's PDF/UA-1 accessibility check. To export an accessible PDF, run

  `typst compile --pdf-standard ua-1 main.typ`

or, with Typst 0.15 or later, for a PDF that is both archival and accessible

  `typst compile --pdf-standard a-2a,ua-1 main.typ`

PDF/UA-1 needs alt text on every image and equation. main.typ shows how to add it.


## Usage
The template takes a number of options (e.g. font, font size, whether the optional front-matter items are displayed). These are detailed in main.typ and should be fairly obvious. 

The preliminary pages follow the order in the policy. The COVID-19 impact statement (`covidstatement`), list of thesis revisions (`revisions`), AI declaration (`aideclaration`) and content notification (`contentnotification`) are only included if given. `declaration` replaces the standard declaration of originality, for when part of the work has been submitted for another degree, and `degree` sets the degree on the title page.

Chapters and appendices start on a new page by themselves. A page break can't go inside a box, block or grid, so if a chapter heading has to, set `chapterbreak: false` in `uom-thesis` (and `#show: uom-appendix.with(chapterbreak: false)` for the appendices). The word count at the bottom of the contents page counts the main text only, as the policy asks: the chapters, including footnotes, but not the preliminary pages, the bibliography or the appendices.

For a short caption in the list of figures or tables, use `caption: uom-flex-caption([The full caption.], [Short caption])`.

While writing, set `draft: true`. It puts DRAFT across each page, and lets you use `#uom-todo[...]` for things still to do and `#uom-missing-figure([Caption])` for figures that haven't been made yet. They are listed at the end. Without draft mode the build stops if any are left, so none end up in the version that is handed in.

For a figure made of several parts, use `uom-subfigures`. It takes the same arguments as `subpar.grid` from the [subpar](https://typst.app/universe/package/subpar) package, and numbers the figure and its parts to match the rest of the thesis. main.typ has an example.
