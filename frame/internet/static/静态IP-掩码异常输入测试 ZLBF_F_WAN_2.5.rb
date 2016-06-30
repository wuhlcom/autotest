#
# description:
# author:wuhongliang
# bug ������������Ϊȫ0Ҳ�ܱ���
# date:2015-11-05 14:00:18
# modify:
#
testcase {
		attr = {"id" => "ZLBF_6.1.17", "level" => "P3", "auto" => "n"}

		def prepare
				@tc_nomask          = "��������������"
				@tc_mask_format_err = "���������ʽ����ȷ"
				@tc_static_time     = 40
				@tc_wait_time       = 2
				@tc_flag            = false
		end

		def process

				operate("1�����������봦����255.255.255.255��0.0.0.0���Ƿ��������룻") {
						@wan_page = RouterPageObject::WanPage.new(@browser)
						puts "���ý��뷽ʽΪ��̬����".to_gbk
						@wan_page.select_static(@browser.url)

						#����յ�ַ
						tc_staticNetmask =""
						puts "���������ַΪ��".encode("GBK")
						@wan_page.static_ip_element.click #����Ԫ�ص�������Է�����ʧ��
						@wan_page.static_ip = @ts_staticIp

						@wan_page.static_netmask_element.click
						@wan_page.static_netmask = tc_staticNetmask

						@wan_page.static_gateway_element.click
						@wan_page.static_gateway = @ts_staticGateway

						@wan_page.static_dns_element.click
						@wan_page.static_dns = @ts_staticPriDns
						@wan_page.save
						sleep @tc_wait_time

						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO��#{error_tip}".encode("GBK")
						unless error_tip==@tc_nomask
								@tc_flag = true
						end
						assert_equal(@tc_nomask, error_tip, "������ʾ���ݲ���ȷ!")

						#����յ�ַ
						tc_staticNetmask =" "
						puts "���������ַΪ�ո�".encode("GBK")
						@wan_page.static_netmask_element.click
						@wan_page.static_netmask = tc_staticNetmask
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO��#{error_tip}".encode("GBK")
						unless error_tip==@tc_mask_format_err
								@tc_flag = true
						end
						assert_equal(@tc_mask_format_err, error_tip, "������ʾ���ݲ���ȷ!")

						tc_staticNetmask ="255.255.255.255"
						puts "���������ַΪ#{tc_staticNetmask}".encode("GBK")
						@wan_page.static_netmask_element.click
						@wan_page.static_netmask = tc_staticNetmask
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO��#{error_tip}".encode("GBK")
						unless error_tip==@tc_mask_format_err
								@tc_flag = true
						end
						assert_equal(@tc_mask_format_err, error_tip, "������ʾ���ݲ���ȷ!")

						tc_staticNetmask ="0.0.0.0"
						puts "���������ַΪ#{tc_staticNetmask}".encode("GBK")
						@wan_page.static_netmask_element.click
						@wan_page.static_netmask = tc_staticNetmask
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO��#{error_tip}".encode("GBK")
						unless error_tip==@tc_mask_format_err
								@tc_flag = true
						end
						assert_equal(@tc_mask_format_err, error_tip, "������ʾ���ݲ���ȷ!")
				}

				operate("2�����������봦��������Ҳ�����Ϊ1�ĵ�ַ���磺255.0.255.0,255.128.255.0���Ƿ�������룻") {
						tc_staticNetmask ="0.255.255.0"
						puts "���������ַΪ#{tc_staticNetmask}".encode("GBK")
						@wan_page.static_netmask_element.click
						@wan_page.static_netmask = tc_staticNetmask
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO��#{error_tip}".encode("GBK")
						unless error_tip==@tc_mask_format_err
								@tc_flag = true
						end
						assert_equal(@tc_mask_format_err, error_tip, "������ʾ���ݲ���ȷ!")

						tc_staticNetmask ="255.0.255.0"
						puts "���������ַΪ#{tc_staticNetmask}".encode("GBK")
						@wan_page.static_netmask_element.click
						@wan_page.static_netmask = tc_staticNetmask
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO��#{error_tip}".encode("GBK")
						unless error_tip==@tc_mask_format_err
								@tc_flag = true
						end
						assert_equal(@tc_mask_format_err, error_tip, "������ʾ���ݲ���ȷ!")

						tc_staticNetmask ="255.128.255.0"
						puts "���������ַΪ#{tc_staticNetmask}".encode("GBK")
						@wan_page.static_netmask_element.click
						@wan_page.static_netmask = tc_staticNetmask
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO��#{error_tip}".encode("GBK")
						unless error_tip==@tc_mask_format_err
								@tc_flag = true
						end
						assert_equal(@tc_mask_format_err, error_tip, "������ʾ���ݲ���ȷ!")
				}

				operate("3��������������������ʽ��ַ����256.255.255.255��a.a.a.a�ȣ�") {
						tc_staticNetmask ="256.255.255.0"
						puts "���������ַΪ#{tc_staticNetmask}".encode("GBK")
						@wan_page.static_netmask_element.click
						@wan_page.static_netmask = tc_staticNetmask
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO��#{error_tip}".encode("GBK")
						unless error_tip==@tc_mask_format_err
								@tc_flag = true
						end
						assert_equal(@tc_mask_format_err, error_tip, "������ʾ���ݲ���ȷ!")

						tc_staticNetmask ="255.256.255.0"
						puts "���������ַΪ#{tc_staticNetmask}".encode("GBK")
						@wan_page.static_netmask_element.click
						@wan_page.static_netmask = tc_staticNetmask
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO��#{error_tip}".encode("GBK")
						unless error_tip==@tc_mask_format_err
								@tc_flag = true
						end
						assert_equal(@tc_mask_format_err, error_tip, "������ʾ���ݲ���ȷ!")

						tc_staticNetmask ="255.255.256.0"
						puts "���������ַΪ#{tc_staticNetmask}".encode("GBK")
						@wan_page.static_netmask_element.click
						@wan_page.static_netmask = tc_staticNetmask
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO��#{error_tip}".encode("GBK")
						unless error_tip==@tc_mask_format_err
								@tc_flag = true
						end
						assert_equal(@tc_mask_format_err, error_tip, "������ʾ���ݲ���ȷ!")

						tc_staticNetmask ="a.255.255.0"
						puts "���������ַΪ#{tc_staticNetmask}".encode("GBK")
						@wan_page.static_netmask_element.click
						@wan_page.static_netmask = tc_staticNetmask
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO��#{error_tip}".encode("GBK")
						unless error_tip==@tc_mask_format_err
								@tc_flag = true
						end
						assert_equal(@tc_mask_format_err, error_tip, "������ʾ���ݲ���ȷ!")

						tc_staticNetmask ="255.a.255.0"
						puts "���������ַΪ#{tc_staticNetmask}".encode("GBK")
						@wan_page.static_netmask_element.click
						@wan_page.static_netmask = tc_staticNetmask
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO��#{error_tip}".encode("GBK")
						unless error_tip==@tc_mask_format_err
								@tc_flag = true
						end
						assert_equal(@tc_mask_format_err, error_tip, "������ʾ���ݲ���ȷ!")

						tc_staticNetmask ="yanma"
						puts "���������ַΪ#{tc_staticNetmask}".encode("GBK")
						@wan_page.static_netmask_element.click
						@wan_page.static_netmask = tc_staticNetmask
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO��#{error_tip}".encode("GBK")
						unless error_tip==@tc_mask_format_err
								@tc_flag = true
						end
						assert_equal(@tc_mask_format_err, error_tip, "������ʾ���ݲ���ȷ!")

						tc_staticNetmask ="a.a.a.0"
						puts "���������ַΪ#{tc_staticNetmask}".encode("GBK")
						@wan_page.static_netmask_element.click
						@wan_page.static_netmask = tc_staticNetmask
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO��#{error_tip}".encode("GBK")
						unless error_tip==@tc_mask_format_err
								@tc_flag = true
						end
						assert_equal(@tc_mask_format_err, error_tip, "������ʾ���ݲ���ȷ!")
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
