// functions
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
  nametag-width: 90mm
  
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
  set text(font-size, font: "Lato", fill: rgb("#444444"))
  set par(leading: leading)

  grid(
    stroke: (paint: silver, thickness: 0.5pt, dash: "dashed"),
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
        //fill: pattern(image("images/bg-90x55.png")),
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
