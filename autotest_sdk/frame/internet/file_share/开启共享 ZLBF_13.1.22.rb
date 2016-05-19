#
#description:
#author:wuhongliang
#date:2015-06-30 14:12:41
#modify:
#
testcase {
		attr = {"id" => "ZLBF_13.1.11", "level" => "P1", "auto" => "n"}

		def prepare
				@tc_wait_time        = 2
				@tc_gap_time         = 5
				@tc_close_share      = 5
				@tc_relogin_time     = 80
				@tc_reboot_time      = 120
				@tc_tag_button       = "button"
				@tc_share_switch_off = "off"
				@tc_share_switch_on  = "on"
				@tc_storage_usb      = "U��"
				@tc_storage_sd       = "SD��"
				@tc_share_dir        = "һ��Ŀ¼"
				@tc_test_file        = "���������ļ�_TEST.txt"
		end

		def process

				operate("1 �򿪸߼�����") {
						@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
						@browser.link(id: @ts_tag_options).click
						@advance_iframe = @browser.iframe
						assert_match /#{@ts_tag_advance_src}/i, @advance_iframe.src, "�򿪸߼�����ʧ��!"
				}

				operate("2 ��ϵͳ���ÿ����ļ�����") {
						#ѡ��ϵͳ���á�
						sysset = @advance_iframe.link(id: @ts_tag_op_system).class_name
						unless sysset == @ts_tag_select_state
								@advance_iframe.link(id: @ts_tag_op_system).click
								sleep @tc_gap_time
						end

						#ѡ�� "�ļ�����"
						file_share_label       = @advance_iframe.link(id: @ts_tag_fileshare)
						file_share_label_state = file_share_label.parent.class_name
						file_share_label.click unless file_share_label_state==@ts_tag_liclass
						sleep @tc_gap_time
						@browser.iframe(src: @ts_file_share_dir)
						rs = @browser.iframe(src: @ts_file_share_dir).exists?
						#���rsΪtrue,˵���ļ������ѱ��򿪣��ⲻ����Ĭ������
						assert_equal(false, rs, "�ļ������Ѿ�����")

						#��"�ļ�����"����
						file_share_switch = @advance_iframe.button(type: @tc_tag_button)
						switch_state      = file_share_switch.class_name
						if switch_state == @tc_share_switch_off
								file_share_switch.click
						end
				}

				operate("3 �鿴����Ŀ¼U���е��ļ�") {
						rs = @browser.iframe(src: @ts_file_share_dir).wait_until_present(@tc_gap_time)
						assert(rs, "δ���ļ�����Ŀ¼����")
						@file_share_iframe      = @browser.iframe(src: @ts_file_share_dir)
						usb_dir                 = @file_share_iframe.link(text: @tc_storage_usb)
						@back_to_previous_level = @file_share_iframe.link(text: @ts_tag_back)
						puts "�鿴#{@tc_storage_usb}�е��ļ�".to_gbk
						assert(usb_dir.exists?, "δ��ʾU��")
						#��U��
						usb_dir.click

						#�鿴U���е��ļ���
						sub_dir    =@file_share_iframe.link(text: @tc_share_dir)
						rs_sub_dir = sub_dir.wait_until_present(@tc_gap_time)
						assert(rs_sub_dir, "�Ҳ���U���е��ļ���")
						dir_name = sub_dir.parent.parent[0].text
						dir_size = sub_dir.parent.parent[1].text
						puts "�ļ�������#{dir_name}----�ļ���С:#{dir_size}".to_gbk
						#����Ŀ¼
						sub_dir.click

						#�鿴U���е��ļ�
						file    = @file_share_iframe.link(text: @tc_test_file)
						rs_file = file.wait_until_present(@tc_gap_time)
						assert(rs_file, "δ�ҵ������ļ�")
						file_name = file.parent.parent[0].text
						file_size = file.parent.parent[1].text
						puts "�����ļ�����#{file_name}------------�ļ���С��#{file_size}".to_gbk

						#���ص���Ŀ¼
						@back_to_previous_level.click
						rs_back_sub_dir = sub_dir.wait_until_present(@tc_gap_time)
						assert(rs_back_sub_dir, "���ص���һ��Ŀ¼ʧ��")
						@back_to_previous_level.click
						rs_back_usb_dir = @file_share_iframe.link(text: @tc_storage_usb).wait_until_present(@tc_gap_time)
						assert(rs_back_usb_dir, "���ص�U�̸�Ŀ¼ʧ��")
				}

				operate("4 �鿴SD���е��ļ�") {
						sd_dir                  = @file_share_iframe.link(text: @tc_storage_sd)
						@back_to_previous_level = @file_share_iframe.link(text: @ts_tag_back)
						puts "�鿴#{@tc_storage_sd}�е��ļ�".to_gbk
						assert(sd_dir.exists?, "δ��ʾSD��")
						sd_dir.click
						sub_dir    =@file_share_iframe.link(text: @tc_share_dir)
						rs_sub_dir = sub_dir.wait_until_present(@tc_gap_time)
						assert(rs_sub_dir, "�Ҳ���SD���е��ļ�")
						dir_name = sub_dir.parent.parent[0].text
						dir_size = sub_dir.parent.parent[1].text
						puts "�ļ�������#{dir_name}----�ļ���С:#{dir_size}".to_gbk

						sub_dir.click
						sleep @tc_gap_time
						file    = @file_share_iframe.link(text: @tc_test_file)
						rs_file = file.wait_until_present(@tc_gap_time)
						assert(rs_file, "δ�ҵ������ļ�")
						file_name = file.parent.parent[0].text
						file_size = file.parent.parent[1].text
						puts "�����ļ�����#{file_name}------------�ļ���С��#{file_size}".to_gbk

						#���ص���Ŀ¼
						@back_to_previous_level.click
						rs_back_sub_dir = sub_dir.wait_until_present(@tc_gap_time)
						assert(rs_back_sub_dir, "���ص���һ��Ŀ¼ʧ��")
						@back_to_previous_level.click
						rs_back_usb_dir = sd_dir.wait_until_present(@tc_gap_time)
						assert(rs_back_usb_dir, "���ص�U�̸�Ŀ¼ʧ��")
				}

				operate("5 ����·����") {
						#�ҵ�����Ŀ¼ҳ���DIV
						file_div         = @browser.div(class_name: @ts_tag_file_div)
						zindex_value     = file_div.style(@ts_tag_style_zindex)
						#�ҵ�������DIV
						background_zindex=(zindex_value.to_i-1).to_s
						background_div   = @browser.element(xpath: "//div[contains(@style,'#{background_zindex}')]")

						#���ع���Ŀ¼ҳ���DIV
						@browser.execute_script("$(arguments[0]).hide();", file_div)
						#���ر�����DIV
						@browser.execute_script("$(arguments[0]).hide();", background_div)

						#����·����
						@browser.span(id: @ts_tag_reboot).click

						reboot_confirm = @browser.button(class_name: @ts_tag_reboot_confirm)
						assert reboot_confirm.exists?, "δ��ʾ����·����Ҫȷ��!"
						reboot_confirm.click
						sleep @tc_wait_time
						#<div class="aui_content" style="padding: 20px 25px;">���������У����Ե�...</div>
						Watir::Wait.until(@tc_wait_time, "����·��������������ʾδ����") {
								@browser.div(:class_name, @ts_tag_rebooting).visible?
						}
						puts "Waitfing for system reboot...."
						sleep(@tc_reboot_time) #����������Ͽ����������������ʹ��sleep���ȴ�����������Watir::Wait���ȴ�
						rs = @browser.text_field(:name, @ts_tag_usr).wait_until_present(@tc_relogin_time)
						assert rs, "��ת����¼ҳ��ʧ��!"
				}

				operate("6 ����·������,���µ�¼·�������򿪸߼�����") {
						login_no_default_ip(@browser)
						@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
						@browser.link(id: @ts_tag_options).click
						@advance_iframe = @browser.iframe
						assert_match /#{@ts_tag_advance_src}/i, @advance_iframe.src, "�򿪸߼�����ʧ��!"
				}

				operate("7 ����·�����󣬴�ϵͳ���ò鿴�ļ�����") {
						#ѡ��ϵͳ���á�
						sysset = @advance_iframe.link(id: @ts_tag_op_system).class_name
						unless sysset == @ts_tag_select_state
								@advance_iframe.link(id: @ts_tag_op_system).click
								sleep @tc_gap_time
						end
						#ѡ�� "�ļ�����"
						file_share_label       = @advance_iframe.link(id: @ts_tag_fileshare)
						file_share_label_state = file_share_label.parent.class_name
						file_share_label.click unless file_share_label_state==@ts_tag_liclass
				}

				operate("8 ����·�����󣬲鿴����Ŀ¼U���е��ļ�") {
						rs = @browser.iframe(src: @ts_file_share_dir).wait_until_present(@tc_gap_time)
						assert(rs, "������δ���ļ�����Ŀ¼����")
						@file_share_iframe      = @browser.iframe(src: @ts_file_share_dir)
						usb_dir                 = @file_share_iframe.link(text: @tc_storage_usb)
						@back_to_previous_level = @file_share_iframe.link(text: @ts_tag_back)
						puts "�鿴#{@tc_storage_usb}�е��ļ�".to_gbk
						assert(usb_dir.exists?, "δ��ʾU��")
						usb_dir.click
						sleep @tc_wait_time
						sub_dir    =@file_share_iframe.link(text: @tc_share_dir)
						rs_sub_dir = sub_dir.wait_until_present(@tc_gap_time)
						assert(rs_sub_dir, "�Ҳ���U���е��ļ�")
						dir_name = sub_dir.parent.parent[0].text
						dir_size = sub_dir.parent.parent[1].text
						puts "�ļ�������#{dir_name}----�ļ���С:#{dir_size}".to_gbk

						sub_dir.click
						sleep @tc_gap_time
						file    = @file_share_iframe.link(text: @tc_test_file)
						rs_file = file.exists?
						assert(rs_file, "δ�ҵ������ļ�")
						file_name = file.parent.parent[0].text
						file_size = file.parent.parent[1].text
						puts "�����ļ�����#{file_name}------------�ļ���С��#{file_size}".to_gbk

						#���ص���Ŀ¼
						@back_to_previous_level.click
						rs_back_sub_dir = sub_dir.wait_until_present(@tc_gap_time)
						assert(rs_back_sub_dir, "���ص���һ��Ŀ¼ʧ��")
						@back_to_previous_level.click
						rs_back_usb_dir = usb_dir.wait_until_present(@tc_gap_time)
						assert(rs_back_usb_dir, "���ص�U�̸�Ŀ¼ʧ��")
				}

				operate("9 ����·�����󣬲鿴SD���е��ļ�") {
						sd_dir                  = @file_share_iframe.link(text: @tc_storage_sd)
						@back_to_previous_level = @file_share_iframe.link(text: @ts_tag_back)
						puts "�鿴#{@tc_storage_sd}�е��ļ�".to_gbk
						assert(sd_dir.exists?, "δ��ʾSD��")
						sd_dir.click
						sleep @tc_wait_time
						sub_dir    =@file_share_iframe.link(text: @tc_share_dir)
						rs_sub_dir = sub_dir.wait_until_present(@tc_gap_time)
						assert(rs_sub_dir, "�Ҳ���SD���е��ļ�")
						dir_name = sub_dir.parent.parent[0].text
						dir_size = sub_dir.parent.parent[1].text
						puts "�ļ�������#{dir_name}----�ļ���С:#{dir_size}".to_gbk

						sub_dir.click
						sleep @tc_gap_time
						file    = @file_share_iframe.link(text: @tc_test_file)
						rs_file = file.exists?
						assert(rs_file, "δ�ҵ������ļ�")
						file_name = file.parent.parent[0].text
						file_size = file.parent.parent[1].text
						puts "�����ļ�����#{file_name}------------�ļ���С��#{file_size}".to_gbk

						#���ص���Ŀ¼
						@back_to_previous_level.click
						rs_back_sub_dir = sub_dir.wait_until_present(@tc_gap_time)
						assert(rs_back_sub_dir, "���ص���һ��Ŀ¼ʧ��")
						@back_to_previous_level.click
						rs_back_usb_dir = sd_dir.wait_until_present(@tc_gap_time)
						assert(rs_back_usb_dir, "���ص�U�̸�Ŀ¼ʧ��")
				}

		end

		def clearup

				operate("�ָ��������ر��ļ�����") {
						rs = @browser.iframe(src: @ts_file_share_dir).exists?
						if rs
								#�����ǰWEBΪ�ļ�����Ŀ¼��ֱ�ӹرչ���
								@file_share_iframe = @browser.iframe(src: @ts_file_share_dir)
								@file_share_iframe.link(text: @ts_tag_close_share).click
								file_share = @browser.iframe(src: @ts_file_share_dir)
								if file_share.exists?
										sleep @tc_wait_time
								end
						else
								if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
										@browser.execute_script(@ts_close_div)
								end
								#�����ǰ��Ϊ�ļ��������´򿪸߼�����
								if @browser.div(class_name: @ts_aui_state).exists?
										@browser.execute_script(@ts_close_div)
								end
								@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
								@browser.link(id: @ts_tag_options).click
								@advance_iframe = @browser.iframe

								#ѡ��ϵͳ���á�
								sysset          = @advance_iframe.link(id: @ts_tag_op_system).class_name
								unless sysset == @ts_tag_select_state
										@advance_iframe.link(id: @ts_tag_op_system).click
										sleep @tc_gap_time
								end
								#ѡ�� "�ļ�����"
								file_share_label       = @advance_iframe.link(id: @ts_tag_fileshare)
								file_share_label_state = file_share_label.parent.class_name
								file_share_label.click unless file_share_label_state==@ts_tag_liclass
								sleep @tc_gap_time
								file_share=@browser.iframe(src: @ts_file_share_dir)
								if file_share.exists?
										#���´򿪺������ǰWEBΪ�ļ�����Ŀ¼��ֱ�ӹرչ���
										@file_share_iframe = @browser.iframe(src: @ts_file_share_dir)
										@file_share_iframe.link(text: @ts_tag_close_share).click
										if file_share.exists?
												file_share.wait_while_present(@tc_close_share)
										end
								end
						end
				}
		end

}
