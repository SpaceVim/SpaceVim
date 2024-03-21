local cmp = {}

---@alias cmp.ConfirmBehavior 'insert' | 'replace'
cmp.ConfirmBehavior = {
  Insert = 'insert',
  Replace = 'replace',
}

---@alias cmp.SelectBehavior 'insert' | 'select'
cmp.SelectBehavior = {
  Insert = 'insert',
  Select = 'select',
}

---@alias cmp.ContextReason 'auto' | 'manual' | 'triggerOnly' | 'none'
cmp.ContextReason = {
  Auto = 'auto',
  Manual = 'manual',
  TriggerOnly = 'triggerOnly',
  None = 'none',
}

---@alias cmp.TriggerEvent 'InsertEnter' | 'TextChanged'
cmp.TriggerEvent = {
  InsertEnter = 'InsertEnter',
  TextChanged = 'TextChanged',
}

---@alias cmp.PreselectMode 'item' | 'None'
cmp.PreselectMode = {
  Item = 'item',
  None = 'none',
}

---@alias cmp.ItemField 'abbr' | 'kind' | 'menu'
cmp.ItemField = {
  Abbr = 'abbr',
  Kind = 'kind',
  Menu = 'menu',
}

---@class cmp.ContextOption
---@field public reason cmp.ContextReason|nil

---@class cmp.ConfirmOption
---@field public behavior cmp.ConfirmBehavior
---@field public commit_character? string

---@class cmp.SelectOption
---@field public behavior cmp.SelectBehavior

---@class cmp.SnippetExpansionParams
---@field public body string
---@field public insert_text_mode integer

---@class cmp.CompleteParams
---@field public reason? cmp.ContextReason
---@field public config? cmp.ConfigSchema

---@class cmp.SetupProperty
---@field public buffer fun(c: cmp.ConfigSchema)
---@field public global fun(c: cmp.ConfigSchema)
---@field public cmdline fun(type: string|string[], c: cmp.ConfigSchema)
---@field public filetype fun(type: string|string[], c: cmp.ConfigSchema)

---@alias cmp.Setup cmp.SetupProperty | fun(c: cmp.ConfigSchema)

---@class cmp.SourceApiParams: cmp.SourceConfig

---@class cmp.SourceCompletionApiParams : cmp.SourceConfig
---@field public offset integer
---@field public context cmp.Context
---@field public completion_context lsp.CompletionContext

---@alias  cmp.MappingFunction fun(fallback: function): nil

---@class cmp.MappingClass
---@field public i nil|cmp.MappingFunction
---@field public c nil|cmp.MappingFunction
---@field public x nil|cmp.MappingFunction
---@field public s nil|cmp.MappingFunction

---@alias cmp.Mapping cmp.MappingFunction | cmp.MappingClass

---@class cmp.ConfigSchema
---@field private revision? integer
---@field public enabled? boolean | fun(): boolean
---@field public performance? cmp.PerformanceConfig
---@field public preselect? cmp.PreselectMode
---@field public completion? cmp.CompletionConfig
---@field public window? cmp.WindowConfig|nil
---@field public confirmation? cmp.ConfirmationConfig
---@field public matching? cmp.MatchingConfig
---@field public sorting? cmp.SortingConfig
---@field public formatting? cmp.FormattingConfig
---@field public snippet? cmp.SnippetConfig
---@field public mapping? table<string, cmp.Mapping>
---@field public sources? cmp.SourceConfig[]
---@field public view? cmp.ViewConfig
---@field public experimental? cmp.ExperimentalConfig

---@class cmp.PerformanceConfig
---@field public debounce integer
---@field public throttle integer
---@field public fetching_timeout integer
---@field public confirm_resolve_timeout integer
---@field public async_budget integer Maximum time (in ms) an async function is allowed to run during one step of the event loop.
---@field public max_view_entries integer

---@class cmp.WindowConfig
---@field completion? cmp.WindowConfig
---@field documentation? cmp.WindowConfig|nil

---@class cmp.CompletionConfig
---@field public autocomplete? cmp.TriggerEvent[]|false
---@field public completeopt? string
---@field public get_trigger_characters? fun(trigger_characters: string[]): string[]
---@field public keyword_length? integer
---@field public keyword_pattern? string

---@class cmp.WindowConfig
---@field public border? string|string[]
---@field public winhighlight? string
---@field public zindex? integer|nil
---@field public max_width? integer|nil
---@field public max_height? integer|nil
---@field public scrolloff? integer|nil
---@field public scrollbar? boolean|true

---@class cmp.ConfirmationConfig
---@field public default_behavior cmp.ConfirmBehavior
---@field public get_commit_characters fun(commit_characters: string[]): string[]

---@class cmp.MatchingConfig
---@field public disallow_fuzzy_matching boolean
---@field public disallow_fullfuzzy_matching boolean
---@field public disallow_partial_fuzzy_matching boolean
---@field public disallow_partial_matching boolean
---@field public disallow_prefix_unmatching boolean

---@class cmp.SortingConfig
---@field public priority_weight integer
---@field public comparators cmp.Comparator[]

---@class cmp.FormattingConfig
---@field public fields cmp.ItemField[]
---@field public expandable_indicator boolean
---@field public format fun(entry: cmp.Entry, vim_item: vim.CompletedItem): vim.CompletedItem

---@class cmp.SnippetConfig
---@field public expand fun(args: cmp.SnippetExpansionParams)

---@class cmp.ExperimentalConfig
---@field public ghost_text cmp.GhostTextConfig|boolean

---@class cmp.GhostTextConfig
---@field hl_group string

---@class cmp.SourceConfig
---@field public name string
---@field public option table|nil
---@field public priority integer|nil
---@field public trigger_characters string[]|nil
---@field public keyword_pattern string|nil
---@field public keyword_length integer|nil
---@field public max_item_count integer|nil
---@field public group_index integer|nil
---@field public entry_filter nil|function(entry: cmp.Entry, ctx: cmp.Context): boolean

---@class cmp.ViewConfig
---@field public entries? cmp.EntriesViewConfig
---@field public docs? cmp.DocsViewConfig

---@alias cmp.EntriesViewConfig cmp.CustomEntriesViewConfig|cmp.NativeEntriesViewConfig|cmp.WildmenuEntriesViewConfig|string

---@class cmp.CustomEntriesViewConfig
---@field name 'custom'
---@field selection_order 'top_down'|'near_cursor'

---@class cmp.NativeEntriesViewConfig
---@field name 'native'

---@class cmp.WildmenuEntriesViewConfig
---@field name 'wildmenu'
---@field separator string|nil

---@class cmp.DocsViewConfig
---@field public auto_open boolean

return cmp
