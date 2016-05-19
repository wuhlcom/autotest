require 'net/ftp'
require 'pp'

ip         = "10.10.10.57"
user       = "admin"
pw         = "admin"

srv_file   = "QOS_TEST2.zip"
cli_file   = "D:/ftpclient/#{srv_file}"
block_size = 32768

# file_get = "QOS_TEST.zip"
# ftp = Net::FTP.new(ip)
# ftp.login(user,pw)
# # files = ftp.chdir('pub/lang/ruby/contrib')
# # pp files = ftp.list('/')
# pp files = ftp.nlst('/')
# # ftp.getbinaryfile('nif.rb-0.91.gz', 'nif.gz', 1024)
# p ftp.getbinaryfile(file_get, File.basename(file_get))
# # ftp.putbinaryfile(file_get, File.basename(file_get))
# ftp.close

Net::FTP.open(ip,user,pw,) do |ftp|

	ftp.debug_mode = true
	# ftp.binary=true
	#  ftp.welcome
	ftp.passive    =true #使用被动模式,在NAT之后应该使用被模式
	ftp.login(user, pw)
	# files = ftp.chdir('pub/lang/ruby/contrib')
	pp files = ftp.list('/')
	# pp files = ftp.nlst()
	# p ftp.last_response
	# p ftp.last_response_code
	# p ftp.lastresp
	# p ftp.status
	# p ftp.system
	ftp.getbinaryfile(srv_file, cli_file, block_size)
	# ftp.get(file_get, file_get,block_size)
end

