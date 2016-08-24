#encoding:utf-8
require 'htmltags'
require 'drb/drb'
require 'pp'
require "rexml/document"
SERVER_URI="druby://50.50.50.56:8787"
DRb.start_service
@wifi         = DRbObject.new_with_uri(SERVER_URI)
ssid_name     ="WIFI_006C9B"
nicname       ="wireless"
passwd        ="12345678"
passwd_profile=""
@tc_wifi_flag = 1
########################drb wifi#######################
pwfile        ="#{nicname}-#{ssid_name}.xml"
p @wifi.connect(ssid_name, @tc_wifi_flag, passwd, nicname, passwd_profile, false)
# @wifi.goto_url("www.baidu.com")
# pp hash = @wifi.netsh_if_shif
#  pp hash = @wifi.enable_wireless_nic
# p @wifi.enable_wired_nic
# sleep 10
# pp hash = @wifi.get_host_name
# pp @wifi.ipconfig("all")
####################################tcp client################
# SERVER_URI="druby://50.50.50.57:8787"
# DRb.start_service
# @tc_wan_drb         = DRbObject.new_with_uri(SERVER_URI)
# p @tc_wan_drb.ipconfig
#  i = 1
# loop do
# 		# @tc_pppoe_addr          ="20.20.20.91"
# 		# @tc_pppoe_addr          ="10.10.10.57"
# 		@tc_pppoe_addr          ="10.10.10.79"
# 		@ts_pppoe_dmz_tcpsrvport="9000"
# 		rs                      = @tc_wan_drb.tcp_client(@tc_pppoe_addr, @ts_pppoe_dmz_tcpsrvport)
# 		# tcp_client(@tc_ppptp_addr, @tc_dmz_tcpsrv_port)
# 		tcp_msg = rs.tcp_message
# 		puts "=================Message from TCP server #{i}==============="
# 		print tcp_msg
# 		sleep 5
# 		i+=1
# 		p rs.tcp_state
# 		break if i==2
#
# end
######################################drb udp client##################################
#  p @tc_srv_wan = "192.168.0.57"
# p @tc_srv_wan_udpsrvport= "15801"
#  p @tc_client_addr = "192.168.100.100"
#  p @tc_client_udport = rand_port
#  p rs2 = @tc_wan_drb.udp_client(@tc_client_addr, @tc_client_udport,@ts_srv_wan, @tc_srv_wan_udpsrvport)
# puts "=================Message from UDP server==============="
# p rs2.udp_message

#####################################DRB FTP################################################################
# p client = File.absolute_path("../ftp_client.rb", __FILE__)
# server_ip            ="10.10.10.57"
# usr                  = "admin"
# pw                   = "admin"
# size                 = 32768
# action               ="get"
# @tc_cap_wired_client1="d:/ftpcaps/drb_ftp_client.pcapng"
# @ts_nicname          ="wireless"
# @tc_output_time      = 10
# @tc_cap_time         = 10

# p rs                   = @tc_wan_drb.ipconfig("all")
# # @ts_pc_mac               = rs[@ts_nicname][:mac]
# pc_mac_address       =rs[@ts_nicname][:mac]
# @ts_pc_mac           = pc_mac_address.gsub!("-", ":")
# @ts_pc_ip            = rs[@ts_nicname][:ip][0]
# @tc_ftp_filter       = "not ether src #{@ts_pc_mac}"
#
# # pid = @tc_wan_drb.drb_ftp_client(server_ip, usr, pw, size, action, srv_file="QOS_TEST2.zip", local_path="d:/ftpdownloads/QOS_TEST2.zip")
# puts "=============wired client capture first time================="
#  # @tc_wan_drb.tshark_duration(@tc_cap_wired_client1, @ts_nicname, @tc_output_time, @tc_cap_time, @tc_ftp_filter)
# # sleep 12
# # @tc_wan_drb.drb_stop_ftp_client(pid)
# p @tc_wan_drb.capinfos_all("d:/ftpcaps/drb_ftp_client_00001_20151019201346.pcapng")
###################################remote web#############################################
# SERVER_URI="druby://50.50.50.57:8787"
# DRb.start_service
# @tc_wan_drb         = DRbObject.new_with_uri(SERVER_URI)
# remote_url="10.10.10.79:9000"
# @ts_default_usr="admin"
# @ts_default_pw="admin"
# p @tc_wan_drb.login_router(remote_url, @ts_default_usr, @ts_default_pw)
#######################route os#################33###
# SERVER_URI="druby://50.50.50.57:8787"
# DRb.start_service
# @tc_wan_drb         = DRbObject.new_with_uri(SERVER_URI)
# ip = "10.10.10.1"
# @tc_wan_drb.init_routeros_obj(ip)
#######################get_host_name
# SERVER_URI="druby://50.50.50.56:8787"
# DRb.start_service
# @tc_wan_drb         = DRbObject.new_with_uri(SERVER_URI)
# # ip = "10.10.10.1"
# p @tc_wan_drb.get_host_name()
