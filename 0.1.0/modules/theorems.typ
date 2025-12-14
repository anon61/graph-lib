#import "math.typ": smart-theorem, col, deg, dist, setBuilder

// The "Course Database"
#let lib = (

  // ============================================================================
  // PART 1: BASICS & TREES
  // ============================================================================

  bipartite_char: smart-theorem(
    "Bipartite Characterization",
    [A graph $G$ is bipartite if and only if it contains no odd cycles.],
    given: [$G$ is a connected graph],
    proof: [
      *($=>$) Forward:* If $G$ is bipartite, its vertices partition into sets $A, B$. Any path must alternate between $A$ and $B$. To return to the start vertex (forming a cycle), we must take an even number of steps ($A -> B -> A...$). Thus, no odd cycles exist. \
      *($<=$) Backward:* Pick a root $v$. Define levels $L_i = setBuilder(u, dist(v, u) = i)$.
      If an edge existed between two vertices $x, y$ in the same level $L_k$, then the path $v -> x$, the edge $x y$, and the path $y -> v$ would form a cycle of length $k + 1 + k = 2k+1$ (odd), which is forbidden.
      Thus, edges only go between levels. We can color even levels $A$ and odd levels $B$ to form a valid bipartition.
    ]
  ),

  tree_equiv: smart-theorem(
    "Characterization of Trees",
    [The following are equivalent for an $n$-vertex graph $G$: \
     (i) $G$ is a tree (connected & acyclic). \
     (ii) $G$ is connected and has $n-1$ edges. \
     (iii) $G$ is acyclic and has $n-1$ edges. \
     (iv) There is a unique path between any pair of vertices.],
    proof: [
      *(i) $=>$ (ii):* Induction on $n$. A tree has a leaf. Remove it: $n' = n-1, e' = e-1$. By hypothesis $e' = n'-1$, so $e-1 = (n-1)-1 => e=n-1$. \
      *(ii) $=>$ (iii):* If connected with $n-1$ edges, assume a cycle exists. Removing a cycle edge keeps it connected. Repeat until acyclic (a tree). A tree has $n-1$ edges. If we removed edges, we started with $> n-1$, contradiction. \
      *(iii) $=>$ (i):* If acyclic with $n-1$ edges, assume disconnected. Components $1..k$ are trees. Total edges = sum of $(n_i - 1) = n - k$. Given $e=n-1$, so $k=1$. Connected. \
      *(i) $=>$ (iv):* Connected means at least one path. Acyclic means no second path (otherwise path1 + path2 forms a cycle).
    ]
  ),

  tree_embedding: smart-theorem(
    "Tree Embedding Theorem",
    [Every graph $G$ with $delta(G) >= k$ contains every tree $T$ with $k$ edges as a subgraph.],
    proof: [
      We build the tree node by node (Induction on $k$).
      *Base:* Trivial for one edge.
      *Step:* Let $v$ be a leaf of $T$, attached to parent $u$. Remove $v$ to get $T'$. Since $T'$ has $k-1$ edges, it embeds in $G$ by hypothesis.
      When we map $u$ to a vertex in $G$, that vertex has degree $>= k$. We have used at most $k-1$ neighbors for the rest of $T'$. Therefore, there is at least $k - (k-1) = 1$ neighbor free to map $v$ to.
    ]
  ),

  // ============================================================================
  // PART 2: CONNECTIVITY
  // ============================================================================

  whitney: smart-theorem(
    "Whitney's Theorem",
    [$kappa(G) <= kappa'(G) <= delta(G)$],
    to-show: [Vertex Connectivity $<=$ Edge Connectivity $<=$ Min Degree],
    proof: [
      *Right inequality:* To isolate a vertex $v$, we can simply cut all $deg(v)$ edges connected to it. Thus $kappa' <= delta$.
      *Left inequality:* Consider a minimum edge cut of size $kappa'$.
      If the edges in the cut share a vertex, we can cut that vertex.
      If not, we can pick one vertex from each edge in the cut to form a vertex cut of size $<= kappa'$. (Special care needed for complete graphs, but holds generally).
    ]
  ),

  dirac_critical: smart-theorem(
    "Dirac's Connectivity Theorem",
    [Every $(k+1)$-colour-critical graph is $k$-edge-connected.],
    given: [$G$ is critical ($chi$ drops if any edge removed)],
    proof: [
      Suppose there is a small cut of size $j < k$ that splits $G$ into $A$ and $B$.
      Because $G$ is critical, $A$ and $B$ (plus the cut edges) are $k$-colorable on their own.
      We can permute the colors of $B$ so that they match the colors of $A$ at the cut edges (since there are few edges, we have freedom).
      This would yield a $k$-coloring of the whole graph $G$, contradicting that $chi(G)=k+1$.
    ]
  ),

  menger: smart-theorem(
    "Menger's Theorem",
    [The size of the minimum vertex cut separating $u$ and $v$ equals the maximum number of internally disjoint paths between them.],
    proof: [
      *Max $<=$ Min:* If there are $k$ disjoint paths, we must remove at least 1 vertex from each to cut them. Thus Cut $>= k$.
      *Max $>=$ Min:* Usually proved via Max-Flow Min-Cut. Assign capacity 1 to vertices. The max flow represents the paths. The min cut represents the vertex separator.
    ]
  ),

  // ============================================================================
  // PART 3: EULER & HAMILTON
  // ============================================================================

  euler: smart-theorem(
    "Euler's Theorem",
    [A connected graph has an Eulerian circuit iff every vertex has even degree.],
    proof: [
      *($=>$) Necessity:* Every time the tour enters a vertex via an edge, it must leave via a different edge. Thus edges come in pairs. Degree must be even.
      *($<=$) Sufficiency:* Start a random walk from $v$. Since degrees are even, we never get stuck (if we enter, we can leave). We eventually return to $v$, forming a cycle $C$.
      If $C$ covers all edges, done. If not, remove $C$. Remaining edges still have even degrees. Find a cycle in the remainder and "splice" it into $C$. Repeat.
    ]
  ),

  dirac_hamilton: smart-theorem(
    "Dirac's Theorem (Hamiltonian)",
    [If $n >= 3$ and $delta(G) >= n/2$, then $G$ is Hamiltonian.],
    proof: [
      Assume $G$ is not Hamiltonian. Add edges until adding one more creates a cycle. The graph is now "maximally non-Hamiltonian", so it has a Hamiltonian Path $v_1 ... v_n$.
      The vertices $v_1$ and $v_n$ are not connected (or we'd have a cycle).
      Sum of degrees: $deg(v_1) + deg(v_n) >= n/2 + n/2 = n$.
      By Pigeonhole Principle, there must be an index $i$ such that $v_1$ connects to $v_{i+1}$ and $v_n$ connects to $v_i$.
      This allows us to form a cycle: $v_1 -> v_{i+1} ... v_n -> v_i ... v_1$. Contradiction.
    ]
  ),

  chvatal_erdos: smart-theorem(
    "Chvátal-Erdős Theorem",
    [If $kappa(G) >= alpha(G)$ (Connectivity $>=$ Independence Number), then $G$ is Hamiltonian.],
    proof: [
      Uses a closure argument. If a graph is not Hamiltonian, it contains a "blocker" structure related to independent sets.
      Specifically, if there is no cycle, the graph must tend to break apart into independent clumps, which violates high connectivity.
      Since $kappa$ is high, the graph stays together, forcing the independent set $alpha$ to be small, which forces Hamiltonicity.
    ]
  ),

  // ============================================================================
  // PART 4: MATCHINGS
  // ============================================================================

  hall: smart-theorem(
    "Hall's Marriage Theorem",
    [A bipartite graph $G=(A union B, E)$ has a matching saturating $A$ iff $|N(S)| >= |S|$ for all $S subset.eq A$.],
    proof: [
      *($=>$) Necessity:* If $S$ is matched, each node maps to a unique neighbor. Thus we need at least $|S|$ neighbors.
      *($<=$) Sufficiency:* If no matching exists, consider the symmetric difference with a maximum matching.
      Alternatively, finding a bottleneck set $S$ where $|N(S)| < |S|$ is the only obstruction. This is proved by analyzing the Alternating Paths Algorithm—if it fails, such a set $S$ is found.
    ]
  ),

  konig: smart-theorem(
    "König's Theorem",
    [In any bipartite graph, size of Max Matching = size of Min Vertex Cover. ($nu(G) = tau(G)$)],
    // FIX: Removed 'statement:' because statement is already provided in the argument above
    proof: [
      Let $M$ be a max matching. Let $U$ be the set of unmatched vertices in $A$.
      Build a tree of alternating paths from $U$.
      Let $Z$ be the set of vertices in the tree.
      The Vertex Cover is $K = (A without Z) union (B inter Z)$.
      One can show $|K| = |M|$, proving the equality.
    ]
  ),

  tutte: smart-theorem(
    "Tutte's Theorem",
    [A graph has a perfect matching iff for every subset $S$, the number of odd components in $G-S$ is at most $|S|$. \
     ($q(G-S) <= |S|$)],
    // FIX: Removed 'statement:' duplicate
    proof: [
      *($=>$) Necessity:* If a component $C$ is odd, at least one vertex in $C$ must match to someone outside $C$ (in $S$). Since each odd component demands a partner in $S$, if there are more odd components than nodes in $S$, someone is left alone.
      *($<=$) Sufficiency:* Uses the "Berge-Tutte Formula". The deficit of a graph is exactly determined by the worst-case set $S$. If condition holds, deficit is 0.
    ]
  ),

  petersen_2factor: smart-theorem(
    "Petersen's Theorem (2-Factors)",
    [Every $2k$-regular graph has a 2-factor (union of disjoint cycles).],
    proof: [
      Since degrees are even ($2k$), the graph is Eulerian. Take an Euler Tour.
      Direct the edges along the tour. Now every vertex has in-degree $k$ and out-degree $k$.
      Construct a bipartite graph by splitting each vertex $v$ into $v_{"in"}$ and $v_{"out"}$.
      This bipartite graph is $k$-regular. By Hall's Theorem (or regular bipartite property), it has a perfect matching.
      This matching maps $v_{"out"} -> u_{"in"}$, which corresponds to edges in the original graph forming cycles (a 2-factor).
    ]
  ),

  petersen_perfect: smart-theorem(
    "Petersen's Theorem (Perfect Matching)",
    [Every 3-regular graph with no cut-edges has a perfect matching.],
    proof: [
      We check Tutte's condition. Let $S$ be a set. We need to count odd components of $G-S$.
      Since $G$ is 3-regular and bridgeless, we count the edges leaving the odd components.
      Parity arguments show that at least 3 edges must leave each odd component (since it's bridgeless, can't be 1 edge).
      Counting edge endpoints shows $|S|$ is large enough to satisfy Tutte.
    ]
  ),

  // ============================================================================
  // PART 5: COLORING
  // ============================================================================

  konig_line: smart-theorem(
    "König's Line Colouring Theorem",
    [If $G$ is bipartite, $chi'(G) = Delta(G)$.],
    proof: [
      We need to color edges with $Delta$ colors. Induction on edges.
      Suppose edge $u v$ is uncolored. Since $deg(u), deg(v) < Delta$ (in partial graph), there is a color missing at $u$ (say Red) and at $v$ (say Blue).
      If Red = Blue, use it.
      If not, consider the path of edges alternating Red-Blue starting at $v$. Since graph is bipartite, path cannot loop back oddly to $u$. Swap colors on this path to free up a common color.
    ]
  ),

  vizing: smart-theorem(
    "Vizing's Theorem",
    [For any simple graph, $Delta(G) <= chi'(G) <= Delta(G)+1$.],
    proof: [
      Clearly we need $Delta$ colors.
      To show $Delta+1$ is enough: Similar to König's proof but harder.
      If a color is missing at $u$ and another at $v$, we construct a "Vizing Fan" (sequence of neighbors).
      We can rotate colors along the fan and swap colors along alternating paths until a safe color is found for the uncolored edge.
    ]
  ),

  heawood: smart-theorem(
    "Heawood's Theorem (Five Color)",
    [Every planar graph is 5-colorable.],
    proof: [
      Induction on $n$. Euler's formula implies planar graphs have a vertex $v$ with degree $<= 5$.
      *Case $<= 4$:* Remove $v$, color $G-v$, put $v$ back (it has a free color).
      *Case 5:* Remove $v$. Neighbors $v_1 ... v_5$ might use all 5 colors.
      Look at subgraphs induced by colors $1,3$ and $2,4$.
      If $v_1, v_3$ are in different components of the $1,3$-subgraph, we can swap colors in $v_1$'s component to free color 1.
      If they are connected, the path blocks $v_2$ from connecting to $v_4$ (planarity!). Thus $v_2, v_4$ must be disconnected in $2,4$-subgraph. Swap there.
    ]
  ),

  // ============================================================================
  // PART 6: EXTREMAL
  // ============================================================================

  mantel: smart-theorem(
    "Mantel's Theorem",
    [Max edges in triangle-free $G$ is $floor(n^2/4)$.],
    proof: [
      Let $G$ be triangle free. Let $u v$ be an edge.
      Since no triangles, neighbors of $u$ and neighbors of $v$ are disjoint.
      Thus $deg(u) + deg(v) <= n$.
      Summing over all edges: $sum_(u v) (deg(u)+deg(v)) <= e dot n$.
      LHS is also $sum_(v) deg(v)^2$.
      Using Cauchy-Schwarz: $sum deg(v)^2 >= (2e)^2 / n$.
      $(2e)^2 / n <= e n => 4e^2 <= e n^2 => e <= n^2/4$.
    ]
  ),

  erdos_szekeres: smart-theorem(
    "Erdős-Szekeres (Ramsey)",
    [$R(s,t) <= binom(s+t-2, s-1)$],
    proof: [
      Uses recurrence $R(s,t) <= R(s-1, t) + R(s, t-1)$.
      Similar to Pascal's Triangle logic.
      Pick a vertex $v$. Split others into neighbors $N$ and non-neighbors $M$.
      Either $N$ has clique $s-1$ (making clique $s$ with $v$) or $M$ has independent $t$...
      Induction establishes the binomial bound.
    ]
  ),

  euler_formula: smart-theorem(
    "Euler's Formula",
    [For connected plane graph: $v - e + f = 2$.],
    proof: [
      Induction on edges $e$.
      *Base:* Tree ($e=v-1$). No cycles, so 1 infinite face ($f=1$).
      $v - (v-1) + 1 = 2$. Correct.
      *Step:* If not a tree, there is a cycle edge $e$.
      Remove $e$. It merges two faces into one ($f -> f-1$).
      $v - (e-1) + (f-1) = v - e + f$.
      Formula invariant under edge removal.
    ]
  )
)