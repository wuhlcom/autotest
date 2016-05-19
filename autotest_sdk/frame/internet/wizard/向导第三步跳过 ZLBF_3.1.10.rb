#
# description:
# author:wuhongliang
# date:2015-08-26 11:47:03
# modify:
#
testcase {
	attr = {"id" => "ZLBF_3.1.10", "level" => "P1", "auto" => "n"}

	def prepare
		@tc_wait_time        = 3
		@tc_tag_setup_guide  = "setup_guide"
		@tc_tag_net_guide    = "images/step1.png"
		@tc_tag_lan_guide    = "images/step2.png"
		@tc_tag_status_guide = "images/step3.png"
		@tc_tag_use_guide    = "images/step4.png"
		@tc_tag_map          = "Map"
		@tc_tag_map2         = "Map2"
		@tc_tag_map3         = "Map3"
		@tc_tag_map4         = "Map4"
	end

	def process

		operate("1��PC��¼��·���������ҳ���������򵼰�ť") {
			@browser.link(id: @tc_tag_setup_guide).click
			assert(@browser.image(src: @tc_tag_net_guide).exists?, "�򵼴�ʧ��")
			assert(@browser.map(id: @tc_tag_map).exists?, "����û����һ����ť")
		}

		operate("2�����뵽�������鿴״̬������������Ƿ��������Ĳ�") {
			#����������õ�"����"
			@browser.map(id: @tc_tag_map).area.click
			assert(@browser.image(src: @tc_tag_lan_guide).exists?, "����תLAN����ʧ��")
			assert(@browser.map(id: @tc_tag_map2).exists?, "����LAN������һ����ťδ����")

			#����������õ�"����"
			@browser.map(id: @tc_tag_map2).area.click
			assert(@browser.image(src: @tc_tag_status_guide).exists?, "����תLAN����ʧ��")
			assert(@browser.map(id: @tc_tag_map3).exists?, "����LAN������һ����ťδ����")

			#���״̬�����"����"
			@browser.map(id: @tc_tag_map3).area.click
			assert(@browser.image(src: @tc_tag_use_guide).exists?, "����תLAN����ʧ��")
			assert(@browser.map(id: @tc_tag_map4).exists?, "����LAN������һ����ťδ����")
		}


	end

	def clearup

	end

}
