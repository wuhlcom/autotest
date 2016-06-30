#
# description:
# apģʽ��WAN��LAN���ò��ܵ��
# �߼�������ֻ��ϵͳ����->�̼����������ûָ�����־����ʱ�����ļ�����
# ϵͳ״̬Ҳ������Ӧ�ĸ���
# author:wuhongliang
# date:2016-03-12 11:25:32
# modify:
#
testcase {

		attr = {"id" => "ZLBF_ApMode_1.1.1", "level" => "P1", "auto" => "n"}

		def prepare
				@tc_wait_time   = 2
				@tc_static_args = {nicname: @ts_nicname, source: "static", ip: "192.168.100.121", mask: "255.255.255.0", gateway: @ts_default_ip}
				@tc_dhcp_args   = {nicname: @ts_nicname, source: "dhcp"}
		end

		def process

				operate("1��·�����л���APģʽ��������棬�鿴��ʾ�Ƿ���ȷ��") {
						@mode_page = RouterPageObject::ModePage.new(@browser)
						@mode_page.save_apmode(@browser.url)
						#���þ�̬IP
						netsh_if_ip_setip(@tc_static_args)
						@mode_page.login_mode_change(@ts_default_usr, @ts_default_pw, @ts_default_ip) #���µ�¼
				}

				operate("2���鿴APģʽҳ�棻") {
						#�鿴WAN���ú�LAN��Ӧ���޷������
						@mode_page.lan_span_obj.click
						sleep @tc_wait_time
						lan_set = @browser.iframe(src: @ts_tag_lan_src).exists?
						refute(lan_set, "LAN����Ӧ�ò��ܴ�")

						@mode_page.wan_span_obj.click
						sleep @tc_wait_time
						wan_set = @browser.iframe(src: @ts_tag_netset_src).exists?
						refute(wan_set, "WAN����Ӧ�ò��ܴ�")

						@mode_page.open_mode_page(@browser.url)
						#�鿴·����ģʽ�Ƿ���ȷ
						assert(@mode_page.apmode_selected?, "APģʽ����ʧ��")
						@apoptions_page = RouterPageObject::APOptionsPage.new(@browser)
						#apģʽ�߼�������ֻ��ϵͳ���õĹ��ܣ��鿴�򿪸߼����ú�����Щ����
						@apoptions_page.open_options_page(@browser.url)
						refute(@apoptions_page.apply_settings_element.visible?, "�л���APģʽ��Ӧ�����ù��ܲ�Ӧ�ô���")
						refute(@apoptions_page.network_element.visible?, "�л���APģʽ���������ù��ܲ�Ӧ�ô���")
						refute(@apoptions_page.security_settings_element.visible?, "�л���APģʽ��ȫ���ù��ܲ�Ӧ�ô���")
						refute(@apoptions_page.traffic_manage_element.visible?, "�л���APģʽ�����������ܲ�Ӧ�ô���")
						assert(@apoptions_page.sysset_element.visible?, "�л���APģʽ��ϵͳ���ù���Ӧ�ô���")
				}
		end

		def clearup

				operate("1.�ָ�Ĭ������") {
						#���þ�̬IP
						netsh_if_ip_setip(@tc_static_args)
						@mode_page = RouterPageObject::ModePage.new(@browser)
						@mode_page.login_mode_change(@ts_default_usr, @ts_default_pw, @ts_default_ip) #���µ�¼
						@mode_page.open_mode_page(@browser.url)
						unless @mode_page.routermode_selected?
								@mode_page.set_router_mode
						end
						#��̬IP
						netsh_if_ip_setip(@tc_dhcp_args)
				}

		end

}
