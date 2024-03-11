class Fields:
    def __init__(self, fields: list[int]) -> None:
#                                   ^^^ @type.builtin
#                                            ^^^^ @constant.builtin
        self.fields = fields
#            ^^^^^^ @field
        self.__dunderfield__ = None
#            ^^^^^^^^^^^^^^^ @field
        self._FunKyFielD = 0
#            ^^^^^^^^^^^ @field
        self.NOT_A_FIELD = "IM NOT A FIELD"
#            ^^^^^^^^^^^ @constant
