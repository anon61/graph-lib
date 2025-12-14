// --- CONFIGURATION ---
// A robust default theme that uses color theory for pedagogical focus
#let default-theme = (
  primary: rgb("#1d3557"),    // Navy: Headers & Structure
  secondary: rgb("#e3f2fd"),  // Pale Blue: Solution Backgrounds
  accent: rgb("#d32f2f"),     // Red: Mistakes & Alerts
  success: rgb("#2e7d32"),    // Green: Tools & Definitions
  text: rgb("#212121"),       // Black/Grey: Body text
  gray: rgb("#f5f5f5")        // Light Grey: Neutral backgrounds
)

// --- TITLE PAGE ENGINE ---
#let worksheet-title(
  title: "Homework",
  subtitle: none,
  author: "Student Name",
  date: datetime.today().display(),
  definitions: none,
  tools: none,
  mistakes: none,  // <--- NEW: The requested Common Mistakes section
  theme: default-theme
) = {
  set page(header: none, footer: none)
  
  // 1. Hero Header (Professional & Clean)
  block(width: 100%, inset: 2em, fill: theme.primary, radius: (bottom: 8pt))[
    #set text(fill: white)
    #align(center)[
      #text(title, size: 22pt, weight: "bold") \
      #if subtitle != none { 
        v(0.3em)
        text(subtitle, size: 14pt, style: "italic") 
      }
      #v(1.5em)
      #grid(
        columns: (auto, auto),
        gutter: 3em,
        text("Author: " + author, weight: "light"),
        text("Date: " + date, weight: "light")
      )
    ]
  ]
  
  v(2em)

  // 2. Learning Resources Grid
  let has-defs = definitions != none
  let has-tools = tools != none
  
  if has-defs or has-tools {
    grid(
      columns: if has-defs and has-tools { (1fr, 1fr) } else { (1fr,) },
      gutter: 1.5em,
      
      if has-defs {
        block(stroke: 1pt + theme.success, radius: 6pt, inset: 1.2em, width: 100%)[
          #place(top + left, dy: -1.9em)[
             #block(fill: white, inset: (x: 0.4em))[
               #text("Key Definitions", weight: "bold", fill: theme.success, size: 11pt)
             ]
          ]
          #set text(size: 10pt)
          #definitions
        ]
      },
      
      if has-tools {
        block(fill: theme.gray, radius: 6pt, inset: 1.2em, width: 100%)[
          #text("Tools & Theorems", weight: "bold", fill: theme.primary, size: 11pt)
          #v(0.3em)
          #line(length: 100%, stroke: 0.5pt + theme.primary)
          #v(0.3em)
          #set text(size: 10pt)
          #tools
        ]
      }
    )
  }
  
  // 3. Common Mistakes (The "Alert" Zone)
  // Designed to grab attention without being ugly
  if mistakes != none {
    v(1.5em)
    block(
      width: 100%, 
      fill: theme.accent.lighten(92%), // Very faint red background
      stroke: (left: 4pt + theme.accent), // Strong red bar on left
      radius: 4pt, 
      inset: 1.2em
    )[
      #text("Common Pitfalls & Mistakes", weight: "bold", fill: theme.accent, size: 11pt)
      #v(0.5em)
      #set text(size: 10pt)
      #mistakes
    ]
  }
  
  pagebreak()
}

// --- QUESTION ENGINE ---
#let question(
  title: none, 
  body, 
  answer: none, 
  hint: none,      // <--- NEW: Pedagogical scaffolding
  points: none,    // <--- NEW: Assessment transparency
  height: 3cm,     // <--- NEW: Control handwriting space
  theme: default-theme
) = {
  // 1. Question Header
  pad(bottom: 0.5em, top: 1em)[
    #block(
      stroke: (left: 3pt + theme.primary), 
      inset: (left: 1em, top: 0.2em, bottom: 0.2em)
    )[
      #grid(
        columns: (1fr, auto),
        align: (left, bottom),
        if title != none { text(title, weight: "bold", fill: theme.primary, size: 12pt) },
        if points != none { text(str(points) + " pts", style: "italic", fill: gray.darken(20%), size: 10pt) }
      )
      #if title != none { v(0.3em) }
      #body
    ]
  ]

  // 2. Pedagogical Hint (Optional)
  if hint != none {
    pad(left: 1.5em, bottom: 0.8em)[
      #text(fill: theme.success, style: "italic", size: 10pt)[
        *Hint:* #hint
      ]
    ]
  }

  // 3. Answer Area (Smart Toggle)
  if answer != none {
    // --- DIGITAL MODE (Typed) ---
    block(
      width: 100%, 
      fill: theme.secondary, 
      radius: 4pt, 
      inset: 1.2em,
      stroke: 0.5pt + theme.primary.lighten(60%)
    )[
      #place(top + left, dy: -1.9em)[
         #block(fill: theme.secondary, inset: (x: 0.4em), radius: 2pt)[
           #text("Solution", weight: "bold", size: 9pt, fill: theme.primary)
         ]
      ]
      #answer
    ]
  } else {
    // --- PRINT MODE (Handwriting) ---
    block(
      width: 100%, 
      height: height, 
      radius: 4pt, 
      stroke: (paint: gray.darken(10%), dash: "dotted", thickness: 1pt),
      inset: 1em
    )[
      // A subtle pencil icon to indicate writing space
      #place(center + horizon, text(fill: gray.lighten(20%), size: 24pt)[#sym.pencil])
    ]
  }
  
  v(1.5em)
}