#
# description:
# author:wuhongliang
# date:2015-10-16 17:43:16
# modify:
#
testcase {
		attr = {"id" => "ZLBF_8.1.24", "level" => "P2", "auto" => "n"}

		def prepare
				@tc_default_ip    = "192.168.100.1"
				@tc_default_start = "100"
				@tc_default_end   = "200"
				@tc_lan_ip_new    = "192.168.30.1"
				@tc_lan_start_new = "50"
				@tc_lan_end_new   = "100"
				@tc_lan_time      = 70
		end

		def process

				operate("1������LAN����ҳ�棻") {
						@lan_page = RouterPageObject::LanPage.new(@browser)
						@lan_page.open_lan_page(@browser.url)
				}

				operate("2������LAN IP���������룬���ĵ�ַ�ط�Χ") {
						@lan_page.lan_ip = @tc_lan_ip_new
						@lan_page.lan_startip_set @tc_lan_start_new
						@lan_page.lan_endip_set @tc_lan_end_new
						@lan_page.btn_save_lanset
						puts "sleep #{@tc_lan_time} seconds..."
						sleep @tc_lan_time
						puts "�޸�LAN IP�󷵻ص���¼����".to_gbk
						assert(@lan_page.username?, "�޸�LAN IP�󵯳��µ�ַ����")
						#���µ�¼
						rs_login = login_no_default_ip(@browser) #���µ�¼
						assert(rs_login[:flag], "��¼ʧ�ܣ�#{rs_login[:message]}")
						# login(@browser, @tc_lan_ip_new)
						#����Ƿ����óɹ�
						@lan_page.open_lan_page(@browser.url)
						tc_lan_ip    = @lan_page.lan_ip
						tc_lan_start = @lan_page.lan_startip
						tc_lan_end   = @lan_page.lan_endip
						assert_equal(@tc_lan_ip_new, tc_lan_ip, "�޸�LAN IPʧ��")
						assert_equal(@tc_lan_start_new, tc_lan_start, "�޸�LAN��ʼ��ַʧ��")
						assert_equal(@tc_lan_end_new, tc_lan_end, "�޸�LAN������ַʧ��")
				}

				operate("3���ָ�DUTΪ����Ĭ��״̬���鿴LAN����ҳ��Ĳ����Ƿ񱻸�λ��Ĭ��״̬��") {
						@advance_page = RouterPageObject::OptionsPage.new(@browser)
						@advance_page.recover_factory(@browser.url)
						sleep @tc_lan_time
						assert(@advance_page.username?, "�ָ�����ֵ�󷵻ص���¼����")
						#���µ�¼
						rs_login = login_no_default_ip(@browser) #���µ�¼
						assert(rs_login[:flag], "��¼ʧ�ܣ�#{rs_login[:message]}")
						#�鿴�Ƿ�ָ��ɹ�
						@lan_page.open_lan_page(@browser.url)
						tc_lan_ip    = @lan_page.lan_ip
						tc_lan_start = @lan_page.lan_startip
						tc_lan_end   = @lan_page.lan_endip
						assert_equal(@tc_default_ip, tc_lan_ip, "�޸�LAN IPʧ��")
						assert_equal(@tc_default_start, tc_lan_start, "�޸�LAN��ʼ��ַʧ��")
						assert_equal(@tc_default_end, tc_lan_end, "�޸�LAN������ַʧ��")
				}
		end

		def clearup

				operate("1 �ָ�LAN����ΪĬ������") {
						@browser.refresh
						@lan_page = RouterPageObject::LanPage.new(@browser)
						if @lan_page.username?
								rs_login = login_no_default_ip(@browser) #���µ�¼
								p rs_login[:flag]
								p rs_login[:message]
						end
						@lan_page.open_lan_page(@browser.url)
						tc_lan_ip    = @lan_page.lan_ip
						tc_lan_start = @lan_page.lan_startip
						tc_lan_end   = @lan_page.lan_endip
						flag         = false

						unless tc_lan_ip == @tc_default_ip
								@lan_page.lan_ip = @tc_default_ip
								flag             = true
						end

						unless tc_lan_start == @tc_default_start
								@lan_page.lan_startip_set @tc_default_start
								flag = true
						end

						unless tc_lan_end == @tc_default_end
								@lan_page.lan_endip_set @tc_default_end
								flag = true
						end
						if flag
								@lan_page.btn_save_lanset
						end
				}
		end

}
