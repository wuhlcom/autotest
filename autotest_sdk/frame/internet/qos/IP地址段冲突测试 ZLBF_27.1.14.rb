#
# description:
#ֻҪ�������¼�������Ϳ��Ը��ǵ����п��ܵ��쳣
#����ԭ��:�¹������ʼ�ͽ���IPҪô��С�����й�����±߽磬Ҫô���������й�����ϱ߽�
#���ǿɵó��������������a,bΪ����1,�����ҴӴ�С��������
# 1--(x,a)(a b) ,2--(a b) (b,y),3--x (a b) y
#����1Ϊһ��IP��Χ������2ΪIP��Χ���ϱ߽磬�±߽������1�ص������1�ڹ���2�ķ�Χ��
#����1Ϊһ��IP��ַ��������ֻҪIP��Χ�Ĳ���ͨ����������Ҳ��ͨ����
#2015 12 17 bug δ���ϱ߽�ĺϷ��������
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
testcase {
		attr = {"id" => "ZLBF_27.1.14", "level" => "P4", "auto" => "n"}

		def prepare
				#kpbs
				@tc_bandwidth_total = 100000
				@tc_bandwidth_limit = 8000
				@tc_wait_time       = 2
				@tc_qos_time        = 2
				@tc_rule_time       = 1

				#rule1@tc_rule1_ip1
				@tc_rule1_ip1       = "100"
				@tc_rule1_ip2       = "110"
				#�ϱ߽���tc_rule1_ip1��һ��
				@tc_rule2_ip1       = "50"
				@tc_rule2_ip2       = "100"
				#�±߽���tc_rule1_ip1��һ��
				@tc_rule3_ip1       = "110"
				@tc_rule3_ip2       = "120"
				#rule1�ڷ�Χ��
				@tc_rule5_ip1       = "90"
				@tc_rule5_ip2       = "120"
				@tc_rule_error      = "IP��ַ���н���"
		end

		def process

				operate("1������DUT �������ҳ�棬��ѡ������IP������ơ�ѡ��������������Ϊ1000kbps") {
						#�򿪸߼�����
						@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
						@browser.link(id: @ts_tag_options).click
						@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
						assert(@advance_iframe.exists?, "�򿪸߼�����ʧ��")
						#����������
						bandwith = @advance_iframe.link(id: @ts_tag_bandwidth)
						unless bandwith.class_name=~/#{@ts_tag_select_state}/
								bandwith.click
						end
						sleep @tc_wait_time #�������������Ӧ�����������ӳ�
						#����������
						traffic_control = @advance_iframe.link(id: @ts_tag_traffic)
						unless traffic_control.parent.class_name==@ts_tag_liclass
								traffic_control.click
						end
						sleep @tc_wait_time #�������������Ӧ�����������ӳ�
						####�����ܿ���
						qos_sw = @advance_iframe.checkbox(id: @ts_tag_bandsw)
						unless qos_sw.checked?
								qos_sw.click
						end
						####�����ܴ���
						@advance_iframe.text_field(id: @ts_tag_wideband).set(@tc_bandwidth_total)
				}

				operate("2�����赱ǰLAN�ڵ�ַΪ192.168.100.1�����ù���1��ַ��Ϊ192.168,100.2��192.168,100.2") {
						#���ù���1���������Ƶ�IP,����ip��Χ
						puts "rule 1 ip start ip #{@tc_rule1_ip1},end ip #{@tc_rule1_ip2}"
						@advance_iframe.text_field(id: @ts_tag_range_min).set(@tc_rule1_ip1)
						@advance_iframe.text_field(id: @ts_tag_range_max).set(@tc_rule1_ip2)
						#ѡ�����������
						mode_select = @advance_iframe.select_list(id: @ts_tag_band_mode)
						mode_select.select(@ts_tag_bandlimit)
						#���ƿ��
						@advance_iframe.text_field(id: @ts_tag_band_size).set(@tc_bandwidth_limit)
						sleep @tc_rule_time

						puts "rule 2 ip start ip #{@tc_rule2_ip1},end ip #{@tc_rule2_ip2}"
						#���ù���2���������Ƶ�IP,����ip��Χ
						@advance_iframe.text_field(id: @ts_tag_range_min2).set(@tc_rule2_ip1)
						@advance_iframe.text_field(id: @ts_tag_range_max2).set(@tc_rule2_ip2)
						#ѡ�����������
						mode_select = @advance_iframe.select_list(id: @ts_tag_band_mode2)
						mode_select.select(@ts_tag_bandlimit)
						#���ƿ��
						@advance_iframe.text_field(id: @ts_tag_band_size2).set(@tc_bandwidth_limit)
						#�ύ
						@advance_iframe.button(id: @ts_tag_sbm).click
						error_tip = @advance_iframe.span(:id, @ts_tag_band_err)
						assert(error_tip.exists?, "������ʾ��Ϣδ����!")
						puts "ERROR TIP :#{error_tip.text}".encode("GBK")
						assert_equal(@tc_rule_error, error_tip.text, "��ʾ��Ϣ���ݴ���!")
				}

				operate("3�����ù���2��ַ��ҲΪ192.168,100.2��192.168,100.2���Ƿ������óɹ�") {
						#ɾ������2
						@advance_iframe.td(text: "2").parent.tds[5].link.click
						#���ù���1���������Ƶ�IP,����ip��Χ
						puts "rule 1 ip start ip #{@tc_rule1_ip1},end ip #{@tc_rule1_ip2}"
						@advance_iframe.text_field(id: @ts_tag_range_min).set(@tc_rule1_ip1)
						@advance_iframe.text_field(id: @ts_tag_range_max).set(@tc_rule1_ip2)
						sleep @tc_rule_time
						#ѡ�����������
						mode_select = @advance_iframe.select_list(id: @ts_tag_band_mode)
						mode_select.select(@ts_tag_bandlimit)
						#���ƿ��
						@advance_iframe.text_field(id: @ts_tag_band_size).set(@tc_bandwidth_limit)
						sleep @tc_rule_time
						
						puts "rule 3 ip start ip #{@tc_rule3_ip1},end ip #{@tc_rule3_ip2}"
						#���ù���3���������Ƶ�IP,����ip��Χ
						@advance_iframe.text_field(id: @ts_tag_range_min3).set(@tc_rule3_ip1)
						@advance_iframe.text_field(id: @ts_tag_range_max3).set(@tc_rule3_ip2)
						sleep @tc_rule_time
						#ѡ�����������
						mode_select = @advance_iframe.select_list(id: @ts_tag_band_mode3)
						mode_select.select(@ts_tag_bandlimit)
						#���ƿ��
						@advance_iframe.text_field(id: @ts_tag_band_size3).set(@tc_bandwidth_limit)
						#�ύ
						@advance_iframe.button(id: @ts_tag_sbm).click
						error_tip = @advance_iframe.span(:id, @ts_tag_band_err)
						assert(error_tip.exists?, "������ʾ��Ϣδ����!")
						puts "ERROR TIP :#{error_tip.text}".encode("GBK")
						assert_equal(@tc_rule_error, error_tip.text, "��ʾ��Ϣ���ݴ���!")
				}

				operate("4���������ù���1��ַ��Ϊ192.168,100.2��192.168,100.3�����ù���2��ַ��Ϊ192.168,100.3��192.168,100.4���Ƿ������óɹ�") {
						#ɾ������3
						@advance_iframe.td(text: "3").parent.tds[5].link.click
						#���ù���1���������Ƶ�IP,����ip��Χ
						puts "rule 1 ip start ip #{@tc_rule1_ip1},end ip #{@tc_rule1_ip2}"
						@advance_iframe.text_field(id: @ts_tag_range_min).set(@tc_rule1_ip1)
						@advance_iframe.text_field(id: @ts_tag_range_max).set(@tc_rule1_ip2)
						sleep @tc_rule_time
						#ѡ�����������
						mode_select = @advance_iframe.select_list(id: @ts_tag_band_mode)
						mode_select.select(@ts_tag_bandlimit)
						#���ƿ��
						@advance_iframe.text_field(id: @ts_tag_band_size).set(@tc_bandwidth_limit)
						sleep @tc_rule_time

						puts "rule 5 ip start ip #{@tc_rule5_ip1},end ip #{@tc_rule5_ip2}"
						#���ù���5���������Ƶ�IP,����ip��Χ
						@advance_iframe.text_field(id: @ts_tag_range_min5).set(@tc_rule5_ip1)
						@advance_iframe.text_field(id: @ts_tag_range_max5).set(@tc_rule5_ip2)
						#ѡ�����������
						mode_select = @advance_iframe.select_list(id: @ts_tag_band_mode5)
						mode_select.select(@ts_tag_bandlimit)
						sleep @tc_rule_time
						#���ƿ��
						@advance_iframe.text_field(id: @ts_tag_band_size5).set(@tc_bandwidth_limit)
						#�ύ
						@advance_iframe.button(id: @ts_tag_sbm).click
						error_tip = @advance_iframe.span(:id, @ts_tag_band_err)
						assert(error_tip.exists?, "������ʾ��Ϣδ����!")
						puts "ERROR TIP :#{error_tip.text}".encode("GBK")
						assert_equal(@tc_rule_error, error_tip.text, "��ʾ��Ϣ���ݴ���!")
				}


		end

		def clearup

				operate("ɾ�������������") {
						unless @browser.span(:id => @ts_tag_netset).exists?
								login_recover(@browser, @ts_default_ip)
						end

						@browser.link(id: @ts_tag_options).click
						sleep @tc_wait_time
						@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)

						#����������
						bandwith = @advance_iframe.link(id: @ts_tag_bandwidth)
						unless bandwith.class_name=~/#{@ts_tag_select_state}/
								bandwith.click
						end

						#����������
						traffic_control = @advance_iframe.link(id: @ts_tag_traffic)
						unless traffic_control.parent.class_name==@ts_tag_liclass
								traffic_control.click
						end

						#ɾ������1��2��3��5
						@advance_iframe.td(text: "1").parent.tds[5].link.click
						@advance_iframe.td(text: "2").parent.tds[5].link.click
						@advance_iframe.td(text: "3").parent.tds[5].link.click
						@advance_iframe.td(text: "5").parent.tds[5].link.click

						####�ر��ܿ���
						qos_sw = @advance_iframe.checkbox(id: @ts_tag_bandsw)
						if qos_sw.checked?
								qos_sw.click
								#�ύ
								@advance_iframe.button(id: @ts_tag_sbm).click
								sleep @tc_qos_time
						end
				}
		end

}
