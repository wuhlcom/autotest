#encode:utf-8
require 'net/ftp'
class FTPClient

		def initialize
				@ftp_block=32768 #默认
		end

	#download files
	def self.getbinaryfile(ftp_server_ip, ftp_server_usr, ftp_server_pw, ftp_file, ftp_downfile, ftp_block=@ftp_block)
		Net::FTP.open(ftp_server_ip) do |ftp|
			ftp.debug_mode = true
			ftp.passive    = true #使用被动模式,在NAT之后应该使用被模式
			ftp.login(ftp_server_usr, ftp_server_pw)
			ftp.getbinaryfile(ftp_file, ftp_downfile, ftp_block)
		end
	end

	#upload files
	def self.putbinaryfile(ftp_server_ip, ftp_server_usr, ftp_server_pw, ftp_file, ftp_downfile, ftp_block=@ftp_block)
		Net::FTP.open(ftp_server_ip) do |ftp|
			ftp.debug_mode = true
			ftp.passive    = true #使用被动模式,在NAT之后应该使用被模式
			ftp.login(ftp_server_usr, ftp_server_pw)
			ftp.putbinaryfile(ftp_file, ftp_downfile, ftp_block)
		end
	end
end

ftp_server_ip  = ARGV[0]
ftp_server_usr = ARGV[1]
ftp_server_pw  = ARGV[2]
ftp_file       = ARGV[3]
ftp_downfile   = ARGV[4]
ftp_block      = ARGV[5].to_i
ftp_action     = ARGV[6]

if ftp_action=="get"
	FTPClient.getbinaryfile(ftp_server_ip, ftp_server_usr, ftp_server_pw, ftp_file, ftp_downfile, ftp_block)
elsif ftp_action=="put"
	FTPClient.putbinaryfile(ftp_server_ip, ftp_server_usr, ftp_server_pw, ftp_file, ftp_downfile, ftp_block)
else
	fail "FTP action error"
end

