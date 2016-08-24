#encoding:utf-8
#override the MiniTest::Unit::TestCase initialize method
#wuhongliang
require 'htmltags'
class WebTestNameSpace<MiniTest::Unit::TestCase
		extend HtmlTag::WebFrame
		include HtmlTag::WinCmd
		include HtmlTag::WinCmdSys
		include HtmlTag::WinCmdRoute
		include HtmlTag::Reporter
		include HtmlTag::LogInOut
		include HtmlTag::Wireshark
		include HtmlTag::Socket
		include HtmlTag::Telnet
		include HtmlTag::RouterTelnet

		def initialize name
				super name
				#####################login ############################
				@default_url    = "192.168.100.1"
				@ts_default_ip  = @default_url
				@ts_default_dns = @ts_default_ip

				@ts_dhcp_server_ip = "192.168.200.1"
				@ts_tag_login_usr  = 'admuser'
				@ts_tag_login_pw   = 'admpass'
				@usr_text_id       = 'admuser'
				@ts_tag_usr        = @usr_text_id
				@pw_text_id        = 'admpass'
				@ts_tag_pw         = @pw_text_id
				@login_button      = '登录'
				@ts_tag_login_btn  = @login_button

				@usr                    = "admin"
				@ts_default_usr         = @usr
				@pw                     = "admin"
				@ts_default_pw          = @pw
				##########################net set#######################
				@ts_tag_netset          = "set_network"
				@ts_tag_netset_src      = "netset.asp"

				######wan mode
				@ts_wan_mode_dhcp       = "DHCP"
				@ts_wan_mode_pppoe      = "PPPOE"
				@ts_wan_mode_pptp       = "PPTP"
				@ts_wan_mode_static     = "STATIC"
				@ts_tag_wired_mode_link = "tab_ip"
				@ts_tag_wired_mode_span = "wire"
				@ts_tag_wired_dhcp      = "ip_type_dhcp"
				@ts_tag_wired_pppoe     = "ip_type_pppoe"
				@ts_tag_wired_static    = "ip_type_static"
				@ts_tag_pppoe_usr       = "pppoeUser"
				@ts_tag_pppoe_pw        = "input_password1"
				@ts_tag_3g_mode_link    = "tab_3g"
				@ts_tag_3g_mode_span    = "dial"
				@ts_tag_wan_err         = "error_msg"
				######################## static ip  ############
				@ts_pppoe_usr           = 'pppoe@163.gd'
				@ts_pppoe_pw            = 'PPPOETEST'

				@ts_tag_staticIp        = "staticIp"
				@ts_tag_staticNetmask   = "staticNetmask"
				@ts_tag_staticGateway   = "staticGateway"
				@ts_tag_staticPriDns    = "staticPriDns"
				@ts_tag_backupDns       = "backupDns"
				@ts_staticIp            = '10.10.10.223'
				@ts_staticNetmask       = '255.255.255.0'
				@ts_staticGateway       = '10.10.10.1'
				@ts_staticPriDns        = '10.10.10.1'
				@ts_staticBackupDns     = "8.8.8.8"
				########lan set ######
				@ts_tag_lan             = "set_wifi"
				@ts_tag_lan_src         = "lanset.asp"
				@ts_tag_lanip           = "lan_ip"
				@ts_tag_lanstart        = "dhcpStart"
				@ts_tag_lanend          = "dhcpEnd"
				@ts_tag_lanerr          = "error_msg"
				@ts_lanip_err           = "DHCP地址格式有误"
				@ts_default_leasetime   = "43200"
				@ts_ssid_test_pre       = "ZhiluAuto"
				@ts_tag_ssid            = "ssid"
				@ts_tag_sec_select_list = "security_mode"
				@ts_sec_mode_none       = 'None'
				@ts_sec_mode_wpa        = 'WPA-PSK/WPA2-PSK'
				@ts_tag_input_pw        = "input_password1"
				@ts_wifi_flag           = "1"
				@ts_tag_dhcp_lease      = "dhcpLease"

				@ts_tag_systemver = "sysversion"
				@ts_tag_sys_ver   = "系统版本"

				@ts_wan_mac_pattern1 = /([\d|a-f]{2}:[\d|a-f]{2}:[\d|a-f]{2}:[\d|a-f]{2}:[\d|a-f]{2}:[\d|a-f]{2})/i
				@ts_lan_mask         = "255.255.255.0"
				@ts_default_wlan_pw  = "12345678"

				@ts_tag_net_reset_tip  = "aui_state_noTitle aui_state_focus aui_state_lock"
				@ts_tag_net_reset      = "aui_content"
				@ts_tag_net_reset_text = "设置成功！正在重启网络中，请稍等..."

				@ts_tag_lan_reset      = "aui_content"
				@ts_tag_lan_reset_text = "设置成功，请稍候...，如果网络断连，请重新连接。"

				@ts_tag_reboot_confirm   = "aui_state_highlight"
				@ts_tag_reboot_cancel    = "取消"
				@ts_tag_rebooting        = "aui_content"
				@ts_tag_rebooting_text   = "正在重启中，请稍后..."
				@ts_tag_reset            = "aui_content"
				@ts_tag_reset_text       = "恢复出厂将会清除当前所有配置， 确定要恢复出厂设置吗?"
				@ts_tag_reseting_text    = "正在恢复出厂设置，请稍等..."
				@ts_tag_pptp_set         = "设置成功"

				######reboot####
				@ts_tag_del_ipfilter_btn = "all_del"
				###system######
				@ts_tag_account_manage   = "passwd.asp"
				@ts_tag_modify_pw        = "system_config"
				@ts_tag_aduser           = "admuser"
				@ts_tag_adpass           = "admpass"
				@ts_tag_adpass2          = "admpass2"
				@ts_tag_modify_pw_error  = "error_msg"
				@ts_tag_logout           = "logout"
				@ts_tag_login_error      = "error_text"
				@ts_tag_login_errinfo    = "用户名或密码错误"
				@ts_tag_modify_pw_tip    = "修改密码成功！下次登录时请输入新密码。"
				################  ap  #################
				@ts_tag_ap_url           = "192.168.50.1"
				@ts_tag_ap_src           = "d_wizard_step1_start.asp"
				@ts_tag_ap_save          = "save"
				@ts_dut_ssid             = "WIRELESS-SSID"
				@ts_channel              = "WIRELESS-CH"
				@ts_pwdshow2             = "pwdshow2"
				@ts_pwdshow              = "pwdshow"
				@ts_ap_save_hint         = "loading"
				@ts_ap_safe_option       = "methodSel"
				@ts_ap_status            = "d_status.asp"
				@ts_main_content         = "maincontent"
				@ts_ap_wireless          = "d_wlan_basic.asp"
				@ts_wifi_advanced_setup  = "d_wladvanced.asp"
				@ts_24G_wifi_switch      = "advWlanDisabled"
				################ druby ##############
				# @ts_drb_pc2              = "druby://50.50.50.51:8787"
				@ts_drb_pc2              = "druby://50.50.50.56:8787"
				############### dut内网 ################
				@ts_wifi_switch          = "wifiswitch"
				############### dut状态 ################
				@ts_wifi_status          = "WIRELESS-ONOFF"
				############### dut高级设置 ############
				@ts_advance_setup        = "WIFI-Settings"
				@ts_wifi_channel         = "sz11gChannel"
				############### dut url ################
				@ts_url_set              = "menu_set"
				@ts_url_black            = "b_w_select"
				@ts_web_url              = "b_w_url"

				################# option tags #########################
				@ts_tag_options          = "options"
				@ts_tag_advance_src      = "advance.asp"
				#reboot
				@ts_tag_op_reboot        = "reboot_submit_btn"
				@ts_tag_op_reboot_tab    = "reboot-titile"
				@ts_tag_op_system        = "syssetting"
				@ts_tag_select_state     = "selected"
				@ts_tag_recover          = "reset-titile"
				@ts_tag_reset_factory    = "reset_submit_btn"
				@ts_tag_export           = "setmanExpSetExport"
				@ts_default_config_name  = "RT2880_Settings.dat"
				@ts_tag_syslog           = "syslog-titile"
				@ts_tag_liclass          = "active"
				@ts_tag_logclear         = "syslogSysLogClear"
				@ts_tag_log_textarea     = "syslog"
				@ts_tag_domain           = "device"
				@ts_tag_domain_field     = "domain"
				@ts_tag_domain_err       = "error_msg"
				@ts_tag_virsrvip_err     = "error_msg"
				######文件共享
				@ts_tag_fileshare        = "USB-titile"
				@ts_tag_filebtn_off      = "off"
				@ts_tag_filebtn_on       = "on"
				@ts_file_share_dir       = "Folder_structure.asp"
				@ts_storage_usb          = "U盘"
				@ts_storage_sd           = "SD卡"
				@ts_share_dir            = "文件测试"
				@ts_test_file            = "测试文件_TEST.txt"
				@ts_tag_close_share      = "关闭共享"
				@ts_tag_back             = "返回上一级"
				#######应用设置
				####dmz
				@ts_tag_application      = "aplicationsetting"
				@ts_tag_dmz              = "dmzSetting"
				@ts_tag_dmzsw            = "switch"
				@ts_tag_dmzip            = "dwz_ip"
				@ts_tag_dmzsw_on         = "on"
				@ts_tag_dmzsw_off        = "off"
				@ts_conn_state           = "succeed"
				@ts_wan_client_ip        = "10.10.10.57"
				# @ts_wan_client_uport      = rand_port
				@ts_wan_pppoe_httpip     = "192.168.0.57"
				@ts_wan_pppoe_httpport   = 80
				#####虚拟服务器
				@ts_tag_virtualsrv_sw    = "switch"
				@ts_tag_virtualsrv       = "virtualServer"
				@ts_tag_virsw_on         = "on"
				@ts_tag_virsw_off        = "off"
				@ts_tag_addvir           = "add_btn"
				@ts_tag_virip1           = "ip0"
				@ts_tag_virpub_port1     = "port0"
				@ts_tag_virpri_port1     = "port1"
				@ts_tag_virip2           = "ip1"
				@ts_tag_virpub_port2     = "port2"
				@ts_tag_virpri_port2     = "port3"
				@ts_tag_virip3           = "ip2"
				@ts_tag_virpub_port3     = "port4"
				@ts_tag_virpri_port3     = "port5"
				@ts_tag_virip4           = "ip3"
				@ts_tag_virpub_port4     = "port6"
				@ts_tag_virpri_port4     = "port7"
				@ts_tag_virip5           = "ip4"
				@ts_tag_virpub_port5     = "port8"
				@ts_tag_virpri_port5     = "port9"
				@ts_tag_virip6           = "ip5"
				@ts_tag_virpub_port6     = "port10"
				@ts_tag_virpri_port6     = "port11"
				@ts_tag_vir_protocol     = "protocol1"
				@ts_tag_vir_status       = "status1"
				@ts_tag_delvir           = "delete_btn"
				@ts_tag_save_btn         = "take_effect_btn"
				#####防火墙
				@ts_tag_security         = "securitysetting"
				@ts_tag_fwset            = "Firewall-Settings"
				@ts_tag_security_sw      = "switch1"
				@ts_tag_security_url     = "switch4"
				@ts_tag_security_mac     = "switch3"
				@ts_tag_security_save    = "save_btn"
				@ts_tag_macfilter        = "MAC-Filter"
				@ts_tag_fwstatus         = "firewall"
				@ts_tag_fwmac            = "macgl"
				@ts_tag_fw_open          = "开启"
				@ts_tag_fw_close         = "关闭"
				@ts_tag_additem          = "additem"
				@ts_tag_alladd           = "alladd"
				@ts_tag_allcancel        = "allcancle"
				@ts_tag_alldel           = "alldel"
				@ts_tag_fwmac_mac        = "mac"
				@ts_tag_fwmac_desc       = "desc"
				@ts_tag_fw_select        = "status"
				@ts_tag_fwmac_mac1       = "mac1"
				@ts_tag_fwmac_desc1      = "desc1"
				@ts_tag_fw_select1       = "status1"
				@ts_tag_save_filter      = "save_btniptb"
				@ts_tag_save_filter1     = "save_btniptb1"
				@ts_tag_filter_use       = "生效"
				@ts_tag_filter_nouse     = "失效"
				@ts_tag_mac_table        = "macguolv"
				@ts_tag_del              = "del"
				@ts_tag_edit             = "edit"
				####remote web access
				@ts_tag_op_remote        = "webtoroute"
				@ts_remote_default_port  = "9000"
				####close option iframe
				@ts_tag_file_div         = "aui_state_lock aui_state_focus"
				@ts_tag_style_zindex     = "z-index"
				####networking pptp
				@ts_tag_op_network       = "networksetting"
				@ts_tag_op_pptp          = "PPTP-Settings"
				@ts_tag_pptp_server      = "lanIp"
				@ts_tag_pptp_usr         = "username"
				@ts_tag_pptp_pw          = "psd"
				@ts_pptp_server_ip       = "10.10.10.1"
				@ts_pptp_usr             = "pptp"
				@ts_pptp_pw              = "pptp"
				####bandwidth
				@ts_tag_bandwidth        = "traffic-titile"
				@ts_tag_traffic          = "traffic-contol"
				@ts_tag_bandsw           = "wideband_limiter"
				@ts_tag_wideband         = "wideband_size"

				@ts_tag_range_min = "ip_range_min_0"
				@ts_tag_range_max = "ip_range_max_0"
				@ts_tag_band_mode = "wideband_mode_0"

				@ts_tag_range_min2 = "ip_range_min_1"
				@ts_tag_range_max2 = "ip_range_max_1"
				@ts_tag_band_mode2 = "wideband_mode_1"

				@ts_tag_range_min3 = "ip_range_min_2"
				@ts_tag_range_max3 = "ip_range_max_2"
				@ts_tag_band_mode3 = "wideband_mode_2"

				@ts_tag_range_min4 = "ip_range_min_3"
				@ts_tag_range_max4 = "ip_range_max_3"
				@ts_tag_band_mode4 = "wideband_mode_3"

				@ts_tag_range_min5 = "ip_range_min_4"
				@ts_tag_range_max5 = "ip_range_max_4"
				@ts_tag_band_mode5 = "wideband_mode_4"

				@ts_tag_bandlimit         = "受限最大带宽"
				@ts_tag_bandensure        = "保障最小带宽"
				@ts_tag_band_size         = "wideband_size_0"
				@ts_tag_client_bandsw     = "on_off_net_0"
				@ts_tag_band_size2        = "wideband_size_1"
				@ts_tag_client_bandsw2    = "on_off_net_1"
				@ts_tag_band_size3        = "wideband_size_2"
				@ts_tag_client_bandsw3    = "on_off_net_2"
				@ts_tag_band_size4        = "wideband_size_3"
				@ts_tag_client_bandsw4    = "on_off_net_3"
				@ts_tag_band_size5        = "wideband_size_4"
				@ts_tag_client_bandsw5    = "on_off_net_4"
				@ts_tag_band_tb           = "table_box"
				@ts_tag_band_err          = "error_msg"
				######################status Tags#############################################
				@tag_status_iframe_src    = "setstatus.asp"
				@ts_tag_status_iframe_src = @tag_status_iframe_src
				@tag_status               = "setstatus"
				@ts_tag_status            = @tag_status
				@ts_tag_lan_ip            = "LAN-IP"
				@tag_wan_ip               = "WAN-IP"
				@ts_tag_wan_ip            = @tag_wan_ip
				@tag_wan_type             = "WAN-CONTYPE"
				@ts_tag_wan_type          = @tag_wan_type
				@tag_wan_dns              = "WAN-DNS"
				@ts_tag_wan_dns           = @tag_wan_dns
				@tag_wan_mask             = "WAN-NETMASK"
				@ts_tag_wan_mask          = @tag_wan_mask
				@tag_wan_gw               = "WAN-GATEWAY"
				@ts_tag_wan_gw            = @tag_wan_gw
				@ts_tag_lan_mac           = "LAN-MAC"

				@ip_regxp        =/(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})/
				@ts_tag_ip_regxp = @ip_regxp

				@ts_tag_sbm            = "submit_btn"
				@ts_tag_reboot         = "reboottxt"
				######### DRB #####################
				# @ts_drb_server         = "druby://50.50.50.51:8787"  #第二套环境
				@ts_drb_server         = "druby://50.50.50.56:8787" #第一套环境
				@ts_drb_server2        = "druby://50.50.50.57:8787" #for dhcp server
				@ts_tcp_server         = "192.168.0.57"
				@ts_tcp_port_dhcp      = "16801"
				###########新版本3/4状态与原来版本差异很大 3/4G ################
				# 3G/4G拨号状态
				@ts_tag_diag_status    = "dial-status"
				@ts_tag_diag_text      = "3G/4G拨号状态"
				# SIM卡状态
				@ts_tag_sim            = "sim"
				@ts_tag_sim_status     = "sim_status"
				@ts_tag_img_normal     = "images/d.png"
				# 信号强度29
				@ts_tag_signal         = "xinhao"
				@ts_tag_signal_strenth = "wifi-signal"
				@ts_tag_signal_normal  = "images/5.png"
				# 注册状态
				@ts_tag_reg            = "reg"
				@ts_tag_reg_status     = "register-status"
				# 联网状态
				@ts_tag_3g_net         = "lianwang"
				@ts_tag_3g_net_status  = "net-status"
				# 网络类型4G
				@ts_tag_3g_nettype     = "nettype"
				@ts_tag_3g_net_type    = "net_type"
				# 运营商名称CHINA MOBILE
				@ts_tag_3g_isp         = "yiname"
				@ts_tag_3g_ispname     = "net_name"
				#################################diagnose tags#######################
				@ts_tag_diagnose       = "net_detect"
				@ts_tag_ad_diagnose    = "advanced-diagnosis"
				@ts_tag_url            = "url"
				@ts_tag_diag_btn       = "btnDet"

				@ts_tag_diag_detect       = "route-detect"
				@ts_tag_diag_detecting    = "路由器正在检测中……"
				@ts_tag_diag_fini_fail    = "诊断完成：网络很差。"
				@ts_tag_diag_ad_detecting = "努力诊断中，大概需要2分钟，请耐心等待..."
				@ts_tag_diag_fini_success = "恭喜，没有检测出问题。"
				@ts_tag_diag_success      = "正常"
				@ts_tag_diag_fail         = "异常"

				@ts_tag_diag_3gdial        = "3gdial"
				@tc_tag_diag_3gdial_text   = "3G拨号状态"
				@ts_tag_diag_3gdial_status = "checking"
				@ts_tag_diag_3g_errinfo    = "检测到你未接入3G模块，可以尝试通过3G模块上网[暂不支持该功能]"

				@ts_tag_diag_wan                 = "network-conn"
				@ts_tag_diag_wan_text            = "网络连接状态"
				@ts_tag_diag_wan_status          = "checking1"
				@ts_tag_wan_class                = "detail"
				@ts_tag_diag_wan_err             = /\s*外网连接不成功，\s*请检查外网连接类型是否正确，\s*进入【外网设置->网线连接】重新进行设置\s*/
				# @ts_tag_diag_wan_err    = "外网连接不成功 ， 请检查外网连接类型是否正确 ， 进入 【 外网设置->网线连接 】 重新进行设置"

				@ts_tag_diag_internet            = "wlan-conn"
				@ts_tag_diag_internet_text       = "外网连接状态"
				@ts_tag_diag_internet_status     = "checking2"
				@ts_tag_diag_internet_err        = "拨号连接不成功，请检查上网账号密码是否正确， 进入【外网设置->网线连接->宽带拨号】重新进行设置"
				@ts_tag_diag_internet_static_err = "外网连接不成功，请检查外网连接类型是否正确， 进入【外网设置->网线连接】重新进行设置"
				@ts_tag_diag_hardware            = "hardware-status"
				@ts_tag_diag_hardware_text       = "路由硬件状态"
				@ts_tag_diag_hardware_status     = "checking3"

				@ts_tag_diag_netspeed        = "network-speed"
				@ts_tag_diag_netspeed_text   = "连接速度状态"
				@ts_tag_diag_netspeed_status = "checking4"
				@ts_tag_diag_netspeed_err1   = "默认网关丢包率100%,网络质量较差，建议换根网线试试"
				@ts_tag_diag_netspeed_err2   = "域名解析失败，建议重启路由器试试"
				@ts_tag_diag_netspeed_err3   = "端口连通失败，建议重启路由器试试"

				@ts_tag_diag_cpu       = "cpu"
				@ts_tag_diag_cpu_text  = "处理器信息"
				@ts_tag_diag_cpu_xpath = "/html/body/div[2]/div[6]/div[2]"
				@ts_tag_cpu_type_reg   = /处理器类型：.+/im
				@ts_tag_cpu_name_reg   = /处理器型号：.+/im
				@ts_tag_cpu_load_reg   = /系统负载：\d+\.\d+/im

				@ts_tag_diag_mem       = "ram"
				@ts_tag_diag_mem_text  = "内存信息"
				@ts_tag_diag_mem_xpath = "/html/body/div[2]/div[7]/div[2]"
				@ts_tag_mem_total_reg  = /内存总量\s*：\s*[1-9]+\d*\s*M/m
				@ts_tag_mem_useful_reg = /可用内存\s*：\s*[1-9]+\d*\s*M/m
				@ts_tag_mem_cache_reg  = /缓存内存\s*：\s*[1-9]+\d*\s*M/m

				# Wanprotocal （上网连接类型）：DHCP
				@ts_tag_diag_nettype   = "Wanprotocal （上网连接类型）："
				# Wanlink （Wan连接状态）：正常
				@ts_tag_net_status     = "Wanlink （Wan连接状态）："
				# IP （域名解析到的IP地址）：180.97.33.108
				@ts_tag_domain_ip      = "IP （域名解析到的IP地址）："
				@ts_domina_ip_fail     = "失败"
				# GW （连接默认网关的丢包率）：0%
				@ts_tag_loss           = "GW （连接默认网关的丢包率）："
				# DNS （解析域名）：成功
				@ts_tag_dns            = "DNS （解析域名）："
				# HTTP （域名状态码）：200
				@ts_tag_http_status    = "HTTP （域名状态码）："

				@ts_net_link         = "正常"
				@ts_net_link_fail    = "失败"
				@ts_ip_reg           = /[1-9]\d{0,2}\.\d{1,3}\.\d{1,3}\.[1-9]\d{0,2}/
				@ts_loss_rate        = "0%"
				@ts_loss_rate_all    = "100%"
				@ts_dns_status       = "成功"
				@ts_dns_status_fail  = "失败"
				@ts_http_status      = "200"
				@ts_http_status_fail = "404"
				################### mac clone ######################
				@ts_tag_clone_mac    = "MAC-Clone"
				@ts_tag_clone_sw     = "switch"
				@ts_tag_fillmac      = "fillmac"
				@ts_tag_pcmac        = "pc_mac"
				@ts_cap_timeout      = 15
				@ts_server_lannic    = "LAN"
				@ts_cap_packetpath   = "D:/captures"
				FileUtils.mkdir_p(@ts_cap_packetpath) unless File.exists?(@ts_cap_packetpath)
				@ts_tag_btn_off  = "off"
				@ts_tag_btn_on   = "on"
				############################### other ####################################
				##ftp
				@ts_ftp_usr      = "admin"
				@ts_ftp_pw       = "admin"
				@ts_ftp_srv_file = "QOS_TEST2.zip"
				@ts_ftp_download = "D:/ftpdownloads/#{@ts_ftp_srv_file}"
				@ts_ftp_block    = 32768
				#100Mbpbs换算成bps
				@ts_band_100     = 104857600

				@web                  = "www.baidu.com"
				@ts_web               = @web
				@ts_diag_web          = "http://www.baidu.com"
				@ts_diag_web2         = "http://www.qq.com"
				@ts_nicname           = "dut"
				@ts_wlan_nicname      = "wireless"
				@ts_close_div         = "var list = art.dialog.list;for (var i in list) {list[i].close();}" #ArtDialog script
				@ts_aui_state         = "aui_state_focus aui_state_lock"
				@ts_aui_state_focus   = "aui_state_lock aui_state_focus"
				@ts_aui_state_full    = "aui_content aui_state_full"
				@ts_ipconf_all        = "all"
				# rs                    = ipconfig(@ts_ipconf_all)
				# pc_mac_address        = rs[@ts_nicname][:mac]
				# @ts_pc_mac            = pc_mac_address.gsub!("-", ":")
				# @ts_pc_ip             = rs[@ts_nicname][:ip][0]
				@ts_browser_ff        = :ff
				@ts_ff_profile        = "default"

				###############router os############
				@ts_routeros_ip       = "10.10.10.1"
				@ts_pppoe_default_set = "interface pppoe-server server set authentication=pap,chap,mschap1,mschap2 0"
				@ts_pppoe_pap_set     = "interface pppoe-server server set authentication=pap 0"
				@ts_pppoe_chap_set    = "interface pppoe-server server set authentication=chap 0"
				@ts_pppoe_mschap1_set = "interface pppoe-server server set authentication=mschap1 0"
				@ts_pppoe_mschap2_set = "interface pppoe-server server set authentication=mschap2 0"
				@ts_pppoe_srv_pri     = "interface pppoe-server server print"
		end

		#设置按xml顺序来执行
		#重新定义test_order
		def self.test_order_xml!
				class << self
						undef_method :test_order if method_defined? :test_order
						define_method :test_order do
								:xml
						end
				end
		end

		#设置按xml顺序来执行
		#当test_order为:xml时按xml文件顺序来执行
		def self.runnable_methods
				methods = methods_matching(/^test_/)
				if self.test_order == :xml
						methods
				else
						super
				end
		end
		test_order_xml!
end
