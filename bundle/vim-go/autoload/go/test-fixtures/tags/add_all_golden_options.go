package main

type Server struct {
	Name          string   `json:"name,omitempty"`
	ID            int      `json:"id,omitempty"`
	MyHomeAddress string   `json:"my_home_address,omitempty"`
	SubDomains    []string `json:"sub_domains,omitempty"`
	Empty         string   `json:"empty,omitempty"`
	Example       int64    `json:"example,omitempty"`
	Example2      string   `json:"example_2,omitempty"`
	Bar           struct {
		Four string `json:"four,omitempty"`
		Five string `json:"five,omitempty"`
	} `json:"bar,omitempty"`
	Lala interface{} `json:"lala,omitempty"`
}
