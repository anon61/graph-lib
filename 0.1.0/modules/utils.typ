#import "visuals.typ": adj-graph

// --- 1. Graph Conversion & Matrix Logic ---
#let mat-to-graph(matrix) = {
  let n = matrix.len()
  let adj-list = (:)
  for i in range(n) {
    let neighbors = ()
    for j in range(n) {
      let weight = matrix.at(i).at(j)
      // Push 'j' multiple times if weight > 1 (multigraph support)
      if weight > 0 {
        for k in range(weight) { neighbors.push(str(j)) }
      }
    }
    adj-list.insert(str(i), neighbors)
  }
  adj-graph(adj-list)
}

#let print-adj-matrix(adj-list) = {
  // Robustly handle string/int keys
  let keys = adj-list.keys().map(x => if type(x) == str { int(x) } else { x }).sorted().map(str)
  let rows = ()
  for u in keys {
    let row = ()
    let neighbors = adj-list.at(u, default: ()).map(str)
    for v in keys {
      let count = neighbors.filter(x => x == v).len()
      row.push(count)
    }
    rows.push(row)
  }
  math.mat(..rows)
}

// --- 2. Advanced Graph Operations ---
#let complement-matrix(matrix) = {
  let n = matrix.len()
  let new-mat = ()
  for i in range(n) {
    let row = ()
    for j in range(n) {
      if i == j { row.push(0) } 
      else if matrix.at(i).at(j) == 0 { row.push(1) } 
      else { row.push(0) }
    }
    new-mat.push(row)
  }
  new-mat
}

#let contract-matrix(matrix, u, v) = {
  let n = matrix.len()
  let (keep, remove) = if u < v { (u, v) } else { (v, u) }
  let new-mat = ()
  let active-indices = range(n).filter(i => i != remove)
  
  for i in active-indices {
    let row = ()
    for j in active-indices {
      let val = 0
      if i == keep and j == keep { val = 0 } // No self loops
      else if i == keep { val = matrix.at(keep).at(j) + matrix.at(remove).at(j) }
      else if j == keep { val = matrix.at(i).at(keep) + matrix.at(i).at(remove) }
      else { val = matrix.at(i).at(j) }
      row.push(val)
    }
    new-mat.push(row)
  }
  new-mat
}

#let union-matrix(mat1, mat2) = {
  let n1 = mat1.len()
  let n2 = mat2.len()
  let rows = ()
  for r in mat1 { rows.push(r + (0,) * n2) }
  for r in mat2 { rows.push((0,) * n1 + r) }
  rows
}

#let join-matrix(mat1, mat2) = {
  let n1 = mat1.len()
  let n2 = mat2.len()
  let rows = ()
  for r in mat1 { rows.push(r + (1,) * n2) }
  for r in mat2 { rows.push((1,) * n1 + r) }
  rows
}

// --- 3. Homework & Solutions ---
#let subfigures(..figs, captions: ()) = {
  let n = figs.pos().len()
  grid(
    columns: (1fr,) * n,
    gutter: 1em,
    ..figs.pos().enumerate().map(((i, fig)) => {
      align(center)[
        #fig
        #if captions.len() > i [ #v(0.5em) *Figure #(i + 1):* #captions.at(i) ]
      ]
    })
  )
}

#let show-solutions = state("solutions", false)
#let set-solution-mode(visible) = show-solutions.update(visible)

#let solution(body) = context {
  if show-solutions.get() {
    block(fill: rgb("#e3f2fd"), stroke: (left: 4pt + blue), inset: 1em, radius: 4pt, [*Solution:* \ #body])
  } else {
    block(fill: luma(250), stroke: (left: 4pt + gray), inset: 1em, radius: 4pt, text(fill: gray)[_(Solution hidden)_])
  }
}

#let problem-counter = counter("problem")
#let part-counter = counter("part")

#let problem(title: none, points: none) = {
  problem-counter.step()
  part-counter.update(0)
  pad(top: 1em, bottom: 0.5em)[
    #block(stroke: (bottom: 0.5pt + gray), width: 100%, inset: (bottom: 0.3em))[
      #text(weight: "bold", size: 1.2em)[Problem #context problem-counter.display() #if title != none [ : #title ]]
      #h(1fr) #if points != none [ #text(style: "italic")[#points pts] ]
    ]
  ]
}

#let part(body) = { part-counter.step(); pad(left: 1em, top: 0.2em)[*#context part-counter.display("(a)")* #h(0.5em) #body] }