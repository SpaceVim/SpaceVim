
if "(foo)"

	let x = "(foo)"

endif

	( )

let x = (   "( )"   )

let y =  "("
	\ . ")"

	    "("
		)
	\ . ")"

let z =  (   '( ' ) . ' )'

let a = " if   endif "
							*cpo-M*
	M	When excluded, "%" matching will take backslashes into
		account.  Thus in "( \( )" and "\( ( \)" the outer
		parenthesis match.  When included "%" ignores
		backslashes, which is Vi compatible.

let b = '\(  \)'
let c = "\\(  \\)"

let d = "( \\(  )"  .  "\\(  " . '\(  \)' . "\\)"

