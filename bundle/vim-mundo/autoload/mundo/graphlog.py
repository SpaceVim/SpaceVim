import time
import util


# Mercurial's graphlog code -------------------------------------------------------
def asciiedges(seen, rev, parents):
    """adds edge info to changelog DAG walk suitable for ascii()"""
    if rev not in seen:
        seen.append(rev)
    nodeidx = seen.index(rev)

    knownparents = []
    newparents = []
    for parent in parents:
        if parent in seen:
            knownparents.append(parent)
        else:
            newparents.append(parent)

    ncols = len(seen)
    seen[nodeidx:nodeidx + 1] = newparents
    edges = [(nodeidx, seen.index(p)) for p in knownparents]

    if len(newparents) > 0:
        edges.append((nodeidx, nodeidx))
    if len(newparents) > 1:
        edges.append((nodeidx, nodeidx + 1))

    nmorecols = len(seen) - ncols
    return nodeidx, edges, ncols, nmorecols


def get_nodeline_edges_tail(
        node_index, p_node_index, n_columns, n_columns_diff, p_diff, fix_tail):
    if fix_tail and n_columns_diff == p_diff and n_columns_diff != 0:
        # Still going in the same non-vertical direction.
        if n_columns_diff == -1:
            start = max(node_index + 1, p_node_index)
            tail = ["|", " "] * (start - node_index - 1)
            tail.extend(["/", " "] * (n_columns - start))
            return tail
        else:
            return ["\\", " "] * (n_columns - node_index - 1)
    else:
        return ["|", " "] * (n_columns - node_index - 1)


def draw_edges(edges, nodeline, interline):
    for (start, end) in edges:
        if start == end + 1:
            interline[2 * end + 1] = "/"
        elif start == end - 1:
            interline[2 * start + 1] = "\\"
        elif start == end:
            interline[2 * start] = "|"
        else:
            nodeline[2 * end] = "+"
            if start > end:
                (start, end) = (end, start)
            for i in range(2 * start + 1, 2 * end):
                if nodeline[i] != "+":
                    nodeline[i] = "-"


def fix_long_right_edges(edges):
    for (i, (start, end)) in enumerate(edges):
        if end > start:
            edges[i] = (start, end + 1)


def ascii(state, type, char, text, coldata, verbose):
    """prints an ASCII graph of the DAG

    takes the following arguments (one call per node in the graph):

      - Somewhere to keep the needed state in (init to asciistate())
      - Column of the current node in the set of ongoing edges.
      - Type indicator of node data == ASCIIDATA.
      - Payload: (char, lines):
        - Character to use as node's symbol.
        - List of lines to display as the node's text.
      - Edges; a list of (col, next_col) indicating the edges between
        the current node and its parents.
      - Number of columns (ongoing edges) in the current revision.
      - The difference between the number of columns (ongoing edges)
        in the next revision and the number of columns (ongoing edges)
        in the current revision. That is: -1 means one column removed;
        0 means no columns added or removed; 1 means one column added.
      - Verbosity: if enabled then the graph prints an extra '|'
        between each line of information.

    Returns a string representing the output.
    """

    idx, edges, ncols, coldiff = coldata
    assert -2 < coldiff < 2
    if coldiff == -1:
        # Transform
        #
        #     | | |        | | |
        #     o | |  into  o---+
        #     |X /         |/ /
        #     | |          | |
        fix_long_right_edges(edges)

    # fix_nodeline_tail says whether to rewrite
    #
    #     | | o | |        | | o | |
    #     | | |/ /         | | |/ /
    #     | o | |    into  | o / /   # <--- fixed nodeline tail
    #     | |/ /           | |/ /
    #     o | |            o | |
    fix_nodeline_tail = len(text) <= 2

    # nodeline is the line containing the node character (typically o)
    nodeline = ["|", " "] * idx
    nodeline.extend([char, " "])

    nodeline.extend(
        get_nodeline_edges_tail(idx, state[1], ncols, coldiff,
                                state[0], fix_nodeline_tail))

    # shift_interline is the line containing the non-vertical
    # edges between this entry and the next
    shift_interline = ["|", " "] * idx
    if coldiff == -1:
        n_spaces = 1
        edge_ch = "/"
    elif coldiff == 0:
        n_spaces = 2
        edge_ch = "|"
    else:
        n_spaces = 3
        edge_ch = "\\"
    shift_interline.extend(n_spaces * [" "])
    shift_interline.extend([edge_ch, " "] * (ncols - idx - 1))

    # draw edges from the current node to its parents
    draw_edges(edges, nodeline, shift_interline)

    # lines is the list of all graph lines to print
    lines = [nodeline]
    lines.append(shift_interline)

    # make sure that there are as many graph lines as there are
    # log strings
    if any("/" in s for s in lines) or verbose:
        while len(text) < len(lines):
            text.append('')
    if len(lines) < len(text):
        extra_interline = ["|", " "] * (ncols + coldiff)
        while len(lines) < len(text):
            lines.append(extra_interline)

    indentation_level = max(ncols, ncols + coldiff)
    result = []
    for (line, logstr) in zip(lines, text):
        graph = "%-*s" % (2 * indentation_level, "".join(line))
        if not graph.isspace():
            result.append([graph, logstr])

    # ... and start over
    state[0] = coldiff
    state[1] = idx
    return result


def generate(verbose, num_header_lines, first_visible_line, last_visible_line, inline_graph, nodesData):
    """
    Generate an array of the graph, and text describing the node of the graph.
    """
    seen, state = [], [0, 0]
    result = []
    current = nodesData.current()

    nodes, nmap = nodesData.make_nodes()

    for node in nodes:
        node.children = [n for n in nodes if n.parent == node]

    def walk_nodes(nodes):
        for node in nodes:
            if node.parent:
                yield (node, [node.parent])
            else:
                yield (node, [])

    dag = sorted(nodes, key=lambda n: int(n.n), reverse=True)
    dag = walk_nodes(dag)

    line_number = num_header_lines
    for idx, part in list(enumerate(dag)):
        node, parents = part
        if node.time:
            age_label = age(int(node.time))
        else:
            age_label = 'Original'
        line = '[%s] %s' % (node.n, age_label)
        if node.n == current:
            char = '@'
        elif node.saved:
            char = 'w'
        else:
            char = 'o'
        show_inine_diff = inline_graph and line_number >= first_visible_line and line_number <= last_visible_line
        preview_diff = nodesData.preview_diff(node.parent, node, False, show_inine_diff)
        line = '[%s] %-10s %s' % (node.n, age_label, preview_diff)
        new_lines = ascii(state, 'C', char, [line], asciiedges(seen, node, parents), verbose)
        line_number += len(new_lines)
        result.extend(new_lines)
    util._undo_to(current)
    return result

# Mercurial age function -----------------------------------------------------------
agescales = [("yr", 3600 * 24 * 365),
             ("mon", 3600 * 24 * 30),
             ("wk", 3600 * 24 * 7),
             ("dy", 3600 * 24),
             ("hr", 3600),
             ("min", 60)]


def age(ts):
    '''turn a timestamp into an age string.'''

    def plural(t, c):
        if c == 1:
            return t
        return t + "s"

    def fmt(t, c):
        return "%d %s" % (int(c), plural(t, c))

    now = time.time()
    then = ts
    if then > now:
        return 'in the future'

    delta = max(1, int(now - then))
    if delta > agescales[0][1] * 2:
        return time.strftime('%Y-%m-%d', time.gmtime(float(ts)))

    for t, s in agescales:
        n = delta // s
        if n >= 2 or s == 1:
            return '%s ago' % fmt(t, n)

    return "<1 min ago"
