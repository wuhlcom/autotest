#encoding: utf-8
gem 'minitest'
require 'minitest/autorun'
require 'minitest/reporters'
file_path =File.expand_path('../../lib/router_page_object', __FILE__)
require file_path
require "htmltags"
include HtmlTag::Reporter
include HtmlTag::ScreenShot
include HtmlTag::LogInOut
include HtmlTag::Telnet
include HtmlTag::WinCmd


class Test<MiniTest::Unit::TestCase

		#pptp拿到地址
		def test_get_pptp_ip
				url          = "192.168.100.1"
				usrname      = "admin"
				passwd       = "admin"
				@browser     = Watir::Browser.new :firefox, :profile => "default"
				@sys_page    = RouterPageObject::SystatusPage.new(@browser)
				@option_page = RouterPageObject::OptionsPage.new(@browser)
				@wan_page    = RouterPageObject::WanPage.new(@browser)
				@option_page.login_with(usrname, passwd, url)
				log_path     = "E:/autotest/frame/reports/pptp_page"
				report_fpath = log_path + "/get_pptp_ip_80s.log"
				stdio(report_fpath, time)

				100.times do |n|
						begin
								p "第#{n+1}次执行pptp拨号".to_gbk
								@option_page.set_pptp("10.10.10.1", "pptp", "pptp", @browser.url)
								@sys_page.open_systatus_page(@browser.url) #打开系统状态
								pptp_ip = @sys_page.get_wan_ip
								p "获取wan口ip地址为：#{pptp_ip}".to_gbk
								@wan_page.set_dhcp(@browser, @browser.url)
						rescue => ex1
								report_image1 = log_path+"/images/#{n+1}.png"
								save_screenshot(@browser, report_image1, time) #截图
								err = ex1.message.to_s
								print ex1.backtrace.join("\n")
								print("\n")
						ensure
								p "==========================================================================="
						end
				end
		end

		#wifi配置出现白板
		def testwifi_white_page
				url          = "192.168.100.1"
				usrname      = "admin"
				passwd       = "admin"
				@browser     = Watir::Browser.new :firefox, :profile => "default"
				@wifi_page   = RouterPageObject::WIFIPage.new(@browser)
				@sys_page    = RouterPageObject::SystatusPage.new(@browser)
				@option_page = RouterPageObject::OptionsPage.new(@browser)
				@wifi_page.login_with(usrname, passwd, url)
				log_path     = "E:/autotest/frame/reports/white_page"
				report_fpath = log_path + "/wifi_white_page_65s.log"
				stdio(report_fpath, time)
				100.times do |n|
						begin
								p "第#{n+1}次执行".to_gbk
								@wifi_page.modify_ssid_mode_pwd(@browser.url)
								@sys_page.open_systatus_page(@browser.url) #打开系统状态
								channel = @sys_page.get_wifi_channel
								p "获取当前信道未为：#{channel}".to_gbk
						rescue => ex1
								report_image1 = log_path+"/wifi_images_65s/#{n+1}.png"
								save_screenshot(@browser, report_image1, time) #截图
								err = ex1.message.to_s
								print ex1.backtrace.join("\n")
								print("\n")
						ensure
								p "==========================================================================="
						end
				end

		end

		#复现防火墙设置异常
		def testdia
				100.times do |n|
						url           = "192.168.100.1"
						usrname       = "admin"
						passwd        = "admin"
						@browser      = Watir::Browser.new :firefox, :profile => "default"
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.login_with(usrname, passwd, url)
						log_path     = "E:/autotest/frame/reports/block_page"
						report_fpath = log_path + "/block_page.log"
						stdio(report_fpath, time)

						begin
								p "第#{n+1}次执行".to_gbk
								# @options_page = RouterPageObject::OptionsPage.new(@browser)
								puts "设置非法的pptp帐户".to_gbk
								@options_page.set_pptp("10.10.10.1", "pptpfail", "pptpfail", @browser.url)
								@browser.refresh

								@diagnose_page = RouterPageObject::DiagnosePage.new(@browser)
								@diagnose_page.initialize_diag(@browser)
								@diagnose_page.switch_page(1) #切换到诊断窗口
								tc_diag_wan_status = @diagnose_page.wan_conn
								puts "WAN Port status:#{tc_diag_wan_status}".to_gbk
								# assert_equal("正常", tc_diag_wan_status, "显示WAN口状态异常")

								tc_diag_internet_status = @diagnose_page.net_status
								puts "Internet status:#{tc_diag_internet_status}".to_gbk
								# assert_equal("异常", tc_diag_internet_status, "显示外网连接状态应该为'异常'")
								tc_diag_internet_err    = @diagnose_page.net_status_element.element.parent.parent.div(class_name: "detail").text
								# assert_equal("外网连接不成功，请检查外网连接类型是否正确， 进入【高级设置->网络设置->PPTP设置】重新进行设置", tc_diag_internet_err, "网络异常提示内容错误!")

								tc_diag_hardware_status = @diagnose_page.route_status
								puts "Hardware status:#{tc_diag_hardware_status}".to_gbk
								# assert_equal("正常", tc_diag_hardware_status, "显示路由器硬件状态异常")

								tc_diag_netspeed_status = @diagnose_page.net_speed
								puts "NetSpeed status:#{tc_diag_netspeed_status}".to_gbk
								# assert_equal("异常", tc_diag_netspeed_status, "显示连接速率异常")

								tc_diag_cpu_status = @diagnose_page.cpu_status
								puts "CPU status:\n#{tc_diag_cpu_status}".to_gbk
								# assert_match(/处理器类型：.+/im, tc_diag_cpu_status, "显示处理器类型异常")
								# assert_match(/处理器型号：.+/im, tc_diag_cpu_status, "显示处理器名称异常")
								# assert_match(/系统负载：(.+:\s*\d+\.\d+)|(\d+\.\d+)/im, tc_diag_cpu_status, "显示处理器负载异常")

								tc_diag_mem_status = @diagnose_page.mem_status
								puts "MEM status:\n#{tc_diag_mem_status}".to_gbk
								# assert_match(/内存总量\s*：\s*[1-9]+\d*\s*M/m, tc_diag_mem_status, "显示内存总大小类型异常")
								# assert_match(/可用内存\s*：\s*[1-9]+\d*\s*M/m, tc_diag_mem_status, "显示可用内存异常")
								# assert_match(/缓存内存\s*：\s*[1-9]+\d*\s*M/m, tc_diag_mem_status, "显示缓存空间异常")

								@diagnose_page.switch_page(0) #切换到路由器窗口
								puts "设置合法的PPTP帐户".to_gbk
								@options_page.set_pptp("10.10.10.1", "pptp", "pptp", @browser.url)
								@diagnose_page.switch_page(1) #切换到诊断窗口
								sleep 1
								@diagnose_page.rediagnose(60) #重新诊断
								tc_diag_wan_status = @diagnose_page.wan_conn
								puts "WAN Port status:#{tc_diag_wan_status}".to_gbk
								# assert_equal("正常", tc_diag_wan_status, "显示WAN口状态异常")

								tc_diag_internet_status = @diagnose_page.net_status
								puts "Internet status:#{tc_diag_internet_status}".to_gbk
								# assert_equal("正常", tc_diag_internet_status, "显示外网连接状态异常")

								tc_diag_hardware_status = @diagnose_page.route_status
								puts "Hardware status:#{tc_diag_hardware_status}".to_gbk
								# assert_equal("正常", tc_diag_hardware_status, "显示路由器硬件状态异常")

								tc_diag_netspeed_status = @diagnose_page.net_speed
								puts "Hardware status:#{tc_diag_netspeed_status}".to_gbk
								# assert_equal("正常", tc_diag_netspeed_status, "显示连接速率异常")

								tc_diag_cpu_status = @diagnose_page.cpu_status
								puts "CPU status:\n#{tc_diag_cpu_status}".to_gbk
								# assert_match(/处理器类型：.+/im, tc_diag_cpu_status, "显示处理器类型异常")
								# assert_match(/处理器型号：.+/im, tc_diag_cpu_status, "显示处理器名称异常")
								# assert_match(/系统负载：(.+:\s*\d+\.\d+)|(\d+\.\d+)/im, tc_diag_cpu_status, "显示处理器负载异常")

								tc_diag_mem_status = @diagnose_page.mem_status
								puts "MEM status:\n#{tc_diag_mem_status}".to_gbk
										# assert_match(/内存总量\s*：\s*[1-9]+\d*\s*M/m, tc_diag_mem_status, "显示内存总大小类型异常")
										# assert_match(/可用内存\s*：\s*[1-9]+\d*\s*M/m, tc_diag_mem_status, "显示可用内存异常")
										# assert_match(/缓存内存\s*：\s*[1-9]+\d*\s*M/m, tc_diag_mem_status, "显示缓存空间异常")
						rescue => ex1
								report_image1 = log_path+"/block_page_images/#{n+1}_ex1.png"
								save_screenshot(@browser, report_image1) #截图
								err = ex1.message.to_s
								print ex1.backtrace.join("\n")
								print("\n")
						ensure
								begin
										@tc_handles = @browser.driver.window_handles
										if @tc_handles.size > 1
												@browser.driver.switch_to.window(@tc_handles[0])
										end
										wan_page = RouterPageObject::WanPage.new(@browser)
										wan_page.set_dhcp(@browser, @browser.url)
								rescue => ex2
										report_image2 = log_path+"/block_page_images/#{n+1}_ex2.png"
										save_screenshot(@browser, report_image2) #截图
										err = ex2.message.to_s
										print ex2.backtrace.join("\n")
										print("\n")
								ensure
										@browser.close
								end
								p "==========================================================================="
						end
				end
		end

		#WAN口配置出现白板
		def testwhite_page
				url          = "192.168.100.1"
				usrname      = "admin"
				passwd       = "admin"
				pppoe_usr    = "pppoe@163.gd"
				pppoe_pwd    = "PPPOETEST"
				@browser     = Watir::Browser.new :firefox, :profile => "default"
				@wan_page    = RouterPageObject::WanPage.new(@browser)
				@sys_page    = RouterPageObject::SystatusPage.new(@browser)
				@option_page = RouterPageObject::OptionsPage.new(@browser)
				@wan_page.login_with(usrname, passwd, url)

				log_path     = "E:/autotest/frame/reports/white_page"
				report_fpath = log_path + "/white_page.log"
				stdio(report_fpath, time)
				100.times do |n|
						begin
								@wan_page.set_pppoe(pppoe_usr, pppoe_pwd, @browser.url)
								@sys_page.open_systatus_page(@browser.url) #打开系统状态
								pppoe_ip = @sys_page.get_wan_ip
								p "第#{n+1}次pppoe拨号获取wan口ip地址：#{pppoe_ip}".to_gbk
								@option_page.open_options_page(@browser.url)
								@wan_page.set_dhcp(@browser, @browser.url)
								@sys_page.open_systatus_page(@browser.url) #打开系统状态
								dhcp_ip = @sys_page.get_wan_ip
								p "第#{n+1}次dhcp拨号获取wan口ip地址：#{dhcp_ip}".to_gbk
								@option_page.open_options_page(@browser.url)
						rescue => ex1
								report_image1 = log_path+"/images/#{n+1}.png"
								save_screenshot(@browser, report_image1, time) #截图
								err = ex1.message.to_s
								print ex1.backtrace.join("\n")
								print("\n")
						ensure
								p "==========================================================================="
						end
				end
		end
end