-- Magic constants for highlight priorities;
--
-- Priorities are ranged on 16-bit integers; 0 is the least priority and 2^16 - 1 is the higher.
-- We want Hop to override everything so we use a very high priority for grey (2^16 - 3 = 65533); hint
-- priorities are one level above (2^16 - 2) and the virtual cursor one level higher (2^16 - 1), which
-- is the higher.

local M = {}

M.DIM_PRIO = 65533
M.HINT_PRIO = 65534
M.CURSOR_PRIO = 65535

return M
