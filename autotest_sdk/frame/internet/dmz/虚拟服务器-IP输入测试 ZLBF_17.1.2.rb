#
# description:
# bug:虚拟服务器能输入与LAN相的IP地址
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
testcase {
		attr = {"id" => "ZLBF_17.1.2", "level" => "P4", "auto" => "n"}

		def prepare
				@tc_wait_time       = 2
				@tc_pub_tcp_port    = 5869
				@tc_vir_tcpsrv_port = 80
				@tc_ip_error_tip    = "IP地址格式错误"
		end

		def process

				operate("1、在“IP地址”输入全0，全1，或0开头地址或0结尾地址，如：0.0.0.0，255.255.255.255，0.0.0.1，192.0.0.0是否允许输入；") {
						@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
						@browser.link(id: @ts_tag_options).click
						@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
						assert(@advance_iframe.exists?, "打开高级设置失败")
						#选择‘应用设置’
						application      = @advance_iframe.link(id: @ts_tag_application)
						application_name = application.class_name
						unless application_name == @ts_tag_select_state
								application.click
								sleep @tc_wait_time
						end
						#选择“虚拟服务器”标签
						virtualsrv       = @advance_iframe.link(id: @ts_tag_virtualsrv)
						virtualsrv_state = virtualsrv.parent.class_name
						virtualsrv.click unless virtualsrv_state==@ts_tag_liclass
						sleep @tc_wait_time
						#打开虚拟服务器开关
						@advance_iframe.button(id: @ts_tag_virtualsrv_sw).click if @advance_iframe.button(id: @ts_tag_virtualsrv_sw, class_name: @ts_tag_virsw_off).exists?
						#添加一条单端口映射
						unless @advance_iframe.text_field(name: @ts_tag_virip1).exists?
								@advance_iframe.button(id: @ts_tag_addvir).click
						end
						virtualsrv_ip_addr1 = "0.168.100.100"
						p "输入虚拟服务器IP地址为:#{virtualsrv_ip_addr1}".encode("GBK")
						@advance_iframe.text_field(name: @ts_tag_virip1).set(virtualsrv_ip_addr1)
						@advance_iframe.text_field(name: @ts_tag_virpub_port1).set(@tc_pub_tcp_port)
						@advance_iframe.text_field(name: @ts_tag_virpri_port1).set(@tc_vir_tcpsrv_port)
						@advance_iframe.button(id: @ts_tag_save_btn).click
						error_tip = @advance_iframe.span(id: @ts_tag_virsrvip_err)
						assert(error_tip.exists?, "提示输入地址错误")
						error_info=error_tip.text
						assert_equal(@tc_ip_error_tip, error_info, "提示信息错误")
						sleep @tc_wait_time

						virtualsrv_ip_addr3 = "192.168.100.0"
						p "输入虚拟服务器IP地址为:#{virtualsrv_ip_addr3}".encode("GBK")
						@advance_iframe.text_field(name: @ts_tag_virip1).set(virtualsrv_ip_addr3)
						@advance_iframe.button(id: @ts_tag_save_btn).click
						error_tip = @advance_iframe.span(id: @ts_tag_virsrvip_err)
						assert(error_tip.exists?, "提示输入地址错误")
						error_info=error_tip.text
						assert_equal(@tc_ip_error_tip, error_info, "提示信息错误")

				}

				operate("2、在“IP地址”输入D类地址或E类地址、组播地址，如：224.1.1.1，240.1.1.1，255.1.1.1，是否允许输入；") {
						virtualsrv_ip_addr5 = "224.168.100.10"
						p "输入虚拟服务器IP地址为:#{virtualsrv_ip_addr5}".encode("GBK")
						@advance_iframe.text_field(name: @ts_tag_virip1).set(virtualsrv_ip_addr5)
						@advance_iframe.button(id: @ts_tag_save_btn).click
						error_tip = @advance_iframe.span(id: @ts_tag_virsrvip_err)
						assert(error_tip.exists?, "提示输入地址错误")
						error_info=error_tip.text
						assert_equal(@tc_ip_error_tip, error_info, "提示信息错误")
				}

				operate("3、在“IP地址”输入大于255或小于0或小数的数字，如：256，-11，是否允许输入；") {
						virtualsrv_ip_addr7 = "100"
						p "输入虚拟服务器IP地址为:#{virtualsrv_ip_addr7}".encode("GBK")
						@advance_iframe.text_field(name: @ts_tag_virip1).set(virtualsrv_ip_addr7)
						@advance_iframe.button(id: @ts_tag_save_btn).click
						error_tip = @advance_iframe.span(id: @ts_tag_virsrvip_err)
						assert(error_tip.exists?, "提示输入地址错误")
						error_info=error_tip.text
						assert_equal(@tc_ip_error_tip, error_info, "提示信息错误")

						virtualsrv_ip_addr4 = "192.168.-100.100"
						p "输入虚拟服务器IP地址为:#{virtualsrv_ip_addr4}".encode("GBK")
						@advance_iframe.text_field(name: @ts_tag_virip1).set(virtualsrv_ip_addr4)
						@advance_iframe.button(id: @ts_tag_save_btn).click
						error_tip = @advance_iframe.span(id: @ts_tag_virsrvip_err)
						assert(error_tip.exists?, "提示输入地址错误")
						error_info=error_tip.text
						assert_equal(@tc_ip_error_tip, error_info, "提示信息错误")
				}

				operate("4、在“IP地址”输入广播地址，如：192.168.2.255,10.255.255.255，是否允许输入；") {
						virtualsrv_ip_addr4 = "192.168.100.255"
						p "输入虚拟服务器IP地址为:#{virtualsrv_ip_addr4}".encode("GBK")
						@advance_iframe.text_field(name: @ts_tag_virip1).set(virtualsrv_ip_addr4)
						@advance_iframe.button(id: @ts_tag_save_btn).click
						error_tip = @advance_iframe.span(id: @ts_tag_virsrvip_err)
						assert(error_tip.exists?, "提示输入地址错误")
						error_info=error_tip.text
						assert_equal(@tc_ip_error_tip, error_info, "提示信息错误")
				}

				operate("5、输入与DUT WAN口的IP地址地址，是否允许输入；") {
#padding
				}

				operate("6、输入回环地址，如：127.0.0.1，是否允许输入；") {
						virtualsrv_ip_addr4 = "127.0.0.1"
						p "输入虚拟服务器IP地址为:#{virtualsrv_ip_addr4}".encode("GBK")
						@advance_iframe.text_field(name: @ts_tag_virip1).set(virtualsrv_ip_addr4)
						@advance_iframe.button(id: @ts_tag_save_btn).click
						error_tip = @advance_iframe.span(id: @ts_tag_virsrvip_err)
						assert(error_tip.exists?, "提示输入地址错误")
						error_info=error_tip.text
						assert_equal(@tc_ip_error_tip, error_info, "提示信息错误")
				}

				operate("7、在IP地址输入A~Z,a~z,~!@#$%^等33个特殊字符，中文，空格，为空等，是否允许输入；") {
						virtualsrv_ip_addr = "中文"
						p "输入虚拟服务器IP地址为:#{virtualsrv_ip_addr}".encode("GBK")
						@advance_iframe.text_field(name: @ts_tag_virip1).set(virtualsrv_ip_addr)
						@advance_iframe.button(id: @ts_tag_save_btn).click
				}

				operate("8、输入与LAN口IP同一个地址，如：192.168.100.1，是否允许输入；") {
						#正常应该不允许输入与LAN相同的地址
						ip_info = ipconfig
						srv_ip  = ip_info[@ts_nicname][:gateway][0]
						p "输入虚拟服务器IP地址为:#{srv_ip}".encode("GBK")
						@advance_iframe.text_field(name: @ts_tag_virip1).set(srv_ip)
						@advance_iframe.button(id: @ts_tag_save_btn).click
						error_tip = @advance_iframe.span(id: @ts_tag_virsrvip_err)
						assert(error_tip.exists?, "提示输入地址错误")
						error_info=error_tip.text
						assert_equal(@tc_ip_error_tip, error_info, "提示信息错误")
				}


		end

		def clearup
				operate("1 删除虚拟服务器配置") {
						if !@advance_iframe.nil? && !@advance_iframe.exists?
								@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
								@browser.link(id: @ts_tag_options).click
								@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
						end

						#选择‘应用设置’
						application      = @advance_iframe.link(id: @ts_tag_application)
						application_name = application.class_name
						unless application_name == @ts_tag_select_state
								application.click
								sleep @tc_wait_time
						end

						#选择“虚拟服务器”标签
						virtualsrv       = @advance_iframe.link(id: @ts_tag_virtualsrv)
						virtualsrv_state = virtualsrv.parent.class_name
						virtualsrv.click unless virtualsrv_state==@ts_tag_liclass
						sleep @tc_wait_time
						flag=false
						if @advance_iframe.button(id: @ts_tag_virtualsrv_sw, class_name: @ts_tag_virsw_on).exists?
								#关闭虚拟服务器开关
								@advance_iframe.button(id: @ts_tag_virtualsrv_sw).click
								flag=true
						end
						if @advance_iframe.text_field(name: @ts_tag_virip1).exists?
								#删除端口映射
								@advance_iframe.button(id: @ts_tag_delvir).click
								flag=true
						end
						if flag
								#保存
								@advance_iframe.button(id: @ts_tag_save_btn).click
								sleep @tc_wait_time
						end
				}
		end

}
