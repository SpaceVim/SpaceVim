call vimtest#StartTap()
call vimtap#Plan(1) " <== XXX  Keep plan number updated.  XXX

let pcre_regex = '
      \      /^
      \        (?:
      \          (?<prefix>\d)             # prefix digit
      \          [ \-\.]?                  # optional separator
      \        )?
      \        (?:
      \          \(?(?<areacode>\d{3})\)?  # area code
      \          [ \-\.]                   # separator
      \        )?
      \        (?<trunk>\d{3})             # trunk
      \        [ \-\.]                     # separator
      \        (?<line>\d{4})              # line
      \        (?:\ ?x?                    # optional space or ''x''
      \          (?<extension>\d+)         # extension
      \        )?
      \      $/x'

call vimtap#Is(vrs#get('phone_number', 'pcre'), pcre_regex, 'retrieve pcre regex')

call vimtest#Quit()
