if (( $(tree-sitter parse test/Petalisp/**/*.lisp -q | wc -l) > 2 )); then
#  ^ punctuation.bracket
#                                                                  ^ punctuation.bracket
#                                                           ^ punctuation.bracket
   exit 1 
fi
