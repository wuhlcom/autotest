#
# description:
# author:wuhongliang
# date:2015-08-26 11:47:03
# modify:
#
testcase {
		attr = {"id" => "ZLBF_8.1.2", "level" => "P2", "auto" => "n"}

		def prepare
				@tc_lease_time = "120"
				#抓包查看
				tc_cap_fields = "-e eth.dst -e eth.src -e ip.src -e ip.dst -e bootp.option.type -e bootp.option.ip_address_lease_time"
				tc_cap_filter = "bootp.option.type==51"
				puts "Capture filter: #{tc_cap_filter}"
				@tc_cap_args      ={nic: @ts_nicname, filter: tc_cap_filter, duration: @tc_lease_time, fields: tc_cap_fields}
		end

		def process

				operate("1、在PC1启动抓包软件；") {
						##打开lan设置
						@lan_page = RouterPageObject::LanPage.new(@browser)
						@lan_page.open_lan_page(@browser.url)
						##修改租约为2分钟
						puts "设置租期为#{@tc_lease_time}".to_gbk
						@lan_page.dhcp_lease_set(@tc_lease_time)
						@lan_page.btn_save_lanset
				}

				operate("2、设置PC1为自动获取IP地址，抓包查看lease time是否为设置的时间，PC1网卡的“网络连接详细信息”租约时间是否正确；") {
						ip_release(@ts_nicname)
						ip_renew(@ts_nicname)
						rs          = ipconfig(@ts_ipconf_all)
						rent_time   = rs[@ts_nicname][:rent_time]
						lease_time  = rs[@ts_nicname][:lease_time]
						t_rent_time = Time.parse(rent_time)
						puts "PC NIC Rent time : #{t_rent_time}"
						t_lease_time = Time.parse(lease_time)
						puts "PC NIC Lease time : #{t_lease_time}"
						nic_rent = (t_lease_time-t_rent_time).to_i
						flag     = (@tc_lease_time.to_i-nic_rent)<=3
						puts "PC NIC DHCP clinet timeout after  #{nic_rent} seconds"
						assert(flag, "PC获取的租约不正确")
				}

				operate("3、PC1一直抓包,PC1抓包查看是否在lease time/2时间点续约IP地址；") {
						rs        = tshark_display_filter_fields(@tc_cap_args)
						lease_time=rs[0].split("->").last
						puts "抓到路由器DHCP服务的发送报文的租约是：#{lease_time}".encode("GBK")
						assert_equal(@tc_lease_time, lease_time, "路由器在租约过50%时续约响应不正确")
				}

				operate("4、登录DUT页面，修改DHCP Server的lease time，如：设置为2分钟，重步骤1~3，确认测试结果；") {
				#
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
