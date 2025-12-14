#import "@local/graph-lib:0.1.0": *

// 1. TITLE PAGE WITH PEDAGOGICAL DESIGN
#worksheet-title(
  title: "Graph Theory HW #2",
  subtitle: "Connectivity & Structure",
  author: "Student Admin",
  date: "Due: Dec 15, 2025",
  
  // Learning Resources (Green/Blue Zones)
  definitions: [
    *Connectivity $kappa(G)$:* Min vertices to disconnect $G$. \
    *Cut-Edge:* An edge whose removal increases components. \
    *Bipartite:* A graph with no odd cycles.
  ],
  tools: [
    - *Whitney:* $kappa(G) <= kappa'(G) <= delta(G)$
    - *Handshake:* $sum_(v) deg(v) = 2|E|$
    - *Euler:* Connected & Even degrees $<=>$ Eulerian.
  ],
  
  // WARNING ZONE (Red)
  mistakes: [
    - *Confusing $kappa$ and $kappa'$:* Remember, vertex cuts are "cheaper" or equal to edge cuts. Removing vertices kills all incident edges!
    - *Regularity Assumption:* Do not assume a graph is regular unless stated. $K_{m,n}$ is bipartite but not necessarily regular.
    - *Empty Sets:* Remember that connectivity of a complete graph $K_n$ is $n-1$, not undefined.
  ]
)

// 2. QUESTIONS (The "Excellent" Layout)

// Q1: Typed Answer (Digital Submission)
#question(
  title: "Problem 1: Whitney's Inequality", 
  points: 10,
  hint: "Consider the edges incident to a vertex of minimum degree.",
  answer: [
    We know that removing all neighbors of a vertex $v$ isolates it. 
    The number of neighbors is $delta(G)$.
    Thus, there exists a vertex cut of size $delta(G)$, so $kappa(G) <= delta(G)$.
    
    For the second part... #thm.whitney
  ]
)[
  Prove that for any graph $G$, $kappa(G) <= kappa'(G) <= delta(G)$.
]

// Q2: Handwriting Mode (Print Submission)
// Notice we provide NO 'answer', so it renders a dotted box.
#question(
  title: "Problem 2: Bipartite Matching",
  points: 15,
  hint: "Draw the graph using the Bipartite Layout tool to visualize the partitions.",
  height: 5cm // Reserve 5cm for writing
)[
  Determine if the following graph has a perfect matching. If not, find a Hall violator set.
  
  #let my-graph = (
    "A": ("1", "2"), "B": ("1"), "C": ("1", "2", "3"),
    "1": ("A", "B", "C"), "2": ("A", "C"), "3": ("C")
  )
  
  #align(center, adj-graph(
    my-graph, 
    layout: "bipartite",
    partitions: (("A", "B", "C"), ("1", "2", "3"))
  ))
]

// Q3: Advanced Logic
#question(title: "Problem 3: Super Vertices", points: 5)[
  Draw the graph resulting from contracting the edge $(u, v)$ in $C_4$.
  
  #let c4 = ((0,1,0,1),(1,0,1,0),(0,1,0,1),(1,0,1,0))
  #align(center, subfigures(
    mat-to-graph(c4),
    mat-to-graph(contract-matrix(c4, 0, 1)),
    captions: ("Original $C_4$", "Contracted")
  ))
]