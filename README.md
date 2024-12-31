# quarto-typst-nametag

A quarto extension that uses typst to create nametags

<img src="preview.jpg" width="400px">

## Installation

:warning: Requires quarto 1.4.

```
quarto use template royfrancis/quarto-typst-nametag
```

## Render

```
quarto render index.qmd
```

## Settings

Change YAML metadata in `index.qmd` as needed. All of the settings specified below are optional.

- info: Up to four lines of information. Key must be named line1, line2 etc. All lines are optional.
- logo-left.path/logo-right.path: Path to left logo
- logo-left-height/logo-right-height: Height of left and right logos
- font-size: Base font size. Line 1 is 1.2x and line3/line4 are 0.9x.
- leading: Spacing between lines
- paper-height: Height of paper. Defaults to A4
- paper-width: Width of paper. Defaults to A4
- nametag-height: Height of nametag. Defaults to 55mm
- nametag-width: Width of nametag. Defaults to 90mm
- bg-image: A background image for the nametag. Preferably use same dimensions as nametag for accurate alignment
- trim-color: Color of dashed trim line in hexadecimal
- text-color: Color of all text in hexadecimal

## Examples

**With custom background image**

```
---
info:
  - line1: "Olivia Sterling"
    line2: "Quantum Physicist"
    line3: "Quantum Research Institute"
  - line1: "Marcus Finnegan"
    line2: "Chief Technology Officer"
logo-left:
  path: "assets/logo1.png"
logo-right:
  path: "assets/logo2.png"
bg-image:
  path: assets/abstract.png
format:
  nametag-typst:
    keep-typ: true
    font-paths: fonts
---
```

![](preview-1.jpg)

```
---
info:
  - line1: "Olivia Sterling"
    line2: "Manager"
  - line1: "Marcus Finnegan"
    line2: "Manager"
bg-image:
  path: assets/bg.png
format:
  nametag-typst:
    keep-typ: true
    font-paths: fonts
---
```

![](preview-2.jpg)

```
---
info:
  - line1: "Olivia Sterling"
    line2: "Manager"
  - line1: "Marcus Finnegan"
    line2: "Manager"
bg-image:
  path: assets/abstract-dark.png
text-color: "#d6dbdf"
format:
  nametag-typst:
    keep-typ: true
    font-paths: fonts
---
```

![](preview-3.jpg)

---

2025 • Roy Francis
