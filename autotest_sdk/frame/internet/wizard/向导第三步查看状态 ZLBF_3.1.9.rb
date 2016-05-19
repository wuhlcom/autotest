#
# description:
# author:wuhongliang
# date:2015-08-26 11:47:03
# modify:
#
testcase {
	attr = {"id" => "ZLBF_3.1.9", "level" => "P1", "auto" => "n"}

	def prepare
		@tc_wait_time        = 3
		@tc_tag_setup_guide  = "setup_guide"
		@tc_tag_net_guide    = "images/step1.png"
		@tc_tag_lan_guide    = "images/step2.png"
		@tc_tag_status_guide = "images/step3.png"
		@tc_tag_map          = "Map"
		@tc_tag_map2         = "Map2"
		@tc_tag_map3         = "Map3"
	end

	def process

		operate("1��PC��¼��·���������ҳ���������򵼰�ť") {
			@browser.link(id: @tc_tag_setup_guide).click
			assert(@browser.image(src: @tc_tag_net_guide).exists?, "�򵼴�ʧ��")
			assert(@browser.map(id: @tc_tag_map).exists?, "����û����һ����ť")
		}

		operate("2�����뵽�������������ã�����鿴״̬���Ƿ��ܽ���鿴״̬ҳ��") {
			#����������õ�"����"
			@browser.map(id: @tc_tag_map).area.click
			assert(@browser.image(src: @tc_tag_lan_guide).exists?, "����תLAN����ʧ��")
			assert(@browser.map(id: @tc_tag_map2).exists?, "����LAN������һ����ťδ����")
			#����������õ�"����"
			@browser.map(id: @tc_tag_map2).area.click
			assert(@browser.image(src: @tc_tag_status_guide).exists?, "����תLAN����ʧ��")
			assert(@browser.map(id: @tc_tag_map3).exists?, "����LAN������һ����ťδ����")
		}

		operate("3���鿴״̬�󣬵��ȷ�����Ƿ񷵻ص���ҳ��") {
			@browser.span(id: @ts_tag_status).click
			Watir::Wait.until(@tc_wait_time, "����������ʧ�ܣ�") {
				@browser.iframe(src: @ts_tag_status_iframe_src).present?
			}
		}


	end

	def clearup

	end

}
