// Issue #2396

int main()                                                                
{                                                                         
  B::foo();                                                                 
  //  ^ @function
  Foo::A::foo();                                                            
  //       ^ @function
  Foo::a::A::foo();                                                            
  //          ^ @function
  return 0;                                                                 
}    
