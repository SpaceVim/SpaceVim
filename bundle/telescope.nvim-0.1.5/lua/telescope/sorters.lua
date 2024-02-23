local log = require "telescope.log"
local util = require "telescope.utils"

local sorters = {}

local ngram_highlighter = function(ngram_len, prompt, display)
  local highlights = {}
  display = display:lower()

  for disp_index = 1, #display do
    local char = display:sub(disp_index, disp_index + ngram_len - 1)
    if prompt:find(char, 1, true) then
      table.insert(highlights, {
        start = disp_index,
        finish = disp_index + ngram_len - 1,
      })
    end
  end

  return highlights
end

local FILTERED = -1

local Sorter = {}
Sorter.__index = Sorter

---@class Sorter
--- Sorter sorts a list of results by return a single integer for a line,
--- given a prompt
---
--- Lower number is better (because it's like a closer match)
--- But, any number below 0 means you want that line filtered out.
---@field scoring_function function: Function that has the interface: (sorter, prompt, line): number
---@field tags table: Unique tags collected at filtering for tag completion
---@field filter_function function: Function that can filter results
---@field highlighter function: Highlights results to display them pretty
---@field discard boolean: Whether this is a discardable style sorter or not.
---@field score function: Override the score function if desired.
---@field init function: Function to run when creating sorter
---@field start function: Function to run on every new prompt
---@field finish function: Function to run after every new prompt
---@field destroy function: Functo to run when destroying sorter
function Sorter:new(opts)
  opts = opts or {}

  return setmetatable({
    score = opts.score,
    state = {},
    tags = opts.tags,

    -- State management
    init = opts.init,
    start = opts.start,
    finish = opts.finish,
    destroy = opts.destroy,
    _status = nil,

    filter_function = opts.filter_function,
    scoring_function = opts.scoring_function,
    highlighter = opts.highlighter,
    discard = opts.discard,
    _discard_state = {
      filtered = {},
      prompt = "",
    },
  }, Sorter)
end

function Sorter:_init()
  self._status = "init"
  if self.init then
    self:init()
  end
end

function Sorter:_destroy()
  self._status = "destroy"
  if self.destroy then
    self:destroy()
  end
end

-- TODO: We could make this a bit smarter and cache results "as we go" and where they got filtered.
--          Then when we hit backspace, we don't have to re-caculate everything.
--          Prime did a lot of the hard work already, but I don't want to copy as much memory around
--              as he did in his example.
--              Example can be found in ./scratch/prime_prompt_cache.lua
function Sorter:_start(prompt)
  self._status = "start"
  if self.start then
    self:start(prompt)
  end

  if not self.discard then
    return
  end

  local previous = self._discard_state.prompt
  local len_previous = #previous

  if #prompt < len_previous then
    log.trace "Reset discard because shorter prompt"
    self._discard_state.filtered = {}
  elseif string.sub(prompt, 1, len_previous) ~= previous then
    log.trace "Reset discard no match"
    self._discard_state.filtered = {}
  end

  self._discard_state.prompt = prompt
end

function Sorter:_finish(prompt)
  self._status = "finish"
  if self.finish then
    self:finish(prompt)
  end
end

-- TODO: Consider doing something that makes it so we can skip the filter checks
--          if we're not discarding. Also, that means we don't have to check otherwise as well :)
function Sorter:score(prompt, entry, cb_add, cb_filter)
  if not entry or not entry.ordinal then
    return
  end

  if self._status and self._status ~= "start" then
    return
  end

  local ordinal = entry.ordinal
  if self:_was_discarded(prompt, ordinal) then
    return cb_filter(entry)
  end

  local filter_score
  if self.filter_function ~= nil then
    if self.tags then
      self.tags:insert(entry)
    end
    filter_score, prompt = self:filter_function(prompt, entry, cb_add, cb_filter)
  end

  if filter_score == FILTERED then
    return cb_filter(entry)
  end

  local score = self:scoring_function(prompt or "", ordinal, entry, cb_add, cb_filter)
  if score == FILTERED then
    self:_mark_discarded(prompt, ordinal)
    return cb_filter(entry)
  end

  if cb_add then
    return cb_add(score, entry)
  else
    return score
  end
end

function Sorter:_was_discarded(prompt, ordinal)
  return self.discard and self._discard_state.filtered[ordinal]
end

function Sorter:_mark_discarded(prompt, ordinal)
  if not self.discard then
    return
  end

  self._discard_state.filtered[ordinal] = true
end

function sorters.new(...)
  return Sorter:new(...)
end

sorters.Sorter = Sorter

local make_cached_tail = function()
  local os_sep = util.get_separator()
  local match_string = "[^" .. os_sep .. "]*$"
  return setmetatable({}, {
    __index = function(t, k)
      local tail = string.match(k, match_string)

      rawset(t, k, tail)
      return tail
    end,
  })
end

local make_cached_uppers = function()
  return setmetatable({}, {
    __index = function(t, k)
      local obj = {}
      for i = 1, #k do
        local s_byte = k:byte(i, i)
        if s_byte <= 90 and s_byte >= 65 then
          obj[s_byte] = true
        end
      end

      rawset(t, k, obj)
      return obj
    end,
  })
end

-- TODO: Match on upper case words
-- TODO: Match on last match
sorters.get_fuzzy_file = function(opts)
  opts = opts or {}

  local ngram_len = opts.ngram_len or 2

  local cached_ngrams = {}

  local function overlapping_ngrams(s, n)
    if cached_ngrams[s] and cached_ngrams[s][n] then
      return cached_ngrams[s][n]
    end

    local R = {}
    for i = 1, s:len() - n + 1 do
      R[#R + 1] = s:sub(i, i + n - 1)
    end

    if not cached_ngrams[s] then
      cached_ngrams[s] = {}
    end

    cached_ngrams[s][n] = R

    return R
  end

  local cached_tails = make_cached_tail()
  local cached_uppers = make_cached_uppers()

  return Sorter:new {
    scoring_function = function(_, prompt, line)
      local N = #prompt

      if N == 0 or N < ngram_len then
        -- TODO: If the character is in the line,
        -- then it should get a point or somethin.
        return 1
      end

      local prompt_lower = prompt:lower()
      local line_lower = line:lower()

      local prompt_lower_ngrams = overlapping_ngrams(prompt_lower, ngram_len)

      -- Contains the original string
      local contains_string = line_lower:find(prompt_lower, 1, true)

      local prompt_uppers = cached_uppers[prompt]
      local line_uppers = cached_uppers[line]

      local uppers_matching = 0
      for k, _ in pairs(prompt_uppers) do
        if line_uppers[k] then
          uppers_matching = uppers_matching + 1
        end
      end

      -- TODO: Consider case senstivity
      local tail = cached_tails[line_lower]
      local contains_tail = tail:find(prompt, 1, true)

      local consecutive_matches = 0
      local previous_match_index = 0
      local match_count = 0

      for i = 1, #prompt_lower_ngrams do
        local match_start = line_lower:find(prompt_lower_ngrams[i], 1, true)
        if match_start then
          match_count = match_count + 1
          if match_start > previous_match_index then
            consecutive_matches = consecutive_matches + 1
          end

          previous_match_index = match_start
        end
      end

      local tail_modifier = 1
      if contains_tail then
        tail_modifier = 2
      end

      local denominator = (
        (10 * match_count / #prompt_lower_ngrams)
        -- biases for shorter strings
        + 3 * match_count * ngram_len / #line
        + consecutive_matches
        + N / (contains_string or (2 * #line))
        -- + 30/(c1 or 2*N)
        -- TODO: It might be possible that this too strongly correlates,
        --          but it's unlikely for people to type capital letters without actually
        --          wanting to do something with a capital letter in it.
        + uppers_matching
      ) * tail_modifier

      if denominator == 0 or denominator ~= denominator then
        return -1
      end

      if #prompt > 2 and denominator < 0.5 then
        return -1
      end

      return 1 / denominator
    end,

    highlighter = opts.highlighter or function(_, prompt, display)
      return ngram_highlighter(ngram_len, prompt, display)
    end,
  }
end

sorters.get_generic_fuzzy_sorter = function(opts)
  opts = opts or {}

  local ngram_len = opts.ngram_len or 2

  local cached_ngrams = {}
  local function overlapping_ngrams(s, n)
    if cached_ngrams[s] and cached_ngrams[s][n] then
      return cached_ngrams[s][n]
    end

    local R = {}
    for i = 1, s:len() - n + 1 do
      R[#R + 1] = s:sub(i, i + n - 1)
    end

    if not cached_ngrams[s] then
      cached_ngrams[s] = {}
    end

    cached_ngrams[s][n] = R

    return R
  end

  return Sorter:new {
    -- self
    -- prompt (which is the text on the line)
    -- line (entry.ordinal)
    -- entry (the whole entry)
    scoring_function = function(_, prompt, line, _)
      if prompt == 0 or #prompt < ngram_len then
        return 1
      end

      local prompt_lower = prompt:lower()
      local line_lower = line:lower()

      local prompt_ngrams = overlapping_ngrams(prompt_lower, ngram_len)

      local N = #prompt

      local contains_string = line_lower:find(prompt_lower, 1, true)

      local consecutive_matches = 0
      local previous_match_index = 0
      local match_count = 0

      for i = 1, #prompt_ngrams do
        local match_start = line_lower:find(prompt_ngrams[i], 1, true)
        if match_start then
          match_count = match_count + 1
          if match_start > previous_match_index then
            consecutive_matches = consecutive_matches + 1
          end

          previous_match_index = match_start
        end
      end

      -- TODO: Copied from ashkan.
      local denominator = (
        (10 * match_count / #prompt_ngrams)
        -- biases for shorter strings
        -- TODO(ashkan): this can bias towards repeated finds of the same
        -- subpattern with overlapping_ngrams
        + 3 * match_count * ngram_len / #line
        + consecutive_matches
        + N / (contains_string or (2 * #line)) -- + 30/(c1 or 2*N)

      )

      if denominator == 0 or denominator ~= denominator then
        return -1
      end

      if #prompt > 2 and denominator < 0.5 then
        return -1
      end

      return 1 / denominator
    end,

    highlighter = opts.highlighter or function(_, prompt, display)
      return ngram_highlighter(ngram_len, prompt, display)
    end,
  }
end

sorters.fuzzy_with_index_bias = function(opts)
  opts = opts or {}
  opts.ngram_len = 2

  -- TODO: Probably could use a better sorter here.
  local fuzzy_sorter = sorters.get_generic_fuzzy_sorter(opts)

  return Sorter:new {
    scoring_function = function(_, prompt, line, entry, cb_add, cb_filter)
      local base_score = fuzzy_sorter:scoring_function(prompt, line, cb_add, cb_filter)

      if base_score == FILTERED then
        return FILTERED
      end

      if not base_score or base_score == 0 then
        return entry.index
      else
        return math.min(math.pow(entry.index, 0.25), 2) * base_score
      end
    end,
    highlighter = fuzzy_sorter.highlighter,
  }
end

-- Sorter using the fzy algorithm
sorters.get_fzy_sorter = function(opts)
  opts = opts or {}
  local fzy = opts.fzy_mod or require "telescope.algos.fzy"
  local OFFSET = -fzy.get_score_floor()

  return sorters.Sorter:new {
    discard = true,

    scoring_function = function(_, prompt, line)
      -- Check for actual matches before running the scoring alogrithm.
      if not fzy.has_match(prompt, line) then
        return -1
      end

      local fzy_score = fzy.score(prompt, line)

      -- The fzy score is -inf for empty queries and overlong strings.  Since
      -- this function converts all scores into the range (0, 1), we can
      -- convert these to 1 as a suitable "worst score" value.
      if fzy_score == fzy.get_score_min() then
        return 1
      end

      -- Poor non-empty matches can also have negative values. Offset the score
      -- so that all values are positive, then invert to match the
      -- telescope.Sorter "smaller is better" convention. Note that for exact
      -- matches, fzy returns +inf, which when inverted becomes 0.
      return 1 / (fzy_score + OFFSET)
    end,

    -- The fzy.positions function, which returns an array of string indices, is
    -- compatible with telescope's conventions. It's moderately wasteful to
    -- call call fzy.score(x,y) followed by fzy.positions(x,y): both call the
    -- fzy.compute function, which does all the work. But, this doesn't affect
    -- perceived performance.
    highlighter = function(_, prompt, display)
      return fzy.positions(prompt, display)
    end,
  }
end

-- TODO: Could probably do something nice where we check their conf
--          and choose their default for this.
--          But I think `fzy` is good default for now.
sorters.highlighter_only = function(opts)
  opts = opts or {}
  local fzy = opts.fzy_mod or require "telescope.algos.fzy"

  return Sorter:new {
    scoring_function = function()
      return 1
    end,

    highlighter = function(_, prompt, display)
      return fzy.positions(prompt, display)
    end,
  }
end

sorters.empty = function()
  return Sorter:new {
    scoring_function = function()
      return 1
    end,
  }
end

-- Bad & Dumb Sorter
sorters.get_levenshtein_sorter = function()
  return Sorter:new {
    scoring_function = function(_, prompt, line)
      return require "telescope.algos.string_distance"(prompt, line)
    end,
  }
end

local substr_highlighter = function(_, prompt, display)
  local highlights = {}
  display = display:lower()

  local search_terms = util.max_split(prompt, "%s")
  local hl_start, hl_end

  for _, word in pairs(search_terms) do
    hl_start, hl_end = display:find(word, 1, true)
    if hl_start then
      table.insert(highlights, { start = hl_start, finish = hl_end })
    end
  end

  return highlights
end

sorters.get_substr_matcher = function()
  return Sorter:new {
    highlighter = substr_highlighter,
    scoring_function = function(_, prompt, _, entry)
      if #prompt == 0 then
        return 1
      end

      local display = entry.ordinal:lower()

      local search_terms = util.max_split(prompt, "%s")
      local matched = 0
      local total_search_terms = 0
      for _, word in pairs(search_terms) do
        total_search_terms = total_search_terms + 1
        if display:find(word, 1, true) then
          matched = matched + 1
        end
      end

      return matched == total_search_terms and entry.index or -1
    end,
  }
end

local substr_matcher = function(_, prompt, line, _)
  local display = line:lower()
  local search_terms = util.max_split(prompt:lower(), "%s")
  local matched = 0
  local total_search_terms = 0
  for _, word in pairs(search_terms) do
    total_search_terms = total_search_terms + 1
    if display:find(word, 1, true) then
      matched = matched + 1
    end
  end

  return matched == total_search_terms and 0 or FILTERED
end

local filter_function = function(opts)
  local scoring_function = vim.F.if_nil(opts.filter_function, substr_matcher)
  local tag = vim.F.if_nil(opts.tag, "ordinal")

  return function(_, prompt, entry)
    local filter = "^(" .. opts.delimiter .. "(%S+)" .. "[" .. opts.delimiter .. "%s]" .. ")"
    local matched = prompt:match(filter)

    if matched == nil then
      return 0, prompt
    end
    -- clear prompt of tag
    prompt = prompt:sub(#matched + 1, -1)
    local query = vim.trim(matched:gsub(opts.delimiter, ""))
    return scoring_function(_, query, entry[tag], _), prompt
  end
end

local function create_tag_set(tag)
  tag = vim.F.if_nil(tag, "ordinal")
  local set = {}
  return setmetatable(set, {
    __index = {
      insert = function(set_, entry)
        local value = entry[tag]
        if not set_[value] then
          set_[value] = true
        end
      end,
    },
  })
end

sorters.prefilter = function(opts)
  local sorter = opts.sorter
  opts.delimiter = vim.F.if_nil(opts.delimiter, ":")
  sorter._delimiter = opts.delimiter
  sorter.tags = create_tag_set(opts.tag)
  sorter.filter_function = filter_function(opts)
  sorter._was_discarded = function()
    return false
  end
  return sorter
end

return sorters
