program matchup_parsing
  real :: x = 1.0, y = 2.0, a


  if (x < y) then
    if (x == 0) stop
    a = y / x
  else
    if (y == 0) stop  ! matchup sees corresponding `if - end if` pairs from HERE
    a = x / y
  end if  ! to HERE

  write(*, *) a

end program

