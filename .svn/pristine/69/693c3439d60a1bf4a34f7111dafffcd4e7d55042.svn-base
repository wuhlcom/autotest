#encoding:utf-8
=begin
"http://192.168.200.1/setstatus.asp"=~/\qos{1,3}\.\qos{1,3}\.\qos{1,3}\.\qos{1,3}/
s="first11"
p /(first|second)(\qos+)/=~s# 差
p Regexp.last_match(1)
p Regexp.last_match(2)
p /(?:first|second)/=~s# 好
p $1
p "~"*30
# /(regexp)/ =~ string
/(111)/ =~"1111"
# 差
p $1
# 好
Regexp.last_match(1)
=end
/(?<meaningful_var>string)/ =~ "string"
p meaningful_var
p "#################"
=begin
x=1
rs = if x==1
	     "11"
	   elsif x==2
		   "22"
	   else
		   raise "11"
     end
p "---------------------------------------------------------"
s = "config"
s="adddresses"
p /\Aconfig|addresses\Z/=~s

p "666666666666666666666666666666"
h={t:"1",s:"2"}
p h.fetch(:t)
p k ||= "a"
p h[:a] = "xx"

p t = "1"=~/1/
p t.class
p "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
p ip_regexp = '\qos{1,3}\.\qos{1,3}\.\qos{1,3}\.\qos{1,3}'
ip="192.168.100.1"
p /(#{ip_regexp})/=~ip
p Regexp.last_match 1=end
=end
# "1"=~/1(.*)/
# p $1
# p "无"
# @ts_default_ip="192.168.111.1"
# p sub_default_ip=@ts_default_ip.sub(/\.\qos+$/, "")

# s="sfe11:a2:d3:e3:22:ffddddd"
# p s=~/([\qos|a-f]{2}:[\qos|a-f]{2}:[\qos|a-f]{2}:[\qos|a-f][\qos|a-f]:[\qos|a-f][\qos|a-f]:[\qos|a-f][\qos|a-f])/i
# p Regexp.last_match(1)
#
# @tc_usb_download_file_size="177.92MB"
# @tc_usb_download_file_size=~/^(\qos+\.*\qos+)/
# p "@tc_usb_download_file_size"
# p @tc_usb_file_size=Regexp.last_match(1)
# @ip_regxp        =/(\qos{1,3}\.\qos{1,3}\.\qos{1,3}\.\qos{1,3})/
# p "IP\u5730\u5740\n10.10.10.100"=~@ip_regxp

#encoding:utf-8
# @ts_tag_cpu_type_reg  = /处理器类型：.+/i
# @ts_tag_cpu_name_reg  = /处理器型号：.+/i
# @ts_tag_cpu_load_reg  = /系统负载：\d+\.\d+/i
# @ts_tag_mem           = "内存信息"
# @ts_tag_mem_total_reg = /内存总量：\s*[1-9]+\s*M/
# @ts_tag_mem_total_reg = /可用内存：\s*[1-9]+\s*M/
# @ts_tag_mem_total_reg = /缓存内存：\s*[1-9]+\s*M/
# p "缓存内存：13M"
# p @ts_tag_mem_total_reg=~"缓存内存：13M"
# p @ts_tag_mem_total_reg.source
# p @ts_tag_mem_total_reg.options
# p /(1)/=~"1"
# p Regexp.last_match(1)
# p "1"=~/(1)/
# p Regexp.last_match(1)
ssid_name = "SSID\nWIFI_762066"
/\n(?<ssid>.+)/m=~ssid_name
p ssid