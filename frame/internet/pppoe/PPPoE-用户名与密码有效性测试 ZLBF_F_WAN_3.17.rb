#
# description:
#  `&\"\'\s �û�������������������ַ���֧��
# author:wuhongliang
# date:2015-11-05 14:00:18
# modify:
#
testcase {
		attr = {"id" => "ZLBF_6.1.37", "level" => "P4", "auto" => "n"}

		def prepare
				@tc_net_time     = 60
				@tc_wait_time    = 3
				@tc_usr_err      = "�ʺ�Ϊ1��32λ���֡���ĸ�������ַ�(~!@#*()_{}<>?.[]-=^:)"
				@tc_pw_err       = "����Ϊ1��32λ���֡���ĸ�������ַ�(~!@#*()_{}<>?.[]-=^:)"
				@tc_usr_null     = "�������ʺ�"
				@tc_netreset_div = "�ɹ�"
				@tc_net_hint     = "���óɹ����������������У����Ե�..."
		end

		def process

				operate("1����BAS����ץ����") {

				}

				operate("2����½DUT������PPPoE����ҳ�棻") {
						@wan_page = RouterPageObject::WanPage.new(@browser)
				}

				operate("3�����û��������������ַ�~!@#$%^&*()_+{}|:<>?�� ������33�������ַ�, �鿴�Ƿ��������뱣�� �� ҳ����ʾ�Ƿ����� �� ץ��ȷ�ϲ����Ƿ��������û������� �� ") {
						tc_pppoe_usr = "-=[];\\,./~!@#$%^*()_+{}:|<>?"
						tc_pppoe_pw  = "PPPOETEST"
						puts "����PPPOE�ʻ�����PPPOE���룡".to_gbk
						puts "�����û���Ϊ#{tc_pppoe_usr}".encode("GBK")
						puts "��������Ϊ#{tc_pppoe_pw}".encode("GBK")
						@wan_page.select_pppoe(@browser.url)
						@wan_page.pppoe_input(tc_pppoe_usr, tc_pppoe_pw) #�����˺�����
						@wan_page.save
						err_msg = @wan_page.pppoe_err_msg
						assert_equal(@tc_usr_err, err_msg, "��ʾ��Ϣ����ȷ")
				}

				operate(" 4 �� ���û���������09, �鿴�Ƿ��������뱣�� �� ҳ����ʾ�Ƿ����� �� ץ��ȷ�ϲ����Ƿ��������û������� �� ") {
						tc_pppoe_usr = "0123456789"
						tc_pppoe_pw  = "PPPOETEST"
						puts "����PPPOE�ʻ�����PPPOE���룡".to_gbk
						puts "�����û���Ϊ#{tc_pppoe_usr}".encode("GBK")
						puts "��������Ϊ#{tc_pppoe_pw}".encode("GBK")
						@wan_page.select_pppoe(@browser.url)
						@wan_page.pppoe_input(tc_pppoe_usr, tc_pppoe_pw) #�����˺�����
						@wan_page.save
						sleep 2
						net_hint_msg = @wan_page.net_hint
						assert_equal(@tc_net_hint, net_hint_msg, "ʹ�������û������벦�ź�ҳ����ʾ����")
						sleep @tc_net_time
				}

				operate(" 5 �� ���û���������az, �鿴�Ƿ��������뱣�� �� ҳ����ʾ�Ƿ����� �� ץ��ȷ�ϲ����Ƿ��������û������� �� ") {
						tc_pppoe_usr = "abcdefghijklmopqrstuvwxyz"
						tc_pppoe_pw  = "PPPOETEST"
						puts "����PPPOE�ʻ�����PPPOE���룡".to_gbk
						puts "�����û���Ϊ#{tc_pppoe_usr}".encode("GBK")
						puts "��������Ϊ#{tc_pppoe_pw}".encode("GBK")
						@wan_page.select_pppoe(@browser.url)
						@wan_page.pppoe_input(tc_pppoe_usr, tc_pppoe_pw) #�����˺�����
						@wan_page.save
						sleep 2
						net_hint_msg = @wan_page.net_hint
						assert_equal(@tc_net_hint, net_hint_msg, "ʹ�������û������벦�ź�ҳ����ʾ����")
						sleep @tc_net_time
				}

				operate(" 6 �� ���û���������AZ, �鿴�Ƿ��������뱣�� �� ҳ����ʾ�Ƿ����� �� ץ��ȷ�ϲ����Ƿ��������û������� �� ") {
						tc_pppoe_usr = "ABCDEFGHIJKLMOPQRSTUVWXYZ"
						tc_pppoe_pw  = "PPPOETEST"
						puts "����PPPOE�ʻ�����PPPOE���룡".to_gbk
						puts "�����û���Ϊ#{tc_pppoe_usr}".encode("GBK")
						puts "��������Ϊ#{tc_pppoe_pw}".encode("GBK")
						@wan_page.select_pppoe(@browser.url)
						@wan_page.pppoe_input(tc_pppoe_usr, tc_pppoe_pw) #�����˺�����
						@wan_page.save
						sleep 2
						net_hint_msg = @wan_page.net_hint
						assert_equal(@tc_net_hint, net_hint_msg, "ʹ�������û������벦�ź�ҳ����ʾ����")
						sleep @tc_net_time
				}

				operate(" 7 �� �����봦�����ظ�����3 ~7 �� �鿴���Խ�� �� ") {
						tc_pppoe_usr = "pppoe"
						tc_pppoe_pw  = "-=[];\\,./~!@#$%^*()_+{}:|<>?"
						puts "����PPPOE�ʻ�����PPPOE���룡".to_gbk
						puts "�����û���Ϊ#{tc_pppoe_usr}".encode("GBK")
						puts "��������Ϊ#{tc_pppoe_pw}".encode("GBK")
						@wan_page.select_pppoe(@browser.url)
						@wan_page.pppoe_input(tc_pppoe_usr, tc_pppoe_pw) #�����˺�����
						@wan_page.save
						err_msg = @wan_page.pppoe_err_msg
						assert_equal(@tc_pw_err, err_msg, "��ʾ��Ϣ����ȷ")

						tc_pppoe_usr = "pppoe"
						tc_pppoe_pw  = "0123456789"
						puts "����PPPOE�ʻ�����PPPOE���룡".to_gbk
						puts "�����û���Ϊ#{tc_pppoe_usr}".encode("GBK")
						puts "��������Ϊ#{tc_pppoe_pw}".encode("GBK")
						@wan_page.select_pppoe(@browser.url)
						@wan_page.pppoe_input(tc_pppoe_usr, tc_pppoe_pw) #�����˺�����
						@wan_page.save
						sleep 2
						net_hint_msg = @wan_page.net_hint
						assert_equal(@tc_net_hint, net_hint_msg, "ʹ�������û������벦�ź�ҳ����ʾ����")
						sleep @tc_net_time

						tc_pppoe_usr = "pppoe"
						tc_pppoe_pw  = "abcdefghijklmopqrstuvwxyz"
						puts "����PPPOE�ʻ�����PPPOE���룡".to_gbk
						puts "�����û���Ϊ#{tc_pppoe_usr}".encode("GBK")
						puts "��������Ϊ#{tc_pppoe_pw}".encode("GBK")
						@wan_page.select_pppoe(@browser.url)
						@wan_page.pppoe_input(tc_pppoe_usr, tc_pppoe_pw) #�����˺�����
						@wan_page.save
						sleep 2
						net_hint_msg = @wan_page.net_hint
						assert_equal(@tc_net_hint, net_hint_msg, "ʹ�������û������벦�ź�ҳ����ʾ����")
						sleep @tc_net_time
				}


		end

		def clearup

				operate("�ָ�Ĭ��DHCP����") {
						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
						wan_page = RouterPageObject::WanPage.new(@browser)
						wan_page.set_dhcp(@browser, @browser.url)
				}
		end

}
