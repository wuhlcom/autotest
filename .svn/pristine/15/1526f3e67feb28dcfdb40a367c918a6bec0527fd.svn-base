#encoding:utf-8
#
# 路由器诊断页面
# author:wuhongliang
# date:2016-03-24
# modify:
#
file_path1 =File.expand_path('../router_main_page', __FILE__)
require file_path1
module RouterPageObject

		module Diagnose_Page
				include PageObject
				h1(:detect_rs, id: @@ts_tag_diag_detect) #检测结果
				span(:the_3g, id: @@ts_tag_diag_3gdial_status) #3g拨号信息
				span(:wan_conn, id: @@ts_tag_diag_wan_status) #WAN口连接状态
				span(:net_status, id: @@ts_tag_diag_internet_status) #外网连接状态
				span(:net_speed, id: @@ts_tag_diag_netspeed_status) #连接速度状态
				span(:route_status, id: @@ts_tag_diag_hardware_status) #路由器硬件状态
				div(:mem_status, xpath: @@ts_tag_diag_mem_xpath) #内存信息
				div(:cpu_status, xpath: @@ts_tag_diag_cpu_xpath) #处理器信息
				link(:rediag, id: @@ts_tag_rediag) #重新诊断
				link(:diagadv, id: @@ts_tag_ad_diagnose) #高级诊断
		end

		class DiagnosePage < MainPage
				include Diagnose_Page
				#初始化页面为诊断页面
				def initialize_diag(browserobj, detect_time=60)
						@browserobj  =browserobj
						self.refresh
						self.netdect_page
						router_diaging="路由器正在检测中"
						puts "sleeping #{detect_time} seconds for diagnose..."
						sleep detect_time
						#得个@browserobj对象下各个窗口对象的句柄对象
						@tc_handles = @browserobj.driver.window_handles
						#通过句柄来切换不同的windows窗口
						@browserobj.driver.switch_to.window(@tc_handles[1])
						sleep 2
				end

				#切换页面
				def switch_page(num)
						@browserobj.driver.switch_to.window(@tc_handles[num])
				end

				def rediagnose(detect_time=90)
						self.rediag
						puts "sleeping #{detect_time} seconds for rediagnose..."
						sleep detect_time
				end

		end

end

