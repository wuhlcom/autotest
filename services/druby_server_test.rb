#encoding:utf-8
require "htmltags"
require "drb"
require "rexml/document"
require "fileutils"
# require "drb/observer"
# 1扫描网络
# 2连接网络
# 3查询网络连接
# 4断开网络连接
# 添加FTP client 操作 2015-10-19 wuhongliang
class Wlan
		include HtmlTag::WinCmd
		include HtmlTag::LogInOut
		include HtmlTag::Wireshark
		include HtmlTag::Reporter
		include HtmlTag::WinCmdSys
		stdio("logs/druby_server,log")
		attr_accessor :ftp_client_pid

		def initialize(file_name="", nicname="wireless")
				@file_name         =file_name
				# @netobj=HtmlTag::Network.new()
				@pwdobj            =HtmlTag::Passwd.new()
				@ftp_client_pid    =nil
				@default_srv_file  ="QOS_TEST2.zip"
				@default_local_path="D:/ftpdownloads/#{@default_srv_file}"
		end

		#@@passwd_profile = "#{nicname}-#{ssid_name}.xml"
		def create_pwfile(ssid_hash, ssid_name, passwd_profile="", passwd="12345678", nicname="wireless")
				passwd_profile=nicname+"-"+ssid_name+".xml" if passwd_profile==""
				puts "method_name:#{__method__.to_s}"
				args={
						:ssid      => ssid_name,
						:passwd    => passwd,
						:file_path => passwd_profile,
						:au_type   => ssid_hash[:au_type].to_utf8,
						:pass_type => ssid_hash[:pass_type]
				}
				if passwd !=""
						puts "create_aes"
						@pwdobj.create_aes(args)
				else
						puts "create_none"
						@pwdobj.create_none(args)
				end
		end

		def add_new_connection(ssid_hash, ssid_name, passwd="12345678", passwd_profile="", nicname="wireless")
				passwd_profile=nicname+"-"+ssid_name+".xml" if passwd_profile==""
				puts "method_name:#{__method__.to_s}"
				puts "create passwd file..."
				create_pwfile(ssid_hash, ssid_name, passwd_profile, passwd, nicname)
				puts "add passwd file..."
				netsh_ap(passwd_profile)
				sleep 2
				puts "show profile info..."
				pros     = show_profiles
				pros_arr = pros["wireless"]
				if pros_arr.empty?
						fail("add profile failed!")
				end
				netsh_conn(ssid_name)
				puts "Waiting for new connecting..."
				sleep 30
				interface=show_interfaces
				status   = interface["wireless"][:status]
				if status=="connected"
						puts "Connected..."
						return true
				else
						puts "Connect failed!!!!"
						return false
				end
		end

		def scan_network(ssid_name, nicname="wireless")
				puts "method_name:#{__method__.to_s}"
				for i in 0..2
						networks  = show_networks #查找网络
						ssid_find = networks[nicname].keys.any? { |key| key==ssid_name } #判断是否扫描到网络
						if ssid_find
								ssid_hash = networks[nicname][ssid_name]
								break
						end
						sleep 10
				end
				{:flag => ssid_find, :ssid_hash => ssid_hash}
		end

		#已经连接的情况下修改配置文件
		#flag->1 已连接时修改现有密码，2 将加密修改为不加密 3 从不加密修改为加密  (profile_name, passwd, ssid="", nicname="wireless")
		def modify_profile passwd_profile, flag, ssid_name="", passwd="12345678", nicname="wireless"
				puts "method_name:#{__method__.to_s}"
				if flag == "1" #修改aes
						netsh_modify_pass passwd_profile, passwd, ssid_name, nicname
				elsif flag=="2" #无加密
						netsh_set_none passwd_profile, ssid_name, nicname
				elsif flag=="3" #从无加密修改为aes
						netsh_modify_none_pass passwd_profile, passwd, ssid_name, nicname
				end
				sleep 1
				netsh_conn(ssid_name)
				puts "Waiting for connecting after modified profile..."
				sleep 30
				interface= show_interfaces
				status   = interface["wireless"][:status]
				if status=="connected"
						puts "Connected.."
						return true
				else
						puts "Connect failed"
						return false
				end
		end

		def connect(ssid_name, flag, passwd="12345678", nicname="wireless", passwd_profile="")
				puts "method_name:#{__method__.to_s}"
				nicname = nicname.downcase
				if passwd_profile==""
						passwd_profile=nicname+"-"+ssid_name+".xml"
				end
				passwd_profile=File.expand_path(passwd_profile)

				# if File.exists?(passwd_profile)
				puts "XML file '#{passwd_profile}' existed! "
				@pwdobj.doc     = REXML::Document.new
				@pwdobj.root_el = @pwdobj.doc.add_element("WLANProfile")
				# end

				#先删除路径下所有的配置文件
				xml_files       = Dir.glob("*.xml") #获取当前目录下的所有xml文件，既是配置文件
				FileUtils.rm(xml_files)

				rs = scan_network(ssid_name)
				if rs[:flag]
						profiles     = show_profiles
						profiles_arr = profiles[nicname]
						if profiles_arr.empty? #如果不存在配置文件将要添加配置文件
								p "No Profiles create new XML to connect"
								add_new_connection(rs[:ssid_hash], ssid_name, passwd, passwd_profile, nicname)
						else
								#删除网卡所有配置文件，这里是删除存在电脑中的配置
								profiles_arr.each { |profile|
										netsh_dp(profile, nicname)
								}
								#删除了配置文件后，新建配置文件(xml文本)
								p "Profiles do not contain #{ssid_name}， create new XML to connect"
								add_new_connection(rs[:ssid_hash], ssid_name, passwd, passwd_profile, nicname)
						end
				else
						fail("Can't find wifi ssid:#{ssid_name} !")
				end
		end

		def delete_pwfile(passwd_profile)
				puts "method_name:#{__method__.to_s}"
				if File.exists?(passwd_profile)
						open("passwd_profile", "w") { |f|
								f.puts ""
						}
				end
		end

		def login_router(address, usr, pw)
				# browser, default_ip=@@default_ip, usrname="admin", passwd="admin", relogin=false
				begin
						browser = Watir::Browser.new :firefox, :profile => "default"
						browser.cookies.clear
						rs = login_default(browser, address, usr, pw)
				rescue => e
						p e.message.to_s
						rs = false
				ensure
						browser.close unless browser.nil?
				end
				rs
		end

		def drb_ftp_client(server_ip, usr, pw, size, action, srv_file=@default_srv_file, local_path=@default_local_path)
				file_dir = File.dirname(local_path)
				#如果目录不存在则创建目录
				FileUtils.mkdir_p(file_dir) unless File.exists?(file_dir)
				file_name = File.basename(local_path, ".*")
				Dir.glob("#{file_dir}/*") { |filename|
						filename=~/#{file_name}/ && FileUtils.rm_f(filename) #rm_rf要慎用
				}
				client          =File.absolute_path("../ftp_client.rb", __FILE__)
				@ftp_client_pid = Process.spawn("ruby #{client} #{server_ip} #{usr} #{pw} #{srv_file} #{local_path} #{size} #{action}", STDERR => :out)
				sleep 30 #等待ftp客户端下载，无线在等待30以上才能稳定
				@ftp_client_pid
		end

		def drb_top_ftp_client(pid)
				begin
						if Process.detach(pid).alive? #抓完包后杀死进程
								Process.kill(9, pid)
						end #停止下载
				rescue => ex
						puts "#{ex.message.to_s}"
				end
		end

end

=begin
wifi          = Wlan.new()
ipinfo        = wifi.ipconfig
nicname       = "control"
server_port   = "8787"
drb_server_ip = ipinfo[nicname][:ip][0]
puts "..."*20
puts "DRB Server #{drb_server_ip} Started on NIC ##{nicname} port #{server_port}......"
uri = "druby://#{drb_server_ip}:#{server_port}"
DRb.start_service(uri, wifi)
DRb.thread.join
=end

#=begin
if __FILE__==$0
		wifi = Wlan.new()
		p rs = wifi.ipconfig
		p rs.has_key?("control")
		p rs.has_key?("lan")
		# p wifi.ipconfig
		# ssid_name = "WIFI_00116B"
		# passwd = "12345678"
		ssid_name              = "WIFI_039E99"
		passwd                 = "ABCDEFGH"
		nicname                = "wireless"
		flag                   = "1"
		passwd_profile         = "#{nicname}-#{ssid_name}.xml"
		# wifi.instance_eval { @ssid_name="Test2" }
		# passwd_profile=File.expand_path(passwd_profile)
		# p File.exists?(passwd_profile)
		# wifi.netsh_ap(passwd_profile)
		#wifi.connect(ssid_name, flag, passwd, nicname, passwd_profile)
		# p wifi.login_router("192.168.100.1", "admin", "admin")

		server_ip              ="10.10.10.57"
		usr                    = "admin"
		pw                     = "admin"
		size                   = 32768
		action                 = "get"
		tc_cap_wireless_client1="d:/captest/ftp.pcapng"
		ts_wlan_nicname        = "wireless"
		pid                    = wifi.drb_ftp_client(server_ip, usr, pw, size, action)
		tc_output_time         =10
		tc_cap_time            =10
		wifi.tshark_duration(tc_cap_wireless_client1, ts_wlan_nicname, tc_output_time, tc_cap_time)
		wifi.drb_top_ftp_client(pid)
end
#=end



