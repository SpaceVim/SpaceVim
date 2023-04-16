local M = {}

-- Get the first key of a key set.
local function first_key(keys)
  return keys:sub(1, vim.fn.byteidx(keys, 1))
end

-- Get the next key of the input key in the input key set, if any, or return nil.
local function next_key(keys, key)
  local _, e = keys:find(key, 1, true)

  if e == #keys then
    return nil
  end

  local next = keys:sub(e + 1)
  local n = next:sub(1, vim.fn.byteidx(next, 1))
  return n
end

-- Permutation algorithm based on tries and backtrack filling.
M.TrieBacktrackFilling = {}

-- Get the sequence encoded in a trie by a pointer.
function M.TrieBacktrackFilling:lookup_seq_trie(trie, p)
  local seq = {}
  local t = trie

  for _, i in pairs(p) do
    local current_trie = t[i]

    seq[#seq + 1] = current_trie.key
    t = current_trie.trie
  end

  seq[#seq + 1] = t[#t].key

  return seq
end

-- Add a new permutation to the trie at the current pointer by adding a key.
function M.TrieBacktrackFilling:add_trie_key(trie, p, key)
  local seq = {}
  local t = trie

  -- find the parent trie
  for _, i in pairs(p) do
    local current_trie = t[i]

    seq[#seq + 1] = current_trie.key
    t = current_trie.trie
  end

  t[#t + 1] = { key = key; trie = {} }

  return trie
end

-- Maintain a trie pointer of a given dimension.
--
-- If a pointer has components { 4, 1 } and the dimension is 4, this function will automatically complete the missing
-- dimensions by adding the last index, i.e. { 4, 1, X, X }.
local function maintain_deep_pointer(depth, n, p)
  local q = vim.deepcopy(p)

  for i = #p + 1, depth do
    q[i] = n
  end

  return q
end

-- Generate the next permutation with backtrack filling.
--
-- - `keys` is the input key set.
-- - `trie` is a trie representing all the already generated permutations.
-- - `p` is the current pointer in the trie. It is a list of indices representing the parent layer in which the current
--   sequence occurs in.
--
-- Returns `perms` added with the next permutation.
function M.TrieBacktrackFilling:next_perm(keys, trie, p)
  if #trie == 0 then
    return { { key = first_key(keys); trie = {} } }, p
  end

  -- check whether the current sequence can have a next one
  local current_seq = self:lookup_seq_trie(trie, p)
  local key = next_key(keys, current_seq[#current_seq])

  if key ~= nil then
    -- we can generate the next permutation by just adding key to the current trie
    self:add_trie_key(trie, p, key)
    return trie, p
  else
    -- we have to backtrack; first, decrement the pointer if possible
    local max_depth = #p
    local keys_len = vim.fn.strwidth(keys)

    while #p > 0 do
      local last_index = p[#p]
      if last_index > 1 then
        p[#p] = last_index - 1

        p = maintain_deep_pointer(max_depth, keys_len, p)

        -- insert the first key at the new pointer after mutating the one already there
        self:add_trie_key(trie, p, first_key(keys))
        self:add_trie_key(trie, p, next_key(keys, first_key(keys)))
        return trie, p
      else
        -- we have exhausted all the permutations for the current layer; drop the layer index and try again
        p[#p] = nil
      end
    end

    -- all layers are completely full everywhere; add a new layer at the end
    p = maintain_deep_pointer(max_depth, keys_len, p)

    p[#p + 1] = #trie -- new layer
    self:add_trie_key(trie, p, first_key(keys))
    self:add_trie_key(trie, p, next_key(keys, first_key(keys)))

    return trie, p
  end
end

function M.TrieBacktrackFilling:trie_to_perms(trie, perm)
  local perms = {}
  local p = vim.deepcopy(perm)
  p[#p + 1] = trie.key

  if #trie.trie > 0 then
    for _, sub_trie in pairs(trie.trie) do
      vim.list_extend(perms, self:trie_to_perms(sub_trie, p))
    end
  else
    perms = { p }
  end

  return perms
end

function M.TrieBacktrackFilling:permutations(keys, n)
  local perms = {}
  local trie = {}
  local p = {}

  for _ = 1, n do
    trie, p = self:next_perm(keys, trie, p)
  end

  for _, sub_trie in pairs(trie) do
    vim.list_extend(perms, self:trie_to_perms(sub_trie, {}))
  end

  return perms
end

function M.permutations(keys, n, opts)
  return opts.perm_method:permutations(keys, n, opts)
end

return M
