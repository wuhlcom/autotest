#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:18
# modify:
#
testcase {
		attr = {"id" => "ZLBF_6.1.19", "level" => "P4", "auto" => "n"}

		def prepare
				@tc_nodns          = "������DNS"
				@tc_dns_format_err = "DNS ��ʽ����"
				@tc_wait_time      = 1
				@tc_static_time    = 35
				@tc_flag           = false
		end

		def process

				operate("1��ѡ��̬IP���ŷ�ʽ��") {
						@wan_page = RouterPageObject::WanPage.new(@browser)
						puts "���ý��뷽ʽΪStatic".to_gbk
						@wan_page.select_static(@browser.url)
				}

				operate("2����DNS��ַ����0��ͷ��ַ����0��β��ַ���磺0.0.0.0��10.0.0.0�Ƿ��������룻") {
						@wan_page.static_ip_element.click #����Ԫ�ص�������Է�����ʧ��
						@wan_page.static_ip = @ts_staticIp

						@wan_page.static_netmask_element.click
						@wan_page.static_netmask = @ts_staticNetmask

						@wan_page.static_gateway_element.click
						@wan_page.static_gateway = @ts_staticGateway

						#��DNS����
						tc_staticPriDns          =""
						puts "������DNSΪ��".encode("GBK")
						@wan_page.static_dns_element.click
						@wan_page.static_dns = tc_staticPriDns
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO��#{error_tip}".encode("GBK")
						unless error_tip == @tc_nodns
								@tc_flag = true
						end
						assert_equal(@tc_nodns, error_tip, "������ʾ���ݲ���ȷ!")

						tc_staticPriDns =" "
						puts "������DNSΪ�ո�".encode("GBK")
						@wan_page.static_dns_element.click
						@wan_page.static_dns = tc_staticPriDns
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO��#{error_tip}".encode("GBK")
						unless error_tip == @tc_dns_format_err
								@tc_flag = true
						end
						assert_equal(@tc_dns_format_err, error_tip, "������ʾ���ݲ���ȷ!")

						tc_staticPriDns ="0.0.0.0"
						puts "������DNSΪ#{tc_staticPriDns}".encode("GBK")
						@wan_page.static_dns_element.click
						@wan_page.static_dns = tc_staticPriDns
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO��#{error_tip}".encode("GBK")
						unless error_tip == @tc_dns_format_err
								@tc_flag = true
						end
						assert_equal(@tc_dns_format_err, error_tip, "������ʾ���ݲ���ȷ!")

						tc_staticPriDns ="255.255.255.255"
						puts "������DNSΪ#{tc_staticPriDns}".encode("GBK")
						@wan_page.static_dns_element.click
						@wan_page.static_dns = tc_staticPriDns
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO��#{error_tip}".encode("GBK")
						unless error_tip == @tc_dns_format_err
								@tc_flag = true
						end
						assert_equal(@tc_dns_format_err, error_tip, "������ʾ���ݲ���ȷ!")

						tc_staticPriDns ="0.10.10.1"
						puts "������DNSΪ#{tc_staticPriDns}".encode("GBK")
						@wan_page.static_dns_element.click
						@wan_page.static_dns = tc_staticPriDns
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO��#{error_tip}".encode("GBK")
						unless error_tip == @tc_dns_format_err
								@tc_flag = true
						end
						assert_equal(@tc_dns_format_err, error_tip, "������ʾ���ݲ���ȷ!")

						tc_staticPriDns ="10.10.10.255"
						puts "������DNSΪ#{tc_staticPriDns}".encode("GBK")
						@wan_page.static_dns_element.click
						@wan_page.static_dns = tc_staticPriDns
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO��#{error_tip}".encode("GBK")
						unless error_tip == @tc_dns_format_err
								@tc_flag = true
						end
						assert_equal(@tc_dns_format_err, error_tip, "������ʾ���ݲ���ȷ!")

						tc_staticPriDns ="10.10.10.0"
						puts "������DNSΪ#{tc_staticPriDns}".encode("GBK")
						@wan_page.static_dns_element.click
						@wan_page.static_dns = tc_staticPriDns
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO��#{error_tip}".encode("GBK")
						unless error_tip == @tc_dns_format_err
								@tc_flag = true
						end
						assert_equal(@tc_dns_format_err, error_tip, "������ʾ���ݲ���ȷ!")
				}

				operate("3��DNS��ַ�����鲥��ַ����239.1.1.1���Ƿ��������룻") {
						tc_staticPriDns ="224.10.10.1"
						puts "������DNSΪ#{tc_staticPriDns}".encode("GBK")
						@wan_page.static_dns_element.click
						@wan_page.static_dns = tc_staticPriDns
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO��#{error_tip}".encode("GBK")
						unless error_tip == @tc_dns_format_err
								@tc_flag = true
						end
						assert_equal(@tc_dns_format_err, error_tip, "������ʾ���ݲ���ȷ!")
				}

				operate("4��DNS��ַ����E���ַ����240.1.1.1���Ƿ��������룻") {
						tc_staticPriDns ="240.10.10.1"
						puts "������DNSΪ#{tc_staticPriDns}".encode("GBK")
						@wan_page.static_dns_element.click
						@wan_page.static_dns = tc_staticPriDns
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO��#{error_tip}".encode("GBK")
						unless error_tip == @tc_dns_format_err
								@tc_flag = true
						end
						assert_equal(@tc_dns_format_err, error_tip, "������ʾ���ݲ���ȷ!")
				}

				operate("5��DNS��ַ���뻷�ص�ַ����127��ͷ�ĵ�ַ����127.0.0.1���Ƿ��������룻") {
						tc_staticPriDns ="127.10.10.1"
						puts "������DNSΪ#{tc_staticPriDns}".encode("GBK")
						@wan_page.static_dns_element.click
						@wan_page.static_dns = tc_staticPriDns
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO��#{error_tip}".encode("GBK")
						unless error_tip == @tc_dns_format_err
								@tc_flag = true
						end
						assert_equal(@tc_dns_format_err, error_tip, "������ʾ���ݲ���ȷ!")
				}

				operate("6��DNS��ַ��������ʽ��ַ����192.168.10��192.168.10.256��a.a.a.a�ȣ�") {
						tc_staticPriDns ="10.10.10"
						puts "������DNSΪ#{tc_staticPriDns}".encode("GBK")
						@wan_page.static_dns_element.click
						@wan_page.static_dns = tc_staticPriDns
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO��#{error_tip}".encode("GBK")
						unless error_tip == @tc_dns_format_err
								@tc_flag = true
						end
						assert_equal(@tc_dns_format_err, error_tip, "������ʾ���ݲ���ȷ!")

						tc_staticPriDns ="a.10.10.1"
						puts "������DNSΪ#{tc_staticPriDns}".encode("GBK")
						@wan_page.static_dns_element.click
						@wan_page.static_dns = tc_staticPriDns
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO��#{error_tip}".encode("GBK")
						unless error_tip == @tc_dns_format_err
								@tc_flag = true
						end
						assert_equal(@tc_dns_format_err, error_tip, "������ʾ���ݲ���ȷ!")

						tc_staticPriDns ="10.x.10.1"
						puts "������DNSΪ#{tc_staticPriDns}".encode("GBK")
						@wan_page.static_dns_element.click
						@wan_page.static_dns = tc_staticPriDns
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO��#{error_tip}".encode("GBK")
						unless error_tip == @tc_dns_format_err
								@tc_flag = true
						end
						assert_equal(@tc_dns_format_err, error_tip, "������ʾ���ݲ���ȷ!")

						tc_staticPriDns ="10.10.c.1"
						puts "������DNSΪ#{tc_staticPriDns}".encode("GBK")
						@wan_page.static_dns_element.click
						@wan_page.static_dns = tc_staticPriDns
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO��#{error_tip}".encode("GBK")
						unless error_tip == @tc_dns_format_err
								@tc_flag = true
						end
						assert_equal(@tc_dns_format_err, error_tip, "������ʾ���ݲ���ȷ!")

						tc_staticPriDns ="10.10.10.f"
						puts "������DNSΪ#{tc_staticPriDns}".encode("GBK")
						@wan_page.static_dns_element.click
						@wan_page.static_dns = tc_staticPriDns
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO��#{error_tip}".encode("GBK")
						unless error_tip == @tc_dns_format_err
								@tc_flag = true
						end
						assert_equal(@tc_dns_format_err, error_tip, "������ʾ���ݲ���ȷ!")

						tc_staticPriDns ="maindns"
						puts "������DNSΪ#{tc_staticPriDns}".encode("GBK")
						@wan_page.static_dns_element.click
						@wan_page.static_dns = tc_staticPriDns
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO��#{error_tip}".encode("GBK")
						unless error_tip == @tc_dns_format_err
								@tc_flag = true
						end
						assert_equal(@tc_dns_format_err, error_tip, "������ʾ���ݲ���ȷ!")
				}

				operate("������ڴ�DNS�����Դ�DNS") {
						# if @wan_iframe.text_field(:id, @ts_tag_backupDns).exists?
						# end
				}


		end

		def clearup

				operate("1 �ָ�Ĭ�Ϸ�ʽ:DHCP") {
						if @tc_flag
								sleep @tc_static_time
						end
						@wan_page = RouterPageObject::WanPage.new(@browser)
						@wan_page.set_dhcp(@browser, @browser.url)
				}

		end

}
