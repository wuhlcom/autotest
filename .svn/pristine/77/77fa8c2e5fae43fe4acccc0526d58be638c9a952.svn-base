#encoding:utf-8
#
# 路由器诊断页面
# author:wuhongliang
# date:2016-03-24
# modify:
#
# file_path1 =File.expand_path('../router_main_page', __FILE__)
file_path2 =File.expand_path('../router_diagnose_page', __FILE__)
# require file_path1
require file_path2
module RouterPageObject

		module DiagnoseAdv_Page
				include PageObject
				text_field(:url_addr, id: @@ts_tag_url)
				button(:check, id: @@ts_tag_diag_btn)
				paragraph(:wan_type, text: /#{@@ts_tag_diag_nettype}/)
				paragraph(:net_status, text: /#{@@ts_tag_net_status}/)
				paragraph(:domain_ip, text: /#{@@ts_tag_domain_ip}/)
				paragraph(:gw_loss, text: /#{@@ts_tag_loss}/)
				paragraph(:dns_parse, text: /#{@@ts_tag_dns}/)
				paragraph(:http_code, text: /#{@@ts_tag_http_status}/)
				div(:diagnoseadv_err, class_name: @@ts_tag_ad_diagnose_err)
		end

		class DiagnoseAdvPage < DiagnosePage
				include DiagnoseAdv_Page

				#初始化页面为诊断页面
				def initialize_diagadv(browserobj, detect_time=60)
						@browserobj  =browserobj
						main_page = MainPage.new(@browserobj)
						main_page.netdect_page
						#得个@browserobj对象下各个窗口对象的句柄对象
						tc_handles = @browserobj.driver.window_handles
						#通过句柄来切换不同的windows窗口
						@browserobj.driver.switch_to.window(tc_handles[1])
						sleep 2
						self.navigate_to(@browserobj.url)
						self.diagadv
						@tc_handles = @browserobj.driver.window_handles
				end

				def advdiag(detect_time=30)
						self.check
						puts "sleeping #{detect_time} seconds for adv diagnose..."
						sleep detect_time
				end

		end

end

