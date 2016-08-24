require 'net/http/server'
require 'pp'
Net::HTTP::Server.run(:port => 8082) do |request, stream|
	pp request
	[200, {'Content-Type' => 'text/html'}, ['Hello World']]
end