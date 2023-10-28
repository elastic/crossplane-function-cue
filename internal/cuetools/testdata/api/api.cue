package api

#Country: *"USA" | "Canada" | "Mexico"

#Address: {
	Street?: string
	City?: string
}

#Input: {
	Name: string
	Address?: #Address
	Country: #Country
}
