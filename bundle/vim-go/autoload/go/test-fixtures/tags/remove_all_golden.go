package main

type Server struct {
	Name          string   
	ID            int      
	MyHomeAddress string   
	SubDomains    []string 
	Empty         string   
	Example       int64    
	Example2      string   
	Bar           struct {
		Four string 
		Five string 
	} 
	Lala interface{} 
}
