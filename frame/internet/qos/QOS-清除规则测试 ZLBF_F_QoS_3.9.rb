#
# description:
# author:wuhongliang
# date:2015-08-26 11:47:04
# modify:
#
testcase {
		attr = {"id" => "ZLBF_27.1.16", "level" => "P1", "auto" => "n"}

		def prepare
				#kbps
				@tc_bandwidth_total = "100000"
				@tc_bandwidth_limit = "1024"
				@tc_wait_time       = 3
		end

		def process

				operate("1������DUT �������ҳ�棬��ѡ������IP������ơ�ѡ��������������Ϊ1000kbps") {
						#�򿪸߼�����
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.select_traffic_ctl(@browser.url)
						@options_page.select_traffic_sw
						@options_page.set_total_bw(@tc_bandwidth_total) #�����ܴ���
				}

				operate("2�����赱ǰLAN�ڵ�ַΪ192.168.100.1�����ù���1-����5��ʼ��ַ�ηֱ�Ϊ192.168,100.2-192.168.2.6��������ַ������ʼ��ַ����ͬ��ģʽ��Ϊ����������Ϊ100kbps�����ù���1-5") {
						@ip_arr     =[]
						@pc_ip_last = @ts_pc_ip.split(".").last.to_i
						@ip_arr<<@pc_ip_last.to_s
						if @pc_ip_last<=200
								p "ip address less then 200 last segment"
								(1..7).each do |i|
										tc_ip = (@pc_ip_last+i).to_s
										puts "����#{i+1}��������ʼIP #{tc_ip}������IP #{tc_ip}".encode("GBK")
										@ip_arr<<tc_ip
								end
						elsif @pc_ip_last>200
								p "ip address more than 200 last segment"
								(1..7).each do |i|
										tc_ip = (@pc_ip_last-i).to_s
										puts "����#{i+1}��������ʼIP #{tc_ip}������IP #{tc_ip}".encode("GBK")
										@ip_arr<<tc_ip
								end
						end
						#����ip��Χ�����õ�һ������
						#����1
						@ip_arr.each_with_index { |ip, index|
								puts "���õ�#{index+1}������".to_gbk
								@options_page.add_item
								@options_page.set_client_bw(index+1, ip, ip, @ts_tag_bandlimit, @tc_bandwidth_limit)
						}
						@options_page.save_traffic #����
						# ������ɺ�ˢ������������鿴�����Ƿ����
						puts "Refresh browser......"
						@browser.refresh
						sleep @tc_wait_time
						@options_page.select_traffic_ctl(@browser.url)
						puts "checkout the bandwidth setting"
						item_ipmin = @options_page.bw_ip_min0
						item_ipmax = @options_page.bw_ip_max0
						item_bw    = @options_page.bw_size0
						assert_equal(item_ipmin, @ip_arr[0], "����IPΪ#{@ip_arr[0]}������")
						assert_equal(item_ipmax, @ip_arr[0], "����IPΪ#{@ip_arr[0]}������")
						assert_equal(item_bw, @tc_bandwidth_limit, "����IPΪ#{@ip_arr[0]}������")
						item_ipmin = @options_page.bw_ip_min1
						item_ipmax = @options_page.bw_ip_max1
						item_bw    = @options_page.bw_size1
						assert_equal(item_ipmin, @ip_arr[1], "����IPΪ#{@ip_arr[1]}������")
						assert_equal(item_ipmax, @ip_arr[1], "����IPΪ#{@ip_arr[1]}������")
						assert_equal(item_bw, @tc_bandwidth_limit, "����IPΪ#{@ip_arr[1]}������")
						item_ipmin = @options_page.bw_ip_min2
						item_ipmax = @options_page.bw_ip_max2
						item_bw    = @options_page.bw_size2
						assert_equal(item_ipmin, @ip_arr[2], "����IPΪ#{@ip_arr[2]}������")
						assert_equal(item_ipmax, @ip_arr[2], "����IPΪ#{@ip_arr[2]}������")
						assert_equal(item_bw, @tc_bandwidth_limit, "����IPΪ#{@ip_arr[2]}������")
						item_ipmin = @options_page.bw_ip_min3
						item_ipmax = @options_page.bw_ip_max3
						item_bw    = @options_page.bw_size3
						assert_equal(item_ipmin, @ip_arr[3], "����IPΪ#{@ip_arr[3]}������")
						assert_equal(item_ipmax, @ip_arr[3], "����IPΪ#{@ip_arr[3]}������")
						assert_equal(item_bw, @tc_bandwidth_limit, "����IPΪ#{@ip_arr[3]}������")
						item_ipmin = @options_page.bw_ip_min4
						item_ipmax = @options_page.bw_ip_max4
						item_bw    = @options_page.bw_size4
						assert_equal(item_ipmin, @ip_arr[4], "����IPΪ#{@ip_arr[4]}������")
						assert_equal(item_ipmax, @ip_arr[4], "����IPΪ#{@ip_arr[4]}������")
						assert_equal(item_bw, @tc_bandwidth_limit, "����IPΪ#{@ip_arr[4]}������")
						item_ipmin = @options_page.bw_ip_min5
						item_ipmax = @options_page.bw_ip_max5
						item_bw    = @options_page.bw_size5
						assert_equal(item_ipmin, @ip_arr[5], "����IPΪ#{@ip_arr[5]}������")
						assert_equal(item_ipmax, @ip_arr[5], "����IPΪ#{@ip_arr[5]}������")
						assert_equal(item_bw, @tc_bandwidth_limit, "����IPΪ#{@ip_arr[5]}������")
						item_ipmin = @options_page.bw_ip_min6
						item_ipmax = @options_page.bw_ip_max6
						item_bw    = @options_page.bw_size6
						assert_equal(item_ipmin, @ip_arr[6], "����IPΪ#{@ip_arr[6]}������")
						assert_equal(item_ipmax, @ip_arr[6], "����IPΪ#{@ip_arr[6]}������")
						assert_equal(item_bw, @tc_bandwidth_limit, "����IPΪ#{@ip_arr[6]}������")
						item_ipmin = @options_page.bw_ip_min7
						item_ipmax = @options_page.bw_ip_max7
						item_bw    = @options_page.bw_size7
						assert_equal(item_ipmin, @ip_arr[7], "����IPΪ#{@ip_arr[7]}������")
						assert_equal(item_ipmax, @ip_arr[7], "����IPΪ#{@ip_arr[7]}������")
						assert_equal(item_bw, @tc_bandwidth_limit, "����IPΪ#{@ip_arr[7]}������")
				}

				operate("3����ÿ�����������������ť���Ƿ�������ҳ���ϵ�����") {
						#ɾ������1
						@options_page.bw_td0_element.parent[5].link_element.click
						sleep @tc_wait_time
						#ɾ������2
						@options_page.bw_td1_element.parent[5].link_element.click
						sleep @tc_wait_time
						#ɾ������3
						@options_page.bw_td2_element.parent[5].link_element.click
						sleep @tc_wait_time
						#ɾ������4
						@options_page.bw_td3_element.parent[5].link_element.click
						sleep @tc_wait_time
						#ɾ������5
						@options_page.bw_td4_element.parent[5].link_element.click
						sleep @tc_wait_time
						#ɾ������6
						@options_page.bw_td5_element.parent[5].link_element.click
						sleep @tc_wait_time
						#ɾ������7
						@options_page.bw_td6_element.parent[5].link_element.click
						sleep @tc_wait_time
						#ɾ������8
						@options_page.bw_td7_element.parent[5].link_element.click
						sleep @tc_wait_time
						@options_page.save_traffic #����
				}

				operate("4������������棬ˢ��ҳ�棬ȷ����Ϣ�Ѿ����") {
						puts "Refresh browser again......"
						@browser.refresh
						sleep @tc_wait_time
						@options_page.select_traffic_ctl(@browser.url)
						item_ipmin = @options_page.bw_td0_element.exists?
						refute(item_ipmin, "����IPΪ#{@ip_arr[0]}ɾ��ʧ��")
						item_ipmin = @options_page.bw_td1_element.exists?
						refute(item_ipmin, "����IPΪ#{@ip_arr[1]}ɾ��ʧ��")
						item_ipmin = @options_page.bw_td2_element.exists?
						refute(item_ipmin, "����IPΪ#{@ip_arr[2]}ɾ��ʧ��")
						item_ipmin = @options_page.bw_td3_element.exists?
						refute(item_ipmin, "����IPΪ#{@ip_arr[3]}ɾ��ʧ��")
						item_ipmin = @options_page.bw_td4_element.exists?
						refute(item_ipmin, "����IPΪ#{@ip_arr[4]}ɾ��ʧ��")
						item_ipmin = @options_page.bw_td5_element.exists?
						refute(item_ipmin, "����IPΪ#{@ip_arr[5]}ɾ��ʧ��")
						item_ipmin = @options_page.bw_td6_element.exists?
						refute(item_ipmin, "����IPΪ#{@ip_arr[6]}ɾ��ʧ��")
						item_ipmin = @options_page.bw_td7_element.exists?
						refute(item_ipmin, "����IPΪ#{@ip_arr[7]}ɾ��ʧ��")
				}

		end

		def clearup
				operate("1 �ر���������") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.select_traffic_ctl(@browser.url)
						@options_page.delete_item_all
						@options_page.unselect_traffic_sw
						@options_page.save_traffic #����
				}
		end

}
