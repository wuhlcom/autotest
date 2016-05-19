#
# description:
# author:wuhongliang
# date:2015-08-26 11:47:04
# modify:
#
testcase {
		attr = {"id" => "ZLBF_27.1.16", "level" => "P1", "auto" => "n"}

		def prepare

				@tc_wait_time       = 2
				@tc_qos_time        = 5
				@tc_net_time        = 35
				#kbps
				@tc_bandwidth_total = "100000"
				@tc_bandwidth_limit = "1024"

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
						#####�����ܴ���
						@advance_iframe.text_field(id: @ts_tag_wideband).set(@tc_bandwidth_total)
				}

				operate("2�����赱ǰLAN�ڵ�ַΪ192.168.100.1�����ù���1-����5��ʼ��ַ�ηֱ�Ϊ192.168,100.2-192.168.2.6��������ַ������ʼ��ַ����ͬ��ģʽ��Ϊ����������Ϊ100kbps�����ù���1-5") {
						@pc_ip_last = @ts_pc_ip.split(".").last.to_i
						if @pc_ip_last<=200
								p "ip address last segment"
								@tc_ip_min2 = (@pc_ip_last+1).to_s
								@tc_ip_max2 =(@pc_ip_last+1).to_s
								puts "����2��������ʼIP#{@tc_ip_min2}������IP#{@tc_ip_max2}".encode("GBK")
								@tc_ip_min3 = (@pc_ip_last+2).to_s
								@tc_ip_max3 = (@pc_ip_last+4).to_s
								puts "����3��������ʼIP#{@tc_ip_min3}������IP#{@tc_ip_max3}".encode("GBK")
								@tc_ip_min4 = (@pc_ip_last+5).to_s
								@tc_ip_max4 = (@pc_ip_last+5).to_s
								puts "����4��������ʼIP#{@tc_ip_min4}������IP#{@tc_ip_max4}".encode("GBK")
								@tc_ip_min5 = (@pc_ip_last+6).to_s
								@tc_ip_max5 = (@pc_ip_last+8).to_s
								puts "����5��������ʼIP#{@tc_ip_min5}������IP#{@tc_ip_max5}".encode("GBK")
						elsif @pc_ip_last>200
								p "ip address last segment"
								@tc_ip_min2 = (@pc_ip_last-1).to_s
								@tc_ip_max2 = (@pc_ip_last-1).to_s
								puts "����2��������ʼIP#{@tc_ip_min2}������IP#{@tc_ip_max2}".encode("GBK")
								@tc_ip_min3 = (@pc_ip_last-2).to_s
								@tc_ip_max3 = (@pc_ip_last-4).to_s
								puts "����3��������ʼIP#{@tc_ip_min3}������IP#{@tc_ip_max3}".encode("GBK")
								@tc_ip_min4 = (@pc_ip_last-5).to_s
								@tc_ip_max4 = (@pc_ip_last-5).to_s
								puts "����4��������ʼIP#{@tc_ip_min4}������IP#{@tc_ip_max4}".encode("GBK")
								@tc_ip_min5 = (@pc_ip_last-6).to_s
								@tc_ip_max5 = (@pc_ip_last-8).to_s
								puts "����5��������ʼIP#{@tc_ip_min5}������IP#{@tc_ip_max5}".encode("GBK")
						end
						@pc_ip_last=@pc_ip_last.to_s
						#����ip��Χ�����õ�һ������
						@advance_iframe.text_field(id: @ts_tag_range_min).set(@pc_ip_last)
						@advance_iframe.text_field(id: @ts_tag_range_max).set(@pc_ip_last)
						#ѡ�� ����������
						mode_select = @advance_iframe.select_list(id: @ts_tag_band_mode)
						mode_select.select(@ts_tag_bandlimit)
						#���ƴ���
						@advance_iframe.text_field(id: @ts_tag_band_size).set(@tc_bandwidth_limit)
						sleep @tc_wait_time
						#����ip��Χ ���õڶ�������
						@advance_iframe.text_field(id: @ts_tag_range_min2).set(@tc_ip_min2)
						@advance_iframe.text_field(id: @ts_tag_range_max2).set(@tc_ip_max2)
						#ѡ�� ����������
						mode_select2 = @advance_iframe.select_list(id: @ts_tag_band_mode2)
						mode_select2.select(@ts_tag_bandlimit)
						#���ƴ���
						@advance_iframe.text_field(id: @ts_tag_band_size2).set(@tc_bandwidth_limit)
						sleep @tc_wait_time
						#����ip��Χ ���õ���������
						@advance_iframe.text_field(id: @ts_tag_range_min3).set(@tc_ip_min3)
						@advance_iframe.text_field(id: @ts_tag_range_max3).set(@tc_ip_max3)
						#ѡ�� ������С����
						mode_select3 = @advance_iframe.select_list(id: @ts_tag_band_mode3)
						mode_select3.select(@ts_tag_bandensure)
						#���ƴ���
						@advance_iframe.text_field(id: @ts_tag_band_size3).set(@tc_bandwidth_limit)
						sleep @tc_wait_time
						#����ip��Χ ���õ���������
						@advance_iframe.text_field(id: @ts_tag_range_min4).set(@tc_ip_min4)
						@advance_iframe.text_field(id: @ts_tag_range_max4).set(@tc_ip_min4)
						#ѡ�� ����������
						mode_select4 = @advance_iframe.select_list(id: @ts_tag_band_mode4)
						mode_select4.select(@ts_tag_bandlimit)
						#���ƴ���
						@advance_iframe.text_field(id: @ts_tag_band_size4).set(@tc_bandwidth_limit)
						sleep @tc_wait_time
						#����ip��Χ ���õ���������
						@advance_iframe.text_field(id: @ts_tag_range_min5).set(@tc_ip_min5)
						@advance_iframe.text_field(id: @ts_tag_range_max5).set(@tc_ip_max5)
						#ѡ�� ������С����
						mode_select5 = @advance_iframe.select_list(id: @ts_tag_band_mode5)
						mode_select5.select(@ts_tag_bandensure)
						#���ƴ���
						@advance_iframe.text_field(id: @ts_tag_band_size5).set(@tc_bandwidth_limit)
						#�ύ
						@advance_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_qos_time

						# ������ɺ�ˢ������������鿴�����Ƿ����
						puts "Refresh browser......"
						@browser.refresh
						sleep @tc_wait_time
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
						#����������
						traffic_control = @advance_iframe.link(id: @ts_tag_traffic)
						unless traffic_control.parent.class_name==@ts_tag_liclass
								traffic_control.click
						end
						puts "checkout the bandwidth setting"
						#��һ������
						min_ip        = @advance_iframe.text_field(id: @ts_tag_range_min).value
						max_ip        = @advance_iframe.text_field(id: @ts_tag_range_max).value
						#ѡ�� ����������
						mode_select   = @advance_iframe.select_list(id: @ts_tag_band_mode)
						select_state  = mode_select.selected?(@ts_tag_bandlimit)
						#���ƴ���
						bandwith_limit=@advance_iframe.text_field(id: @ts_tag_band_size).value
						assert_equal(@pc_ip_last, min_ip, "����1����ʼip#{@pc_ip_last}����ʧ��")
						assert_equal(@pc_ip_last, max_ip, "����1�Ľ���ip#{@pc_ip_last}����ʧ��")
						assert(select_state, "����1��ģʽ#{@ts_tag_bandlimit}����ʧ��")
						assert_equal(@tc_bandwidth_limit, bandwith_limit, "����1�Ĵ�������Ϊ#{@tc_bandwidth_limit}����ʧ��")

						# �ڶ�������
						min_ip2        = @advance_iframe.text_field(id: @ts_tag_range_min2).value
						max_ip2        = @advance_iframe.text_field(id: @ts_tag_range_max2).value
						#ѡ�� ����������
						mode_select2   = @advance_iframe.select_list(id: @ts_tag_band_mode2)
						select_state2  = mode_select2.selected?(@ts_tag_bandlimit)
						#���ƴ���
						bandwith_limit2= @advance_iframe.text_field(id: @ts_tag_band_size2).value
						assert_equal(@tc_ip_min2, min_ip2, "����2����ʼip#{@tc_ip_min2}����ʧ��")
						assert_equal(@tc_ip_max2, max_ip2, "����2�Ľ���ip#{@tc_ip_max2}����ʧ��")
						assert(select_state2, "����2��ģʽ#{@ts_tag_bandlimit}����ʧ��")
						assert_equal(@tc_bandwidth_limit, bandwith_limit2, "����2�Ĵ�������Ϊ#{@tc_bandwidth_limit}����ʧ��")

						# ����������
						min_ip3        = @advance_iframe.text_field(id: @ts_tag_range_min3).value
						max_ip3        = @advance_iframe.text_field(id: @ts_tag_range_max3).value
						#ѡ�� ����������
						mode_select3   = @advance_iframe.select_list(id: @ts_tag_band_mode3)
						select_state3  = mode_select3.selected?(@ts_tag_bandensure)
						#���ƴ���
						bandwith_limit3=@advance_iframe.text_field(id: @ts_tag_band_size3).value
						assert_equal(@tc_ip_min3, min_ip3, "����3����ʼip#{@tc_ip_min3}����ʧ��")
						assert_equal(@tc_ip_max3, max_ip3, "����3�Ľ���ip#{@tc_ip_max3}����ʧ��")
						assert(select_state3, "����3��ģʽ#{@ts_tag_bandlimit}����ʧ��")
						assert_equal(@tc_bandwidth_limit, bandwith_limit3, "����3�Ĵ�������Ϊ#{@tc_bandwidth_limit}����ʧ��")

						# ����������
						min_ip4        = @advance_iframe.text_field(id: @ts_tag_range_min4).value
						max_ip4        = @advance_iframe.text_field(id: @ts_tag_range_max4).value
						#ѡ�� ������С����
						mode_select4   = @advance_iframe.select_list(id: @ts_tag_band_mode4)
						select_state4  = mode_select4.selected?(@ts_tag_bandlimit)
						#���ƴ���
						bandwith_limit4=@advance_iframe.text_field(id: @ts_tag_band_size).value
						assert_equal(@tc_ip_min4, min_ip4, "����4����ʼip#{@tc_ip_min4}����ʧ��")
						assert_equal(@tc_ip_max4, max_ip4, "����4�Ľ���ip#{@tc_ip_max4}����ʧ��")
						assert(select_state4, "����4��ģʽ#{@ts_tag_bandlimit}����ʧ��")
						assert_equal(@tc_bandwidth_limit, bandwith_limit4, "����4�Ĵ�������Ϊ#{@tc_bandwidth_limit}����ʧ��")

						# ����������
						min_ip5        = @advance_iframe.text_field(id: @ts_tag_range_min5).value
						max_ip5        = @advance_iframe.text_field(id: @ts_tag_range_max5).value
						#ѡ�� ����������
						mode_select5   = @advance_iframe.select_list(id: @ts_tag_band_mode5)
						select_state5  = mode_select5.selected?(@ts_tag_bandensure)
						#���ƴ���
						bandwith_limit5= @advance_iframe.text_field(id: @ts_tag_band_size5).value
						assert_equal(@tc_ip_min5, min_ip5, "����5����ʼip#{@tc_ip_min5}����ʧ��")
						assert_equal(@tc_ip_max5, max_ip5, "����5�Ľ���ip#{@tc_ip_max5}����ʧ��")
						assert(select_state5, "����5��ģʽ#{@ts_tag_bandlimit}����ʧ��")
						assert_equal(@tc_bandwidth_limit, bandwith_limit5, "����5�Ĵ�������Ϊ#{@tc_bandwidth_limit}����ʧ��")
				}

				operate("3����ÿ�����������������ť���Ƿ�������ҳ���ϵ�����") {
						# bandwidth_table = @advance_iframe.table(class_name: @ts_tag_band_tb)
						# @advance_iframe.table(class_name: @ts_tag_band_tb).trs[1][5].link(title: @ts_tag_clear_btn).click
						#ɾ������1
						@advance_iframe.td(text: "1").parent.tds[5].link.click
						#ɾ������2
						@advance_iframe.td(text: "2").parent.tds[5].link.click
						#ɾ������3
						@advance_iframe.td(text: "3").parent.tds[5].link.click
						#ɾ������4
						@advance_iframe.td(text: "4").parent.tds[5].link.click
						#ɾ������5
						@advance_iframe.td(text: "5").parent.tds[5].link.click
						#�ύ
						@advance_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_qos_time
				}

				operate("4������������棬ˢ��ҳ�棬ȷ����Ϣ�Ѿ����") {
						puts "Refresh browser again......"
						@browser.refresh
						sleep @tc_wait_time
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
						#����������
						traffic_control = @advance_iframe.link(id: @ts_tag_traffic)
						unless traffic_control.parent.class_name==@ts_tag_liclass
								traffic_control.click
						end
						#��һ������
						empty_ip      = ""
						empty_bandwith=""
						min_ip        = @advance_iframe.text_field(id: @ts_tag_range_min).value
						max_ip        = @advance_iframe.text_field(id: @ts_tag_range_max).value
						#ѡ�� ����������
						mode_select   = @advance_iframe.select_list(id: @ts_tag_band_mode)
						select_state  = mode_select.selected?(@ts_tag_bandensure)
						#���ƴ���
						bandwith_limit=@advance_iframe.text_field(id: @ts_tag_band_size).value
						assert_equal(empty_ip, min_ip, "����1����ʼip���ʧ��")
						assert_equal(empty_ip, max_ip, "����1�Ľ���ip���ʧ��")
						assert(select_state, "����1��ģʽδ�ָ��ɣ�#{@ts_tag_bandensure}")
						assert_equal(empty_bandwith, bandwith_limit, "����1�Ĵ����������ʧ��")

						#�ڶ�������
						min_ip2        = @advance_iframe.text_field(id: @ts_tag_range_min2).value
						max_ip2        = @advance_iframe.text_field(id: @ts_tag_range_max2).value
						#ѡ�� ����������
						mode_select2   = @advance_iframe.select_list(id: @ts_tag_band_mode2)
						select_state2  = mode_select2.selected?(@ts_tag_bandensure)
						#���ƴ���
						bandwith_limit2=@advance_iframe.text_field(id: @ts_tag_band_size2).value
						assert_equal(empty_ip, min_ip2, "����2����ʼip���ʧ��")
						assert_equal(empty_ip, max_ip2, "����2�Ľ���ip���ʧ��")
						assert(select_state2, "����2��ģʽδ�ָ��ɣ�#{@ts_tag_bandensure}")
						assert_equal(empty_bandwith, bandwith_limit2, "����2�Ĵ����������ʧ��")

						#����������
						min_ip3        = @advance_iframe.text_field(id: @ts_tag_range_min3).value
						max_ip3        = @advance_iframe.text_field(id: @ts_tag_range_max3).value
						#ѡ�� ����������
						mode_select3   = @advance_iframe.select_list(id: @ts_tag_band_mode3)
						select_state3  = mode_select3.selected?(@ts_tag_bandensure)
						#���ƴ���
						bandwith_limit3= @advance_iframe.text_field(id: @ts_tag_band_size3).value
						assert_equal(empty_ip, min_ip3, "����3����ʼip���ʧ��")
						assert_equal(empty_ip, max_ip3, "����3�Ľ���ip���ʧ��")
						assert(select_state3, "����3��ģʽδ�ָ��ɣ�#{@ts_tag_bandensure}")
						assert_equal(empty_bandwith, bandwith_limit3, "����3�Ĵ����������ʧ��")

						#����������
						min_ip4        = @advance_iframe.text_field(id: @ts_tag_range_min4).value
						max_ip4        = @advance_iframe.text_field(id: @ts_tag_range_max4).value
						#ѡ�� ����������
						mode_select4   = @advance_iframe.select_list(id: @ts_tag_band_mode4)
						select_state4  = mode_select4.selected?(@ts_tag_bandensure)
						#���ƴ���
						bandwith_limit4= @advance_iframe.text_field(id: @ts_tag_band_size4).value
						assert_equal(empty_ip, min_ip4, "����4����ʼip���ʧ��")
						assert_equal(empty_ip, max_ip4, "����4�Ľ���ip���ʧ��")
						assert(select_state4, "����4��ģʽδ�ָ��ɣ�#{@ts_tag_bandensure}")
						assert_equal(empty_bandwith, bandwith_limit4, "����4�Ĵ����������ʧ��")

						#����������
						min_ip5        = @advance_iframe.text_field(id: @ts_tag_range_min5).value
						max_ip5        = @advance_iframe.text_field(id: @ts_tag_range_max5).value
						#ѡ�� ����������
						mode_select5   = @advance_iframe.select_list(id: @ts_tag_band_mode5)
						select_state5  = mode_select5.selected?(@ts_tag_bandensure)
						#���ƴ���
						bandwith_limit5= @advance_iframe.text_field(id: @ts_tag_band_size5).value
						assert_equal(empty_ip, min_ip5, "����5����ʼip���ʧ��")
						assert_equal(empty_ip, max_ip5, "����5�Ľ���ip���ʧ��")
						assert(select_state5, "����5��ģʽδ�ָ��ɣ�#{@ts_tag_bandensure}")
						assert_equal(empty_bandwith, bandwith_limit5, "����5�Ĵ����������ʧ��")
				}

		end

		def clearup
				operate("1 �ر���������") {
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

						#ɾ������1
						@advance_iframe.td(text: "1").parent.tds[5].link.click
						#ɾ������2
						@advance_iframe.td(text: "2").parent.tds[5].link.click
						#ɾ������3
						@advance_iframe.td(text: "3").parent.tds[5].link.click
						#ɾ������4
						@advance_iframe.td(text: "4").parent.tds[5].link.click
						#ɾ������5
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
