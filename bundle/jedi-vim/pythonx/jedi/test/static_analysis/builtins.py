# ----------
# isinstance
# ----------

isinstance(1, int)
isinstance(1, (int, str))

#! 14 type-error-isinstance
isinstance(1, 1)
#! 14 type-error-isinstance
isinstance(1, [int, str])
