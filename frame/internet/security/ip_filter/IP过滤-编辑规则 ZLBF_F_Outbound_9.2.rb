#
# description:
# author:liluping
# date:2015-11-05 14:00:19
# modify:
#
testcase {
		attr = {"id" => "ZLBF_15.1.19", "level" => "P2", "auto" => "n"}

		def prepare
				@tc_wait_time = 5
				@tc_port      = 80
				@tc_port_new  = 90
		end

		def process

				operate("1、DUT的接入类型选择为DHCP，保存配置；") {
						@wan_page = RouterPageObject::WanPage.new(@browser)
						@wan_page.set_dhcp(@browser, @browser.url)
				}

				operate("2、进入到安全设置的防火墙设置界面，开启防火墙总开关和IP过虑开关，在IP过虑界面添加规则，添加一条IP过滤，设置源IP为192.168.100.100，端口为80，协议为TCP，保存配置；") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.open_security_setting(@browser.url) #打开安全界面
						@options_page.firewall_click
						@options_page.open_switch("on", "on", "off", "off")
						@options_page.ipfilter_click
						@options_page.ip_add_item_element.click
						@options_page.ip_filter_dst_port_input(@tc_port, @tc_port)
						@options_page.ip_filter_save
				}

				operate("3、在PC1上用数据包生成器（如科来数据包生成器、IPTEST）构建TCP的数据包，端口为80，源IP地址为：192.168.100.100，PC2上是否能抓到PC1上发出的数据包；") {
						begin
								rs = HtmlTag::TestHttpClient.new(@ts_wan_pppoe_httpip, '/', @tc_port).get
						rescue => ex
								p "向#{@ts_wan_pppoe_httpip}的#{@tc_port}端口发送请求时出现异常".to_gbk
								p "具体异常信息是：#{ex.message}".to_gbk
						end
						puts "http请求返回值为：#{rs}".to_gbk
						assert(rs.nil?, "端口过滤失败，#{@ts_wan_pppoe_httpport}端口被过滤后，依然能收到请求响应！")
				}

				operate("4、编辑步骤2，修改过滤规则，修改过滤端口为90，保存；") {
						@options_page.ip_filter_table_element.element.trs[1][7].link(class_name: @ts_tag_edit).image.click #编辑第一条规则
						@options_page.dst_port_start1 = @tc_port_new
						@options_page.dst_port_end1   = @tc_port_new
						@options_page.ip_save1
						sleep @tc_wait_time
				}

				operate("5、重复步骤3，查看测试结果；") {
						begin
								rs = HtmlTag::TestHttpClient.new(@ts_wan_pppoe_httpip, '/', @ts_wan_pppoe_httpport).get
						rescue => ex
								p "向#{@ts_wan_pppoe_httpip}的#{@tc_port}端口发送请求时出现异常".to_gbk
								p "具体异常信息是：#{ex.message}".to_gbk
						end
						puts "http请求返回值为：#{rs}".to_gbk
						assert_match("succeed", rs, "端口过滤失败，#{@tc_port_new}端口被过滤后，向#{@tc_port}端口发送http请求时无法获得响应！")
				}

		end

		def clearup
				operate("1 关闭防火墙总开关和IP过滤开关并删除所有配置") {
						options_page = RouterPageObject::OptionsPage.new(@browser)
						options_page.ipfilter_close_sw_del_all_step(@browser.url)
				}
		end

}
