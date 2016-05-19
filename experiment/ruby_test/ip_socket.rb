
$stdout.read
require 'socket'
host_name = Socket.gethostname
p host_name
address = IPSocket.getaddress(host_name)
p address
host = TCPSocket.gethostbyname(host_name)
p host

# require 'win32olt'
# p win32ole.new(,"IPHLPAPI","AddIPAddress","aa")