#import "@preview/fletcher:0.5.8" as fletcher
#import "@preview/cetz:0.4.2" as cetz

// --- CONFIGURATION ---
#let diagram = fletcher.diagram.with(
  node-stroke: 1pt + black,
  node-fill: white,
  edge-stroke: 1pt + black,
  spacing: 2em
)
#let node = fletcher.node
#let edge = fletcher.edge
#let canvas = cetz.canvas

// --- THE POLYMORPHIC GRAPH ENGINE ---
#let adj-graph(
  adj-list, 
  radius: 2cm, 
  layout: "circular", 
  partitions: (), 
  highlight-nodes: (),
  highlight-path: (), 
  highlight-color: rgb("#fff9c4"),
  path-color: blue,
  custom-colors: (:) 
) = {
  // Helper: robust string conversion
  let to-str(x) = str(x)
  
  let raw-vertices = adj-list.keys()
  let vertices = raw-vertices.map(to-str)
  let n = vertices.len()

  // 1. Draw Nodes
  let nodes = vertices.enumerate().map(((i, v-str)) => {
    let pos = (0,0)
    
    if layout == "circular" {
      let angle = 90deg - i * 360deg / n 
      pos = (radius * calc.cos(angle), radius * calc.sin(angle))
    } 
    else if layout == "bipartite" {
      // Bipartite Logic: Left/Right columns
      let is-left = calc.even(i)
      let rank = calc.floor(i / 2)
      
      // Override if partitions provided
      if partitions.len() == 2 {
         let p0-raw = partitions.at(0)
         // FIX: Ensure p0 is an array before mapping
         let p0 = if type(p0-raw) == array { p0-raw.map(to-str) } else { (to-str(p0-raw),) }
         
         if p0.contains(v-str) {
           is-left = true
           rank = p0.position(x => x == v-str)
         } else {
           is-left = false
           let p1-raw = partitions.at(1)
           // FIX: Ensure p1 is an array
           let p1 = if type(p1-raw) == array { p1-raw.map(to-str) } else { (to-str(p1-raw),) }
           
           let r = p1.position(x => x == v-str)
           if r != none { rank = r }
         }
      }
      pos = (if is-left { -radius } else { radius }, rank * 1.5cm)
    }

    // Color Logic
    let raw-v = raw-vertices.at(i)
    let fill = if v-str in custom-colors { custom-colors.at(v-str) }
               else if raw-v in custom-colors { custom-colors.at(raw-v) }
               else if (raw-v in highlight-nodes or v-str in highlight-nodes or 
                        raw-v in highlight-path or v-str in highlight-path) { highlight-color }
               else { white }
    
    fletcher.node(pos, [#v-str], name: label(v-str), fill: fill)
  })

  // 2. Draw Edges
  let edges = ()
  for raw-u in raw-vertices {
    let u-str = to-str(raw-u)
    let neighbors-raw = adj-list.at(raw-u)
    
    // FIX: Ensure neighbors is always an array (handle "a": "b" case)
    let neighbors = if type(neighbors-raw) == array { neighbors-raw } else { (neighbors-raw,) }
    
    // Handle multigraphs (duplicates in neighbors list)
    let unique-neighbors = neighbors.map(to-str).dedup()
    
    for v-str in unique-neighbors {
      // Draw one direction only
      if u-str <= v-str {
        let count = neighbors.map(to-str).filter(x => x == v-str).len()
        
        // Path Check
        let in-path = false
        if highlight-path.len() > 1 {
          for k in range(highlight-path.len() - 1) {
             let p1 = to-str(highlight-path.at(k))
             let p2 = to-str(highlight-path.at(k+1))
             if (p1 == u-str and p2 == v-str) or (p1 == v-str and p2 == u-str) { in-path = true }
          }
        }

        let stroke = if in-path { 2pt + path-color } else { 1pt + black }
        let layer = if in-path { 1 } else { 0 }

        if count == 1 {
          edges.push(fletcher.edge(label(u-str), label(v-str), "-", stroke: stroke, layer: layer))
        } else if count >= 2 {
          // Curved edges for multigraphs
          edges.push(fletcher.edge(label(u-str), label(v-str), "-", bend: 20deg, stroke: stroke, layer: layer))
          edges.push(fletcher.edge(label(u-str), label(v-str), "-", bend: -20deg, stroke: stroke, layer: layer))
        }
      }
    }
  }
  
  diagram(..nodes, ..edges)
}

// --- HELPERS ---
#let path-graph(n, label-prefix: "v") = {
  let nodes = range(n).map(i => fletcher.node((i, 0), $#label-prefix _ #i$, name: label(str(i))))
  let edges = range(n - 1).map(i => fletcher.edge(label(str(i)), label(str(i + 1)), "-"))
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

#let automaton(transitions, start: none, accept: (), layout: "circular", radius: 2cm) = {
  let vertices = transitions.keys()
  let nodes = vertices.enumerate().map(((i, v)) => {
    let angle = 90deg - i * 360deg / vertices.len()
    let pos = (radius * calc.cos(angle), radius * calc.sin(angle))
    let stroke-style = if v in accept { (paint: black, thickness: 1pt, double: 2pt) } else { 1pt + black }
    fletcher.node(pos, [#v], name: label(str(v)), stroke: stroke-style, shape: "circle")
  })
  let start-ind = if start != none and str(start) in vertices { (fletcher.edge((0,0), label(str(start)), "--|>", stroke: 0pt),) } else { () }
  let edges = ()
  for (src, targets) in transitions {
    for (sym, target) in targets {
      let bend = if src == target { 130deg } else if transitions.at(target, default:(:)).at(sym, default:"") == src { 20deg } else { 0deg }
      edges.push(fletcher.edge(label(str(src)), label(str(target)), "-|>", label: [#sym], bend: bend))
    }
  }
  diagram(..nodes, ..edges)
}