#
# description:
#�ڶ�����WAN����
# author:wuhongliang
# date:2015-08-26 11:47:03
# modify:
#
testcase {
		attr = {"id" => "ZLBF_3.1.7", "level" => "P1", "auto" => "n"}

		def prepare

		end

		def process

				operate("1��PC��¼��·���������ҳ���������򵼰�ť") {
						@wan_page = RouterPageObject::WanPage.new(@browser)
						@wan_page.guide
						router_mode_wz = @wan_page.rtmode_wz_element.visible?
						next_step      = @wan_page.rtmode_wz_map?
						assert(router_mode_wz, "δ��������·��ģʽ��")
						assert(next_step, "δ����������ť")
				}

				operate("2�����뵽�ڶ����������ã�����������ã��Ƿ��ܽ�����������ҳ��") {
						#���·��ģʽ�򵼵�"����"
						@wan_page.rtmode_wz_map_element.area_element.click
						#�鿴���Ƿ�����WAN����
						wan_wz    = @wan_page.wanset_wz_element.visible?
						next_step = @wan_page.wanset_wz_map?
						assert(wan_wz, "δ��������WAN������")
						assert(next_step, "δ����������ť")
						#��WAN����
						@wan_page.open_wan_page(@browser.url)
						rs = @browser.iframe(src: @ts_tag_netset_src).exists?
						assert(rs, "�޷���·����WAN���ý���")
				}

		end

		def clearup

		end

}
