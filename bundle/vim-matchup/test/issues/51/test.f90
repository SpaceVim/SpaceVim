program ifElseIfElseProg
implicit none

   integer :: a = 100
 
   if( a == 10 ) then
  
      a = a + 1
#ifdef three_d
		 + 3
#endif      
   
   else if( a == 20 )
&  then
      print*, "Value of a is 20" 
  
   else if( a == 30 ) then
   
      print*, "Value of a is 30" 
  
   else
   
      print*, "None of the values is matching" 
      
   end if
   
   print*, "exact value of a is ", a
 
end program ifElseIfElseProg
