#
# description:
# author:wuhongliang
# date:2016-03-12 11:25:32
# modify:
#
testcase {
		attr = {"id" => "ZLBF_ApMode_2.1.7", "level" => "P1", "auto" => "n"}

		def prepare

				@tc_static_args = {nicname: @ts_nicname, source: "static", ip: "192.168.100.121", mask: "255.255.255.0", gateway: @ts_default_ip}
				@tc_dhcp_args   = {nicname: @ts_nicname, source: "dhcp"}
		end

		def process

				operate("1���鿴״̬ҳ���WAN��״̬��Ϣ") {
						@mode_page = RouterPageObject::ModePage.new(@browser)
						@mode_page.save_apmode(@browser.url)
				}

				operate("2�����������Ƿ�Ϊ��APģʽ��") {
						#���þ�̬IP
						netsh_if_ip_setip(@tc_static_args)
						@mode_page.login_mode_change(@ts_default_usr, @ts_default_pw, @ts_default_ip) #���µ�¼
						@mode_page.open_mode_page(@browser.url)
						#�鿴·����ģʽ�Ƿ���ȷ
						assert(@mode_page.apmode_selected?, "APģʽ����ʧ��")

						@systatus_page = RouterPageObject::SystatusPage.new(@browser)
						#�鿴ϵͳ״̬ҳ��ı仯
						@systatus_page.open_systatus_page(@browser.url)
						puts "#{@systatus_page.version_info}".to_gbk
						verinfo = @systatus_page.version_info_element.visible?
						assert(verinfo, "δ��ʾ�汾��Ϣ")
						puts "ϵͳ״̬ҳ����ʾ����Ϣ��:".to_gbk
						puts "#{@systatus_page.wan_info}".to_gbk
						wanifo = @systatus_page.wan_info_element.visible?
						refute(wanifo, "��Ӧ����ʾWAN��Ϣ")

						puts "#{@systatus_page.lan_info}".to_gbk
						laninfo = @systatus_page.lan_info_element.visible?
						assert(laninfo, "δ��ʾLAN��Ϣ")

						puts "#{@systatus_page.wifi_info}".to_gbk
						wifi_info = @systatus_page.wifi_info_element.visible?
						assert(wifi_info, "δ��ʾWIFI��Ϣ")
				}

				# operate("3��IP��ַ���������롢���ء�DNS�������Ƿ�Ϊ��") {
				#
				# }


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
