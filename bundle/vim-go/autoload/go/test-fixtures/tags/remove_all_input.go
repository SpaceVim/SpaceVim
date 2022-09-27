package main

type Server struct {
	Name          string   `json:"name"`
	ID            int      `json:"id"`
	MyHomeAddress string   `json:"my_home_address"`
	SubDomains    []string `json:"sub_domains"`
	Empty         string   `json:"empty"`
	Example       int64    `json:"example"`
	Example2      string   `json:"example_2"`
	Bar           struct {
		Four string `json:"four"`
		Five string `json:"five"`
	} `json:"bar"`
	Lala interface{} `json:"lala"`
}
