#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:18
# modify:
#
testcase {
		attr = {"id" => "ZLBF_6.1.16", "level" => "P3", "auto" => "n"}

		def prepare
				@tc_noip_tip     = "������ IP ��ַ"
				@tc_ip_error_tip = "IP��ַ��ʽ����"
				@tc_static_time  = 70
				@tc_wait_time    = 1
				@tc_flag         = false
		end

		def process

				operate("1��ѡ��̬IP���ŷ�ʽ��") {
						@wan_page = RouterPageObject::WanPage.new(@browser)
						puts "���ý��뷽ʽΪStatic".to_gbk
						@wan_page.select_static(@browser.url)
				}

				operate("2����IP��ַ����0��ͷ��ַ����0��β��ַ���磺0.0.0.0��10.0.0.0�Ƿ��������룻") {
						#����յ�ַ
						tc_staticIp =""
						puts "����IP��ַΪ��".encode("GBK")
						@wan_page.static_ip_element.click #����Ԫ�ص�������Է�����ʧ��
						@wan_page.static_ip = tc_staticIp

						@wan_page.static_netmask_element.click
						@wan_page.static_netmask = @ts_staticNetmask

						@wan_page.static_gateway_element.click
						@wan_page.static_gateway = @ts_staticGateway

						@wan_page.static_dns_element.click
						@wan_page.static_dns = @ts_staticPriDns

						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO��#{error_tip}".encode("GBK")
						unless error_tip==@tc_noip_tip
								@tc_flag = true
						end
						assert_equal(@tc_noip_tip, error_tip, "������ʾ���ݲ���ȷ!")

						#����ո�
						tc_staticIp =" "
						puts "����IP��ַΪ�ո�".encode("GBK")
						@wan_page.static_ip_element.click #����Ԫ�ص�������Է�����ʧ��
						@wan_page.static_ip = tc_staticIp
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO��#{error_tip}".encode("GBK")
						unless error_tip==@tc_ip_error_tip
								@tc_flag = true
						end
						assert_equal(@tc_ip_error_tip, error_tip, "������ʾ���ݲ���ȷ!")

						#0��ͷ
						tc_staticIp="0.10.10.2"
						puts "����IP��ַΪ:#{tc_staticIp}".encode("GBK")
						@wan_page.static_ip_element.click #����Ԫ�ص�������Է�����ʧ��
						@wan_page.static_ip = tc_staticIp
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO��#{error_tip}".encode("GBK")
						unless error_tip==@tc_ip_error_tip
								@tc_flag = true
						end
						assert_equal(@tc_ip_error_tip, error_tip, "������ʾ���ݲ���ȷ!")

						#���Ա߽磬1��ͷ
						tc_staticIp     = "1.10.10.2"
						tc_staticGateway= "1.10.10.1"
						puts "����IP��ַΪ:#{tc_staticIp}".encode("GBK")
						puts "��������ΪΪ:#{tc_staticGateway}".encode("GBK")
						@wan_page.static_ip_element.click #����Ԫ�ص�������Է�����ʧ��
						@wan_page.static_ip = tc_staticIp

						@wan_page.static_gateway_element.click
						@wan_page.static_gateway = tc_staticGateway
						@wan_page.save
						sleep @tc_static_time

						@systatus_page = RouterPageObject::SystatusPage.new(@browser)
						@systatus_page.open_systatus_page(@browser.url)
						wan_type = @systatus_page.get_wan_type
						wan_addr = @systatus_page.get_wan_ip
						wan_gw   = @systatus_page.get_wan_gw
						puts "��ѯ��WAN���뷽ʽΪ#{wan_type}".to_gbk
						puts "��ѯ��WAN IPΪ#{wan_addr}".to_gbk
						puts "��ѯ��WAN����IPΪ#{wan_gw}".to_gbk
						assert_equal(tc_staticIp, wan_addr, "��̬IP#{tc_staticIp}����ʧ��!")
						assert_equal(tc_staticGateway, wan_gw, "��̬IP����#{tc_staticGateway}ʧ�ܣ�")
						assert_match /#{@ts_wan_mode_static}/, wan_type, '�������ʹ���'

						#���Ա߽�:�׷ֶ����223
						tc_staticIp     = "223.10.10.2"
						tc_staticGateway= "223.10.10.1"
						puts "����IP��ַΪ:#{tc_staticIp}".encode("GBK")
						puts "��������ΪΪ:#{tc_staticGateway}".encode("GBK")
						@wan_page.select_static(@browser.url)
						@wan_page.static_ip_element.click #����Ԫ�ص�������Է�����ʧ��
						@wan_page.static_ip = tc_staticIp

						@wan_page.static_gateway_element.click
						@wan_page.static_gateway = tc_staticGateway
						@wan_page.save
						sleep @tc_static_time

						@systatus_page.open_systatus_page(@browser.url)
						wan_type = @systatus_page.get_wan_type
						wan_addr = @systatus_page.get_wan_ip
						wan_gw   = @systatus_page.get_wan_gw
						puts "��ѯ��WAN���뷽ʽΪ#{wan_type}".to_gbk
						puts "��ѯ��WAN IPΪ#{wan_addr}".to_gbk
						puts "��ѯ��WAN����IPΪ#{wan_gw}".to_gbk
						assert_equal(tc_staticIp, wan_addr, "��̬IP#{tc_staticIp}����ʧ��!")
						assert_equal(tc_staticGateway, wan_gw, "��̬IP����#{tc_staticGateway}ʧ�ܣ�")
						assert_match /#{@ts_wan_mode_static}/, wan_type, '�������ʹ���'

						#�������ֵ������224
						tc_staticIp = "224.10.10.2"
						puts "����IP��ַΪ:#{tc_staticIp}".encode("GBK")
						@wan_page.select_static(@browser.url)
						@wan_page.static_ip_element.click #����Ԫ�ص�������Է�����ʧ��
						@wan_page.static_ip = tc_staticIp
						@wan_page.save

						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO��#{error_tip}".encode("GBK")
						unless error_tip==@tc_ip_error_tip
								@tc_flag = true
						end
						assert_equal(@tc_ip_error_tip, error_tip, "������ʾ���ݲ���ȷ!")

						#ĩβ����0
						tc_staticIp= "10.10.10.0"
						puts "����IP��ַΪ:#{tc_staticIp}".encode("GBK")
						@wan_page.static_ip_element.click #����Ԫ�ص�������Է�����ʧ��
						@wan_page.static_ip = tc_staticIp
						@wan_page.save
						sleep @tc_wait_time

						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO��#{error_tip}".encode("GBK")
						unless error_tip==@tc_ip_error_tip
								@tc_flag = true
						end
						assert_equal(@tc_ip_error_tip, error_tip, "������ʾ���ݲ���ȷ!")

						#���� 255
						tc_staticIp= "10.10.10.255"
						puts "����IP��ַΪ:#{tc_staticIp}".encode("GBK")
						@wan_page.static_ip_element.click #����Ԫ�ص�������Է�����ʧ��
						@wan_page.static_ip = tc_staticIp
						@wan_page.save
						sleep @tc_wait_time

						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO��#{error_tip}".encode("GBK")
						unless error_tip==@tc_ip_error_tip
								@tc_flag = true
						end
						assert_equal(@tc_ip_error_tip, error_tip, "������ʾ���ݲ���ȷ!")

						#���� 254
						tc_staticIp     = "10.10.10.254"
						tc_staticGateway= "10.10.10.1"
						puts "����IP��ַΪ:#{tc_staticIp}".encode("GBK")
						puts "�������ص�ַΪ:#{tc_staticGateway}".encode("GBK")
						@wan_page.static_ip_element.click #����Ԫ�ص�������Է�����ʧ��
						@wan_page.static_ip = tc_staticIp

						@wan_page.static_gateway_element.click
						@wan_page.static_gateway = tc_staticGateway
						@wan_page.save
						sleep @tc_static_time

						@systatus_page.open_systatus_page(@browser.url)
						wan_type = @systatus_page.get_wan_type
						wan_addr = @systatus_page.get_wan_ip
						puts "��ѯ��WAN���뷽ʽΪ#{wan_type}".to_gbk
						puts "��ѯ��WAN IPΪ#{wan_addr}".to_gbk
						assert_equal(tc_staticIp, wan_addr, "��̬IP#{tc_staticIp}����ʧ��!")
						assert_match /#{@ts_wan_mode_static}/, wan_type, '�������ʹ���'
				}

				operate("3��IP��ַ�����鲥��ַ����239.1.1.1���Ƿ��������룻") {
						#�ڶ������Ѿ�����
				}

				operate("4��IP��ַ����E���ַ����240.1.1.1���Ƿ��������룻") {
						tc_staticIp = "240.1.1.2"
						puts "����IP��ַΪ:#{tc_staticIp}".encode("GBK")
						@wan_page.select_static(@browser.url)
						@wan_page.static_ip_element.click #����Ԫ�ص�������Է�����ʧ��
						@wan_page.static_ip = tc_staticIp
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO��#{error_tip}".encode("GBK")
						unless error_tip==@tc_ip_error_tip
								@tc_flag = true
						end
						assert_equal(@tc_ip_error_tip, error_tip, "������ʾ���ݲ���ȷ!")
				}

				operate("5��IP��ַ���뻷�ص�ַ����127��ͷ�ĵ�ַ����127.0.0.1���Ƿ��������룻") {
						tc_staticIp = "127.0.0.2"
						puts "����IP��ַΪ:#{tc_staticIp}".encode("GBK")
						@wan_page.static_ip_element.click #����Ԫ�ص�������Է�����ʧ��
						@wan_page.static_ip = tc_staticIp
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO��#{error_tip}".encode("GBK")
						unless error_tip==@tc_ip_error_tip
								@tc_flag = true
						end
						assert_equal(@tc_ip_error_tip, error_tip, "������ʾ���ݲ���ȷ!")
				}

				operate("6��IP��ַ��������ʽ��ַ����192.168.10��a.a.a.a�ȣ�") {
						tc_staticIp="10.10.10"
						puts "����IP��ַΪ:#{tc_staticIp}".encode("GBK")
						@wan_page.static_ip_element.click #����Ԫ�ص�������Է�����ʧ��
						@wan_page.static_ip = tc_staticIp
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO��#{error_tip}".encode("GBK")
						unless error_tip==@tc_ip_error_tip
								@tc_flag = true
						end
						assert_equal(@tc_ip_error_tip, error_tip, "������ʾ���ݲ���ȷ!")

						tc_staticIp="10.10.10.a"
						puts "����IP��ַΪ:#{tc_staticIp}".encode("GBK")
						@wan_page.static_ip_element.click #����Ԫ�ص�������Է�����ʧ��
						@wan_page.static_ip = tc_staticIp
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO��#{error_tip}".encode("GBK")
						unless error_tip==@tc_ip_error_tip
								@tc_flag = true
						end
						assert_equal(@tc_ip_error_tip, error_tip, "������ʾ���ݲ���ȷ!")

						tc_staticIp="10.10.-1.10"
						puts "����IP��ַΪ:#{tc_staticIp}".encode("GBK")
						@wan_page.static_ip_element.click #����Ԫ�ص�������Է�����ʧ��
						@wan_page.static_ip = tc_staticIp
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO��#{error_tip}".encode("GBK")
						unless error_tip==@tc_ip_error_tip
								@tc_flag = true
						end
						assert_equal(@tc_ip_error_tip, error_tip, "������ʾ���ݲ���ȷ!")

						tc_staticIp="10.@.10.10"
						puts "����IP��ַΪ:#{tc_staticIp}".encode("GBK")
						@wan_page.static_ip_element.click #����Ԫ�ص�������Է�����ʧ��
						@wan_page.static_ip = tc_staticIp
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO��#{error_tip}".encode("GBK")
						unless error_tip==@tc_ip_error_tip
								@tc_flag = true
						end
						assert_equal(@tc_ip_error_tip, error_tip, "������ʾ���ݲ���ȷ!")

						tc_staticIp="10.10.10. 111"
						puts "����IP��ַΪ:#{tc_staticIp},��ַ���пո�".encode("GBK")
						@wan_page.static_ip_element.click #����Ԫ�ص�������Է�����ʧ��
						@wan_page.static_ip = tc_staticIp
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO��#{error_tip}".encode("GBK")
						unless error_tip==@tc_ip_error_tip
								@tc_flag = true
						end
						assert_equal(@tc_ip_error_tip, error_tip, "������ʾ���ݲ���ȷ!")

						tc_staticIp="*.10.10.10"
						puts "����IP��ַΪ:#{tc_staticIp}".encode("GBK")
						@wan_page.static_ip_element.click #����Ԫ�ص�������Է�����ʧ��
						@wan_page.static_ip = tc_staticIp
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO��#{error_tip}".encode("GBK")
						unless error_tip==@tc_ip_error_tip
								@tc_flag = true
						end
						assert_equal(@tc_ip_error_tip, error_tip, "������ʾ���ݲ���ȷ!")
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
