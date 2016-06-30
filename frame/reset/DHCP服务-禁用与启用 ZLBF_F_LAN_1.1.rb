#
#description:
#author:wuhongliang
#date:2015-06-30 14:12:41
#modify:
#
testcase {
		attr = {"id" => "ZLBF_8.1.1", "level" => "P1", "auto" => "n"}

		def prepare
				DRb.start_service
				@wifi                  = DRbObject.new_with_uri(@ts_drb_server)
				@tc_wait_time          = 5
				@tc_static_ip          = @ts_default_ip.sub(/\.\d+$/, '.123')
				@tc_static_args        = {nicname: @ts_nicname, source: "static", ip: "#{@tc_static_ip}", mask: "255.255.255.0"}
				@tc_dhcp_args          = {nicname: @ts_nicname, source: "dhcp"}
				@tc_show_dut_args      = {type: "addresses", nicname: @ts_nicname}
				@tc_show_wireless_args = {type: "addresses", nicname: @ts_wlan_nicname}
		end

		def process
				operate("1 打开内网设置") {
						@lan_page = RouterPageObject::LanPage.new(@browser)
				}

				operate("2 连接路由器wifi") {
						@wifi_page = RouterPageObject::WIFIPage.new(@browser)
						wifi_conf  = @wifi_page.modify_ssid_mode_pwd(@browser.url)
						flag       ="1"
						rs1        = @wifi.connect(wifi_conf[:ssid], flag, wifi_conf[:pwd])
						assert rs1, 'wifi连接失败'
						rs2 =@wifi.ping(@ts_default_ip)
						assert rs2, 'wiif客户端无法ping通路由器'
				}

				operate("3 禁用DHCP功能") {
						#dhcp开关关闭
						@lan_page.open_lan_page(@browser.url)
						if @lan_page.dhcp_btn_element.class_name == "on"
								@lan_page.dhcp_btn
								sleep 1
								@lan_page.btn_save_lanset
						end
				}

				operate("4 关闭DHCP功能后重新获取ip地址") {
						rs_ip_release=ip_release(@ts_nicname)
						assert rs_ip_release, '释放ip地址失败！'
						rs_ip_renew= ip_renew(@ts_nicname)
						assert_equal(false, rs_ip_renew, '更新ip地址操作应失败,但却成功了！')

						ip_info = netsh_if_ip_show(@tc_show_dut_args)
						flag    = ip_info[:ip].empty? || ip_info[:ip][0]=~/^169/
						p "#{@ts_nicname} ip: #{ip_info[:ip].join(",")}"
						assert flag, '应获取ip地址失败，但却获取ip地址成功！'

						rs_wip_release =@wifi.ip_release(@ts_wlan_nicname)
						assert rs_wip_release, 'wifi释放ip地址失败！'

						rs_wip_renew=@wifi.ip_renew(@ts_wlan_nicname)
						assert_equal(false, rs_wip_renew, 'wifi更新ip地址操作应失败,但却成功了！')

						wip_info = @wifi.netsh_if_ip_show(@tc_show_wireless_args)
						wflag    = wip_info[:ip].empty? || wip_info[:ip][0]=~/^169/
						p "#{@ts_wlan_nicname} ip: #{wip_info[:ip].join(",")}"
						assert wflag, 'wifi应获取ip地址失败，但却获取ip地址成功！'
				}

				operate("5 重新打开DHCP开关") {
						#要打开dhcp开关先要设置一个静态ip与路由器相连
						rs = netsh_if_ip_setip(@tc_static_args)
						assert rs, "设置静态ip失败"
						ping_test = ping(@ts_default_ip)
						assert_equal(true, ping_test, "设置静态ip后，无法ping通路由器！")

						#重新登录路由器
						login_ui = @lan_page.login_with_exists(@browser.url)
						login(@browser, @ts_default_ip) if login_ui
						@lan_page.open_lan_page(@browser.url)
						if @lan_page.dhcp_btn_element.class_name == "off"
								@lan_page.dhcp_btn
								sleep 1
								@lan_page.btn_save_lanset
						end
				}

				operate("6 重新打开DHCP功能后重新获取ip地址") {
						set_dhcp = netsh_if_ip_setip(@tc_dhcp_args)
						assert set_dhcp, '恢复dhcp功能后，还原网卡为dhcp模式！'

						sleep 3
						rs_ip_release=ip_release(@ts_nicname)
						assert rs_ip_release, '释放ip地址失败！'

						rs_ip_renew= ip_renew(@ts_nicname)
						assert rs_ip_renew, '更新ip地址操作失败'

						ip_info = netsh_if_ip_show(@tc_show_dut_args)
						p "#{@ts_nicname} ip: #{ip_info[:ip].join(",")}"

						rs1 =ping(@ts_default_ip)
						assert rs1, '客户端无法ping通路由器'

						rs_wip_release =@wifi.ip_release(@ts_wlan_nicname)
						assert rs_wip_release, 'wifi释放ip地址失败！'

						rs_wip_renew=@wifi.ip_renew(@ts_wlan_nicname)
						assert rs_wip_renew, 'wifi更新ip地址操作失败！'

						wip_info = @wifi.netsh_if_ip_show(@tc_show_wireless_args)
						p "#{@ts_wlan_nicname} ip: #{wip_info[:ip].join(",")}"


						rs2 =@wifi.ping(@ts_default_ip)
						assert rs2, 'wiif客户端无法ping通路由器'
				}

		end

		def clearup

				operate("还原路由器DHCP默认开关设置") {
				    @wifi.netsh_disc_all #断开wifi连接
				    ping_test = ping(@ts_default_ip)
				    unless ping_test
				        netsh_if_ip_setip(@tc_static_args)
				        sleep 5
				    end

				    lan_page = RouterPageObject::LanPage.new(@browser)
				    login_ui    = lan_page.login_with_exists(@browser.url)
				    login(@browser, @ts_default_ip) if login_ui
				    lan_page.open_lan_page(@browser.url)
				    if lan_page.dhcp_btn_element.class_name == "off"
				        lan_page.dhcp_btn
				        sleep 1
				        lan_page.btn_save_lanset
				    end
				}

				operate("恢复网卡默认设置") {
				    rs_state=netsh_if_ip_show(@tc_show_dut_args)
				    netsh_if_ip_setip(@tc_dhcp_args) if rs_state[:dhcp_state]=="no"
				    sleep @tc_wait_time
				}
		end

}
