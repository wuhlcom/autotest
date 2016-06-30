#
# description:
# author:wuhongliang
# date:2016-03-12 11:25:32
# modify:
#
testcase {
		attr = {"id" => "ZLBF_ApMode_1.1.2", "level" => "P3", "auto" => "n"}

		def prepare
				@tc_wait_time   = 4
				@tc_static_args = {nicname: @ts_nicname, source: "static", ip: "192.168.100.111", mask: "255.255.255.0", gateway: @ts_default_ip}
				@tc_dhcp_args   = {nicname: @ts_nicname, source: "dhcp"}
		end

		def process

				operate("1��·������APģʽ�л���·��ģʽ��������棬�鿴��ʾ�Ƿ���ȷ��") {
						#���л���APģʽ
						@mode_page = RouterPageObject::ModePage.new(@browser)
						@mode_page.save_apmode(@browser.url)
						#���þ�̬IP
						netsh_if_ip_setip(@tc_static_args)
						#�鿴APģʽ�Ƿ��л��ɹ�
						@mode_page.login_mode_change(@ts_default_usr, @ts_default_pw, @ts_default_ip) #���µ�¼

						#�鿴WAN���ú�LAN��Ӧ���޷������
						@mode_page.wan_span_obj.click
						sleep @tc_wait_time
						lan_set = @browser.iframe(src: @ts_tag_lan_src).exists?
						refute(lan_set, "LAN����Ӧ�ò��ܴ�")

						@mode_page.lan_span_obj.click
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

				operate("2���鿴·��ģʽҳ�棻") {
						#�л���·��ģʽ
						@mode_page.save_routermode(@browser.url)
						#�鿴·��ģʽ�Ƿ��л��ɹ�
						@mode_page.login_mode_change(@ts_default_usr, @ts_default_pw, @ts_default_ip) #���µ�¼
						#�鿴WAN���ú�LAN��Ӧ���ܵ����
						@mode_page.lan_span_obj.click
						sleep @tc_wait_time
						lan_set = @browser.iframe(src: @ts_tag_lan_src).exists?
						assert(lan_set, "LAN���ô�ʧ��")

						@mode_page.refresh
						sleep 1
						@mode_page.refresh
						@mode_page.wan_span_obj.click
						sleep @tc_wait_time
						wan_set = @browser.iframe(src: @ts_tag_netset_src).exists?
						assert(wan_set, "WAN���ô�ʧ��")

						@mode_page.open_mode_page(@browser.url)
						#�鿴·����ģʽ�Ƿ���ȷ
						assert(@mode_page.routermode_selected?, "·��ģʽ����ʧ��")
						@apoptions_page = RouterPageObject::OptionsPage.new(@browser)
						#apģʽ�߼�������ֻ��ϵͳ���õĹ��ܣ��鿴�򿪸߼����ú�����Щ����
						@apoptions_page.open_options_page(@browser.url)
						assert(@apoptions_page.apply_settings_element.visible?, "��APģʽ�л���·��ģʽʧ��Ӧ�����ù��ܲ�����")
						assert(@apoptions_page.network_element.visible?, "��APģʽ�л���·��ģʽʧ���������ù��ܲ�����")
						assert(@apoptions_page.security_settings_element.visible?, "��APģʽ�л���·��ģʽʧ�ܰ�ȫ���ù��ܲ�����")
						assert(@apoptions_page.traffic_manage_element.visible?, "��APģʽ�л���·��ģʽʧ�����������ܲ�����")
						assert(@apoptions_page.sysset_element.visible?, "��APģʽ�л���·��ģʽʧ��ϵͳ���ù��ܲ�����")
				}

		end

		def clearup
				operate("1.�ָ�Ĭ������") {
						#���þ�̬IP
						netsh_if_ip_setip(@tc_static_args)
						@mode_page = RouterPageObject::ModePage.new(@browser)
						@mode_page.login_mode_change(@ts_default_usr, @ts_default_pw, @ts_default_ip)
						@mode_page.open_mode_page(@browser.url)
						unless @mode_page.routermode_selected?
								@mode_page.set_router_mode
						end
						#��̬IP
						netsh_if_ip_setip(@tc_dhcp_args)
				}
		end

}
