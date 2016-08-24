#
# description:
# author:wuhongliang
# date:2015-08-26 11:47:03
# modify:
#
testcase {
		attr = {"id" => "ZLBF_8.1.2", "level" => "P2", "auto" => "n"}

		def prepare
				@tc_wait_time     = 2
				@tc_net_time      = 40
				@tc_tag_dhcplease = "dhcpLease"
				@tc_lease_time    = "120"
		end

		def process

				operate("1、在PC1启动抓包软件；") {
						##打开lan设置
						@browser.span(:id => @ts_tag_lan).click
						@lan_iframe = @browser.iframe(src: @ts_tag_lan_src)
						assert(@lan_iframe.exists?, '打开内网设置失败！')
						##修改租约为2分钟
						@lan_iframe.text_field(id: @tc_tag_dhcplease).set(@tc_lease_time)
						@lan_iframe.button(id: @ts_tag_sbm).click
						# Watir::Wait.until(@tc_wait_time, "等待重启网络提示出现失败") {
						# 		@lan_iframe.div(class_name: @ts_tag_lan_reset, text: @ts_tag_lan_reset_text).present?
						# }
						# Watir::Wait.while(@tc_net_time, "等待重启网络提示出现失败") {
						# 		@lan_iframe.div(class_name: @ts_tag_lan_reset, text: @ts_tag_lan_reset_text).present?
						# }
						puts "sleep #{@tc_net_time} for net reseting"
						sleep @tc_net_time
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
						puts "PC NIC  lease time : #{t_lease_time}"
						nic_rent = (t_lease_time-t_rent_time).to_i
						flag     = (@tc_lease_time.to_i-nic_rent)<=3
						puts "PC NIC DHCP clinet timeout after  #{nic_rent} seconds"
						assert(flag, "PC获取的租约不正确")
				}

				operate("3、PC1一直抓包,PC1抓包查看是否在lease time/2时间点续约IP地址；") {
						#抓包查看
						tc_cap_fields = "-e eth.dst -e eth.src -e ip.src -e ip.dst -e bootp.option.type -e bootp.option.ip_address_lease_time"
						tc_cap_filter = "bootp.option.type==51"
						puts "Capture filter: #{tc_cap_filter}"
						args      ={nic: @ts_nicname, filter: tc_cap_filter, duration: @tc_lease_time, fields: tc_cap_fields}
						rs        = tshark_display_filter_fields(args)
						lease_time=rs[0].split("->").last
						puts "抓到路由器DHCP服务的发送报文的租约是：#{lease_time}".encode("GBK")
						assert_equal(@tc_lease_time, lease_time, "路由器在租约过50%时续约响应不正确")
				}

				operate("4、登录DUT页面，修改DHCP Server的lease time，如：设置为2分钟，重步骤1~3，确认测试结果；") {

				}


		end

		def clearup

				operate("1 恢复路由器默认租约") {
						if !@lan_iframe.nil? && @lan_iframe.exists?
								@browser.span(:id => @ts_tag_lan).click
								@lan_iframe = @browser.iframe(src: @ts_tag_lan_src)
						end
						##恢复默认组约
						@lan_iframe.text_field(id: @tc_tag_dhcplease).set(@ts_default_leasetime)
						@lan_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_net_time
				}
		end
}
