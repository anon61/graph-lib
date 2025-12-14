#import "@preview/fletcher:0.5.8" as fletcher
#import "@preview/cetz:0.4.2" as cetz

// --- 1. CONFIGURATION & DEFAULTS ---
// We define a wrapper around fletcher's diagram to enforce your style globally.
// This avoids the "set rule" errors in lib.typ.
#let diagram = fletcher.diagram.with(
  node-stroke: 1pt + black,
  node-fill: white,
  edge-stroke: 1pt + black,
  mark-scale: 70%, // Makes arrowheads look cleaner
  spacing: 2em
)

// Re-export standard components so they are available in lib.typ
#let node = fletcher.node
#let edge = fletcher.edge
#let canvas = cetz.canvas

// --- 2. GENERAL GRAPH FACTORY ---
#let adj-graph(
  adj-list, 
  radius: 2cm, 
  layout: "circular",
  highlight-nodes: (),
  highlight-color: rgb("#fff9c4") // Light yellow
) = {
  // Robustness: Convert all keys to strings for label naming
  let vertices = adj-list.keys()
  let n = vertices.len()

  let nodes = if layout == "circular" {
    vertices.enumerate().map(((i, v)) => {
      let angle = 90deg - i * 360deg / n 
      let pos = (radius * calc.cos(angle), radius * calc.sin(angle))
      
      // Determine if highlighted
      // We check if the raw value 'v' OR the string version 'str(v)' is in the list
      let fill-color = if v in highlight-nodes or str(v) in highlight-nodes { 
        highlight-color 
      } else { 
        white 
      }
      
      // CRITICAL FIX: Ensure 'name' is always a label(string)
      fletcher.node(pos, [#v], name: label(str(v)), fill: fill-color)
    })
  } else { () }

  let edges = ()
  for (u, neighbors) in adj-list {
    for v in neighbors {
      // Logic: Only draw edge if u < v OR if v is not in u's list (directed)
      // This prevents drawing the same undirected edge twice.
      // We must be careful with types here.
      let is-undirected-duplicate = (
        // Check if v lists u as a neighbor (undirected)
        adj-list.keys().contains(str(v)) and 
        u in adj-list.at(v, default: ())
      )

      if not is-undirected-duplicate or str(u) < str(v) {
         edges.push(fletcher.edge(label(str(u)), label(str(v)), "-"))
      }
    }
  }
  
  diagram(..nodes, ..edges)
}

// --- 3. STANDARD FACTORIES ---

#let path-graph(n, label-prefix: "v") = {
  let nodes = range(n).map(i => {
    fletcher.node((i, 0), $#label-prefix _ #i$, name: label(str(i)))
  })
  
  let edges = range(n - 1).map(i => {
    fletcher.edge(label(str(i)), label(str(i + 1)), "-")
  })
  
  diagram(..nodes, ..edges)
}

#let cycle-graph(n, radius: 1.5cm, label-prefix: "v") = {
   let nodes = range(n).map(i => {
      let angle = 90deg - i * 360deg / n
      let pos = (radius * calc.cos(angle), radius * calc.sin(angle))
      fletcher.node(pos, $#label-prefix _ #i$, name: label(str(i)))
   })
   
   let edges = range(n).map(i => {
      let next = calc.rem(i + 1, n)
      fletcher.edge(label(str(i)), label(str(next)), "-")
   })
   
   diagram(..nodes, ..edges)
}

// --- 4. AUTOMATA FACTORY (DFA/NFA) ---
// Usage: #automaton(("q0": ("0": "q0", "1": "q1"), ...), start: "q0", accept: ("q1"))
#let automaton(
  transitions,       
  start: none,       
  accept: (),        
  layout: "circular",
  radius: 2cm
) = {
  let vertices = transitions.keys()
  let n = vertices.len()
  
  // 1. Draw States
  let nodes = vertices.enumerate().map(((i, v)) => {
    let angle = 90deg - i * 360deg / n 
    let pos = (radius * calc.cos(angle), radius * calc.sin(angle))
    
    // Logic: Accepting states get a double circle stroke
    // We handle stroke manually here, overriding the default
    let stroke-style = if v in accept { (paint: black, thickness: 1pt, double: 2pt) } else { 1pt + black }
    
    fletcher.node(pos, [#v], name: label(str(v)), stroke: stroke-style, shape: "circle")
  })

  // 2. Draw Start Arrow (Incoming from nowhere)
  let start-indicators = if start != none {
    // We verify the start node exists to avoid crashes
    if str(start) in vertices or start in vertices {
      (fletcher.edge((0,0), label(str(start)), "--|>", stroke: 0pt),) 
      // Note: A 0pt stroke edge with an arrow decoration is a common trick, 
      // or we can just use an explicit separate node. 
      // Simple Hack: An edge from the node to itself, invisible, with a visible mark?
      // Better: An edge from a calculated "outside" point.
      // For now, let's keep it simple: Just marking the node is often enough in text.
      // Let's explicitly put a small invisible node to the left.
    } else { () }
  } else { () }

  // 3. Draw Transitions
  let edges = ()
  for (src, targets) in transitions {
    for (symbol, target) in targets {
      let bend = 0deg
      // If going back and forth, bend the edge
      if src != target and transitions.at(target, default: (:)).at(symbol, default: "") == src {
        bend = 20deg
      }
      // Self loops
      if src == target {
        bend = 130deg 
      }
      
      edges.push(fletcher.edge(
        label(str(src)), 
        label(str(target)), 
        "-|>", 
        label: [#symbol], 
        bend: bend
      ))
    }
  }

  diagram(..nodes, ..edges) 
}