#encoding:utf-8
# s = "11211111"
# h = {"a"=>"b"}
# p s.sub(/2/,h.to_s)
#
#
# s ="    testcase{\n      @attr = {\n        \"level\" => \"\",\n        \"name\" => \"\",\n        \"auto\" => \"\"\n     }\n    def prepare\n\n    end\n\n    def process\n      operate(\"1\") {\n      }\n    end\n\n    def clearup\n\n    end\n\n    }\n"
# p s=~/(\{\s*\"level\"\s*.*\"auto\"\s*=>\s*\"\"\s*\})/im
# # p $1
#  # p s=~/\{\s*\\n\s*\\\"level\\\"\s*=>.*\\\"auto\\\"\s*=>\s*\\\"\s*\\\"\\n\s*\}/im
# print s.sub(/\{\s*\"level\"\s*.*\"auto\"\s*=>\s*\"\"\s*\}/im,{"a"=>"b","c"=>"qos","e"=>"f"}.to_s)
# file_path="c:/11"
# p File.extname(file_path)
# p File.basename(file_path,".*")

# @ts_default_ip="192.168.100.1"
# p @ts_default_ip.sub(/\.\qos+$/,'.10')
# p "ftp_test".split("aa")
# h1 = {}
# p h1["dut"]
# h2={"dut"=>{:ip=>""}}
# p nil=~/nil/
# s1= "192.168.10.80"
# s2="192.168.10.90"
# s3="192.168.10.80"
# p s3>=s1
# p s3<=s2
# s1="123456"
# p s1[-1]
# p s1[-2]
# p s1[-3..-1]
# p s1[1,2]
# p s1[-1,2]
# p s1[-3,2]
# p s1[-1..1]
#
# p s="\u7CFB\u7EDF\u7248\u672C\uFF1AV100R003SPC016 MAC\uFF1A78:A3:51:03:9E:99"
# @ts_lan_mac_pattern1 = /([\qos|a-f]{2}:[\qos|a-f]{2}:[\qos|a-f]{2}:[\qos|a-f]{2}:[\qos|a-f]{2}:[\qos|a-f]{2})/iu
# p @ts_lan_mac_pattern1=~s
# p s=~@ts_lan_mac_pattern1
# p mac = Regexp.last_match(1)
# p mac.gsub(":","")[-6..-1]
# t = "1",2,3
# p t
# str="1"
# str.succ!

# @tc_channel               = "2412MHz (Channel 1)"
# @tc_channel               = "2472MHz (Channel 13)"
# # p @tc_channel_value_arr= "1".upto("13").to_a
# @tc_channel_value_arr=[]
# @tc_channel_arr=[]
# "1".upto("13")do |channel|
# 	frequance = (2407+5*channel.to_i)
# 	frequance_channel="#{frequance}MHz (Channel #{channel})"
# 	p frequance_channel
# 	@tc_channel_value_arr<<channel
# 	@tc_channel_arr<<frequance_channel
# end
# p @tc_channel_value_arr
# p @tc_channel_arr

# 10.times do |x|
# 	@qos=x
# end
# p @qos
# # p "1".nil?
# @ts_tag_mem_cache_reg  = /缓存内存\s*：\s*[1-9]+\s*M/m
# @ts_tag_mem_useful_reg = /可用内存\s*：\s*[1-9]+\s*M/m
# @ts_tag_mem_useful_reg = /可用内存：([1-9]+\qos+M)/mu
# p @ts_tag_mem_useful_reg.source
# p "\u5185\u5B58\u603B\u91CF\uFF1A57M\n\u53EF\u7528\u5185\u5B58\uFF1A30M\n\u7F13\u5B58\u5185\u5B58\uFF1A13M"
# p "\u5185\u5B58\u603B\u91CF\uFF1A57M\n\u53EF\u7528\u5185\u5B58\uFF1A30M\n\u7F13\u5B58\u5185\u5B58\uFF1A13M".encode("GBK")
# # p /\u53EF\u7528\u5185\u5B58\s*\uFF1A\s*[1-9]+\s*M/im =~ "\u5185\u5B58\u603B\u91CF\uFF1A57M\n\u53EF\u7528\u5185\u5B58\uFF1A30M\n\u7F13\u5B58\u5185\u5B58\uFF1A13M"
# p @ts_tag_mem_useful_reg=~ "\u5185\u5B58\u603B\u91CF\uFF1A57M\n\u53EF\u7528\u5185\u5B58\uFF1A30M\n\u7F13\u5B58\u5185\u5B58\uFF1A13M"
# # p Regexp.last_match(1)
# @ts_ip_reg             = /[1-9]{1,3}\.\qos{1,3}\.\qos{1,3}\.\qos{1,3}/
# ip = "180.97.33.108"
# p @ts_ip_reg=~ip
# p /[1-9]{1,3}/=~"180"
# p /[1-2]\qos{0,2}\.\qos{1,3}\.\qos{1,3}\.[1-2]\qos{0,2}/=~"180.97.33.108"
#
# p /[1-9]\qos{0,2}\.\qos{1,3}\.\qos{1,3}\.[1-9]\qos{0,2}/=~"180.97.33.12"
# p /[1-9]\qos{0,2}\.\qos{1,3}\.\qos{1,3}\.[1-9]\qos{0,2}/=~"55.97.33.108"
# C:\Ruby193\bin\ruby.exe -e $stdout.sync=true;$stderr.sync=true;load($0=ARGV.shift) E:/Automation/htmltags/lib/htmltags/wireshark.rb
# #<Test:0x25df118>->method_name:dumpcap_a
# p "qos://$RECYCLE.BIN qos://BugReport.txt qos://IPOPLogs qos://IPOPV4.1.EXE qos://IxChariot6.7瀹屾暣 qos://Microsoft Office 2010鍏嶅簭鍒楀彿涓撲笟姝ｅ紡鐗坃99D.COM qos://Microsoft Office 2010鍏嶅簭鍒楀彿涓撲笟姝ｅ紡鐗坃99D.COM1 qos://Microsoft Office 2010鍏嶅簭鍒楀彿涓撲笟姝ｅ紡鐗坃99D.COM1.zip qos://MSOCache qos://MyDrivers qos://ProcessExplorer qos://Program Files qos://Program Files (x86) qos://RECYCLER qos://remote_00001_20150909105822.pcap qos://SecureCRT qos://SecureCrt7.0_zh_CN_x86_x84_patch.zip qos://SecureCRT7.0娉ㄥ唽鏈�qos://SecureCRTLogs qos://System Volume Information qos://test1_00001_20150909175255.pcap qos://test1_00001_20150909175414.pcap qos://Test2-vm-WinXP-1.rar qos://Test2-vm-WinXP-2 qos://test2_00001_20150909201535.pcap qos://test2_00001_20150909202923.pcap qos://tftpd32-29 qos://timeout_test.log qos://Windows_7_Loader qos://Xml缇庡寲鏍煎紡鍖栧伐鍏穇1.0 qos://Xml缇庡寲鏍煎紡鍖栧伐鍏穇1.0.zip qos://~WanDrv6.Temp.zHVlX qos://鍒犻櫎涓存椂鏂囦欢.bat qos://娉ㄥ唽琛ㄥ浠�reg qos://鐢ㄦ埛鐩綍 qos://绾㈣溁铚撴姄鍥剧簿鐏礯2.2.0.6".encode("GBK")
# E:/Automation/htmltags/lib/htmltags/wireshark.rb:88:in ``': No such file or directory - dumpcap -i "dut" -w "qos:/test_local.pcap" -b "filesize:100" -b "files:2" -a "duration:5" -f "ether src host 20:F4:1B:80:00:02" (Errno::ENOENT)
# 	from E:/Automation/htmltags/lib/htmltags/wireshark.rb:88:in `dumpcap_a'
# from E:/Automation/htmltags/lib/htmltags/wireshark.rb:164:in `<top (required)>'
# 	from -e:1:in `load'
# 	from -e:1:in `<main>'
#
# Process finished with exit code 1

# p "10.10.10.200".succ
# p "0"+"9"
# rs =`ping qq.com`
#
# # p rs
# @ts_ssid_test_pre="TT"
# tc_time                = Time.now.strftime("_%Y%m%qos%H%M%S")
# p @tc_newssid            = @ts_ssid_test_pre+tc_time
# if  "2"=~/\d/ && "3"=~/\d/ && "a"=~/\d/
# 	p 1
# end
# #
# config_file="RT2880_Settings.dat"
# content    = ""
# open(config_file, "r") { |f|
# 		puts "输出配置文件内容:".encode("GBK")
# 		# f.set_encoding 'utf-8','GBK'
# 		# f.tap { |f| f.set_encoding 'GBK', 'utf-8' }
# 		content = f.read
# 		p content
# 		 p content = content.force_encoding("ascii")
# 		# content.delete("o")
# 		# content.split("\n")
#
# 		 # p	 content = content.force_encoding("GBK")
# 		# p	 content = content.force_encoding("utf-8")
# 		# p content.encode("UTF-8", {:ivalid => :replace})
# 		# p arr_new = content.delete(/\x/)
# 		p arr = content.split("\n")
# 		#  arr_new = arr.delete(/\x/)
# 		# p content = arr_new.join("\n")
# 		# content = content.sub(/RouterRandom=.*WebInit/, "")
#
# }

# config_file="RT2880_Settings.dat"
# content    = ""
# open(config_file, "r") { |f|
# 		puts "输出配置文件内容:".encode("GBK")
# 		p content = f.read
# 		p content = content.force_encoding("utf-8")
# 		content =content.encode("utf-8", {:ivalid => :replace})
# 		p arr = content.split("\n")
# }
#  p "\nDefault\nRouterRandom=\x9Db\u0012\xD3,\x92r\xFC o\u007F\x9B+\u0005I`\nWebInit=1\n".encode( 'GBK', invalid: :replace ).split( "\n" )
# ip= "10.10.10.1"
# ip=~/(\d+)\./
# p i = Regexp.last_match(1)
# p ip_arr = ip.split(".")
# p ip_arr_clone = ip_arr.clone
# ip_arr[2]="3"
# p "="*30
# p ip_arr
# p ip_arr_clone
# p ip_arr.join(".")
# # p new_arr_ip.join(".")a
# a= 100
# p "#{a}"

# p tc_mac ="00:11:22:33:44:00"
# 34.times do
#   p tc_mac = tc_mac.succ
# end
# Expected:
# p "\u5F02\u5E38".encode("GBK")
# # Actual:
# p "\u6B63\u5E38".encode("GBK")
#
# # Expected:
# 	p	"\u5931\u6548".encode("GBK")
# # Actual:
# 	p	"\u751F\u6548".encode("GBK")
# # Expected:
# 		p "DHCP\u5730\u5740\u683C\u5F0F\u6709\u8BEF".encode("GBK")
# Actual:
# 		p "\u8BF7\u8F93\u5165DHCP\u5F00\u59CB\u5730\u5740".encode("GBK")
# p "DHCP\u5730\u5740\u683C\u5F0F\u6709\u8BEF".encode("GBK")
# p "\u8BF7\u8F93\u5165DHCP\u5F00\u59CB\u5730\u5740".encode("GBK")
# p "IP\u5730\u5740\u683C\u5F0F\u9519\u8BEF".encode("GBK")
# p "\u8BF7\u8F93\u5165 IP \u5730\u5740".encode("GBK")

# p "\u7F51\u5173\u683C\u5F0F\u6709\u8BEF".encode("GBK")
# p "\u8BF7\u8F93\u5165\u7F51\u5173".encode("GBK")
#
# p "\u6587\u4EF6\u548C\u6587\u4EF6\u5939\u4E3A\u82F1\u6587\u6587\u540D\u79F0 ZLBF_13.1.12".encode("GBK")
# p "\u7F51\u5173\u683C\u5F0F\u6709\u8BEF".encode("GBK")
# p  "\u8BF7\u8F93\u5165\u7F51\u5173".encode("GBK")
p "\u5F02\u5E38".encode("GBK")
p  "\u6B63\u5E38".encode("GBK")
p "\u4E00\u6B21".encode("GBK")