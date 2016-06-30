#
# description:
# author:wuhongliang
# date:2016-03-12 11:25:32
# modify:
#
testcase {
		attr = {"id" => "ZLBF_ApMode_1.1.3", "level" => "P3", "auto" => "n"}

		def prepare		
				@tc_static_args = {nicname: @ts_nicname, source: "static", ip: "192.168.100.15", mask: "255.255.255.0", gateway: @ts_default_ip}
				@tc_dhcp_args   = {nicname: @ts_nicname, source: "dhcp"}
				@tc_root_usr    = "root"
				@tc_root_pw     = "zl4321"
				@tc_wan_intf    = "eth0.2"
		end

		def process

				operate("1��PC1����DUT��Lan�ڣ���̬��ȡ��ַ���鿴�Ƿ��ܻ�ȡDUT����ĵ�ַ��") {
						@mode_page = RouterPageObject::ModePage.new(@browser)
						@mode_page.save_apmode(@browser.url)
				}

				operate("2��PC2ͨ����������DUT����̬��ȡ��ַ���鿴�Ƿ��ܻ�ȡDUT����ĵ�ַ��") {
						netsh_if_ip_setip(@tc_dhcp_args)
						#�������»�ȡIP��ַ
						ip_release
						ip_renew
						rs        = ipconfig
						pc_ip_arr = rs[@ts_nicname][:ip]
						puts "PC IP address:#{pc_ip_arr}"
						pc_ip = pc_ip_arr[0]
						flag  =false
						flag  =true if pc_ip_arr.empty? || pc_ip=~/^169|10\.10\.10/ #���PCδ��õ�ַ���ȡ�ϲ��ַ��˵��DHCP����
						assert(flag, "APģʽδ�ر�DHCP")
				}

				operate("3��DUT��Wan����������AP��Lan�ڣ��鿴Wan���Ƿ��ܻ�ȡ����AP����ĵ�ַ��") {
						#���þ�̬IP
						netsh_if_ip_setip(@tc_static_args)
						#��ѯ·����ԭWAN���Ƿ���IP��ַ,APģʽ·����ԭWANӦ����IP��ַ
						init_router_obj(@ts_default_ip, @tc_root_usr, @tc_root_pw)
						rs = router_ifconfig(@tc_wan_intf)
						p "wan ifconfig result:#{rs}"
						#��ѯWAN��״̬
						refute(rs.has_key?(:ip), "·����WAN��δ�л���LAN")
				}


		end

		def clearup

				operate("1.�ָ�Ĭ������") {
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
