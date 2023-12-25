"""part one of AOC 2023 day 25"""


class Link:
    """a link between 2 nodes"""

    def __init__(self, t, w):
        self.towards = t
        self.weight = w

    def __str__(self) -> str:
        return self.towards + ": " + str(self.weight)


with open("problem.txt", encoding="utf8") as file:
    input_data = file.read().split("\n")

graph = {}

for line in input_data:
    left, right = line.split(":")
    right_elems = right.split(" ")[1::]
    for elem in right_elems:
        if left in graph:
            graph[left].append(Link(elem, 1))
        else:
            graph[left] = [Link(elem, 1)]
        if elem in graph:
            graph[elem].append(Link(left, 1))
        else:
            graph[elem] = [Link(left, 1)]

OLD_GRAPH_LEN = len(graph)


def graph_deep_clone(g):
    """deep clones a graph"""
    res = {}
    for key, val in g.items():
        res[key] = []
        for link in val:
            res[key].append(Link(link.towards, link.weight))
    return res


def print_graph(g):
    """prints the graph"""
    for key, val in g.items():
        curr_line = key + " -> ["
        for l in val:
            curr_line += str(l) + ", "
        curr_line += "]"
        print(curr_line)


def minimum_cut_phase(g, a):
    """stoer wagner min cut phase"""
    nodes = set()
    nodes.add(a)
    additions = [a]
    while len(nodes) != len(g.keys()):
        neighbours = {}
        for node in nodes:
            for neighbour in g[node]:
                if not neighbour.towards in nodes:
                    if not neighbour.towards in neighbours.keys():
                        neighbours[neighbour.towards] = neighbour.weight
                    else:
                        neighbours[neighbour.towards] += neighbour.weight
        # print(neighbours)
        max_tight = 0
        max_tight_node = None
        for node, dist in neighbours.items():
            if dist > max_tight:
                max_tight = dist
                max_tight_node = node
        additions.append(max_tight_node)
        nodes.add(max_tight_node)
    # COMPUTING CUT OF THE PHASE
    cut_of_the_phase = 0
    for link in g[additions[-1]]:
        cut_of_the_phase += link.weight
    # MERGING GRAPH
    neighbours = {}
    for node in [additions[-1], additions[-2]]:
        for neighbour in g[node]:
            if not neighbour.towards in [additions[-1], additions[-2]]:
                if not neighbour.towards in neighbours.keys():
                    neighbours[neighbour.towards] = neighbour.weight
                else:
                    neighbours[neighbour.towards] += neighbour.weight
    g[additions[-1] + "_" + additions[-2]] = []
    for key, val in neighbours.items():
        g[additions[-1] + "_" + additions[-2]].append(Link(key, val))
        g[key] = list(
            filter(
                lambda link: not link.towards in [additions[-1], additions[-2]], g[key]
            )
        )
        g[key].append(Link(additions[-1] + "_" + additions[-2], val))
    del g[additions[-1]]
    del g[additions[-2]]
    return cut_of_the_phase


def minimum_cut(g, node):
    """stoer wagner algorithm modified for this problem"""
    while len(g) > 1:
        cloned = graph_deep_clone(g)
        min_cut = minimum_cut_phase(g, node)
        if min_cut == 3:
            return cloned


new_graph = minimum_cut(graph, left)
# print_graph(new_graph)

longest_node_len = 0
for k in new_graph.keys():
    curr = k.split("_")
    if len(curr) > longest_node_len:
        longest_node_len = len(curr)

first_partition_length = longest_node_len
second_partition_length = OLD_GRAPH_LEN - first_partition_length

print(first_partition_length * second_partition_length)
