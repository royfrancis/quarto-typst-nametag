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

Change metadata in `index.qmd` as needed. All of the settings metadata specified below are optional.

- info: Up to four lines of information. Key must be named line1, line2 etc. All lines are optional.
- logo-left.path/logo-right.path: Path to left logo
- logo-left-height/logo-right-height: Height of left and right logos
- font-size: Base font size. Line 1 is 1.2x and line3/line4 are 0.9x.
- leading: Spacing between lines
- paper-height: Height of paper. Defaults to A4
- paper-width: Width of paper. Defaults to A4
- nametag-height: Height of nametag. Defaults to 55mm
- nametag-width: Width of nametag. Defaults to 90mm

---

2025 • Roy Francis
