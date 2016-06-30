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
				#ץ���鿴
				tc_cap_fields = "-e eth.dst -e eth.src -e ip.src -e ip.dst -e bootp.option.type -e bootp.option.ip_address_lease_time"
				tc_cap_filter = "bootp.option.type==51"
				puts "Capture filter: #{tc_cap_filter}"
				@tc_cap_args      ={nic: @ts_nicname, filter: tc_cap_filter, duration: @tc_lease_time, fields: tc_cap_fields}
		end

		def process

				operate("1����PC1����ץ�������") {
						##��lan����
						@lan_page = RouterPageObject::LanPage.new(@browser)
						@lan_page.open_lan_page(@browser.url)
						##�޸���ԼΪ2����
						puts "��������Ϊ#{@tc_lease_time}".to_gbk
						@lan_page.dhcp_lease_set(@tc_lease_time)
						@lan_page.btn_save_lanset
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
						puts "PC NIC Lease time : #{t_lease_time}"
						nic_rent = (t_lease_time-t_rent_time).to_i
						flag     = (@tc_lease_time.to_i-nic_rent)<=3
						puts "PC NIC DHCP clinet timeout after  #{nic_rent} seconds"
						assert(flag, "PC��ȡ����Լ����ȷ")
				}

				operate("3��PC1һֱץ��,PC1ץ���鿴�Ƿ���lease time/2ʱ�����ԼIP��ַ��") {
						rs        = tshark_display_filter_fields(@tc_cap_args)
						lease_time=rs[0].split("->").last
						puts "ץ��·����DHCP����ķ��ͱ��ĵ���Լ�ǣ�#{lease_time}".encode("GBK")
						assert_equal(@tc_lease_time, lease_time, "·��������Լ��50%ʱ��Լ��Ӧ����ȷ")
				}

				operate("4����¼DUTҳ�棬�޸�DHCP Server��lease time���磺����Ϊ2���ӣ��ز���1~3��ȷ�ϲ��Խ����") {
				#
				}


		end

		def clearup
				operate("1 �ָ�Ĭ����ʼ��ַ��Χ") {
						unless @lan_page.nil?
								@browser.refresh
								@lan_page.open_lan_page(@browser.url)
								dhcp_lease = @lan_page.dhcp_lease
								unless dhcp_lease == @ts_default_leasetime
										puts "�ָ�����Ϊ#{@ts_default_leasetime}".to_gbk
										@lan_page.dhcp_lease_set(@ts_default_leasetime)
										@lan_page.btn_save_lanset
								end
						end
				}
		end
}
