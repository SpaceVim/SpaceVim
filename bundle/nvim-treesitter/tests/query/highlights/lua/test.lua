local a = { 1, 2, 3, 4, 5 }
--          ^ TSNumber    ^ TSPunctBracket
--    ^ TSVariable

local _ = next(a)
--          ^ TSFuncBuiltin
-- ^ TSKeyword

_ = next(a)
--   ^ TSFuncBuiltin

next(a)
-- ^ TSFuncBuiltin
