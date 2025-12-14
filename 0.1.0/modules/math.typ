#import "@preview/theorion:0.4.1" as theorion

// --- 1. Semantic Math Aliases ---
#let col(G) = $chi (#G)$ 
#let deg(v) = $op("deg")(#v)$
#let dist(u, v) = $op("dist")(#u, #v)$

// FIX: Renamed to camelCase as requested
#let setBuilder(elem, cond) = ${ #elem mid(|) #cond }$ 

// --- 2. Advanced Theorem System ---
#let show-details = state("theorem-details", false)
#let set-theorem-mode(visible) = show-details.update(visible)

#let smart-theorem(
  name, 
  statement, 
  given: none, 
  to-show: none, 
  proof: none
) = {
  theorion.theorem(title: name)[
    #context {
      if show-details.get() {
        // Full Mode
        block(width: 100%, inset: (bottom: 0.5em), statement)
        if given != none or to-show != none {
          pad(left: 1em, top: 0.5em, bottom: 0.5em)[
            #grid(
              columns: (auto, 1fr),
              gutter: 0.5em,
              if given != none { [*Given:*] }, if given != none { given },
              if to-show != none { [*To Show:*] }, if to-show != none { to-show }
            )
          ]
        }
        if proof != none {
           line(length: 100%, stroke: 0.5pt + gray)
           [*Proof:* #proof #h(1fr) $square$]
        }
      } else {
        // Compact Mode
        text(fill: gray, size: 0.8em)[ _(See details)_]
      }
    }
  ]
}

#let init-theorems(body) = { body }
#let definition = theorion.definition
#let example = theorion.example