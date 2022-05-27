
(root)                                   @scope

(defProc)                                @scope
(lambda)                                 @scope
(interface   (declProc)                  @scope)
(declSection (declProc)                  @scope)
(declClass   (declProc)                  @scope)
(declHelper  (declProc)                  @scope)
(declProcRef)                            @scope

(exceptionHandler)                       @scope
(exceptionHandler variable: (identifier) @definition)

(declArg          name: (identifier)     @definition)
(declVar          name: (identifier)     @definition)
(declConst        name: (identifier)     @definition)
(declLabel        name: (identifier)     @definition)
(genericArg       name: (identifier)     @definition)
(declEnumValue    name: (identifier)     @definition)
(declType         name: (identifier)     @definition)
(declType         name: (genericTpl entity: (identifier)     @definition))

(declProc         name: (identifier)     @definition)
(identifier)                             @reference
