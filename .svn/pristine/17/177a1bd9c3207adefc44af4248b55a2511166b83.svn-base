#
# description:
# https不支持不需要测试
# author:wuhongliang
# date:2015-11-05 14:00:18
# modify:
#
testcase {
		attr = {"id" => "ZLBF_4.1.17", "level" => "P3", "auto" => "n"}

		def prepare

		end

		def process

				operate("1、外网连接正常，进入高级诊断") {
						@wan_page = RouterPageObject::WanPage.new(@browser)
						@wan_page.set_dhcp(@browser, @browser.url)
						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end

						@diagnose_page = RouterPageObject::DiagnoseAdvPage.new(@browser)
						@diagnose_page.initialize_diagadv(@browser)
						@diagnose_page.switch_page(1) #切换到诊断窗口
				}

				# operate("2、输入以https开头的网站，例如输入https://www.alipay.com/，点击检测") {
				# 	不支持
				# }
				operate("3、输入字符串较长的网站，例如输入http://baike.baidu.com/link?url=va6Pw5uCurOvD54K-coiCfRYYmvuEge30n3z50CqQm9U7fJPGxpEldyg3hTMU7x3a_O-pOARUQfKTqhivBQoa_，点击检测") {
						tc_http_url = "http://baike.baidu.com/link?url=va6Pw5uCurOvD54K-coiCfRYYmvuEge30n3z50CqQm9U7fJPGxpEldyg3hTMU7x3a_O-pOARUQfKTqhivBQoa_"
						puts "输入URL为：#{tc_http_url}".encode("GBK")
						@diagnose_page.url_addr = tc_http_url
						sleep 1
						@diagnose_page.advdiag(60)

						tc_net_type = @diagnose_page.wan_type_element.element.span.text
						puts "上网连接类型：#{tc_net_type}".to_gbk
						assert_equal(@ts_wan_mode_dhcp, tc_net_type, "上网连接类型错误")
						tc_net_status = @diagnose_page.net_status_element.element.span.text
						puts "WAN口连接状态：#{tc_net_status}".to_gbk
						assert_equal(@ts_net_link, tc_net_status, "上网连接状态异常")
						tc_net_domain_ip = @diagnose_page.domain_ip_element.element.span.text
						puts "域名：#{@ts_diag_web}，解析结果：#{tc_net_domain_ip}".to_gbk
						assert_match(@ts_ip_reg, tc_net_domain_ip, "域名解析失败")
						tc_loss_rate = @diagnose_page.gw_loss_element.element.span.text
						puts "诊断过程丢包率为：#{tc_loss_rate}".to_gbk
						assert_equal(@ts_loss_rate, tc_loss_rate, "诊断过程丢包过多")
						tc_dns_status = @diagnose_page.dns_parse_element.element.span.text
						puts "DNS解析状态：#{tc_dns_status}".to_gbk
						assert_equal(@ts_dns_status, tc_dns_status, "DNS解析失败")
						tc_http_code = @diagnose_page.http_code_element.element.span.text
						puts "HTTP响应码：#{tc_http_code}".to_gbk
						assert_equal(@ts_http_status, tc_http_code, "HTTP响应错误")
				}

				operate("4、输入http开头的url为IP地址的网站，例如http://58.217.200.37,点击检测") {
						tc_http_ip = "http://58.217.200.37"
						puts "输入URL为：#{tc_http_ip}".encode("GBK")
						@diagnose_page.url_addr = tc_http_ip
						sleep 1
						@diagnose_page.advdiag(60)

						tc_net_type = @diagnose_page.wan_type_element.element.span.text
						puts "上网连接类型：#{tc_net_type}".to_gbk
						assert_equal(@ts_wan_mode_dhcp, tc_net_type, "上网连接类型错误")
						tc_net_status = @diagnose_page.net_status_element.element.span.text
						puts "WAN口连接状态：#{tc_net_status}".to_gbk
						assert_equal(@ts_net_link, tc_net_status, "上网连接状态异常")
						tc_net_domain_ip = @diagnose_page.domain_ip_element.element.span.text
						puts "域名：#{@ts_diag_web}，解析结果：#{tc_net_domain_ip}".to_gbk
						assert_match(@ts_ip_reg, tc_net_domain_ip, "域名解析失败")
						tc_loss_rate = @diagnose_page.gw_loss_element.element.span.text
						puts "诊断过程丢包率为：#{tc_loss_rate}".to_gbk
						assert_equal(@ts_loss_rate, tc_loss_rate, "诊断过程丢包过多")
						tc_dns_status = @diagnose_page.dns_parse_element.element.span.text
						puts "DNS解析状态：#{tc_dns_status}".to_gbk
						assert_equal(@ts_dns_status, tc_dns_status, "DNS解析失败")
						tc_http_code = @diagnose_page.http_code_element.element.span.text
						puts "HTTP响应码：#{tc_http_code}".to_gbk
						assert_equal(@ts_http_status, tc_http_code, "HTTP响应错误")
				}

		end

		def clearup

		end

}
