#
# description:
#
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
testcase {
		attr = {"id" => "ZLBF_21.1.41", "level" => "P3", "auto" => "n"}

		def prepare

				@tc_wait_time           = 2
				@tc_import_time         = 5
				@tc_config_format_error = "上传文件格式错误"
				@tc_config_error        = "请上传导入文件"
				@tc_config_recovering   = "正在恢复配置文件，请稍候"
				@tc_net_time            = 50
				@tc_download_conf_time  = 10
				@tc_reboot_time         = 120
				@tc_relogin_time        = 80
				@tc_config_dir          = File.expand_path("../router_config", __FILE__)
				@tc_backup_file         = "#{@ts_backup_directory}/#{@ts_default_config_name}"
				puts "备份的配置文件保存路径:#{@tc_backup_file}".encode("GBK")
		end

		def process

				operate("1、WAN设置为PPPoE方式，输入正确的拨号用户名与密码，查看拨号是否成功，PC1，PC2上网业务是否正常；") {
						@browser.span(:id => @ts_tag_status).wait_until_present(@tc_wait_time)
						@browser.span(:id => @ts_tag_status).click
						@status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
						assert(@status_iframe.exists?, "打开WAN状态失败！")
						wan_type = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
						#先判断是否为PPPOE模式如果不是则设置为PPPOE模式
						unless wan_type=~/#{@ts_wan_mode_pppoe}/
								if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
										@browser.execute_script(@ts_close_div)
								end
								@browser.span(:id => @ts_tag_netset).click
								@wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
								assert(@wan_iframe.exists?, "打开外网设置失败")

								#设置为有线连接
								rs1=@wan_iframe.link(:id => @ts_tag_wired_mode_link).class_name
								unless rs1=~/#{@ts_tag_select_state}/
										@wan_iframe.span(:id => @ts_tag_wired_mode_span).click
								end

								#如果不是静态接入就先设置为静态接入
								pppoe_radio       = @wan_iframe.radio(id: @ts_tag_wired_pppoe)
								pppoe_radio_state = pppoe_radio.checked?
								unless pppoe_radio_state
										pppoe_radio.click
										sleep @tc_wait_time
										puts "设置PPPOE帐户名和PPPOE密码！".to_gbk
										@wan_iframe.text_field(id: @ts_tag_pppoe_usr).set(@ts_pppoe_usr)
										@wan_iframe.text_field(id: @ts_tag_pppoe_pw).set(@ts_pppoe_pw)
										@wan_iframe.button(id: @ts_tag_sbm).click
										sleep @tc_net_time
								end

								#重新查看网络状态
								@browser.span(:id => @ts_tag_status).wait_until_present(@tc_wait_time)
								@browser.span(:id => @ts_tag_status).click
								@status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
								assert(@status_iframe.exists?, "重新打开WAN状态失败！")
								wan_type = @status_iframe.b(:id => @tag_wan_type).parent.text
						end
						wan_addr = @status_iframe.b(:id => @ts_tag_wan_ip).parent.text
						wan_addr =~@ts_tag_ip_regxp
						puts "WAN状态显示获取的IP地址为：#{Regexp.last_match(1)}".to_gbk

						wan_type =~/(#{@ts_wan_mode_pppoe})/
						puts "WAN状态显示接入类型为：#{Regexp.last_match(1)}".to_gbk

						assert_match(@ts_tag_ip_regxp, wan_addr, '获取ip地址失败！')
						assert_match(/#{@ts_wan_mode_pppoe}/, wan_type, '接入类型错误！')
				}

				operate("2、登录DUT管理页面，进入备份与恢复设置页面；") {
						@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
						@browser.link(id: @ts_tag_options).click
						@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
						assert(@advance_iframe.exists?, "打开高级设置失败!")

						#选择‘系统设置’
						sysset      = @advance_iframe.link(id: @ts_tag_op_system)
						sysset_name = sysset.class_name
						unless sysset_name == @ts_tag_select_state
								sysset.click
								sleep @tc_wait_time
						end

						#选择“恢复出厂设置”标签
						system_reset       = @advance_iframe.link(id: @ts_tag_recover)
						system_reset_state = system_reset.parent.class_name
						system_reset.click unless system_reset_state==@ts_tag_liclass
						sleep @tc_wait_time
				}

				operate("3、导入非法格式的配置文件，如：doc，xls，rar，AVI，txt，exe，wmv，cap等类型的文件，查看恢复是否成功，DUT是否会异常，PC1，PC2上网业务是否正常；") {
						#设置配置文件
						tc_config_path = @tc_config_dir+"/config_excel.xlsx"
						puts "导入配置文件为:#{tc_config_path}".encode("GBK")
						@advance_iframe.file_field(id: @ts_tag_filename).set(tc_config_path)
						sleep @tc_wait_time
						@advance_iframe.button(id: @ts_tag_inport_btn).click
						sleep @tc_import_time
						@tc_config_import = @advance_iframe.div(text: /#{@tc_config_recovering}/).exists?
						#未提示正在导入配置，则认为导入失败
						refute(@tc_config_import, "配置文件格式不正确也能导入成功")

						#设置配置文件
						tc_config_path = @tc_config_dir+"/config_pic.png"
						puts "导入配置文件为:#{tc_config_path}".encode("GBK")
						@advance_iframe.file_field(id: @ts_tag_filename).set(tc_config_path)
						sleep @tc_import_time
						@tc_config_import = @advance_iframe.div(text: /#{@tc_config_recovering}/).exists?
						#未提示正在导入配置，则认为导入失败
						refute(@tc_config_import, "配置文件格式不正确也能导入成功")
				}

				operate("4、导入与配置文件名字相同其它类型的文件，如:1.jpg更改为config.xml，查看恢复是否成功，DUT是否会异常，PC1，PC2上网业务是否正常；") {
						#设置配置文件
						tc_config_path = @tc_config_dir+"/config_pic.dat"
						puts "导入配置文件为:#{tc_config_path}".encode("GBK")
						@advance_iframe.file_field(id: @ts_tag_filename).set(tc_config_path)
						sleep @tc_wait_time
						@advance_iframe.button(id: @ts_tag_inport_btn).click
						sleep @tc_import_time
						@tc_config_import = @advance_iframe.div(text: /#{@tc_config_recovering}/).exists?
						#未提示正在导入配置，则认为导入失败
						refute(@tc_config_import, "配置文件格式不正确也能导入成功")
				}

				operate("5、编辑正确的配置文件，修改其中相关内容并保存，再导入此文件，选查看恢复是否成功，DUT是否会异常，PC1，PC2上网业务是否正常；") {
						#设置配置文件
						tc_config_path = @tc_config_dir+"/RT2880_Settings_change.dat"
						puts "导入配置文件为:#{tc_config_path}".encode("GBK")
						@advance_iframe.file_field(id: @ts_tag_filename).set(tc_config_path)
						sleep @tc_wait_time
						@advance_iframe.button(id: @ts_tag_inport_btn).click
						sleep @tc_import_time
						@tc_config_import = @advance_iframe.div(text: /#{@tc_config_recovering}/).exists?
						#未提示正在导入配置，则认为导入失败
						refute(@tc_config_import, "配置文件格式不正确也能导入成功")
				}

				# operate("6、导入其它方案产品同一平台(如TBS)的配置文件,选查看恢复是否成功，DUT是否会异常，PC1，PC2上网业务是否正常；") {
				#
				# }

				operate("6、从另外一个相同硬件相同软件上备份配置，再导入配置到此DUT上，DUT是否会异常，PC1，PC2上网业务是否正常。") {
						#设置配置文件
						tc_config_path = @tc_config_dir+"/RT2880_Settings.dat"
						puts "导入配置文件为:#{tc_config_path}".encode("GBK")
						@advance_iframe.file_field(id: @ts_tag_filename).set(tc_config_path)
						sleep @tc_wait_time
						@advance_iframe.button(id: @ts_tag_inport_btn).click
						sleep @tc_import_time
						@tc_config_import = @advance_iframe.div(text: /#{@tc_config_recovering}/).exists?
						#提示正在导入配置
						assert(@tc_config_import, "配置文件导入失败")
						#等待配置导入完成
						puts "after import config,waiting for system reboot...."
						sleep(@tc_reboot_time) #由于重启会断开连接所以这里必须使用sleep来等待，而不是用Watir::Wait来等待
						rs = @browser.text_field(:name, @ts_tag_usr).wait_until_present(@tc_relogin_time)
						assert rs, "跳转到登录页面失败!"

						#重新登录路由器
						login_no_default_ip(@browser)
						@tc_config_inported = true
				}


		end

		def clearup
				operate("恢复默认配置") {
						#如果错误的配置文件导入成功，这里要等待路由器重启
						if (@tc_config_inported.nil?||!@tc_config_inported) && (!@tc_config_import.nil? && @tc_config_import)
								sleep @tc_reboot_time
								if @browser.text_field(:name, @ts_tag_usr).exists?
										login_no_default_ip(@browser)
								end
						end

						if @browser.text_field(:name, @ts_tag_usr).exists?
								login_no_default_ip(@browser)
								@wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
						end

						if @browser.span(:id => @ts_tag_netset).exists?
								@wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
						else
								login_recover(@browser, @ts_default_ip)
								@wan_iframe = @browser.iframe
						end

						flag = false
						#设置wan连接方式为网线连接
						rs1  = @wan_iframe.link(:id => @ts_tag_wired_mode_link).class_name
						unless rs1 =~/#{@ts_tag_select_state}/
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
								puts "sleep #{@tc_net_time} seconds for net reseting..."
								sleep @tc_net_time
						end
				}
		end

}
