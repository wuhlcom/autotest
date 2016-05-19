require 'net/ftp'
ftp_server_ip  = ARGV[0]
ftp_server_usr = ARGV[1]
ftp_server_pw  = ARGV[2]
ftp_file       = ARGV[3]
ftp_downfile   =ARGV[4]
ftp_block      = ARGV[5].to_i
Net::FTP.open(ftp_server_ip) do |ftp|
	ftp.debug_mode = true
	ftp.login(ftp_server_usr, ftp_server_pw)
	ftp.getbinaryfile(ftp_file, ftp_downfile, ftp_block)
end

