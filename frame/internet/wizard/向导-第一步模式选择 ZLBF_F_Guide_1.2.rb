#
# description:
# openWRT��һ����·��ģʽѡ��
# author:wuhongliang
# date:2015-08-26 11:47:03
# modify:
#
testcase {
		attr = {"id" => "ZLBF_3.1.5", "level" => "P1", "auto" => "n"}

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

				operate("2�����뵽��һ��·����ģʽ���ã����·����ģʽ���Ƿ��ܽ���·����ģʽ����ҳ��") {
						puts "��·����ģʽ����".to_gbk
						@mode_page.open_mode_page(@browser.url)
						rs = @browser.iframe(src: @ts_tag_router_mode).exists?
						assert(rs, "�޷���·����ģʽ���ý���")
				}

		end

		def clearup

		end

}
