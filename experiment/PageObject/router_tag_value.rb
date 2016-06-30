#encoding:utf-8
# define router tag values
require 'page-object'
module PageObject
		################ PC2 网卡IP选择##############
		@@ts_nicname         = "dut"
		@@ts_wlan_nicname    = "wireless"
		@@ts_control_nicname = "control"
		@@ts_ipconf_all      = "all"
		#####################login ############################
		@@ts_default_ip      = "192.168.100.1"
		@@ts_default_dns     = @@ts_default_ip

		@@ts_dhcp_server_ip = "192.168.200.1"
		@@ts_tag_login_usr  = 'admuser'
		@@ts_tag_login_pw   = 'admpass'
		@@usr_text_id       = 'admuser'
		@@ts_tag_usr        = @@usr_text_id
		@@pw_text_id        = 'admpass'
		@@ts_tag_pw         = @@pw_text_id
		@@login_button      = '登录'
		@@ts_tag_login_btn  = @@login_button

		@@usr                      = "admin"
		@@ts_default_usr           = @@usr
		@@pw                       = "admin"
		@@ts_default_pw            = @@pw
		##########################net set#######################
		@@ts_tag_netset            = "set_network"
		@@ts_tag_netset_src        = "netset.asp"
		@@ts_tag_mode              = "apmode"

		######wan mode
		@@ts_wan_mode_dhcp         = "DHCP"
		@@ts_wan_mode_pppoe        = "PPPOE"
		@@ts_wan_mode_pptp         = "PPTP"
		@@ts_wan_mode_static       = "STATIC"
		@@ts_wan_mode_repeater     = "Repeater"
		@@ts_wan_mode_bridge       = "Bridge"
		@@ts_wan_mode_3g_4g        = "3G/4G"
		@@ts_tag_wired_mode_link   = "tab_ip"
		@@ts_tag_wired_mode_span   = "wire"
		@@ts_wireless_id           = "wireless"
		@@ts_tag_wired_dhcp        = "ip_type_dhcp"
		@@ts_tag_wired_pppoe       = "ip_type_pppoe"
		@@ts_tag_wired_static      = "ip_type_static"
		@@ts_tag_pppoe_usr         = "pppoeUser"
		@@ts_tag_pppoe_pw          = "input_password1"
		@@ts_tag_wired_static      = "ip_type_static"
		@@ts_tag_3g_mode_link      = "tab_3g"
		@@ts_tag_3g_mode_span      = "dial"
		@@ts_tag_3g_auto           = "3g_auto_type"
		@@ts_wired_static_id       = "wire-static"
		@@ts_wired_static_ip       = "staticIp"
		@@ts_wired_static_err      = "error_msg"
		@@ts_wired_static_err_text = "IP地址格式错误"
		@@ts_tag_wan_err           = "error_msg"
		######################## static ip  ############
		@@ts_tag_staticIp          = "staticIp"
		@@ts_tag_staticNetmask     = "staticNetmask"
		@@ts_tag_staticGateway     = "staticGateway"
		@@ts_tag_staticPriDns      = "staticPriDns"
		@@ts_tag_backupDns         = "backupDns"
		@@ts_pppoe_usr             = 'pppoe@@163.gd'
		@@ts_pppoe_pw              = 'PPPOETEST'
		@@ts_staticIp              = '10.10.10.223'
		@@ts_staticNetmask         = '255.255.255.0'
		@@ts_staticGateway         = '10.10.10.1'
		@@ts_staticPriDns          = '10.10.10.1'
		@@ts_staticBackupDns       = '8.8.8.8'
		########lan set ######
		@@ts_tag_lan               = "set_wifi"
		@@ts_tag_lan_src           = "lanset.asp"
		@@ts_tag_lanip             = "lan_ip"
		@@ts_tag_lanstart          = "dhcpStart"
		@@ts_tag_lanend            = "dhcpEnd"
		@@ts_tag_lanerr            = "error_msg"
		@@ts_lanip_err             = "DHCP地址格式有误"
		@@ts_default_leasetime     = "43200"
		@@ts_ssid_test_pre         = "ZhiluAuto"
		@@ts_tag_ssid              = "ssid"
		@@ts_tag_ssid_pwd          = "input_password1"
		@@ts_tag_sec_select_list   = "security_mode"
		@@ts_sec_mode_none         = 'None'
		@@ts_sec_mode_none_cn      = "无加密"
		@@ts_sec_mode_wpa          = 'WPA-PSK/WPA2-PSK'
		@@ts_tag_input_pw          = "input_password1"
		@@ts_wifi_flag             = "1"
		@@ts_tag_dhcp_lease        = "dhcpLease"

		@@ts_tag_systemver = "sysversion"
		@@ts_tag_sys_ver   = "系统版本"
		@@ts_tag_sys_vers  = /MAC\s*:\s*\w+/i

		@@ts_wan_mac_pattern1 = /([\d|a-f]{2}:[\d|a-f]{2}:[\d|a-f]{2}:[\d|a-f]{2}:[\d|a-f]{2}:[\d|a-f]{2})/i
		@@ts_lan_mask         = "255.255.255.0"
		@@ts_default_wlan_pw  = "12345678"

		@@ts_tag_net_reset_tip  = "aui_state_noTitle aui_state_focus aui_state_lock"
		@@ts_tag_net_reset      = "aui_content"
		@@ts_tag_net_reset_text = "设置成功！正在重启网络中，请稍等..."

		@@ts_tag_lan_reset      = "aui_content"
		@@ts_tag_lan_reset_text = "设置成功，请稍候...，如果网络断连，请重新连接。"

		@@ts_tag_reboot_confirm     = "aui_state_highlight"
		@@ts_tag_reboot_cancel      = "取消"
		@@ts_tag_rebooting          = "aui_content"
		@@ts_tag_rebooting_text     = "正在重启中，请稍后..."
		@@ts_tag_reset              = "aui_content"
		@@ts_tag_reset_text         = "恢复出厂将会清除当前所有配置， 确定要恢复出厂设置吗?"
		@@ts_tag_reseting_text      = "正在恢复出厂设置，请稍等..."
		@@ts_tag_pptp_set           = "设置成功"

		######reboot####
		@@ts_tag_del_ipfilter_btn   = "all_del"
		###system######
		@@ts_tag_account_manage     = "passwd.asp"
		@@ts_tag_modify_pw          = "system_config"
		@@ts_tag_aduser             = "admuser"
		@@ts_tag_adpass             = "admpass"
		@@ts_tag_adpass2            = "admpass2"
		@@ts_tag_modify_pw_error    = "error_msg"
		@@ts_tag_logout             = "logout"
		@@ts_tag_login_error        = "error_text"
		@@ts_tag_login_errinfo      = "用户名或密码错误"
		@@ts_tag_modify_pw_tip      = "修改密码成功！下次登录时请输入新密码。"
		################  ap  #################
		@@ts_tag_ap_url             = "192.168.50.1"
		@@ts_tag_ap_src             = "d_wizard_step1_start.asp"
		@@ts_tag_ap_save            = "save"
		@@ts_dut_ssid               = "WIRELESS-SSID"
		@@ts_channel                = "WIRELESS-CH"
		@@ts_pwdshow2               = "pwdshow2"
		@@ts_pwdshow                = "pwdshow"
		@@ts_ap_save_hint           = "loading"
		@@ts_ap_safe_option         = "methodSel"
		@@ts_ap_status              = "d_status.asp"
		@@ts_main_content           = "maincontent"
		@@ts_ap_setting             = "d_wizard_step1_start.asp"
		@@ts_ap_wireless            = "d_wlan_basic.asp"
		@@ts_wifi_advanced_setup    = "d_wladvanced.asp"
		@@ts_24G_wifi_switch        = "advWlanDisabled"
		@@ts_ap_login_btn           = "loginBtn"
		@@ts_ap_wireless_pattern    = "band"
		@@ts_ap_channel             = "chan"
		@@ts_ap_bandwidth           = "chanwid"
		@@ts_ap_safe_option         = "methodSel"
		@@ts_ap_save_hint           = "loading"
		@@ts_bridge_id              = "mode-bridge"
		@@ts_dut_wifi_ssid          = "wifi"
		@@ts_dut_wifi_ssid_pwd      = "skey1"
		@@ts_manual_step_name       = "wizardstep1_back"
		@@ts_ap_wan_type            = "wantype"
		@@ts_ap_ip_addr_static      = "staip_ipaddr"
		@@ts_ap_mask_static         = "staip_netmask"
		@@ts_ap_gateway_static      = "staip_gateway"
		@@ts_ap_dns1_static         = "wan_dns1"
		############### dut内网 ################
		@@ts_wifi_switch            = "wifiswitch"
		############### dut外网 ################
		@@ts_relay_id               = "mode-relay"
		@@ts_search_net             = "ssid_reflash"
		@@ts_ssid_list              = "ssid_list"
		@@ts_net_pwd                = "input_password3"

		############### dut状态 ################
		@@ts_wifi_status            = "WIRELESS-ONOFF"
		############### dut高级设置 ############
		@@ts_advance_setup          = "WIFI-Settings"
		@@ts_wifi_channel           = "sz11gChannel"
		@@ts_tag_import             = "aui_content"
		@@ts_tag_import_text        = "正在恢复配置文件，请稍候！"
		############### dut url ################
		@@ts_url_set                = "menu_set"
		@@ts_url_black              = "b_w_select"
		@@ts_web_url                = "b_w_url"
		@@ts_url_add                = "aui_content"
		@@ts_url_add_text           = "名单重复！！"
		@@ts_url_add_unusual_text   = "网址为空或格式错误"
		############### dut ip #################
		@@ts_ip_set                 = "IP-Filter"
		@@ts_ip_src                 = "fip"
		@@ts_ip_src_end             = "endip"
		@@ts_ip_err                 = "error_msg"
		@@ts_ip_src_err_text        = "源起始IP格式错误"
		@@ts_ip_dst                 = "gip"
		@@ts_ip_dst_end             = "gendip"
		@@ts_ip_dst_err_text        = "目的起始IP格式错误"
		@@ts_ip_start_time          = "starttime"
		@@ts_ip_end_time            = "endtime"
		@@ts_ip_start_time1         = "starttime1"
		@@ts_ip_end_time1           = "endtime1"
		@@ts_ip_time_err_text       = "时间格式错误"
		@@ts_ip_invalid             = "all_invalid"
		@@ts_ip_valid               = "all_valid"
		@@ts_ip_dst_port            = "gport"
		@@ts_ip_dst_port_end        = "gendport"
		@@ts_ip_dst_port1           = "gport1"
		@@ts_ip_dst_port_end1       = "gendport1"
		@@ts_ip_src_port            = "fport"
		@@ts_ip_src_port_end        = "endport"
		@@ts_ip_src_port1           = "fport1"
		@@ts_ip_src_port_end1       = "endport1"
		@@ts_iptable                = "iptable"
		############### dut 系统状态 ################
		@@ts_sys_status             = "systatus"
		@@ts_sys_status_src         = "systatus.asp"
		@@ts_pro_version_id         = "version"
		@@ts_software_version_id    = "software-version"
		@@ts_terminal_num_id        = "terminal-num"
		@@ts_upload                 = "aui_content"
		@@ts_upload_text            = "很抱歉，请重新选择升级包再执行升级操作！"
		@@ts_upload_same_text       = "您上传的版本包与系统当前版本相同，确认升级？"
		@@ts_upload_big_text        = "很抱歉，系统检测内存空间不足，请尝试重启后再执行升级操作！"
		############## dut 定时 #####################
		@@ts_btn_id                 = "switch"
		@@ts_timing_strategy        = "strategy"
		@@ts_taday_id               = "laydate_today"
		@@ts_time_classname         = "laydate_sj"
		@@ts_time_minute            = "laydate_hmsno"
		@@ts_time_ok                = "laydate_ok"
		@@ts_rebot_btn              = "baocun"
		@@ts_rebot_time             = "reboottime"

		################ 设备连接列表 #############
		@@ts_tag_customtag          = "zl"
		@@ts_tag_custom_id          = "terminalnum2"
		@@ts_tag_devices_iframe_src = "dhcpclient.asp"
		@@ts_device_list_id         = "device_list"
		@@ts_device_list_cls_name   = "routers-table"

		################# option tags #########################
		@@ts_tag_options            = "options"
		@@ts_tag_advance_src        = "advance.asp"
		@@ts_tag_filename           = "filename"
		@@ts_tag_inport_btn         = "update_submit_btn"
		#reboot
		@@ts_tag_op_reboot          = "reboot_submit_btn"
		@@ts_tag_op_reboot_tab      = "reboot-titile"
		@@ts_tag_op_system          = "syssetting"
		@@ts_tag_plan_task          = "plantask-titile"
		@@ts_select_time_id         = "date_first"
		@@ts_select_time_name       = "starttime"
		@@ts_today_id               = "laydate_today"
		@@ts_tag_select_state       = "selected"
		@@ts_tag_recover            = "reset-titile"
		@@ts_tag_reset_factory      = "reset_submit_btn"
		@@ts_tag_export             = "setmanExpSetExport"
		@@ts_default_config_name    = "RT2880_Settings.dat"
		@@ts_tag_syslog             = "syslog-titile"
		@@ts_tag_liclass            = "active"
		@@ts_tag_logclear           = "syslogSysLogClear"
		@@ts_tag_log_textarea       = "syslog"
		@@ts_update                 = "update-titile"
		@@ts_update_brower          = "brower"
		@@ts_update_filename        = "filename"
		@@ts_upload_directory       = "E:/autotest/frame/uploads"
		@@ts_tag_update_btn         = "update_submit_btn"
		@@ts_reset_default_fname    = "filename"
		@@ts_tag_domain             = "device"
		@@ts_tag_domain_field       = "domain"
		@@ts_tag_domain_err         = "error_msg"
		@@ts_tag_virsrvip_err       = "error_msg"
		######文件共享
		@@ts_tag_fileshare          = "USB-titile"
		@@ts_tag_filebtn_off        = "off"
		@@ts_tag_filebtn_on         = "on"
		@@ts_file_share_dir         = "Folder_structure.asp"
		@@ts_storage_usb            = "U盘"
		@@ts_storage_sd             = "SD卡"
		@@ts_tag_disshare           = "disshare"
		@@ts_tag_close_share        = "关闭共享"
		@@ts_tag_return             = "return"
		@@ts_tag_back               = "返回上一级"
		#######应用设置
		####dmz
		@@ts_tag_application        = "aplicationsetting"
		@@ts_tag_dmz                = "dmzSetting"
		@@ts_tag_dmzsw              = "switch"
		@@ts_tag_dmzip              = "dwz_ip"
		@@ts_tag_dmzsw_on           = "on"
		@@ts_tag_dmzsw_off          = "off"
		@@ts_conn_state             = "succeed"
		@@ts_wan_client_ip          = "10.10.10.57"
		# @@ts_wan_client_uport      = rand_port
		@@ts_wan_pppoe_httpip       = "192.168.0.57"
		@@ts_wan_pppoe_httpport     = 80
		@@ts_tag_ddns               = "ddnsSetting"
		@@ts_tag_ddns_sw            = "switch"
		@@ts_tag_ddns_host          = "host"
		@@ts_tag_ddns_user          = "user"
		@@ts_tag_ddns_pwd           = "pwd"
		@@ts_tag_ddns_save          = "savebtn"
		#####虚拟服务器
		@@ts_tag_virtualsrv_sw      = "switch"
		@@ts_tag_virtualsrv         = "virtualServer"
		@@ts_tag_virsw_on           = "on"
		@@ts_tag_virsw_off          = "off"
		@@ts_tag_addvir             = "add_btn"
		@@ts_tag_virip1             = "ip0"
		@@ts_tag_virpub_port1       = "port0"
		@@ts_tag_virpri_port1       = "port1"
		@@ts_tag_virip2             = "ip1"
		@@ts_tag_virpub_port2       = "port2"
		@@ts_tag_virpri_port2       = "port3"
		@@ts_tag_virip3             = "ip2"
		@@ts_tag_virpub_port3       = "port4"
		@@ts_tag_virpri_port3       = "port5"
		@@ts_tag_virip4             = "ip3"
		@@ts_tag_virpub_port4       = "port6"
		@@ts_tag_virpri_port4       = "port7"
		@@ts_tag_virip5             = "ip4"
		@@ts_tag_virpub_port5       = "port8"
		@@ts_tag_virpri_port5       = "port9"
		@@ts_tag_virip6             = "ip5"
		@@ts_tag_virpub_port6       = "port10"
		@@ts_tag_virpri_port6       = "port11"
		@@ts_tag_vir_protocol       = "protocol1"
		@@ts_tag_vir_status         = "status1"
		@@ts_tag_vir_protocol1      = "protocol"
		@@ts_tag_vir_status1        = "status"
		@@ts_tag_delvir             = "delete_btn"
		@@ts_tag_save_btn           = "take_effect_btn"
		#####防火墙
		@@ts_tag_security           = "securitysetting"
		@@ts_tag_fwset              = "Firewall-Settings"
		@@ts_tag_security_sw        = "switch1"
		@@ts_tag_security_url       = "switch4"
		@@ts_tag_security_mac       = "switch3"
		@@ts_tag_security_ip        = "switch2"
		@@ts_tag_security_save      = "save_btn"
		@@ts_tag_macfilter          = "MAC-Filter"
		@@ts_tag_fwstatus           = "firewall"
		@@ts_tag_fwmac              = "macgl"
		@@ts_tag_fw_open            = "开启"
		@@ts_tag_fw_close           = "关闭"
		@@ts_tag_additem            = "additem"
		@@ts_tag_alladd             = "alladd"
		@@ts_tag_allcancel          = "allcancle"
		@@ts_tag_alldel             = "alldel"
		@@ts_tag_fwmac_mac          = "mac"
		@@ts_tag_fwmac_desc         = "desc"
		@@ts_tag_fw_select          = "status"
		@@ts_tag_fwmac_mac1         = "mac1"
		@@ts_tag_fwmac_desc1        = "desc1"
		@@ts_tag_fw_select1         = "status1"
		@@ts_tag_save_filter        = "save_btniptb"
		@@ts_tag_save_filter1       = "save_btniptb1"
		@@ts_tag_filter_use         = "生效"
		@@ts_tag_filter_nouse       = "失效"
		@@ts_tag_mac_table          = "macguolv"
		@@ts_tag_del                = "del"
		@@ts_tag_edit               = "edit"
		@@ts_tag_ip_back            = "back_ip"
		####remote web access
		@@ts_tag_op_remote          = "webtoroute"
		@@ts_remote_default_port    = "9000"
		@@ts_remote_sw              = "on-off"
		@@ts_remote_port_id         = "port"
		@@ts_remote_port_name       = "port"
		@@ts_remote_save_btn        = "submit_btn"
		####close option iframe
		@@ts_tag_file_div           = "aui_state_lock aui_state_focus"
		@@ts_tag_style_zindex       = "z-index"
		####networking pptp
		@@ts_tag_op_network         = "networksetting"
		@@ts_tag_op_pptp            = "PPTP-Settings"
		@@ts_tag_pptp_server        = "lanIp"
		@@ts_tag_pptp_usr           = "username"
		@@ts_tag_pptp_pw            = "psd"
		@@ts_pptp_server_ip         = "10.10.10.1"
		@@ts_pptp_usr               = "pptp"
		@@ts_pptp_pw                = "pptp"
		@@ts_pptp_pap_set           = "interface pptp-server server set authentication=pap"
		@@ts_pptp_chap_set          = "interface pptp-server server set authentication=chap"
		@@ts_pptp_mschap1_set       = "interface pptp-server server set authentication=mschap1"
		@@ts_pptp_mschap2_set       = "interface pptp-server server set authentication=mschap2"
		@@ts_pptp_default_set       = "interface pptp-server server set authentication=pap,chap,mschap1,mschap2"
		@@pptp_pri                  = "interface pptp-server server print"
		####bandwidth
		@@ts_tag_bandwidth          = "traffic-titile"
		@@ts_tag_traffic            = "traffic-contol"
		@@ts_tag_bandsw             = "wideband_limiter"
		@@ts_tag_wideband           = "wideband_size"
		@@ts_tag_range_min          = "ip_range_min_0"
		@@ts_tag_range_max          = "ip_range_max_0"
		@@ts_tag_band_mode          = "wideband_mode_0"

		@@ts_tag_range_min2 = "ip_range_min_1"
		@@ts_tag_range_max2 = "ip_range_max_1"
		@@ts_tag_band_mode2 = "wideband_mode_1"

		@@ts_tag_range_min3 = "ip_range_min_2"
		@@ts_tag_range_max3 = "ip_range_max_2"
		@@ts_tag_band_mode3 = "wideband_mode_2"

		@@ts_tag_range_min4 = "ip_range_min_3"
		@@ts_tag_range_max4 = "ip_range_max_3"
		@@ts_tag_band_mode4 = "wideband_mode_3"

		@@ts_tag_range_min5        = "ip_range_min_4"
		@@ts_tag_range_max5        = "ip_range_max_4"
		@@ts_tag_band_mode5        = "wideband_mode_4"
		@@ts_tag_bandlimit         = "受限最大带宽"
		@@ts_tag_bandensure        = "保障最小带宽"
		@@ts_tag_band_size         = "wideband_size_0"
		@@ts_tag_client_bandsw     = "on_off_net_0"
		@@ts_tag_band_size2        = "wideband_size_1"
		@@ts_tag_client_bandsw2    = "on_off_net_1"
		@@ts_tag_band_size3        = "wideband_size_2"
		@@ts_tag_client_bandsw3    = "on_off_net_2"
		@@ts_tag_band_size4        = "wideband_size_3"
		@@ts_tag_client_bandsw4    = "on_off_net_3"
		@@ts_tag_band_size5        = "wideband_size_4"
		@@ts_tag_client_bandsw5    = "on_off_net_4"
		@@ts_tag_band_tb           = "table_box"
		@@ts_tag_band_err          = "error_msg"
		######################status Tags#############################################
		@@tag_status_iframe_src    = "setstatus.asp"
		@@ts_tag_status_iframe_src = @@tag_status_iframe_src
		@@ts_tag_status            = "setstatus"
		@@ts_tag_lan_ip            = "LAN-IP"
		@@tag_wan_ip               = "WAN-IP"
		@@ts_tag_wan_ip            = @@tag_wan_ip
		@@tag_wan_type             = "WAN-CONTYPE"
		@@ts_tag_wan_type          = @@tag_wan_type
		@@tag_wan_dns              = "WAN-DNS"
		@@ts_tag_wan_dns           = @@tag_wan_dns
		@@tag_wan_mask             = "WAN-NETMASK"
		@@ts_tag_wan_mask          = @@tag_wan_mask
		@@tag_wan_gw               = "WAN-GATEWAY"
		@@ts_tag_wan_gw            = @@tag_wan_gw
		@@ts_tag_lan_mac           = "LAN-MAC"

		@@ip_regxp        =/(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})/
		@@ts_tag_ip_regxp = @@ip_regxp

		@@ts_tag_sbm            = "submit_btn"
		@@ts_tag_reboot         = "reboottxt"
		######### DRB #####################
		@@ts_drb_server2        = "druby://50.50.50.57:8787" #for dhcp server
		@@ts_tcp_server         = "192.168.0.57"
		@@ts_tcp_port_dhcp      = "16801"
		@@ts_server_ip          = "10.10.10.1"
		###########新版本3/4状态与原来版本差异很大 3/4G ################
		# 3G/4G拨号状态
		@@ts_tag_diag_status    = "dial-status"
		@@ts_tag_diag_text      = "3G/4G拨号状态"
		# SIM卡状态
		@@ts_tag_sim            = "sim"
		@@ts_tag_sim_status     = "sim_status"
		@@ts_tag_img_normal     = "images/d.png"
		# 信号强度29
		@@ts_tag_signal         = "xinhao"
		@@ts_tag_signal_strenth = "wifi-signal"
		@@ts_tag_signal_normal  = "images/5.png"
		# 注册状态
		@@ts_tag_reg            = "reg"
		@@ts_tag_reg_status     = "register-status"
		# 联网状态
		@@ts_tag_3g_net         = "lianwang"
		@@ts_tag_3g_net_status  = "net_status"
		# 网络类型4G
		@@ts_tag_3g_nettype     = "nettype"
		@@ts_tag_3g_net_type    = "net_type"
		@@ts_tag_4g_nettype_text= "4G"
		# 运营商名称CHINA MOBILE
		@@ts_tag_3g_isp         = "yiname"
		@@ts_tag_3g_ispname     = "net_name"
		@@ts_tag_3g_ispname_text= "CHINA MOBILE"
		#################################diagnose tags#######################
		@@ts_tag_diagnose       = "net_detect"
		@@ts_tag_ad_diagnose    = "advanced-diagnosis"
		@@ts_tag_url            = "url"
		@@ts_tag_diag_btn       = "btnDet"

		@@ts_tag_diag_detect       = "route-detect"
		@@ts_tag_diag_detecting    = "路由器正在检测中……"
		@@ts_tag_diag_fini_fail    = "诊断完成：网络很差。"
		@@ts_tag_diag_fini_fail2   = "诊断完成：网络一般。"
		@@ts_tag_diag_ad_detecting = "努力诊断中，大概需要2分钟，请耐心等待..."
		@@ts_tag_diag_fini_success = "恭喜，没有检测出问题。"
		@@ts_tag_diag_success      = "正常"
		@@ts_tag_diag_fail         = "异常"

		@@ts_tag_diag_3gdial        = "3gdial"
		@@tc_tag_diag_3gdial_text   = "3G拨号状态"
		@@ts_tag_diag_3gdial_status = "checking"
		@@ts_tag_diag_3g_errinfo    = "检测到你未接入3G模块，可以尝试通过3G模块上网[暂不支持该功能]"

		@@ts_tag_diag_wan                 = "network-conn"
		@@ts_tag_diag_wan_text            = "WAN口连接状态"
		@@ts_tag_diag_wan_status          = "checking1"
		@@ts_tag_wan_class                = "detail"
		@@ts_tag_diag_wan_err             = /\s*外网连接不成功，\s*请检查外网连接类型是否正确，\s*进入【外网设置->网线连接】重新进行设置\s*/
		# @@ts_tag_diag_wan_err    = "外网连接不成功 ， 请检查外网连接类型是否正确 ， 进入 【 外网设置->网线连接 】 重新进行设置"

		@@ts_tag_diag_internet            = "wlan-conn"
		@@ts_tag_diag_internet_text       = "外网连接状态"
		@@ts_tag_diag_internet_status     = "checking2"
		@@ts_tag_diag_internet_err        = "拨号连接不成功，请检查上网账号密码是否正确， 进入【外网设置->网线连接->宽带拨号】重新进行设置"
		@@ts_tag_diag_internet_static_err = "外网连接不成功，请检查外网连接类型是否正确， 进入【外网设置->网线连接】重新进行设置"
		@@ts_tag_diag_hardware            = "hardware-status"
		@@ts_tag_diag_hardware_text       = "路由硬件状态"
		@@ts_tag_diag_hardware_status     = "checking3"

		@@ts_tag_diag_netspeed        = "network-speed"
		@@ts_tag_diag_netspeed_text   = "连接速度状态"
		@@ts_tag_diag_netspeed_status = "checking4"
		@@ts_tag_diag_netspeed_err1   = "默认网关丢包率100%,网络质量较差，建议换根网线试试"
		@@ts_tag_diag_netspeed_err2   = "域名解析失败，建议重启路由器试试"
		@@ts_tag_diag_netspeed_err3   = "端口连通失败，建议重启路由器试试"

		@@ts_tag_diag_cpu       = "cpu"
		@@ts_tag_diag_cpu_text  = "处理器信息"
		@@ts_tag_diag_cpu_xpath = "/html/body/div[2]/div[6]/div[2]"
		@@ts_tag_cpu_type_reg   = /处理器类型：.+/im
		@@ts_tag_cpu_name_reg   = /处理器型号：.+/im
		@@ts_tag_cpu_load_reg   = /系统负载：\d+\.\d+/im

		@@ts_tag_diag_mem       = "ram"
		@@ts_tag_diag_mem_text  = "内存信息"
		@@ts_tag_diag_mem_xpath = "/html/body/div[2]/div[7]/div[2]"
		@@ts_tag_mem_total_reg  = /内存总量\s*：\s*[1-9]+\d*\s*M/m
		@@ts_tag_mem_useful_reg = /可用内存\s*：\s*[1-9]+\d*\s*M/m
		@@ts_tag_mem_cache_reg  = /缓存内存\s*：\s*[1-9]+\d*\s*M/m

		# Wanprotocal （上网连接类型）：DHCP
		@@ts_tag_diag_nettype   = "Wanprotocal （上网连接类型）："
		# Wanlink （Wan连接状态）：正常
		@@ts_tag_net_status     = "Wanlink （Wan连接状态）："
		# IP （域名解析到的IP地址）：180.97.33.108
		@@ts_tag_domain_ip      = "IP （域名解析到的IP地址）："
		@@ts_domina_ip_fail     = "失败"
		# GW （连接默认网关的丢包率）：0%
		@@ts_tag_loss           = "GW （连接默认网关的丢包率）："
		# DNS （解析域名）：成功
		@@ts_tag_dns            = "DNS （解析域名）："
		# HTTP （域名状态码）：200
		@@ts_tag_http_status    = "HTTP （域名状态码）："

		@@ts_net_link         = "正常"
		@@ts_net_link_fail    = "失败"
		@@ts_ip_reg           = /[1-9]\d{0,2}\.\d{1,3}\.\d{1,3}\.[1-9]\d{0,2}/
		@@ts_loss_rate        = "0%"
		@@ts_loss_rate_all    = "100%"
		@@ts_dns_status       = "成功"
		@@ts_dns_status_fail  = "失败"
		@@ts_http_status      = "200"
		@@ts_http_status_fail = "404"
		################### mac clone ######################
		@@ts_tag_clone_mac    = "MAC-Clone"
		@@ts_tag_clone_sw     = "switch"
		@@ts_tag_fillmac      = "fillmac"
		@@ts_tag_pcmac        = "pc_mac"
		@@ts_tag_errormsg     = "error_msg"
		@@ts_cap_timeout      = 15
		@@ts_server_lannic    = "LAN"
		@@ts_cap_packetpath   = "D:/captures"
		FileUtils.mkdir_p(@@ts_cap_packetpath) unless File.exists?(@@ts_cap_packetpath)
		@@ts_tag_btn_off  = "off"
		@@ts_tag_btn_on   = "on"
		############################### other ####################################
		##ftp
		@@ts_ftp_usr      = "admin"
		@@ts_ftp_pw       = "admin"
		@@ts_ftp_srv_file = "QOS_TEST2.zip" #ftp下载文件名
		@@ts_ftp_download = "D:/ftpdownloads/#{@@ts_ftp_srv_file}"
		@@ts_ftp_block    = 32768
		#100Mbpbs换算成bps
		@@ts_band_100     = 104857600
		@@web             = "www.baidu.com"
		@@ts_web          = @@web
		@@ts_diag_web     = "http://www.baidu.com"
		@@ts_diag_web2    = "http://www.qq.com"

		@@ts_close_div             = "var list = art.dialog.list;for (var i in list) {list[i].close();}" #ArtDialog script
		@@ts_aui_state             = "aui_state_focus aui_state_lock"
		@@ts_aui_state_focus       = "aui_state_lock aui_state_focus"
		@@ts_aui_state_full        = "aui_content aui_state_full"
		@@ts_browser_ff            = :ff
		@@ts_ff_profile            = "default"
		###############router os#############
		@@ts_routeros_ip           = "10.10.10.1"
		@@ts_pppoe_default_set     = "interface pppoe-server server set authentication=pap,chap,mschap1,mschap2 0"
		@@ts_pppoe_pap_set         = "interface pppoe-server server set authentication=pap 0"
		@@ts_pppoe_chap_set        = "interface pppoe-server server set authentication=chap 0"
		@@ts_pppoe_mschap1_set     = "interface pppoe-server server set authentication=mschap1 0"
		@@ts_pppoe_mschap2_set     = "interface pppoe-server server set authentication=mschap2 0"
		@@ts_pppoe_srv_pri         = "interface pppoe-server server print"

		############### 2016/01/04###################
		@@ts_tag_wlan_link         = "tab_sta"
		@@ts_tag_repeater_radio    = "imodel_type_zj"
		@@ts_tag_bridge_radio      = "imodel_type_qj"
		@@ts_tag_ap_ssid           = "ssid"
		@@ts_tag_ap_aes            = "WPA-PSK/WPA2-PSK AES"
		@@ts_ap_pw                 = "zhilutest"
		@@ts_tag_ap_pw             = "pskValue"
		@@ts_nicname_three         = "three"
		################### 2016/01/07 llp ###########
		@@ts_tag_ap_ssid_name      = "ssid"
		@@ts_tag_ap_ssid_pwd       = "pskValue"
		@@ts_unified_platform_user = "root"
		@@ts_unified_platform_pwd  = "zl4321"
		@@ts_tag_refresh_btn       = "refresh-btn"
		@@ts_tag_ip_filter_state   = "ipgl"
		@@ts_tag_export_name       = "ExportSet"
		@@ts_tag_wan_mac           = "WAN-MAC"
		@@ts_tag_wifi              = "setstatus"

		@@ts_tag_lanmask    = "lanNetmask"
		@@ts_tag_sysprotype = "product-mode"
		@@ts_tag_sysruntime = "running-time"
		@@ts_tag_sysprover  ="version"
		@@ts_tag_syspromac  ="product-mac"
		@@ts_tag_systerminal="terminal-num"

		@@ts_tag_syssoftver = "software-version"
		@@ts_tag_syshardver = "hardware-version"

		@@ts_tag_syssimstatus = "sim"
		@@ts_tag_syssignal    = "xinhao"

		@@ts_tag_sysreg       = "reg"
		@@ts_tag_sysconnstatus="lianwang"
		@@ts_tag_sysconntype  = "nettype"
		@@ts_tag_sysispname   = "yiname"

		@@ts_tag_syswan     = "link_type_wan"
		@@ts_tag_syswanmac  = "WAN-MAC"
		@@ts_tag_syswanip   ="WAN-IP"
		@@ts_tag_syswanmask = "WAN-NETMASK"
		@@ts_tag_syswangw   = "WAN-GATEWAY"
		@@ts_tag_syswandns  = "WAN-DNS"

		@@ts_tag_syslanmac = "LAN-MAC"
		@@ts_tag_syslanip  = "LAN-IP"
		@@ts_tag_syslanmask="LAN-NETMASK"

		@@ts_tag_syswifistatus     = "WIRELESS-status"
		@@ts_tag_syswifisw         = "wifiswitch"
		@@ts_tag_syswifisw_status  = "WIRELESS-ONOFF"
		@@ts_tag_sys_ssid          = "WIRELESS-SSID"
		@@ts_tag_syschanel         ="WIRELESS-CH"
		@@ts_tag_sysencry          = "WIRELESS-ENCRY"
		@@ts_tag_wifitable         = "table"
		@@ts_tag_routermode        ="modeselect.asp"
		@@ts_tag_apmode            ="imodel_type_ap"
		@@ts_tag_routermode        = "imodel_type_rt"
		@@ts_tag_showpwd           = "pwdshow_skey"
		@@ts_tag_3g_hand_type      = "3g_hand_type"
		@@ts_tag_cancel            = "close_box"
		@@ts_wire_mode_tab_cls_name= "radio_network_type selected"
		@@ts_tag_3g_handtype_apn   = "APN3G"
		@@ts_tag_3g_handtype_pin   = "PIN3G"
		@@ts_tag_3g_handtype_num   = "Dial3G"
		@@ts_tag_3g_handtype_user  = "User3G"
		@@ts_tag_3g_handtype_pwd   = "Password3G"
		@@ts_tag_wifiset="setwifi.asp"
		@@ts_tag_radio_ssid="SSID_settings"
		@@ts_tag_radio_frequancy ="ip_type_b_2g"
		@@ts_tag_wifi_ssid1 = "2g_ssid_name0"
		@@ts_tag_wifi_ssid2 = "2g_ssid_name1"
		@@ts_tag_wifi_ssid3 = "2g_ssid_name2"
		@@ts_tag_wifi_ssid4 = "2g_ssid_name3"
		@@ts_tag_wifi_pw1="2g_passwd_data0"
		@@ts_tag_wifi_pw2="2g_passwd_data1"
				@@ts_tag_wifi_pw3="2g_passwd_data2"
					@@ts_tag_wifi_pw4="2g_passwd_data3"
					@@ts_tag_wifi_linknum1="2g_max_link0"
						@@ts_tag_wifi_linknum2="2g_max_link1"
					@@ts_tag_wifi_linknum3="2g_max_link2"
			@@ts_tag_wifi_linknum4="2g_max_link3"
	
end
# end