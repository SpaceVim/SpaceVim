// Issue #2396

int main()                                                                
{                                                                         
  B::foo();                                                                 
  //  ^ @function.call
  Foo::A::foo();                                                            
  //       ^ @function.call
  Foo::a::A::foo();                                                            
  //          ^ @function.call
  return 0;                                                                 
}    
