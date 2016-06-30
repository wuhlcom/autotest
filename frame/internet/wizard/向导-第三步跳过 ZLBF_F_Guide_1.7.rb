#
# description:
# author:wuhongliang
# date:2015-08-26 11:47:03
# modify:
#
testcase {
		attr = {"id" => "ZLBF_3.1.10", "level" => "P1", "auto" => "n"}

		def prepare

		end

		def process

				operate("1��PC��¼��·���������ҳ���������򵼰�ť") {
						@lan_page = RouterPageObject::LanPage.new(@browser)
						@lan_page.guide
						router_mode_wz = @lan_page.rtmode_wz_element.visible?
						next_step      = @lan_page.rtmode_wz_map?
						assert(router_mode_wz, "δ��������·��ģʽ��")
						assert(next_step, "δ����������ť")

						#���·��ģʽ�򵼵�"����"
						@lan_page.rtmode_wz_map_element.area_element.click
						#�鿴���Ƿ�����WAN����
						wan_wz    = @lan_page.wanset_wz_element.visible?
						next_step = @lan_page.wanset_wz_map?
						assert(wan_wz, "δ��������WAN������")
						assert(next_step, "δ����������ť")
				}

				operate("2�����뵽������LAN���ã�����������Ƿ��������Ĳ�") {
						#���WAN�����򵼵�"����"
						@lan_page.wanset_wz_map_element.area_element.click
						#�鿴���Ƿ�����LAN����
						lan_wz    = @lan_page.lanset_wz_element.visible?
						next_step = @lan_page.lanset_wz_map?
						assert(lan_wz, "δ��������LAN������")
						assert(next_step, "δ����������ť")

						#���LAN�����򵼵�"����"
						@lan_page.lanset_wz_map_element.area_element.click
						#�鿴���Ƿ�����WIFI����
						wifi_wz    = @lan_page.wifiset_wz_element.visible?
						next_step = @lan_page.wifiset_wz_map?
						assert(wifi_wz, "δ��������WIFI������")
						assert(next_step, "δ����������ť")
				}


		end

		def clearup

		end

}
