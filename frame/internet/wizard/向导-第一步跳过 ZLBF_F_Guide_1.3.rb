#
# description:
# author:wuhongliang
# date:2015-08-26 11:47:03
# modify:
#
testcase {
		attr = {"id" => "ZLBF_3.1.6", "level" => "P1", "auto" => "n"}

		def prepare

		end

		def process

				operate("1��PC��¼��·���������ҳ���������򵼰�ť") {
						@mode_page = RouterPageObject::ModePage.new(@browser)
						@mode_page.guide
						router_mode_wz = @mode_page.rtmode_wz_element.visible?
						next_step      = @mode_page.rtmode_wz_map?
						assert(router_mode_wz, "δ��������·��ģʽ��")
						assert(next_step, "δ����������ť")
				}

				operate("2�����뵽��һ��·����ģʽ���ã�����������Ƿ������ڶ���") {
						#���·��ģʽ�򵼵�"����"
						@mode_page.rtmode_wz_map_element.area_element.click
						#�鿴���Ƿ�����WAN����
						wan_wz    = @mode_page.wanset_wz_element.visible?
						next_step = @mode_page.wanset_wz_map?
						assert(wan_wz, "δ��������WAN������")
						assert(next_step, "δ����������ť")
				}


		end

		def clearup

		end

}
