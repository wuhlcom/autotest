#artDialog X����
#description:
#author:wuhongliang
#date:2015-06-30 14:12:41
#modify:
#
testcase {
		attr = {"id" => "ZLBF_6.1.40", "level" => "P1", "auto" => "n"}

		def prepare
				@tc_wait_time        = 3
				@tc_pptpset_time     = 5
				@tc_pptp_time        = 30
				@tc_net_time         = 50
				@tc_tag_advance_div  = "aui_state_lock aui_state_focus" #focus�ں��ʾѡ���˵�ǰdiv
				@tc_tag_style_zindex = "z-index"

		end

		def process

				operate("1 ��options����") {
						option = @browser.link(:id => @ts_tag_options)
						option.click
						@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
						assert(@advance_iframe.exists?, "�򿪸߼�����ʧ��!")
				}

				operate("2 ѡ��PPTP���ӷ�ʽ") {
						#ѡ����������
						network = @advance_iframe.link(:id, @ts_tag_op_network)
						unless network.class_name =~ /#{@ts_tag_select_state}/
								network.click
								sleep @tc_wait_time
						end
						@advance_iframe.link(:id, @ts_tag_op_pptp).click
						@advance_iframe.text_field(:id, @ts_tag_pptp_server).wait_until_present(@tc_pptpset_time)
				}

				operate("3 ����PPTP����") {
						puts "PPTP Server:#{@ts_pptp_server_ip}"
						puts "PPTP User:#{@ts_pptp_usr}"
						puts "PPTP PassWD:#{@ts_pptp_pw}"
						@advance_iframe.text_field(:id, @ts_tag_pptp_server).set(@ts_pptp_server_ip)
						@advance_iframe.text_field(:id, @ts_tag_pptp_usr).set(@ts_pptp_usr)
						@advance_iframe.text_field(:id, @ts_tag_pptp_pw).set(@ts_pptp_pw)
						@advance_iframe.button(:id, @ts_tag_sbm).click
						Watir::Wait.until(@tc_wait_time, "PPTP���óɹ���ʾδ����") {
								@pptp_tip=@advance_iframe.div(class_name: @ts_tag_reset, text: /#{@ts_tag_pptp_set}/)
								@pptp_tip.present?
						}
						Watir::Wait.while(@tc_pptp_time, "PPTP���óɹ���ʾ��ʧ") {
								@pptp_tip.present?
						}
						puts "Waiting for pptp connection..."
						sleep @tc_pptp_time #·����������ܻ������������������ӳ�
						#�߼�����ҳ�汳��DIV
						file_div         = @browser.div(class_name: @tc_tag_advance_div)
						zindex_value     = file_div.style(@tc_tag_style_zindex)
						#�ҵ�������DIV
						background_zindex=(zindex_value.to_i-1).to_s
						background_div   = @browser.element(xpath: "//div[contains(@style,'#{background_zindex}')]")

						#���ظ߼����ñ���DIV
						@browser.execute_script("$(arguments[0]).hide();", file_div)
						#���ر�����DIV
						@browser.execute_script("$(arguments[0]).hide();", background_div)
				}

				operate("4 �鿴WAN״̬") {
						@browser.span(:id => @ts_tag_status).wait_until_present(@tc_wait_time)
						@browser.span(:id => @ts_tag_status).click
						@status_iframe = @browser.iframe(src: @tag_status_iframe_src)
						assert(@status_iframe.exists?, '��WAN״̬ʧ�ܣ�')
						wan_addr = @status_iframe.b(id: @ts_tag_wan_ip).parent.text
						@ts_tag_ip_regxp=~wan_addr
						puts "PPTP��ȡ��IP��ַΪ��#{Regexp.last_match(1)}".to_gbk

						wan_type = @status_iframe.b(id: @ts_tag_wan_type).parent.text
						/(#{@ts_wan_mode_pptp})/=~wan_type
						puts "��ѯ����������Ϊ��#{Regexp.last_match(1)}".to_gbk

						mask     = @status_iframe.b(id: @ts_tag_wan_mask).parent.text
						dns_addr = @status_iframe.b(id: @ts_tag_wan_dns).parent.text
						@ts_tag_ip_regxp=~dns_addr
						puts "PPTP��ȡ��DNS��ַΪ��#{Regexp.last_match(1)}".to_gbk

						assert_match @ts_tag_ip_regxp, wan_addr, 'PPTP��ȡip��ַʧ�ܣ�'
						assert_match /#{@ts_wan_mode_pptp}/, wan_type, '�������ʹ���'
						assert_match @ts_tag_ip_regxp, mask, 'PPTP��ȡip��ַ����ʧ�ܣ�'
						assert_match @ts_tag_ip_regxp, dns_addr, 'PPTP��ȡdns ip��ַʧ�ܣ�'

				}

				operate("5 ��֤ҵ��") {
						rs =ping(@ts_web)
						assert(rs, '�޷���������')
				}
		end

		def clearup

				operate("1 �ָ�ΪĬ�ϵĽ��뷽ʽ��DHCP����") {
						if @browser.div(class_name: @ts_aui_state).exists?
								@browser.execute_script(@ts_close_div)
						end

						unless @browser.span(:id => @ts_tag_netset).exists?
								login_recover(@browser, @ts_default_ip)
						end

						@browser.span(:id => @ts_tag_netset).click
						@wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
						#����wan���ӷ�ʽΪ��������
						flag        = false
						#����wan���ӷ�ʽΪ��������
						rs1         = @wan_iframe.link(:id => @ts_tag_wired_mode_link)
						unless rs1.class_name =~/#{@ts_tag_select_state}/
								@wan_iframe.span(:id => @ts_tag_wired_mode_span).click
								flag = true
						end

						#��ѯ�Ƿ�ΪΪdhcpģʽ
						dhcp_radio       = @wan_iframe.radio(id: @ts_tag_wired_dhcp)
						dhcp_radio_state = dhcp_radio.checked?
						#����WIRE WANΪDHCPģʽ
						unless dhcp_radio_state
								dhcp_radio.click
								flag = true
						end

						if flag
								@wan_iframe.button(:id, @ts_tag_sbm).click
								puts "Waiting for net reset..."
								sleep @tc_net_time
						end
				}
		end

}
