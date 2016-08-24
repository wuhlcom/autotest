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

				operate("1、进入DUT 带宽控制页面，勾选“开启IP带宽控制”选项框，设置申请带宽为1000kbps") {
						#打开高级设置
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.select_traffic_ctl(@browser.url)
						@options_page.select_traffic_sw
						@options_page.set_total_bw(@tc_bandwidth_total) #设置总带宽
				}

				operate("2、假设当前LAN口地址为192.168.100.1，设置规则1-规则5起始地址段分别为192.168,100.2-192.168.2.6，结束地址段与起始地址段相同。模式都为限制最大带宽为100kbps，启用规则1-5") {
						@ip_arr     =[]
						@pc_ip_last = @ts_pc_ip.split(".").last.to_i
						@ip_arr<<@pc_ip_last.to_s
						if @pc_ip_last<=200
								p "ip address less then 200 last segment"
								(1..7).each do |i|
										tc_ip = (@pc_ip_last+i).to_s
										puts "规则#{i+1}：设置起始IP #{tc_ip}，结束IP #{tc_ip}".encode("GBK")
										@ip_arr<<tc_ip
								end
						elsif @pc_ip_last>200
								p "ip address more than 200 last segment"
								(1..7).each do |i|
										tc_ip = (@pc_ip_last-i).to_s
										puts "规则#{i+1}：设置起始IP #{tc_ip}，结束IP #{tc_ip}".encode("GBK")
										@ip_arr<<tc_ip
								end
						end
						#设置ip范围，设置第一条规则
						#规则1
						@ip_arr.each_with_index { |ip, index|
								puts "设置第#{index+1}条规则".to_gbk
								@options_page.add_item
								@options_page.set_client_bw(index+1, ip, ip, @ts_tag_bandlimit, @tc_bandwidth_limit)
						}
						@options_page.save_traffic #保存
						# 配置完成后，刷新浏览器，并查看配置是否存在
						puts "Refresh browser......"
						@browser.refresh
						sleep @tc_wait_time
						@options_page.select_traffic_ctl(@browser.url)
						puts "checkout the bandwidth setting"
						item_ipmin = @options_page.bw_ip_min0
						item_ipmax = @options_page.bw_ip_max0
						item_bw    = @options_page.bw_size0
						assert_equal(item_ipmin, @ip_arr[0], "规则IP为#{@ip_arr[0]}不存在")
						assert_equal(item_ipmax, @ip_arr[0], "规则IP为#{@ip_arr[0]}不存在")
						assert_equal(item_bw, @tc_bandwidth_limit, "规则IP为#{@ip_arr[0]}不存在")
						item_ipmin = @options_page.bw_ip_min1
						item_ipmax = @options_page.bw_ip_max1
						item_bw    = @options_page.bw_size1
						assert_equal(item_ipmin, @ip_arr[1], "规则IP为#{@ip_arr[1]}不存在")
						assert_equal(item_ipmax, @ip_arr[1], "规则IP为#{@ip_arr[1]}不存在")
						assert_equal(item_bw, @tc_bandwidth_limit, "规则IP为#{@ip_arr[1]}不存在")
						item_ipmin = @options_page.bw_ip_min2
						item_ipmax = @options_page.bw_ip_max2
						item_bw    = @options_page.bw_size2
						assert_equal(item_ipmin, @ip_arr[2], "规则IP为#{@ip_arr[2]}不存在")
						assert_equal(item_ipmax, @ip_arr[2], "规则IP为#{@ip_arr[2]}不存在")
						assert_equal(item_bw, @tc_bandwidth_limit, "规则IP为#{@ip_arr[2]}不存在")
						item_ipmin = @options_page.bw_ip_min3
						item_ipmax = @options_page.bw_ip_max3
						item_bw    = @options_page.bw_size3
						assert_equal(item_ipmin, @ip_arr[3], "规则IP为#{@ip_arr[3]}不存在")
						assert_equal(item_ipmax, @ip_arr[3], "规则IP为#{@ip_arr[3]}不存在")
						assert_equal(item_bw, @tc_bandwidth_limit, "规则IP为#{@ip_arr[3]}不存在")
						item_ipmin = @options_page.bw_ip_min4
						item_ipmax = @options_page.bw_ip_max4
						item_bw    = @options_page.bw_size4
						assert_equal(item_ipmin, @ip_arr[4], "规则IP为#{@ip_arr[4]}不存在")
						assert_equal(item_ipmax, @ip_arr[4], "规则IP为#{@ip_arr[4]}不存在")
						assert_equal(item_bw, @tc_bandwidth_limit, "规则IP为#{@ip_arr[4]}不存在")
						item_ipmin = @options_page.bw_ip_min5
						item_ipmax = @options_page.bw_ip_max5
						item_bw    = @options_page.bw_size5
						assert_equal(item_ipmin, @ip_arr[5], "规则IP为#{@ip_arr[5]}不存在")
						assert_equal(item_ipmax, @ip_arr[5], "规则IP为#{@ip_arr[5]}不存在")
						assert_equal(item_bw, @tc_bandwidth_limit, "规则IP为#{@ip_arr[5]}不存在")
						item_ipmin = @options_page.bw_ip_min6
						item_ipmax = @options_page.bw_ip_max6
						item_bw    = @options_page.bw_size6
						assert_equal(item_ipmin, @ip_arr[6], "规则IP为#{@ip_arr[6]}不存在")
						assert_equal(item_ipmax, @ip_arr[6], "规则IP为#{@ip_arr[6]}不存在")
						assert_equal(item_bw, @tc_bandwidth_limit, "规则IP为#{@ip_arr[6]}不存在")
						item_ipmin = @options_page.bw_ip_min7
						item_ipmax = @options_page.bw_ip_max7
						item_bw    = @options_page.bw_size7
						assert_equal(item_ipmin, @ip_arr[7], "规则IP为#{@ip_arr[7]}不存在")
						assert_equal(item_ipmax, @ip_arr[7], "规则IP为#{@ip_arr[7]}不存在")
						assert_equal(item_bw, @tc_bandwidth_limit, "规则IP为#{@ip_arr[7]}不存在")
				}

				operate("3、对每条规则点击“清除”按钮，是否会清除掉页面上的配置") {
						#删除规则1
						@options_page.bw_td0_element.parent[5].link_element.click
						sleep @tc_wait_time
						#删除规则2
						@options_page.bw_td1_element.parent[5].link_element.click
						sleep @tc_wait_time
						#删除规则3
						@options_page.bw_td2_element.parent[5].link_element.click
						sleep @tc_wait_time
						#删除规则4
						@options_page.bw_td3_element.parent[5].link_element.click
						sleep @tc_wait_time
						#删除规则5
						@options_page.bw_td4_element.parent[5].link_element.click
						sleep @tc_wait_time
						#删除规则6
						@options_page.bw_td5_element.parent[5].link_element.click
						sleep @tc_wait_time
						#删除规则7
						@options_page.bw_td6_element.parent[5].link_element.click
						sleep @tc_wait_time
						#删除规则8
						@options_page.bw_td7_element.parent[5].link_element.click
						sleep @tc_wait_time
						@options_page.save_traffic #保存
				}

				operate("4、清除后点击保存，刷新页面，确保信息已经清空") {
						puts "Refresh browser again......"
						@browser.refresh
						sleep @tc_wait_time
						@options_page.select_traffic_ctl(@browser.url)
						item_ipmin = @options_page.bw_td0_element.exists?
						refute(item_ipmin, "规则IP为#{@ip_arr[0]}删除失败")
						item_ipmin = @options_page.bw_td1_element.exists?
						refute(item_ipmin, "规则IP为#{@ip_arr[1]}删除失败")
						item_ipmin = @options_page.bw_td2_element.exists?
						refute(item_ipmin, "规则IP为#{@ip_arr[2]}删除失败")
						item_ipmin = @options_page.bw_td3_element.exists?
						refute(item_ipmin, "规则IP为#{@ip_arr[3]}删除失败")
						item_ipmin = @options_page.bw_td4_element.exists?
						refute(item_ipmin, "规则IP为#{@ip_arr[4]}删除失败")
						item_ipmin = @options_page.bw_td5_element.exists?
						refute(item_ipmin, "规则IP为#{@ip_arr[5]}删除失败")
						item_ipmin = @options_page.bw_td6_element.exists?
						refute(item_ipmin, "规则IP为#{@ip_arr[6]}删除失败")
						item_ipmin = @options_page.bw_td7_element.exists?
						refute(item_ipmin, "规则IP为#{@ip_arr[7]}删除失败")
				}

		end

		def clearup
				operate("1 关闭流量控制") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.select_traffic_ctl(@browser.url)
						@options_page.delete_item_all
						@options_page.unselect_traffic_sw
						@options_page.save_traffic #保存
				}
		end

}
