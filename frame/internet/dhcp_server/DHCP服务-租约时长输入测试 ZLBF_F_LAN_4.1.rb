#
# description:
##只需要输入边界值两个，一般等价类值一个，上边界加1，下边界减1,五个值来测试即可
# author:wuhongliang
# date:2015-10-%qos 17:43:16
# modify:
#
testcase {
		attr = {"id" => "ZLBF_8.1.26", "level" => "P1", "auto" => "n"}

		def prepare
				@tc_lease_error   = "租约时间范围为60-43200" #SDK
				@tc_lease_time1   = "59"
				@tc_lease_time2   = "60" #边界值
				@tc_lease_time3   = "1800" #等价值
				@tc_lease_time4   = "43200" #边界值
				@tc_lease_time5   = "43201"
				@tc_lan_time      = 30
		end

		def process

				operate("1、登陆路由器进入内网设置") {
						@lan_page = RouterPageObject::LanPage.new(@browser)
						@lan_page.open_lan_page(@browser.url)
				}

				operate("2、更改租约时长输入#{@tc_lease_time1}秒，#{@tc_lease_time2}秒，#{@tc_lease_time3}秒，#{@tc_lease_time4}秒，#{@tc_lease_time5}秒") {
						puts "设置租期为:#{@tc_lease_time1}".to_gbk
						@lan_page.dhcp_lease_set(@tc_lease_time1)
						@lan_page.save_lanset
						puts "ERROR TIP:#{@lan_page.lan_error}".to_gbk
						if @lan_page.lan_error==@tc_lease_error
								assert_equal(@tc_lease_error, @lan_page.lan_error.strip, "设置租期为:#{@tc_lease_time1}也可以保存")
						else
								sleep @tc_lan_time
								assert(false, "设置租期为:#{@tc_lease_time1}未提示租期错误")
						end

						puts "设置租期为:#{@tc_lease_time2}".to_gbk
						@lan_page.dhcp_lease_set(@tc_lease_time2)
						@lan_page.btn_save_lanset
						@lan_page.open_lan_page(@browser.url)
						curr_lease=@lan_page.dhcp_lease
						assert_equal(@tc_lease_time2, curr_lease, "设置租期为最小值#{@tc_lease_time2}失败")

						puts "设置租期为:#{@tc_lease_time3}".to_gbk
						@lan_page.dhcp_lease_set(@tc_lease_time3)
						@lan_page.btn_save_lanset
						@lan_page.open_lan_page(@browser.url)
						curr_lease=@lan_page.dhcp_lease
						assert_equal(@tc_lease_time3, curr_lease, "设置租期为#{@tc_lease_time3}失败")

						puts "设置租期为:#{@tc_lease_time4}".to_gbk
						@lan_page.dhcp_lease_set(@tc_lease_time4)
						@lan_page.btn_save_lanset
						@lan_page.open_lan_page(@browser.url)
						curr_lease=@lan_page.dhcp_lease
						assert_equal(@tc_lease_time4, curr_lease, "设置租期为#{@tc_lease_time4}失败")

						puts "设置租期为:#{@tc_lease_time5}".to_gbk
						@lan_page.dhcp_lease_set(@tc_lease_time5)
						@lan_page.save_lanset
						puts "ERROR TIP:#{@lan_page.lan_error}".to_gbk
						if @lan_page.lan_error==@tc_lease_error
								assert_equal(@tc_lease_error, @lan_page.lan_error.strip, "设置租期为:#{@tc_lease_time5}也可以保存")
						else
								sleep @tc_lan_time
								assert(false, "设置租期为:#{@tc_lease_time5}未提示租期错误")
						end
				}

				operate("3、点击保存") {

				}


		end

		def clearup
				operate("1 恢复默认起始地址范围") {
						unless @lan_page.nil?
								@browser.refresh
								@lan_page.open_lan_page(@browser.url)
								dhcp_lease = @lan_page.dhcp_lease
								unless dhcp_lease == @ts_default_leasetime
										puts "恢复租期为#{@ts_default_leasetime}".to_gbk
										@lan_page.dhcp_lease_set(@ts_default_leasetime)
										@lan_page.btn_save_lanset
								end
						end
				}
		end

}
