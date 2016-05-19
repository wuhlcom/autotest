def rand_port(less=50000,max=65534)
	port = rand(max)
	p port
	return port if port>less
	rand_port
end
p rand_port