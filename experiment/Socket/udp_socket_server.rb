# udp_server_loop(port) {|msg, msg_src| ... } click to toggle source
# udp_server_loop(host, port) {|msg, msg_src| ... }
require 'socket'
msg = "ftp_test"
Socket.udp_server_loop("localhost",9261) {|msg, msg_src|
	msg_src.reply msg
}
# def self.udp_server_loop_on(sockets, &b) # :yield: msg, msg_src
# 	loop {
# 		readable, _, _ = IO.select(sockets)
# 		udp_server_recv(readable, &b)
# 	}
# end

# udp_server_sockets(host, port) {|sockets|
# 	loop {
# 		readable, _, _ = IO.select(sockets)
# 		udp_server_recv(readable) {|msg, msg_src| ... }
# 	}
# }
