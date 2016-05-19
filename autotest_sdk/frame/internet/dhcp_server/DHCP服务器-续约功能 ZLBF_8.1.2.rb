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

				operate("1����PC1����ץ�������") {
						##��lan����
						@browser.span(:id => @ts_tag_lan).click
						@lan_iframe = @browser.iframe(src: @ts_tag_lan_src)
						assert(@lan_iframe.exists?, '����������ʧ�ܣ�')
						##�޸���ԼΪ2����
						@lan_iframe.text_field(id: @tc_tag_dhcplease).set(@tc_lease_time)
						@lan_iframe.button(id: @ts_tag_sbm).click
						# Watir::Wait.until(@tc_wait_time, "�ȴ�����������ʾ����ʧ��") {
						# 		@lan_iframe.div(class_name: @ts_tag_lan_reset, text: @ts_tag_lan_reset_text).present?
						# }
						# Watir::Wait.while(@tc_net_time, "�ȴ�����������ʾ����ʧ��") {
						# 		@lan_iframe.div(class_name: @ts_tag_lan_reset, text: @ts_tag_lan_reset_text).present?
						# }
						puts "sleep #{@tc_net_time} for net reseting"
						sleep @tc_net_time
				}

				operate("2������PC1Ϊ�Զ���ȡIP��ַ��ץ���鿴lease time�Ƿ�Ϊ���õ�ʱ�䣬PC1�����ġ�����������ϸ��Ϣ����Լʱ���Ƿ���ȷ��") {
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
						assert(flag, "PC��ȡ����Լ����ȷ")
				}

				operate("3��PC1һֱץ��,PC1ץ���鿴�Ƿ���lease time/2ʱ�����ԼIP��ַ��") {
						#ץ���鿴
						tc_cap_fields = "-e eth.dst -e eth.src -e ip.src -e ip.dst -e bootp.option.type -e bootp.option.ip_address_lease_time"
						tc_cap_filter = "bootp.option.type==51"
						puts "Capture filter: #{tc_cap_filter}"
						args      ={nic: @ts_nicname, filter: tc_cap_filter, duration: @tc_lease_time, fields: tc_cap_fields}
						rs        = tshark_display_filter_fields(args)
						lease_time=rs[0].split("->").last
						puts "ץ��·����DHCP����ķ��ͱ��ĵ���Լ�ǣ�#{lease_time}".encode("GBK")
						assert_equal(@tc_lease_time, lease_time, "·��������Լ��50%ʱ��Լ��Ӧ����ȷ")
				}

				operate("4����¼DUTҳ�棬�޸�DHCP Server��lease time���磺����Ϊ2���ӣ��ز���1~3��ȷ�ϲ��Խ����") {

				}


		end

		def clearup

				operate("1 �ָ�·����Ĭ����Լ") {
						if !@lan_iframe.nil? && @lan_iframe.exists?
								@browser.span(:id => @ts_tag_lan).click
								@lan_iframe = @browser.iframe(src: @ts_tag_lan_src)
						end
						##�ָ�Ĭ����Լ
						@lan_iframe.text_field(id: @tc_tag_dhcplease).set(@ts_default_leasetime)
						@lan_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_net_time
				}
		end
}
