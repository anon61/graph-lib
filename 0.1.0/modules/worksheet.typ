// --- CONFIGURATION ---
#let default-theme = (
  primary: rgb("#1d3557"),    
  secondary: rgb("#e3f2fd"),  
  accent: rgb("#d32f2f"),     
  success: rgb("#2e7d32"),    
  text: rgb("#212121"),       
  gray: rgb("#f5f5f5")        
)

// --- TITLE PAGE ---
#let worksheet-title(
  title: "Homework",
  subtitle: none,
  author: "Student Name",
  date: datetime.today().display(),
  definitions: none,
  tools: none,
  mistakes: none, 
  theme: default-theme
) = {
  set page(header: none, footer: none)
  
  // 1. Header
  block(width: 100%, inset: 2em, fill: theme.primary, radius: (bottom: 8pt))[
    #set text(fill: white)
    #align(center)[
      #text(title, size: 22pt, weight: "bold") \
      #if subtitle != none { v(0.3em); text(subtitle, size: 14pt, style: "italic") }
      #v(1.5em)
      #grid(columns: (auto, auto), gutter: 3em, text("Author: " + author, weight: "light"), text("Date: " + date, weight: "light"))
    ]
  ]
  
  v(2em)

  // 2. Resources
  if definitions != none or tools != none {
    grid(
      columns: if definitions != none and tools != none { (1fr, 1fr) } else { (1fr,) },
      gutter: 1.5em,
      if definitions != none {
        block(stroke: 1pt + theme.success, radius: 6pt, inset: 1.2em, width: 100%)[
          #place(top + left, dy: -1.9em)[#block(fill: white, inset: (x: 0.4em))[#text("Key Definitions", weight: "bold", fill: theme.success, size: 11pt)]]
          #set text(size: 10pt)
          #definitions
        ]
      },
      if tools != none {
        block(fill: theme.gray, radius: 6pt, inset: 1.2em, width: 100%)[
          #text("Tools & Theorems", weight: "bold", fill: theme.primary, size: 11pt)
          #v(0.3em) #line(length: 100%, stroke: 0.5pt + theme.primary) #v(0.3em)
          #set text(size: 10pt)
          #tools
        ]
      }
    )
  }
  
  // 3. Mistakes
  if mistakes != none {
    v(1.5em)
    block(width: 100%, fill: theme.accent.lighten(92%), stroke: (left: 4pt + theme.accent), radius: 4pt, inset: 1.2em)[
      #text("Common Pitfalls & Mistakes", weight: "bold", fill: theme.accent, size: 11pt)
      #v(0.5em) #set text(size: 10pt)
      #mistakes
    ]
  }
  pagebreak()
}

// --- QUESTION ---
#let question(
  title: none, 
  body, 
  answer: none, 
  hint: none,      
  points: none,    
  height: 3cm,     
  theme: default-theme
) = {
  // 1. Question Header
  pad(bottom: 0.5em, top: 1em)[
    #block(stroke: (left: 3pt + theme.primary), inset: (left: 1em, top: 0.2em, bottom: 0.2em))[
      #grid(
        columns: (1fr, auto),
        align: (left, bottom),
        if title != none { text(title, weight: "bold", fill: theme.primary, size: 12pt) },
        // Fix: Use 'luma' instead of 'gray' to avoid method error
        if points != none { text(str(points) + " pts", style: "italic", fill: luma(100), size: 10pt) }
      )
      #if title != none { v(0.3em) }
      #body
    ]
  ]

  // 2. Hint
  if hint != none {
    pad(left: 1.5em, bottom: 0.8em)[#text(fill: theme.success, style: "italic", size: 10pt)[*Hint:* #hint]]
  }

  // 3. Answer Box
  if answer != none {
    block(width: 100%, fill: theme.secondary, radius: 4pt, inset: 1.2em, stroke: 0.5pt + theme.primary.lighten(60%))[
      #place(top + left, dy: -1.9em)[#block(fill: theme.secondary, inset: (x: 0.4em), radius: 2pt)[#text("Solution", weight: "bold", size: 9pt, fill: theme.primary)]]
      #answer
    ]
  } else {
    // Fix: Use 'luma' color and unicode pencil
    block(width: 100%, height: height, radius: 4pt, stroke: (paint: luma(150), dash: "dotted", thickness: 1pt), inset: 1em)[
       #place(center + horizon, text(fill: luma(200), size: 24pt)[#sym.suit.diamond]) 
    ]
  }
  v(1.5em)
}