[a + 1 for a in [1, 2]]

#! 3 type-error-operation
[a + '' for a in [1, 2]]
#! 3 type-error-operation
(a + '' for a in [1, 2])

#! 12 type-error-not-iterable
[a for a in 1]

tuple(str(a) for a in [1])

#! 8 type-error-operation
tuple(a + 3 for a in [''])

# ----------
# Some variables within are not defined
# ----------

abcdef = []
#! 12 name-error
[1 for a in NOT_DEFINFED for b in abcdef if 1]

#! 25 name-error
[1 for a in [1] for b in NOT_DEFINED if 1]

#! 12 name-error
[1 for a in NOT_DEFINFED for b in [1] if 1]

#! 19 name-error
(1 for a in [1] if NOT_DEFINED)

# ----------
# unbalanced sides.
# ----------

# ok
(1 for a, b in [(1, 2)])
#! 13 value-error-too-few-values
(1 for a, b, c in [(1, 2)])
#! 10 value-error-too-many-values
(1 for a, b in [(1, 2, 3)])
