#import "visuals.typ": adj-graph

// --- 1. Graph Utilities ---
#let mat-to-graph(matrix) = {
  let n = matrix.len()
  let adj-list = (:)
  for i in range(n) {
    let neighbors = ()
    for j in range(n) {
      if matrix.at(i).at(j) != 0 { neighbors.push(str(j)) }
    }
    adj-list.insert(str(i), neighbors)
  }
  adj-graph(adj-list)
}

#let print-adj-matrix(adj-list) = {
  // FIX: Robust sorting. Convert to int to sort numerically (0, 1, 2, 10), then back to str.
  // This prevents the previous crash and ensures "10" comes after "2".
  let keys = adj-list.keys().map(int).sorted().map(str)
  
  let rows = ()
  for u in keys {
    let row = ()
    let neighbors = adj-list.at(u)
    for v in keys {
      if v in neighbors { row.push(1) } else { row.push(0) }
    }
    rows.push(row)
  }
  
  // FIX: Typst's 'mat' function takes flattened content.
  // We pass all elements and let the grid logic handle it or just return the data structure.
  // For simplicity and stability, we display it as a math matrix using standard syntax logic if possible,
  // or default to a simple grid if dynamic matrix construction is tricky.
  // The most robust way for dynamic matrices in current Typst is creating the array of arrays.
  math.mat(..rows)
}

#let subfigures(..figs, captions: ()) = {
  let n = figs.pos().len()
  grid(
    columns: (1fr,) * n,
    gutter: 1em,
    ..figs.pos().enumerate().map(((i, fig)) => {
      align(center)[
        #fig
        // FIX: Replaced 'calc.add(i,1)' with standard addition 'i + 1'
        #if captions.len() > i [ #v(0.5em) *Figure #(i + 1):* #captions.at(i) ]
      ]
    })
  )
}

// --- 3. Solution Toggle ---
#let show-solutions = state("solutions", false)
#let set-solution-mode(visible) = show-solutions.update(visible)

#let solution(body) = context {
  if show-solutions.get() {
    block(
      fill: rgb("#e3f2fd"), 
      stroke: (left: 4pt + blue),
      inset: 1em,
      width: 100%,
      radius: 4pt,
      [*Solution:* \ #body]
    )
  } else {
    block(
      fill: luma(250), 
      stroke: (left: 4pt + gray),
      inset: 1em,
      width: 100%,
      radius: 4pt,
      text(fill: gray)[_(Solution hidden for study purposes)_]
    )
  }
}

// --- 4. Homework Engine ---
#let problem-counter = counter("problem")
#let part-counter = counter("part")

#let problem(title: none, points: none) = {
  problem-counter.step()
  part-counter.update(0)
  
  pad(top: 1em, bottom: 0.5em)[
    #block(stroke: (bottom: 0.5pt + gray), width: 100%, inset: (bottom: 0.3em))[
      #text(weight: "bold", size: 1.2em)[
        Problem #context problem-counter.display()
        #if title != none [ : #title ]
      ]
      #h(1fr)
      #if points != none [ #text(style: "italic")[#points pts] ]
    ]
  ]
}

#let part(body) = {
  part-counter.step()
  pad(left: 1em, top: 0.2em, bottom: 0.2em)[
    *#context part-counter.display("(a)")* #h(0.5em) #body
  ]
}