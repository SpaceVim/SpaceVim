# NuiTree

NuiTree can render tree-like structured content on the buffer.

**Examples**

```lua
local NuiTree = require("nui.tree")

local tree = NuiTree({
  bufnr = bufnr,
  nodes = {
    NuiTree.Node({ text = "a" }),
    NuiTree.Node({ text = "b" }, {
      NuiTree.Node({ text = "b-1" }),
      NuiTree.Node({ text = { "b-2", "b-3" } }),
    }),
  },
})

tree:render()
```

## Options

### `bufnr`

**Type:** `number`

Id of the buffer where the tree will be rendered.

---

### `ns_id`

**Type:** `number` or `string`

Namespace id (`number`) or name (`string`).

---

### `nodes`

**Type:** `table`

List of [`NuiTree.Node`](#nuitreenode) objects.

---

### `get_node_id`

**Type:** `function`

_Signature:_ `get_node_id(node) -> string`

If provided, this function is used for generating node's id.

The return value should be a unique `string`.

**Example**

```lua
get_node_id = function(node)
  if node.id then
    return "-" .. node.id
  end

  if node.text then
    return string.format("%s-%s-%s", node:get_parent_id() or "", node:get_depth(), node.text)
  end

  return "-" .. math.random()
end,
```

---

### `prepare_node`

**Type:** `function`

_Signature:_ `prepare_node(node, parent_node?) -> nil | string | string[] | NuiLine | NuiLine[]`

If provided, this function is used for preparing each node line.

The return value should be a `NuiLine` object or `string` or a list containing either of them.

If return value is `nil`, that node will not be rendered.

**Example**

```lua
prepare_node = function(node)
  local line = NuiLine()

  line:append(string.rep("  ", node:get_depth() - 1))

  if node:has_children() then
    line:append(node:is_expanded() and " " or " ")
  else
    line:append("  ")
  end

  line:append(node.text)

  return line
end,
```

---

### `buf_options`

**Type:** `table`

Contains all buffer related options (check `:h options | /local to buffer`).

**Examples**

```lua
buf_options = {
  bufhidden = "hide",
  buflisted = false,
  buftype = "nofile",
  swapfile = false,
},
```

## Methods

### `tree:get_node`

_Signature:_ `tree:get_node(node_id_or_linenr?) -> NuiTreeNode | nil, number | nil, number | nil`

**Parameters**

| Name                | Type                          | Description              |
| ------------------- | ----------------------------- | ------------------------ |
| `node_id_or_linenr` | `number` or `string` or `nil` | node's id or line number |

If `node_id_or_linenr` is `string`, the node with that _id_ is returned.

If `node_id_or_linenr` is `number`, the node on that _linenr_ is returned.

If `node_id` is `nil`, the current node under cursor is returned.

Returns the `node` if found, and the start and end `linenr` if it is rendered.

### `tree:get_nodes`

_Signature:_ `tree:get_node(parent_id?) -> NuiTreeNode[]`

**Parameters**

| Name        | Type              | Description      |
| ----------- | ----------------- | ---------------- |
| `parent_id` | `string` or `nil` | parent node's id |

If `parent_id` is present, child nodes under that parent are returned,
Otherwise root nodes are returned.

### `tree:add_node`

_Signature:_ `tree:add_node(node, parent_id?)`

Adds a node to the tree.

| Name        | Type              | Description      |
| ----------- | ----------------- | ---------------- |
| `node`      | `NuiTree.Node`    | node             |
| `parent_id` | `string` or `nil` | parent node's id |

If `parent_id` is present, node is added under that parent,
Otherwise node is added to the tree root.

### `tree:remove_node`

_Signature:_ `tree:remove_node(node)`

Removes a node from the tree.

Returns the removed node.

| Name      | Type     | Description |
| --------- | -------- | ----------- |
| `node_id` | `string` | node's id   |

### `tree:set_nodes`

_Signature:_ `tree:set_nodes(nodes, parent_id?)`

Adds a node to the tree.

| Name        | Type              | Description      |
| ----------- | ----------------- | ---------------- |
| `nodes`     | `NuiTree.Node[]`  | list of nodes    |
| `parent_id` | `string` or `nil` | parent node's id |

If `parent_id` is present, nodes are set as parent node's children,
otherwise nodes are set at tree root.

### `tree:render`

_Signature:_ `tree:render(linenr_start?)`

Renders the tree on buffer.

| Name           | Type             | Description                   |
| -------------- | ---------------- | ----------------------------- |
| `linenr_start` | `number` / `nil` | start line number (1-indexed) |

## NuiTree.Node

`NuiTree.Node` is used to create a node object for `NuiTree`.

_Signature:_ `NuiTree.Node(data, children)`

**Examples**

```lua
local NuiTree = require("nui.tree")

local node = NuiTree.Node({ text = "b" }, {
  NuiTree.Node({ text = "b-1" }),
  NuiTree.Node({ text = "b-2" }),
})
```

### Parameters

#### `data`

**Type:** `table`

Data for the node. Can contain anything. The default `get_node_id`
and `prepare_node` functions uses the `id` and `text` keys.

**Example**

```lua
{
  id = "/usr/local/bin/lua",
  text = "lua"
}
```

If you don't want to provide those two values, you should consider
providing your own `get_node_id` and `prepare_node` functions.

#### `children`

**Type:** `table`

List of `NuiTree.Node` objects.

### Methods

#### `node:get_id`

_Signature:_ `node:get_id()`

Returns node's id.

#### `node:get_depth`

_Signature:_ `node:get_depth()`

Returns node's depth.

#### `node:get_parent_id`

_Signature:_ `node:get_parent_id()`

Returns parent node's id.

#### `node:has_children`

_Signature:_ `node:has_children()`

Checks if node has children.

#### `node:get_child_ids`

_Signature:_ `node:get_child_ids() -> string[]`

Returns ids of child nodes.

#### `node:is_expanded`

_Signature:_ `node:is_expanded()`

Checks if node is expanded.

#### `node:expand`

_Signature:_ `node:expand()`

Expands node.

#### `node:collapse`

_Signature:_ `node:collapse()`

Collapses node.

## Wiki Page

You can find additional documentation/examples/guides/tips-n-tricks in [nui.tree wiki page](https://github.com/MunifTanjim/nui.nvim/wiki/nui.tree).
