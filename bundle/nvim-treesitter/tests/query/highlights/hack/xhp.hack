$user_name = 'Fred';
echo "<tt>Hello <strong>$user_name</tt></strong>";

// XHP: Typechecked, well-formed, and secure
$user_name = 'Andrew';
$xhp = <tt>Hello <strong>{$user_name}</strong></tt>;
//       ^ tag
//                 ^ tag
//            ^ string
echo await $xhp->toStringAsync();
