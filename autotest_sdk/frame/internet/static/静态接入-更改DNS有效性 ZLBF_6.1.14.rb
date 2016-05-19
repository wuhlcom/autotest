#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:18
# modify:
#
testcase {
		attr = {"id" => "ZLBF_6.1.14", "level" => "P2", "auto" => "n"}

		def prepare
				DRb.start_service
				@tc_server_obj            = DRbObject.new_with_uri(@ts_drb_server2)
				@tc_staticBackupDns       = "202.96.128.86"
				@tc_error_staticBackupDns = "192.168.168.1"

				@tc_staticPriDns       = "202.96.134.133"
				@tc_error_staticPriDns = "192.168.168.2"
				@tc_wait_time          = 2
				@tc_cap_time           = 20
				@tc_net_time           = 50
				@tc_domain             = "www.baidu.com"
				@tc_cap_fields         = "-e frame.number -e eth.dst -e eth.src -e ip.src -e ip.dst -e dns.qry.name"
		end

		def process

				operate("1、登录DUT设置页面，在BAS开启抓包；") {
						@browser.span(:id => @ts_tag_netset).click
						@wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
						assert(@wan_iframe.exists?, '打开外网设置失败！')

						rs1=@wan_iframe.link(:id => @ts_tag_wired_mode_link).class_name
						unless rs1 =~/#{@ts_tag_select_state}/
								@wan_iframe.span(:id => @ts_tag_wired_mode_span).click
						end
						static_radio = @wan_iframe.radio(:id => @ts_tag_wired_static)
						static_radio.click
						sleep @tc_wait_time
				}

				operate("2、手动设置静态IP方式接入，如输入IP地址：192.168.25.111，子网掩码：255.255.255.0，网关：192.168.25.9，设置DNS为外网有效的DNS地址，如：202.96.134.133，保存；运行状态及设置页面显示的DNS信息显示是否正常；") {
						puts "输入主DNS为#{@tc_staticPriDns}".encode("GBK")
						@wan_iframe.text_field(:id, @ts_tag_staticIp).set(@ts_staticIp)
						@wan_iframe.text_field(:id, @ts_tag_staticNetmask).set(@ts_staticNetmask)
						@wan_iframe.text_field(:id, @ts_tag_staticGateway).set(@ts_staticGateway)
						puts "set main DNS #{@tc_staticPriDns}"
						@wan_iframe.text_field(:id, @ts_tag_staticPriDns).set(@tc_staticPriDns)
						#次DNS输入一个无效的DNS服务
						if @wan_iframe.text_field(:id, @ts_tag_backupDns).exists?
								puts "set backup DNS #{@tc_error_staticBackupDns}"
								@wan_iframe.text_field(:id, @ts_tag_backupDns).set(@tc_error_staticBackupDns)
						end
						@wan_iframe.button(:id, @ts_tag_sbm).click
						sleep @tc_net_time
				}

				operate("3、LAN PC上在DOS下输入:ipconfig/flushdns，清除PC的DNS缓存,执行ping www.sohu.com，在BAS抓包确认，DUT是否以202.96.134.133发送出DNS请求；") {
						@tc_main_filter = "dns && ip.dst==#{@tc_staticPriDns}"
						@tc_main_args   ={nic: @ts_server_lannic, filter: @tc_main_filter, duration: @tc_cap_time, fields: @tc_cap_fields}
						puts "Capture filter: #{@tc_main_filter}"
						capture_rs = []
						begin
								thr = Thread.new do
										capture_rs = @tc_server_obj.tshark_display_filter_fields(@tc_main_args)
								end
								ipconfig_flushdns
								rs = ping(@tc_domain)
								thr.join if thr.alive?
						rescue => ex
								p ex.messge.to_s
								assert(false, "Capture DNS Packets ERROR")
						end
						assert(rs, "无法连接外网")
						#如果capture_rs不为空说明抓到了报文
						puts "Capture Result: #{capture_rs}"
						refute(capture_rs.empty?, "未抓到DNS报文")
				}

				operate("4、在步骤2中更改DNS为：202.96.134.134，重复步骤3，查看测试结果；") {
						#输入无效主DNS无效
						puts "set main DNS #{@tc_error_staticPriDns}"
						@wan_iframe.text_field(:id, @ts_tag_staticPriDns).set(@tc_error_staticPriDns)
						@wan_iframe.button(:id, @ts_tag_sbm).click
						sleep @tc_net_time

						@tc_main_err_filter = "dns && ip.dst==#{@tc_error_staticPriDns}"
						@tc_main_err_args   ={nic: @ts_server_lannic, filter: @tc_main_err_filter, duration: @tc_cap_time, fields: @tc_cap_fields}
						puts "Capture filter: #{@tc_main_err_filter}"
						capture_rs = []
						begin
								thr = Thread.new do
										capture_rs = @tc_server_obj.tshark_display_filter_fields(@tc_main_err_args)
								end
								ipconfig_flushdns
								rs = ping(@tc_domain)
								thr.join if thr.alive?
						rescue => ex
								p ex.messge.to_s
								assert(false, "Capture DNS Packets ERROR")
						end
						#DNS错误情况下应该ping不通
						refute(rs, "错误的DNS也能连接外网")
						#DNS虽然是错误的，但仍发送DNS query给错误的DNS地址，如果capture_rs不为空说明抓到了报文
						puts "Capture Result:#{capture_rs}"
						refute(capture_rs.empty?, "未抓到DNS报文")
				}

				operate("5、反复更改DNS三次以上，查看测试结果。") {
						#重新输入正确的DNS
						@wan_iframe.text_field(:id, @ts_tag_staticPriDns).set(@tc_staticPriDns)
						@wan_iframe.button(:id, @ts_tag_sbm).click
						sleep @tc_net_time
						puts "Capture filter: #{@tc_main_filter}"
						capture_rs = []
						begin
								thr = Thread.new do
										capture_rs = @tc_server_obj.tshark_display_filter_fields(@tc_main_args)
								end
								ipconfig_flushdns
								rs = ping(@tc_domain)
								thr.join if thr.alive?
						rescue => ex
								p ex.messge.to_s
								assert(false, "Capture DNS Packets ERROR")
						end
						assert(rs, "无法连接外网")
						#如果capture_rs不为空说明抓到了报文
						puts "Capture Result:#{capture_rs}"
						refute(capture_rs.empty?, "未抓到DNS报文")

						#主DNS重新输入错误的DNS
						puts "set main DNS #{@tc_error_staticPriDns}"
						@wan_iframe.text_field(:id, @ts_tag_staticPriDns).set(@tc_error_staticPriDns)
						@wan_iframe.button(:id, @ts_tag_sbm).click
						sleep @tc_net_time
						puts "Capture filter: #{@tc_main_err_filter}"
						capture_rs = []
						begin
								thr = Thread.new do
										capture_rs = @tc_server_obj.tshark_display_filter_fields(@tc_main_err_args)
								end
								ipconfig_flushdns
								rs = ping(@tc_domain)
								thr.join if thr.alive?
						rescue => ex
								p ex.messge.to_s
								assert(false, "Capture DNS Packets ERROR")
						end
						#DNS错误情况下应该ping不通
						refute(rs, "错误的DNS也能连接外网")
						#DNS虽然是错误的，但仍发送DNS query给错误的DNS地址，如果capture_rs不为空说明抓到了报文
						puts "Capture Result:#{capture_rs}"
						refute(capture_rs.empty?, "未抓到DNS报文")

						#测试次DNS
						if @wan_iframe.text_field(:id, @ts_tag_backupDns).exists?
								puts "测试备用DNS".encode("GBK")
								puts "set backup dns #{@tc_staticBackupDns}"
								@wan_iframe.text_field(:id, @ts_tag_backupDns).set(@tc_staticBackupDns)
								@wan_iframe.button(:id, @ts_tag_sbm).click
								sleep @tc_net_time

								tc_backup_filter = "dns && ip.dst==#{@tc_staticBackupDns}"
								tc_backup_args   ={nic: @ts_server_lannic, filter: tc_backup_filter, duration: @tc_cap_time, fields: @tc_cap_fields}
								puts "Capture filter: #{tc_backup_filter}"
								capture_rs = []
								begin
										thr = Thread.new do
												capture_rs = @tc_server_obj.tshark_display_filter_fields(tc_backup_args)
										end
										ipconfig_flushdns
										rs = ping(@tc_domain)
										thr.join if thr.alive?
								rescue => ex
										p ex.messge.to_s
										assert(false, "Capture DNS Packets ERROR")
								end
								#备用DNS如果生效应该能ping通外网
								assert(rs, "不能连接外网")
								#如果capture_rs不为空说明抓到了报文
								puts "Capture Result:#{capture_rs}"
								refute(capture_rs.empty?, "未抓到DNS报文")
						end

				}


		end

		def clearup

				operate("恢复默认DHCP接入") {
						if !@wan_iframe.exists? && @browser.span(:id => @ts_tag_netset).exists?
								@browser.span(:id => @ts_tag_netset).click
								@wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
						end

						unless @browser.span(:id => @ts_tag_netset).exists?
								login_recover(@browser, @ts_default_ip)
								@browser.span(:id => @ts_tag_netset).click
								@wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
						end

						flag = false
						#设置wan连接方式为网线连接
						rs1  = @wan_iframe.link(:id => @ts_tag_wired_mode_link)
						unless rs1.class_name =~/#{@ts_tag_select_state}/
								@wan_iframe.span(:id => @ts_tag_wired_mode_span).click
								flag = true
						end

						#查询是否为为dhcp模式
						dhcp_radio       = @wan_iframe.radio(id: @ts_tag_wired_dhcp)
						dhcp_radio_state = dhcp_radio.checked?
						#设置WIRE WAN为DHCP模式
						unless dhcp_radio_state
								dhcp_radio.click
								flag = true
						end

						if flag
								@wan_iframe.button(:id, @ts_tag_sbm).click
								puts "Waiting for net reset..."
								sleep @tc_net_time
						end
				}
		end

}
