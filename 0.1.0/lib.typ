// --- Internal Imports ---
#import "modules/visuals.typ": diagram, node, edge, canvas, adj-graph, path-graph, cycle-graph
#import "modules/math.typ": col, deg, dist, setBuilder, definition, example, init-theorems, set-theorem-mode, smart-theorem
#import "modules/theorems.typ": lib as thm_db
#import "modules/utils.typ": mat-to-graph, print-adj-matrix, subfigures, solution, set-solution-mode, problem, part, complement-matrix, contract-matrix, union-matrix, join-matrix

// --- Re-Exports ---
#let diagram = diagram
#let node = node
#let edge = edge
#let canvas = canvas
#let adj-graph = adj-graph
#let path-graph = path-graph
#let cycle-graph = cycle-graph

#let col = col
#let deg = deg
#let dist = dist
#let setBuilder = setBuilder

#let definition = definition
#let example = example
#let theorem = smart-theorem
#let set-theorem-mode = set-theorem-mode
#let thm = thm_db

#let mat-to-graph = mat-to-graph
#let print-adj-matrix = print-adj-matrix
#let subfigures = subfigures
#let solution = solution
#let set-solution-mode = set-solution-mode
#let problem = problem
#let part = part

#let complement-matrix = complement-matrix
#let contract-matrix = contract-matrix
#let union-matrix = union-matrix
#let join-matrix = join-matrix

// --- Project Template ---
#let project(title: "", authors: (), body) = {
  set document(title: title, author: authors)
  set page(margin: 1.75in, numbering: "1")
  set text(font: "New Computer Modern", size: 11pt)
  set heading(numbering: "1.1")
  show: init-theorems

  align(center)[
    #text(1.5em, weight: "bold")[#title] \
    #v(0.5em) #authors.join(", ") #v(1em)
  ]
  
  body
}