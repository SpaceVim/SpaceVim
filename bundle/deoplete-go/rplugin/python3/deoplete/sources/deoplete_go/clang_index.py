class Clang_Index(object):
    kinds = dict(
        {
            # Declarations
            1: "t",  # CXCursor_UnexposedDecl # A declaration whose specific kind
            # is not exposed via this interface
            2: "struct",  # CXCursor_StructDecl (A C or C++ struct)
            3: "union",  # CXCursor_UnionDecl (A C or C++ union)
            4: "class",  # CXCursor_ClassDecl (A C++ class)
            5: "enumeration",  # CXCursor_EnumDecl (An enumeration)
            # CXCursor_FieldDecl (A field (in C) or non-static data member
            6: "member",
            # (in C++) in a struct, union, or C++ class)
            # CXCursor_EnumConstantDecl (An enumerator constant)
            7: "enumerator constant",
            8: "function",  # CXCursor_FunctionDecl (A function)
            9: "variable",  # CXCursor_VarDecl (A variable)
            # CXCursor_ParmDecl (A function or method parameter)
            10: "method parameter",
            11: "11",  # CXCursor_ObjCInterfaceDecl (An Objective-C @interface)
            # CXCursor_ObjCCategoryDecl (An Objective-C @interface for a
            12: "12",
            # category)
            13: "13",  # CXCursor_ObjCProtocolDecl
            # (An Objective-C @protocol declaration)
            # CXCursor_ObjCPropertyDecl (An Objective-C @property declaration)
            14: "14",
            15: "15",  # CXCursor_ObjCIvarDecl (An Objective-C instance variable)
            16: "16",  # CXCursor_ObjCInstanceMethodDecl
            # (An Objective-C instance method)
            17: "17",  # CXCursor_ObjCClassMethodDecl
            # (An Objective-C class method)
            18: "18",  # CXCursor_ObjCImplementationDec
            # (An Objective-C @implementation)
            19: "19",  # CXCursor_ObjCCategoryImplDecll
            # (An Objective-C @implementation for a category)
            20: "typedef",  # CXCursor_TypedefDecl (A typedef)
            21: "class method",  # CXCursor_CXXMethod (A C++ class method)
            22: "namespace",  # CXCursor_Namespace (A C++ namespace)
            # CXCursor_LinkageSpec (A linkage specification,e.g. Extern "C")
            23: "23",
            24: "constructor",  # CXCursor_Constructor (A C++ constructor)
            25: "destructor",  # CXCursor_Destructor (A C++ destructor)
            # CXCursor_ConversionFunction (A C++ conversion function)
            26: "conversion function",
            # CXCursor_TemplateTypeParameter (A C++ template type parameter)
            27: "a",
            # CXCursor_NonTypeTemplateParameter (A C++ non-type template parameter)
            28: "a",
            # CXCursor_TemplateTemplateParameter (A C++ template template
            # parameter)
            29: "a",
            # CXCursor_FunctionTemplate (A C++ function template)
            30: "function template",
            # CXCursor_ClassTemplate (A C++ class template)
            31: "class template",
            32: "32",  # CXCursor_ClassTemplatePartialSpecialization
            # (A C++ class template partial specialization)
            # CXCursor_NamespaceAlias (A C++ namespace alias declaration)
            33: "n",
            # CXCursor_UsingDirective (A C++ using directive)
            34: "using directive",
            # CXCursor_UsingDeclaration (A C++ using declaration)
            35: "using declaration",
            # CXCursor_TypeAliasDecl (A C++ alias declaration)
            36: "alias declaration",
            # CXCursor_ObjCSynthesizeDecl (An Objective-C synthesize definition)
            37: "37",
            # CXCursor_ObjCDynamicDecl (An Objective-C dynamic definition)
            38: "38",
            39: "39",  # CXCursor_CXXAccessSpecifier (An access specifier)
            # References
            40: "40",  # CXCursor_ObjCSuperClassRef
            41: "41",  # CXCursor_ObjCProtocolRef
            42: "42",  # CXCursor_ObjCClassRef
            43: "43",  # CXCursor_TypeRef
            44: "44",  # CXCursor_CXXBaseSpecifier
            45: "45",  # CXCursor_TemplateRef
            # (A reference to a class template, function template, template
            # template parameter, or class template partial
            # specialization)
            # CXCursor_NamespaceRef (A ref to a namespace or namespace alias)
            46: "46",
            # CXCursor_MemberRef (A reference to a member of a struct, union,
            47: "47",
            # or class that occurs in some non-expression context,
            # e.g., a designated initializer)
            48: "48",  # CXCursor_LabelRef (A reference to a labeled statement)
            49: "49",  # CXCursor_OverloadedDeclRef
            # (A reference to a set of overloaded functions or function
            # templates that has not yet been resolved to a specific
            # function or function template)
            50: "50",  # CXCursor_VariableRef
            # Error conditions
            # 70:  '70',   # CXCursor_FirstInvalid
            70: "70",  # CXCursor_InvalidFile
            71: "71",  # CXCursor_NoDeclFound
            72: "u",  # CXCursor_NotImplemented
            73: "73",  # CXCursor_InvalidCode
            # Expressions
            # CXCursor_UnexposedExpr (An expression whose specific kind is
            100: "100",
            # not exposed via this interface)
            # CXCursor_DeclRefExpr (An expression that refers to some value
            101: "101",
            # declaration, such as a function, varible, or
            # enumerator)
            # CXCursor_MemberRefExpr (An expression that refers to a member
            102: "102",
            # of a struct, union, class, Objective-C class, etc)
            103: "103",  # CXCursor_CallExpr (An expression that calls a function)
            # CXCursor_ObjCMessageExpr (An expression that sends a message
            104: "104",
            # to an Objective-C object or class)
            # CXCursor_BlockExpr (An expression that represents a block
            105: "105",
            # literal)
            106: "106",  # CXCursor_IntegerLiteral (An integer literal)
            # CXCursor_FloatingLiteral (A floating point number literal)
            107: "107",
            108: "108",  # CXCursor_ImaginaryLiteral (An imaginary number literal)
            109: "109",  # CXCursor_StringLiteral (A string literal)
            110: "110",  # CXCursor_CharacterLiteral (A character literal)
            # CXCursor_ParenExpr (A parenthesized expression, e.g. "(1)")
            111: "111",
            # CXCursor_UnaryOperator (This represents the unary-expression's
            112: "112",
            # (except sizeof and alignof))
            # CXCursor_ArraySubscriptExpr ([C99 6.5.2.1] Array Subscripting)
            113: "113",
            # CXCursor_BinaryOperator (A builtin binary operation expression
            114: "114",
            # such as "x + y" or "x <= y")
            # CXCursor_CompoundAssignOperator (Compound assignment such as
            115: "115",
            # "+=")
            116: "116",  # CXCursor_ConditionalOperator (The ?: ternary operator)
            # CXCursor_CStyleCastExpr (An explicit cast in C (C99 6.5.4) or
            117: "117",
            # C-style cast in C++ (C++ [expr.cast]), which uses the
            # syntax (Type)expr)
            118: "118",  # CXCursor_CompoundLiteralExpr ([C99 6.5.2.5])
            # CXCursor_InitListExpr (Describes an C or C++ initializer list)
            119: "119",
            # CXCursor_AddrLabelExpr (The GNU address of label extension,
            120: "120",
            # representing &&label)
            121: "121",  # CXCursor_StmtExpr (This is the GNU Statement Expression
            # extension: ({int X=4; X;})
            # CXCursor_GenericSelectionExpr (brief Represents a C11 generic
            122: "122",
            # selection)
            # CXCursor_GNUNullExpr (Implements the GNU __null extension)
            123: "123",
            # CXCursor_CXXStaticCastExpr (C++'s static_cast<> expression)
            124: "124",
            # CXCursor_CXXDynamicCastExpr (C++'s dynamic_cast<> expression)
            125: "125",
            # CXCursor_CXXReinterpretCastExpr (C++'s reinterpret_cast<>
            126: "126",
            # expression)
            # CXCursor_CXXConstCastExpr (C++'s const_cast<> expression)
            127: "127",
            # CXCursor_CXXFunctionalCastExpr (Represents an explicit C++ type
            128: "128",
            # conversion that uses "functional" notion
            # (C++ [expr.type.conv]))
            129: "129",  # CXCursor_CXXTypeidExpr (A C++ typeid expression
            # (C++ [expr.typeid]))
            # CXCursor_CXXBoolLiteralExpr (brief [C++ 2.13.5] C++ Boolean
            130: "130",
            # Literal)
            # CXCursor_CXXNullPtrLiteralExpr ([C++0x 2.14.7] C++ Pointer
            131: "131",
            # Literal)
            # CXCursor_CXXThisExpr (Represents the "this" expression in C+)
            132: "132",
            133: "133",  # CXCursor_CXXThrowExpr ([C++ 15] C++ Throw Expression)
            # CXCursor_CXXNewExpr (A new expression for memory allocation
            134: "134",
            # and constructor calls)
            135: "135",  # CXCursor_CXXDeleteExpr (A delete expression for memory
            # deallocation and destructor calls)
            136: "136",  # CXCursor_UnaryExpr (A unary expression)
            # CXCursor_ObjCStringLiteral (An Objective-C string literal
            137: "137",
            # i.e. @"foo")
            # CXCursor_ObjCEncodeExpr (An Objective-C @encode expression)
            138: "138",
            # CXCursor_ObjCSelectorExpr (An Objective-C @selector expression)
            139: "139",
            # CXCursor_ObjCProtocolExpr (An Objective-C @protocol expression)
            140: "140",
            # CXCursor_ObjCBridgedCastExpr (An Objective-C "bridged" cast
            141: "141",
            # expression, which casts between Objective-C pointers
            # and C pointers, transferring ownership in the process)
            # CXCursor_PackExpansionExpr (Represents a C++0x pack expansion
            142: "142",
            # that produces a sequence of expressions)
            # CXCursor_SizeOfPackExpr (Represents an expression that computes
            143: "143",
            # the length of a parameter pack)
            # CXCursor_LambdaExpr (Represents a C++ lambda expression that
            144: "144",
            # produces a local function object)
            # CXCursor_ObjCBoolLiteralExpr (Objective-c Boolean Literal)
            145: "145",
            # Statements
            # CXCursor_UnexposedStmt (A statement whose specific kind is not
            200: "200",
            # exposed via this interface)
            201: "201",  # CXCursor_LabelStmt (A labelled statement in a function)
            202: "202",  # CXCursor_CompoundStmt (A group of statements like
            # { stmt stmt }.
            203: "203",  # CXCursor_CaseStmt (A case statment)
            204: "204",  # CXCursor_DefaultStmt (A default statement)
            205: "205",  # CXCursor_IfStmt (An if statemen)
            206: "206",  # CXCursor_SwitchStmt (A switch statement)
            207: "207",  # CXCursor_WhileStmt (A while statement)
            208: "208",  # CXCursor_DoStmt (A do statement)
            209: "209",  # CXCursor_ForStmt (A for statement)
            210: "210",  # CXCursor_GotoStmt (A goto statement)
            211: "211",  # CXCursor_IndirectGotoStmt (An indirect goto statement)
            212: "212",  # CXCursor_ContinueStmt (A continue statement)
            213: "213",  # CXCursor_BreakStmt (A break statement)
            214: "214",  # CXCursor_ReturnStmt (A return statement)
            # CXCursor_GCCAsmStmt (A GCC inline assembly statement extension)
            215: "215",
            # CXCursor_ObjCAtTryStmt (Objective-C's overall try-catch-finally
            216: "216",
            # statement.
            # CXCursor_ObjCAtCatchStmt (Objective-C's catch statement)
            217: "217",
            # CXCursor_ObjCAtFinallyStmt (Objective-C's finally statement)
            218: "218",
            # CXCursor_ObjCAtThrowStmt (Objective-C's throw statement)
            219: "219",
            # CXCursor_ObjCAtSynchronizedStmt (Objective-C's synchronized
            220: "220",
            # statement)
            # CXCursor_ObjCAutoreleasePoolStmt (Objective-C's autorelease
            221: "221",
            # pool statement)
            # CXCursor_ObjCForCollectionStmt (Objective-C's collection
            222: "222",
            # statement)
            223: "223",  # CXCursor_CXXCatchStmt (C++'s catch statement)
            224: "224",  # CXCursor_CXXTryStmt (C++'s try statement)
            225: "225",  # CXCursor_CXXForRangeStmt (C++'s for (*: *) statement)
            # CXCursor_SEHTryStmt (Windows Structured Exception Handling's
            226: "226",
            # try statement)
            # CXCursor_SEHExceptStmt (Windows Structured Exception Handling's
            227: "227",
            # except statement.
            228: "228",  # CXCursor_SEHFinallyStmt (Windows Structured Exception
            # Handling's finally statement)
            # CXCursor_MSAsmStmt (A MS inline assembly statement extension)
            229: "229",
            230: "230",  # CXCursor_NullStmt (The null satement ";": C99 6.8.3p3)
            # CXCursor_DeclStmt (Adaptor class for mixing declarations with
            231: "231",
            # statements and expressions)
            # Translation unit
            300: "300",  # CXCursor_TranslationUnit (Cursor that represents the
            # translation unit itself)
            # Attributes
            # CXCursor_UnexposedAttr (An attribute whose specific kind is
            400: "400",
            # not exposed via this interface)
            401: "401",  # CXCursor_IBActionAttr
            402: "402",  # CXCursor_IBOutletAttr
            403: "403",  # CXCursor_IBOutletCollectionAttr
            404: "404",  # CXCursor_CXXFinalAttr
            405: "405",  # CXCursor_CXXOverrideAttr
            406: "406",  # CXCursor_AnnotateAttr
            407: "407",  # CXCursor_AsmLabelAttr
            # Preprocessing
            500: "500",  # CXCursor_PreprocessingDirective
            501: "define",  # CXCursor_MacroDefinition
            502: "502",  # CXCursor_MacroInstantiation
            503: "503",  # CXCursor_InclusionDirective
            # Modules
            600: "600",  # CXCursor_ModuleImportDecl (A module import declaration)
        }
    )
