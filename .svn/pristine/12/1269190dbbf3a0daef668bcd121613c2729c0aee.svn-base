#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
testcase {
		attr = {"id" => "ZLBF_17.1.3", "level" => "P4", "auto" => "n"}

		def prepare
				@tc_wait_time      = 2
				@tc_normal_port    = 4002
				@tc_pub_srvport    = 9000
				@tc_port_err_tip   = "端口范围1-65535"
				@tc_tag_button_on  = "on"
				@tc_tag_button_off = "off"
				@tc_tag_port       = "port"
				DRb.start_service
				@tc_wan_drb     = DRbObject.new_with_uri(@ts_drb_server2)
				@tc_remote_time = 10
		end

		def process

				operate("1、在“端口”输入全-11，0，65536，是否允许输入") {
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
						ip_info    = ipconfig
						@tc_srv_ip = ip_info[@ts_nicname][:ip][0]
						p "输入虚拟服务器IP地址为:#{@tc_srv_ip}".encode("GBK")
						@advance_iframe.text_field(name: @ts_tag_virip1).set(@tc_srv_ip)
						#=begin
						port1 = 0
						p "输入公共端口为#{port1}".encode("GBK")
						@advance_iframe.text_field(name: @ts_tag_virpub_port1).set(port1)
						@advance_iframe.text_field(name: @ts_tag_virpri_port1).set(@tc_normal_port)
						@advance_iframe.button(id: @ts_tag_save_btn).click
						error_tip = @advance_iframe.span(id: @ts_tag_virsrvip_err)
						assert(error_tip.exists?, "提示输入端口错误")
						error_info=error_tip.text
						assert_equal(@tc_port_err_tip, error_info, "提示信息错误")
						p "输入私有端口为#{port1}".encode("GBK")
						@advance_iframe.text_field(name: @ts_tag_virpub_port1).set(@tc_normal_port)
						@advance_iframe.text_field(name: @ts_tag_virpri_port1).set(port1)
						@advance_iframe.button(id: @ts_tag_save_btn).click
						error_tip = @advance_iframe.span(id: @ts_tag_virsrvip_err)
						assert(error_tip.exists?, "提示输入端口错误")
						error_info=error_tip.text
						assert_equal(@tc_port_err_tip, error_info, "提示信息错误")

						port2 = 65536
						p "输入公共端口为#{port2}".encode("GBK")
						@advance_iframe.text_field(name: @ts_tag_virpub_port1).set(port2)
						@advance_iframe.text_field(name: @ts_tag_virpri_port1).set(@tc_normal_port)
						@advance_iframe.button(id: @ts_tag_save_btn).click
						error_tip = @advance_iframe.span(id: @ts_tag_virsrvip_err)
						assert(error_tip.exists?, "提示输入端口错误")
						error_info=error_tip.text
						assert_equal(@tc_port_err_tip, error_info, "提示信息错误")
						p "输入私有端口为#{port2}".encode("GBK")
						@advance_iframe.text_field(name: @ts_tag_virpub_port1).set(@tc_normal_port)
						@advance_iframe.text_field(name: @ts_tag_virpri_port1).set(port2)
						@advance_iframe.button(id: @ts_tag_save_btn).click
						error_tip = @advance_iframe.span(id: @ts_tag_virsrvip_err)
						assert(error_tip.exists?, "提示输入端口错误")
						error_info=error_tip.text
						assert_equal(@tc_port_err_tip, error_info, "提示信息错误")
#=end
				}

				operate("2、在“端口”输入A~Z,a~z,~!@#$%^等33个特殊字符，中文，空格，为空等，是否允许输入；") {
#=begin
						port1 = "a"
						p "输入公共端口为#{port1}".encode("GBK")
						@advance_iframe.text_field(name: @ts_tag_virpub_port1).set(port1)
						sleep @tc_wait_time
						@advance_iframe.text_field(name: @ts_tag_virpri_port1).set(@tc_normal_port)
						p "输入私有端口为#{port1}".encode("GBK")
						@advance_iframe.text_field(name: @ts_tag_virpub_port1).set(@tc_normal_port)
						@advance_iframe.text_field(name: @ts_tag_virpri_port1).set(port1)
						@advance_iframe.button(id: @ts_tag_save_btn).click
						error_tip = @advance_iframe.span(id: @ts_tag_virsrvip_err)
						assert(error_tip.exists?, "提示输入端口错误")
						error_info=error_tip.text
						assert_equal(@tc_port_err_tip, error_info, "提示信息错误")

						port2 = "@@@@"
						p "输入公共端口为#{port2}".encode("GBK")
						@advance_iframe.text_field(name: @ts_tag_virpub_port1).set(port2)
						@advance_iframe.text_field(name: @ts_tag_virpri_port1).set(@tc_normal_port)
						@advance_iframe.button(id: @ts_tag_save_btn).click
						error_tip = @advance_iframe.span(id: @ts_tag_virsrvip_err)
						assert(error_tip.exists?, "提示输入端口错误")
						error_info=error_tip.text
						assert_equal(@tc_port_err_tip, error_info, "提示信息错误")
						p "输入私有端口为#{port2}".encode("GBK")
						@advance_iframe.text_field(name: @ts_tag_virpub_port1).set(@tc_normal_port)
						@advance_iframe.text_field(name: @ts_tag_virpri_port1).set(port2)
						@advance_iframe.button(id: @ts_tag_save_btn).click
						error_tip = @advance_iframe.span(id: @ts_tag_virsrvip_err)
						assert(error_tip.exists?, "提示输入端口错误")
						error_info=error_tip.text
						assert_equal(@tc_port_err_tip, error_info, "提示信息错误")

						port3 = ""
						p "公共端口为空".encode("GBK")
						@advance_iframe.text_field(name: @ts_tag_virpub_port1).set(port3)
						@advance_iframe.text_field(name: @ts_tag_virpri_port1).set(@tc_normal_port)
						@advance_iframe.button(id: @ts_tag_save_btn).click
						error_tip = @advance_iframe.span(id: @ts_tag_virsrvip_err)
						assert(error_tip.exists?, "提示输入端口错误")
						error_info=error_tip.text
						assert_equal(@tc_port_err_tip, error_info, "提示信息错误")
						p "私有端口为空".encode("GBK")
						@advance_iframe.text_field(name: @ts_tag_virpub_port1).set(@tc_normal_port)
						@advance_iframe.text_field(name: @ts_tag_virpri_port1).set(port3)
						@advance_iframe.button(id: @ts_tag_save_btn).click
						error_tip = @advance_iframe.span(id: @ts_tag_virsrvip_err)
						assert(error_tip.exists?, "提示输入端口错误")
						error_info=error_tip.text
						assert_equal(@tc_port_err_tip, error_info, "提示信息错误")

						port4 = "中文"
						p "输入公共端口为#{port4}".encode("GBK")
						@advance_iframe.text_field(name: @ts_tag_virpub_port1).set(port4)
						@advance_iframe.text_field(name: @ts_tag_virpri_port1).set(@tc_normal_port)
						@advance_iframe.button(id: @ts_tag_save_btn).click
						error_tip = @advance_iframe.span(id: @ts_tag_virsrvip_err)
						assert(error_tip.exists?, "提示输入端口错误")
						error_info=error_tip.text
						assert_equal(@tc_port_err_tip, error_info, "提示信息错误")
						p "输入私有端口为#{port4}".encode("GBK")
						@advance_iframe.text_field(name: @ts_tag_virpub_port1).set(@tc_normal_port)
						@advance_iframe.text_field(name: @ts_tag_virpri_port1).set(port4)
						@advance_iframe.button(id: @ts_tag_save_btn).click
						error_tip = @advance_iframe.span(id: @ts_tag_virsrvip_err)
						assert(error_tip.exists?, "提示输入端口错误")
						error_info=error_tip.text
						assert_equal(@tc_port_err_tip, error_info, "提示信息错误")
#=end
				}

				operate("3、输入远程连接的端口，是否允许输入。如果允许输入，需要验证远程连接和虚拟服务器的优先级") {
						p "输入公共端口为#{@tc_pub_srvport}".encode("GBK")
						p "输入虚拟服务器端口为#{@tc_normal_port}".encode("GBK")
						@advance_iframe.text_field(name: @ts_tag_virpub_port1).set(@tc_pub_srvport)
						@advance_iframe.text_field(name: @ts_tag_virpri_port1).set(@tc_normal_port)
						@advance_iframe.button(id: @ts_tag_save_btn).click
						sleep @tc_remote_time
						#查看Wan ip地址
						@browser.span(:id, @ts_tag_status).click
						sleep @tc_wait_time
						@browser.iframe(src: @tag_status_iframe_src).wait_until_present(@tc_wait_time)
						@status_iframe= @browser.iframe(src: @tag_status_iframe_src)
						wan_addr      = @status_iframe.b(:id => @ts_tag_wan_ip).parent.text
						wan_addr =~@ts_tag_ip_regxp
						@tc_wan_ipaddr = Regexp.last_match(1)
						puts "WAN状态显示获取的IP地址为：#{@tc_wan_ipaddr}".to_gbk

						#启动tcp_server
						tcp_multi_server(@tc_srv_ip, @tc_normal_port)
						#WAN口用户连接虚拟服务器
						rs      = @tc_wan_drb.tcp_client(@tc_wan_ipaddr, @tc_pub_srvport)
						tcp_msg = rs.tcp_message
						puts "=================Message from TCP server==============="
						print tcp_msg
						assert_match(/#{@ts_conn_state}/, tcp_msg, "开启虚拟服务器后，tcp连接失败")

						#设置远程访问WEB,远程连接与虚拟服务器设置为同一端口
						#系统设置
						@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
						@browser.link(id: @ts_tag_options).click
						@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
						system_set      = @advance_iframe.link(id: @ts_tag_op_system)
						unless system_set.class_name==@ts_tag_select_state
								system_set.click
						end
						#外网访问WEB
						web_remote = @advance_iframe.link(id: @ts_tag_op_remote)
						unless web_remote.parent.text==@ts_tag_liclass
								web_remote.click
						end

						#打开外网访问WEB功能
						button_off = @advance_iframe.button(class_name: @tc_tag_button_off)
						if button_off.exists?
								button_off.click
						end
						button_on = @advance_iframe.button(class_name: @tc_tag_button_on)
						assert(button_on.exists?, "打开外网访问失败!")
						@advance_iframe.text_field(id: @tc_tag_port).set(@tc_pub_srvport)
						#保存
						@advance_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_remote_time

						remote_url = "#{@tc_wan_ipaddr}:#{@tc_pub_srvport}"
						puts "Remote Web Login :#{remote_url}"
						rs=@tc_wan_drb.login_router(remote_url, @ts_default_usr, @ts_default_pw)
						assert(rs, "远程WEB访问失败!")

						#远程连接与虚拟服务器设置为同一端口后，连接虚拟服务器失败
						rs      = @tc_wan_drb.tcp_client(@tc_wan_ipaddr, @tc_pub_srvport)
						tcp_msg = rs.tcp_message
						puts "=================Message from TCP server==============="
						print tcp_msg
						refute(rs.tcp_state, "开启远程访问后同端的虚拟服务器应该不能访问")
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

				operate("2 关闭外网访问WEB功能") {
						if !@advance_iframe.nil? && !@advance_iframe.exists?
								@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
								@browser.link(id: @ts_tag_options).click
								@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
						end
						#系统设置
						system_set = @advance_iframe.link(id: @ts_tag_op_system)
						unless system_set.class_name==@tc_select_state
								system_set.click
						end
						#外网访问WEB
						web_remote = @advance_iframe.link(id: @ts_tag_op_remote)
						unless web_remote.parent.text==@tc_tag_liclass
								web_remote.click
						end
						#打开外网访问WEB功能
						button_on = @advance_iframe.button(class_name: @tc_tag_button_on)
						if button_on.exists?
								button_on.click
								@advance_iframe.button(id: @ts_tag_sbm).click
								sleep @tc_remote_time
						end
				}
		end

}
