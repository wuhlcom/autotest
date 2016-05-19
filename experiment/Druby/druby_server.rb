#encoding:utf-8
require "htmltags"
require "drb"
require "rexml/document"
# require "drb/observer"
# 1扫描网络
# 2连接网络
# 3查询网络连接
# 4断开网络连接
class Wlan

	include HtmlTag::WinCmd
	include HtmlTag::Reporter
	stdio("druby_server,log")

	def initialize(file_name="", nicname="wireless")
		@file_name=file_name
		# @netobj=HtmlTag::Network.new()
		@pwdobj   =HtmlTag::Passwd.new()
	end

	#@@passwd_profile = "#{nicname}-#{ssid_name}.xml"
	def create_pwfile(ssid_name, passwd_profile="", passwd="12345678", nicname="wireless")
		passwd_profile=nicname+"-"+ssid_name+".xml" if passwd_profile==""
		puts "method_name:#{__method__.to_s}"
		args={
				:ssid      => ssid_name,
				:passwd    => passwd,
				:file_path => passwd_profile
		}
		if passwd !=""
			puts "create_aes"
			@pwdobj.create_aes(args)
		else
			puts "create_none"
			@pwdobj.create_none(args)
		end
	end

	def add_new_connection(ssid_name, passwd="12345678", passwd_profile="", nicname="wireless")
		passwd_profile=nicname+"-"+ssid_name+".xml" if passwd_profile==""
		puts "method_name:#{__method__.to_s}"
		puts "create passwd file..."
		create_pwfile(ssid_name, passwd_profile, passwd, nicname)
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

	def scan_network(ssid_name)
		puts "method_name:#{__method__.to_s}"
		for i in 0..1
			networks = show_networks #查找网络
		end
		ssid_arr = networks["wireless"].keys.any? { |key| key==ssid_name } #判断是否扫描到网络
	end

	#已经连接的情况下修改配置文件
	#flag->1 已连接时修改现有密码，2 将加密修改为不加密 3 从不加密修改为加密
	def modify_profile flag, ssid_name="", passwd="12345678", nicname="wireless"
		puts "method_name:#{__method__.to_s}"
		if flag == "1" #修改aes
			netsh_modify_pass ssid_name, passwd, ssid_name, nicname
		elsif flag=="2" #无加密
			netsh_set_none ssid_name, ssid_name, nicname
		elsif flag=="3" #从无加密修改为aes
			netsh_modify_none_pass ssid_name, passwd, ssid_name, nicname
		end
		netsh_conn(ssid_name)
		puts "Waiting for connecting after modified profile..."
		sleep 15
		interface=show_interfaces
		status   = interface["wireless"][:status]
		if status=="connected"
			puts "Connected.."
			return true
		else
			puts "Connect failed"
			return false
		end
	end

	def connect(ssid_name, flag, passwd="12345678", nicname="wireless",passwd_profile="")
		puts "method_name:#{__method__.to_s}"
		if passwd_profile==""
			passwd_profile=nicname+"-"+ssid_name+".xml"
		end
		if File.exists?(passwd_profile)
			@pwdobj.doc     = REXML::Document.new
			@pwdobj.root_el = @pwdobj.doc.add_element("WLANProfile")
		end

		if scan_network(ssid_name)
			profiles     = show_profiles
			profiles_arr = profiles["wireless"]
			if profiles_arr.empty? #如果不存在配置文件将要添加配置文件
				add_new_connection ssid_name, passwd, passwd_profile, nicname
			else
				profiles_arr.delete_if { |profile|
					temp = (profile != ssid_name)
					if temp
						netsh_dp(profile, nicname)
					end
					temp
				}
				if profiles_arr[0] != ssid_name
					add_new_connection ssid_name, passwd, passwd_profile, nicname
				else
					modify_profile flag, ssid_name, passwd, nicname
				end
			end
		else
			raise "Can't find wifi ssid:#{ssid_name} !"
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
end

wifi      = Wlan.new()
#=begin
ipinfo    = wifi.ipconfig
drb_server=ipinfo["control"][:ip][0]
puts "..."*50
puts "DRB Server #{drb_server} Started ......"
uri = "druby://#{drb_server}:8787"
DRb.start_service(uri, wifi)
DRb.thread.join
#=end

# if __FILE__==$0
#  p wifi = Wlan.new()
#  p wifi.ipconfig
#    ssid_name = "zhilu"
#    nicname = "wireless"
#    passwd = ""
#    flag ="2"
#    passwd_profile = "#{nicname}-#{ssid_name}.xml"
#    wifi.instance_eval{@ssid_name="Test2"}
#    wifi.connect(ssid_name, passwd, passwd_profile, flag)
# end



