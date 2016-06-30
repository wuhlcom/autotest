#
# description:
# author:wuhongliang
# date:2015-08-26 11:47:03
# modify:
#
testcase {
	attr = {"id" => "ZLBF_3.1.9", "level" => "P1", "auto" => "n"}

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

		operate("2�����뵽�������������ã�����鿴״̬���Ƿ��ܽ���鿴״̬ҳ��") {
				#���WAN�����򵼵�"����"
				@lan_page.wanset_wz_map_element.area_element.click
				#�鿴���Ƿ�����LAN����
				lan_wz    = @lan_page.lanset_wz_element.visible?
				next_step = @lan_page.lanset_wz_map?
				assert(lan_wz, "δ��������LAN������")
				assert(next_step, "δ����������ť")

				@lan_page.open_lan_page(@browser.url)
				rs = @browser.iframe(src: @ts_tag_lan_src).exists?
				assert(rs, "�޷���·����LAN���ý���")
		}
			
	end

	def clearup

	end

}
