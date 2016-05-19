#
# description:
#  1 不再telnet到路由器中uptime获取时间与WEB时间作比较
#      -改为判断WEB页面显示的时间格式是否正确
#      -获取WEB上两次运行时间的差，与Time类两次时间差做比较来测试运行时长统计是否准确
# author:liluping
# date:2015-11-05 14:00:18
# modify:wuhongliang
#
testcase {

		attr = {"id" => "ZLBF_5.1.19", "level" => "P1", "auto" => "n"}

		def prepare
				@tc_wait_runtime = 10
				@tc_relogin_time = 60
		end

		def process
				# operate("1、点击系统状态的页面，查看页面上显示的运行时长是否正确，与串口下使用命令uptime查看的时长是否一致") {
				operate("1、点击系统状态的页面，查看页面上显示的运行时长是否正确") {
						# 改为判断WEB页面显示的时间格式是否正确
						# get_runtime方法是根据路由器界面来封装的获取运行时长的方法，所以这里不必对运行时长格式再做判断
						# 获取WEB上两次运行时间的差，与Time类两次时间差做比较来测试运行时长统计是否准确
						@systatus_page = RouterPageObject::SystatusPage.new(@browser)
						@systatus_page.open_systatus_page(@browser.url)
						runtime1 = @systatus_page.get_runtime #获取路由器上统计运行时长
						puts "路由器显示运行时间为#{runtime1[:hours]}hours,#{runtime1[:minutes]}minutes,#{runtime1[:seconds]}seconds".to_gbk
						runtime_before = Time.now #记录系统时间
						puts "第一次查询系统时间为#{runtime_before}".to_gbk
						puts "等待#{@tc_wait_runtime}seconds".to_gbk
						sleep @tc_wait_runtime
						@browser.refresh
						@systatus_page.open_systatus_page(@browser.url)
						runtime2 = @systatus_page.get_runtime #获取路由器上统计运行时长
						puts "等待#{@tc_wait_runtime}seconds后，路由器显示运行时间为#{runtime2[:hours]}hours,#{runtime2[:minutes]}minutes,#{runtime2[:seconds]}seconds".to_gbk
						runtime_after = Time.now #记录系统时间
						puts "第二次查询系统时间为 #{runtime_after}".to_gbk
						#将路由器记录时长转换为以秒为单位
						web_runtime1 = runtime1[:hours].to_i*60*60+runtime1[:minutes].to_i*60+runtime1[:seconds].to_i
						web_runtime2 = runtime2[:hours].to_i*60*60+runtime2[:minutes].to_i*60+runtime2[:seconds].to_i
						#路由器两次时长的差即为路由器统计到的运行时长
						web_dvalue   = web_runtime2-web_runtime1
						puts "路由器两次运行时长差为#{web_dvalue}".to_gbk
						#计算系统记录的时长
						sys_dvalue = (runtime_after-runtime_before).to_i
						puts "实际运行时长为 #{sys_dvalue} senconds".to_gbk
						#两者可能存1，2秒的误差,所以两者差小于等于，即可证明路由器统计的时长是正确的
						flag = (web_dvalue-sys_dvalue).abs<=2
						assert(flag, "路由器运行时长统计错误")
				}

				operate("2、页面点击重启，重启成功后，查看运行时长是否重新计时") {
						reboot_before = Time.now
						puts "重启前系统统时间 #{reboot_before} ".to_gbk
						@systatus_page.close_systatus_page
						@systatus_page.reboot
						rs = @browser.text_field(:name, @ts_tag_usr).wait_until_present(@tc_relogin_time)
						assert rs, '跳转到登录页面失败！'
						#重新登录路由器
						rs_login = login_no_default_ip(@browser) #重新登录
						assert(rs_login[:flag], "登录失败：#{rs_login[:message]}")
						@systatus_page.open_systatus_page(@browser.url)
						@tc_runtime = @systatus_page.get_runtime #获取路由器上统计运行时长
						puts "重启后路由器显示运行时间为#{@tc_runtime[:hours]}hours,#{@tc_runtime[:minutes]}minutes,#{@tc_runtime[:seconds]}seconds".to_gbk
						@tc_reboot_after = Time.now
						puts "重启后系统统时间 #{@tc_reboot_after}".to_gbk
						#将路由器显示运行时长转换为秒
						@web_runtime     = @tc_runtime[:hours].to_i*60*60+@tc_runtime[:minutes].to_i*60+@tc_runtime[:seconds].to_i
						puts "重启后路由器统计运行时间转换为 #{@web_runtime} seconds".to_gbk
						#重启后，记录运行时长约120秒
						assert(@web_runtime<=125, "重启后路由器运行时长统计错误")
						#计算重启前后，操作系统经过的时长
						sys_time = (@tc_reboot_after-reboot_before).to_i
						puts "实际过程时长为 #{sys_time} seconds".to_gbk
						#重启路由器时，运行计时器重启需要20-25秒左右,这里比较路由器两次统计的运行时长与系统时长
						flag = (sys_time-@web_runtime).abs<=25
						assert(flag, "重启后路由器运行时长统计与实际时长不一致")
				}

				operate("3、长时间将AP上电，进行各种配置和测试后观察运行时长是否正常（例如修改WAN，修改LAN，wifi等操作）") {
						@wan_page = RouterPageObject::WanPage.new(@browser)
						@wan_page.set_pppoe(@ts_pppoe_usr, @ts_pppoe_pw, @browser.url)

						@systatus_page.open_systatus_page(@browser.url)
						runtime = @systatus_page.get_runtime #获取路由器上统计运行时长
						puts "修改WAN接入方式后显示运行时间为#{runtime[:hours]}hours,#{runtime[:minutes]}minutes,#{runtime[:seconds]}seconds".to_gbk
						wan_runtime = runtime[:hours].to_i*60*60+runtime[:minutes].to_i*60+runtime[:seconds].to_i
						puts "修改WAN接入方式后统计运行时长转换为 #{wan_runtime} seconds".to_gbk
						#路由器两次时长的差即为路由器统计到的运行时长
						web_dvalue   = wan_runtime-@web_runtime
						puts "路由器两次运行时长差为 #{web_dvalue} seconds".to_gbk

						wan_time = Time.now
						puts "修改WAN接入方式后系统统时间#{wan_time}".to_gbk
						#计算设置PPPOE拨号后，操作系统经过的时长
						sys_time = (wan_time-@tc_reboot_after).to_i
						puts "修改WAN接入方式后实际过程时长为 #{sys_time} seconds".to_gbk
						#修改WAN接入方式后，比较系统时长与路由器记录时长
						flag = (sys_time-web_dvalue).abs<=2
						assert(flag, "修改WAN接入方式后路由器运行时长统计与实际时长不一致")
						sleep @tc_wait_runtime
						@systatus_page.open_systatus_page(@browser.url)
						wan_type = @systatus_page.get_wan_type
						wan_ip   = @systatus_page.get_wan_ip
						puts "查询到WAN接入方式为#{wan_type}".to_gbk
						puts "查询到WAN IP为#{wan_ip}".to_gbk
						assert_equal(@ts_wan_mode_pppoe, wan_type, '接入类型错误！')
						assert_match(@ts_tag_ip_regxp, wan_ip, 'PPPOE获取地址失败！')
				}

		end

		def clearup
				operate("1 恢复默认方式:DHCP") {
						@wan_page = RouterPageObject::WanPage.new(@browser)
						@wan_page.set_dhcp(@browser, @browser.url)
				}
		end

}
