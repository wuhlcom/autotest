#
# description:
# author:liluping
# date:2015-11-05 14:00:19
# modify:
#
testcase {
		attr = {"id" => "ZLBF_15.1.19", "level" => "P2", "auto" => "n"}

		def prepare
				@tc_wait_time = 5
				@tc_port      = 80
				@tc_port_new  = 90
		end

		def process

				operate("1��DUT�Ľ�������ѡ��ΪDHCP���������ã�") {
						@wan_page = RouterPageObject::WanPage.new(@browser)
						@wan_page.set_dhcp(@browser, @browser.url)
				}

				operate("2�����뵽��ȫ���õķ���ǽ���ý��棬��������ǽ�ܿ��غ�IP���ǿ��أ���IP���ǽ�����ӹ������һ��IP���ˣ�����ԴIPΪ192.168.100.100���˿�Ϊ80��Э��ΪTCP���������ã�") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.open_security_setting(@browser.url) #�򿪰�ȫ����
						@options_page.firewall_click
						@options_page.open_switch("on", "on", "off", "off")
						@options_page.ipfilter_click
						@options_page.ip_add_item_element.click
						@options_page.ip_filter_dst_port_input(@tc_port, @tc_port)
						@options_page.ip_filter_save
				}

				operate("3����PC1�������ݰ�����������������ݰ���������IPTEST������TCP�����ݰ����˿�Ϊ80��ԴIP��ַΪ��192.168.100.100��PC2���Ƿ���ץ��PC1�Ϸ��������ݰ���") {
						begin
								rs = HtmlTag::TestHttpClient.new(@ts_wan_pppoe_httpip, '/', @tc_port).get
						rescue => ex
								p "��#{@ts_wan_pppoe_httpip}��#{@tc_port}�˿ڷ�������ʱ�����쳣".to_gbk
								p "�����쳣��Ϣ�ǣ�#{ex.message}".to_gbk
						end
						puts "http���󷵻�ֵΪ��#{rs}".to_gbk
						assert(rs.nil?, "�˿ڹ���ʧ�ܣ�#{@ts_wan_pppoe_httpport}�˿ڱ����˺���Ȼ���յ�������Ӧ��")
				}

				operate("4���༭����2���޸Ĺ��˹����޸Ĺ��˶˿�Ϊ90�����棻") {
						@options_page.ip_filter_table_element.element.trs[1][7].link(class_name: @ts_tag_edit).image.click #�༭��һ������
						@options_page.dst_port_start1 = @tc_port_new
						@options_page.dst_port_end1   = @tc_port_new
						@options_page.ip_save1
						sleep @tc_wait_time
				}

				operate("5���ظ�����3���鿴���Խ����") {
						begin
								rs = HtmlTag::TestHttpClient.new(@ts_wan_pppoe_httpip, '/', @ts_wan_pppoe_httpport).get
						rescue => ex
								p "��#{@ts_wan_pppoe_httpip}��#{@tc_port}�˿ڷ�������ʱ�����쳣".to_gbk
								p "�����쳣��Ϣ�ǣ�#{ex.message}".to_gbk
						end
						puts "http���󷵻�ֵΪ��#{rs}".to_gbk
						assert_match("succeed", rs, "�˿ڹ���ʧ�ܣ�#{@tc_port_new}�˿ڱ����˺���#{@tc_port}�˿ڷ���http����ʱ�޷������Ӧ��")
				}

		end

		def clearup
				operate("1 �رշ���ǽ�ܿ��غ�IP���˿��ز�ɾ����������") {
						options_page = RouterPageObject::OptionsPage.new(@browser)
						options_page.ipfilter_close_sw_del_all_step(@browser.url)
				}
		end

}
