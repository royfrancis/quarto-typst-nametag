// Some definitions presupposed by pandoc's typst output.
#let blockquote(body) = [
  #set text( size: 0.92em )
  #block(inset: (left: 1.5em, top: 0.2em, bottom: 0.2em))[#body]
]

#let horizontalrule = [
  #line(start: (25%,0%), end: (75%,0%))
]

#let endnote(num, contents) = [
  #stack(dir: ltr, spacing: 3pt, super[#num], contents)
]

#show terms: it => {
  it.children
    .map(child => [
      #strong[#child.term]
      #block(inset: (left: 1.5em, top: -0.4em))[#child.description]
      ])
    .join()
}

// Some quarto-specific definitions.

#show raw.where(block: true): set block(
    fill: luma(230),
    width: 100%,
    inset: 8pt,
    radius: 2pt
  )

#let block_with_new_content(old_block, new_content) = {
  let d = (:)
  let fields = old_block.fields()
  fields.remove("body")
  if fields.at("below", default: none) != none {
    // TODO: this is a hack because below is a "synthesized element"
    // according to the experts in the typst discord...
    fields.below = fields.below.amount
  }
  return block.with(..fields)(new_content)
}

#let unescape-eval(str) = {
  return eval(str.replace("\\", ""))
}

#let empty(v) = {
  if type(v) == "string" {
    // two dollar signs here because we're technically inside
    // a Pandoc template :grimace:
    v.matches(regex("^\\s*$")).at(0, default: none) != none
  } else if type(v) == "content" {
    if v.at("text", default: none) != none {
      return empty(v.text)
    }
    for child in v.at("children", default: ()) {
      if not empty(child) {
        return false
      }
    }
    return true
  }

}

// Subfloats
// This is a technique that we adapted from https://github.com/tingerrr/subpar/
#let quartosubfloatcounter = counter("quartosubfloatcounter")

#let quarto_super(
  kind: str,
  caption: none,
  label: none,
  supplement: str,
  position: none,
  subrefnumbering: "1a",
  subcapnumbering: "(a)",
  body,
) = {
  context {
    let figcounter = counter(figure.where(kind: kind))
    let n-super = figcounter.get().first() + 1
    set figure.caption(position: position)
    [#figure(
      kind: kind,
      supplement: supplement,
      caption: caption,
      {
        show figure.where(kind: kind): set figure(numbering: _ => numbering(subrefnumbering, n-super, quartosubfloatcounter.get().first() + 1))
        show figure.where(kind: kind): set figure.caption(position: position)

        show figure: it => {
          let num = numbering(subcapnumbering, n-super, quartosubfloatcounter.get().first() + 1)
          show figure.caption: it => {
            num.slice(2) // I don't understand why the numbering contains output that it really shouldn't, but this fixes it shrug?
            [ ]
            it.body
          }

          quartosubfloatcounter.step()
          it
          counter(figure.where(kind: it.kind)).update(n => n - 1)
        }

        quartosubfloatcounter.update(0)
        body
      }
    )#label]
  }
}

// callout rendering
// this is a figure show rule because callouts are crossreferenceable
#show figure: it => {
  if type(it.kind) != "string" {
    return it
  }
  let kind_match = it.kind.matches(regex("^quarto-callout-(.*)")).at(0, default: none)
  if kind_match == none {
    return it
  }
  let kind = kind_match.captures.at(0, default: "other")
  kind = upper(kind.first()) + kind.slice(1)
  // now we pull apart the callout and reassemble it with the crossref name and counter

  // when we cleanup pandoc's emitted code to avoid spaces this will have to change
  let old_callout = it.body.children.at(1).body.children.at(1)
  let old_title_block = old_callout.body.children.at(0)
  let old_title = old_title_block.body.body.children.at(2)

  // TODO use custom separator if available
  let new_title = if empty(old_title) {
    [#kind #it.counter.display()]
  } else {
    [#kind #it.counter.display(): #old_title]
  }

  let new_title_block = block_with_new_content(
    old_title_block, 
    block_with_new_content(
      old_title_block.body, 
      old_title_block.body.body.children.at(0) +
      old_title_block.body.body.children.at(1) +
      new_title))

  block_with_new_content(old_callout,
    block(below: 0pt, new_title_block) +
    old_callout.body.children.at(1))
}

// 2023-10-09: #fa-icon("fa-info") is not working, so we'll eval "#fa-info()" instead
#let callout(body: [], title: "Callout", background_color: rgb("#dddddd"), icon: none, icon_color: black) = {
  block(
    breakable: false, 
    fill: background_color, 
    stroke: (paint: icon_color, thickness: 0.5pt, cap: "round"), 
    width: 100%, 
    radius: 2pt,
    block(
      inset: 1pt,
      width: 100%, 
      below: 0pt, 
      block(
        fill: background_color, 
        width: 100%, 
        inset: 8pt)[#text(icon_color, weight: 900)[#icon] #title]) +
      if(body != []){
        block(
          inset: 1pt, 
          width: 100%, 
          block(fill: white, width: 100%, inset: 8pt, body))
      }
    )
}

// functions

// remove escape character
#let remove-escape(str) = {
  str.replace("\\", "")
}

// check if any logo exists
#let validate-logo(ll,lr) = {
  if ll != none or lr != none {
    true
  } else {
    false
  }
}

// text style heavy
#let style-heavy(content) = {
  box(
    text(
      size: 1.2em,
      weight: 600,
      content
    )
  )
}

// text style light
#let style-light(content) = {
  box(
    text(
      size: 0.9em,
      content
    )
  )
}

// main
#let sheet(

  info: (),
  logo-left: none,
  logo-right: none,
  logo-left-height: 0.55cm,
  logo-right-height: 0.55cm,
  font-size: 16pt,
  leading: 0.5em,
  paper-height: 297mm,
  paper-width: 210mm,
  nametag-height: 55mm,
  nametag-width: 90mm,
  bg-image: none,
  trim-color: "#aeb6bf",
  text-color: "#2e4053"
  
) = {

  let rows = calc.floor(paper-height/nametag-height)
  let cols = calc.floor(paper-width/nametag-width)
  let margin-x = (paper-width - (nametag-width * cols))/2
  let margin-y = (paper-height - (nametag-height * rows))/2
  set page(
    height: paper-height,
    width: paper-width,
    //margin: (left: 0cm, right: 0cm, top:0cm, bottom:0cm)
    margin: (left: margin-x, right: margin-x, top:margin-y, bottom:margin-y)
    //margin: (left: 1.5cm, right: 1.5cm, top: 1.1cm, bottom: 1.1cm)
  )
  set text(font-size, font: "Lato", fill: rgb(remove-escape(text-color)))
  set par(leading: leading)

  grid(
    columns: cols,
    rows: rows,
    ..info.map(item => {
      let content = (
        if item.line1 != "" and item.line1 != none and item.line1 != [] { 
          style-heavy(item.line1) + "\n" 
        } else { 
          "" 
        }) + (if item.line2 != "" and item.line2 != none and item.line2 != [] { 
          item.line2 + "\n" 
        } else { 
          "" 
        }) + (if item.line3 != "" and item.line3 != none and item.line3 != [] { 
          style-light(item.line3) + "\n" 
        } else { 
          "" 
        }) + (if item.line4 != "" and item.line4 != none and item.line4 != [] { 
          style-light(item.line4)
        } else { 
          "" 
        }
      );
      
      block(
        fill: if (bg-image != none and bg-image != "") {
          pattern(
            image(bg-image.path, height: nametag-height, width: nametag-width, fit: "cover")
          )
        } else {
          none
        },
        stroke: (paint: rgb(remove-escape(trim-color)), thickness: 0.4pt, dash: "dashed"),
        inset: 0.3em,
        width: nametag-width,
        height: nametag-height,
        breakable: false,
        if validate-logo(logo-left, logo-right) {
          stack(
            dir: ttb,
            grid(
              columns: (1fr, 1fr),
              rows: 1,
              align(left,
                if (logo-left != none and logo-left != "") {
                  image(logo-left.path, height: logo-left-height)
                }
              ),
              align(right,
                if (logo-right != none and logo-right != "") {
                  image(logo-right.path, height: logo-right-height)
                }
              ),
            ),
            align(center + horizon, content)
          )
        } else {
          align(center + horizon, content)
        }
      )
    })
  )
}

#show: doc => sheet(

      info: (
        (
      line1: [Olivia Sterling],
      line2: [Quantum Physicist],
      line3: [Quantum Research Institute],
      line4: [o.sterling\@quantumri.edu],
    ),
        (
      line1: [Marcus Finnegan],
      line2: [Chief Technology Officer],
      line3: [],
      line4: [m.finnegan\@techinnovators.com],
    ),
        (
      line1: [Ariella Knöx],
      line2: [],
      line3: [Global Solutions Inc.],
      line4: [a.knox\@globalsolutions.com],
    ),
        (
      line1: [Theo Jansen],
      line2: [Research Analyst],
      line3: [Netherlands Technology Hub],
      line4: [t.jansen\@nth.nl],
    ),
        (
      line1: [Leila Summers],
      line2: [Environmental Scientist],
      line3: [EcoLogic Research Foundation],
      line4: [l.summers\@ecologic.org],
    ),
        (
      line1: [Jaxon Lee],
      line2: [Data Scientist],
      line3: [Australian Science Network],
      line4: [j.lee\@australiascience.net.au],
    ),
        (
      line1: [Marcus Finnegan],
      line2: [Chief Technology Officer],
      line3: [],
      line4: [m.finnegan\@techinnovators.com],
    ),
        (
      line1: [Ariella Knox],
      line2: [],
      line3: [Global Solutions Inc.],
      line4: [a.knox\@globalsolutions.com],
    ),
        (
      line1: [Theo Jansen],
      line2: [Research Analyst],
      line3: [Netherlands Technology Hub],
      line4: [t.jansen\@nth.nl],
    ),
        (
      line1: [Leila Summers],
      line2: [Environmental Scientist],
      line3: [EcoLogic Research Foundation],
      line4: [l.summers\@ecologic.org],
    ),
        (
      line1: [Jaxon Lee],
      line2: [Data Scientist],
      line3: [Australian Science Network],
      line4: [j.lee\@australiascience.net.au],
    ),
    ),
  
      logo-left: (
      path: "assets/logo1.png"
    ), 
  
      logo-right: (
      path: "assets/logo2.png"
    ), 
  
      logo-left-height: 0.55cm,
  
      logo-right-height: 0.50cm,
  
      font-size: 16pt,
  
      leading: 0.5em,
  
      paper-height: 297mm,
  
      paper-width: 210mm,
  
      nametag-height: 55mm,
  
      nametag-width: 90mm,
    
  
      trim-color: "\#aeb6bf",
  
      text-color: "\#2e4053",
  
)






