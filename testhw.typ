#import "@local/graph-lib:0.1.0": *

#show: project.with(title: "Homework Engine Test", authors: ("Student Admin",))

// ==========================================
// SCENARIO 1: Basic Problems
// ==========================================

#problem(title: "Basic Counting", points: 5)
How many edges are in $K_n$?

#solution[
  The number of edges is $binom(n, 2) = frac(n(n-1), 2)$.
]

// ==========================================
// SCENARIO 2: Multi-Part Problems
// ==========================================

#problem(title: "Connectivity", points: 15)
Let $G$ be a connected graph.

#part[Define vertex connectivity $kappa(G)$.]
#solution[The minimum number of vertices whose removal disconnects $G$.]

#part[State Whitney's Theorem.]
#solution[
  #thm.whitney
]

#part[Prove that $kappa(C_n) = 2$ for $n >= 3$.]
#solution[
  Removing 1 vertex leaves $P_{n-1}$, which is connected. Removing 2 non-adjacent vertices disconnects the cycle. Thus 2 is required.
]

// ==========================================
// SCENARIO 3: Automatic Numbering Check
// ==========================================

#problem() // No title, just numbering
This problem should automatically be "Problem 3".

#part[This should be part (a).]
#part[This should be part (b).]

// ==========================================
// SCENARIO 4: Integration with Visuals
// ==========================================
#problem(title: "Drawings", points: 10)
Draw $C_3$ and its complement.

#subfigures(
  cycle-graph(3),
  // FIX: Use strings "0", "1", "2" instead of integers 0, 1, 2
  adj-graph(("0":(), "1":(), "2":())), 
  captions: ("The Graph", "The Complement")
)