#
# description:
# author:wuhongliang
# date:2015-08-26 11:47:03
# modify:
#
testcase {
		attr = {"id" => "ZLBF_3.1.12", "level" => "P1", "auto" => "n"}

		def prepare

		end

		def process

				operate("1��PC��¼��·���������ҳ���������򵼰�ť") {
						@wifi_page = RouterPageObject::WIFIPage.new(@browser)
						@wifi_page.guide
						router_mode_wz = @wifi_page.rtmode_wz_element.visible?
						next_step      = @wifi_page.rtmode_wz_map?
						assert(router_mode_wz, "δ��������·��ģʽ��")
						assert(next_step, "δ����������ť")

						#���·��ģʽ�򵼵�"����"
						@wifi_page.rtmode_wz_map_element.area_element.click
						#�鿴���Ƿ�����WAN����
						wan_wz    = @wifi_page.wanset_wz_element.visible?
						next_step = @wifi_page.wanset_wz_map?
						assert(wan_wz, "δ��������WAN������")
						assert(next_step, "δ����������ť")

						#���WAN�����򵼵�"����"
						@wifi_page.wanset_wz_map_element.area_element.click
						#�鿴���Ƿ�����LAN����
						lan_wz    = @wifi_page.lanset_wz_element.visible?
						next_step = @wifi_page.lanset_wz_map?
						assert(lan_wz, "δ��������LAN������")
						assert(next_step, "δ����������ť")

						#���LAN�����򵼵�"����"
						@wifi_page.lanset_wz_map_element.area_element.click
						#�鿴���Ƿ�����WIFI����
						lan_wz    = @wifi_page.wifiset_wz_element.visible?
						next_step = @wifi_page.wifiset_wz_map?
						assert(lan_wz, "δ��������WIFI������")
						assert(next_step, "δ����������ť")
				}

				operate("2�����뵽���Ĳ�WIFI���ã�����������Ƿ������������") {
						#���WIFI�����򵼵�"����"
						@wifi_page.wifiset_wz_map_element.area_element.click
						#�鿴���Ƿ�����WIFI����
						wifiset_wz = @wifi_page.wz_finish_element.visible?
						next_step  = @wifi_page.wz_finish_map?
						assert(wifiset_wz, "δ�������������")
						assert(next_step, "δ���ֿ�ʼʹ�ð�ť")
				}


		end

		def clearup

		end

}
