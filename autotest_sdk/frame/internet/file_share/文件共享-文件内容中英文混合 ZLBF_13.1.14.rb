#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:18
# modify:
#
testcase {
		attr = {"id" => "ZLBF_13.1.14", "level" => "P2", "auto" => "n"}

		def prepare
				@tc_wait_time        = 2
				@tc_shareopen_time   = 5
				@tc_gap_time         = 3
				@tc_close_share_time = 5
				@tc_test_file        = "һ�������ļ�_TEST.txt"
				@tc_content_cn       = "֪·�ļ��������"
				@tc_content_en       = "zhilu sharing file test"
		end

		def process

				operate("1������wod��exce���ı��ĵ���SD��") {
						@browser.link(id: @ts_tag_options).click
						@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
						assert(@advance_iframe.exists?, "�򿪸߼�ʧ��!")
				}

				operate("2����½·���������ļ�����") {
						system_set = @advance_iframe.link(id: @ts_tag_op_system)
						unless system_set.class_name == @ts_tag_select_state
								system_set.click
						end
						fileshare = @advance_iframe.link(id: @ts_tag_fileshare)
						fileshare.parent.class_name
						fileshare.click unless fileshare.parent.class_name==@ts_tag_liclass
				}

				operate("3�����ļ����������ļ��д�wod��exce���ı��ĵ�") {
						fileshare_btn = @advance_iframe.button(class_name: @ts_tag_filebtn_off)
						assert(fileshare_btn.exists?, "�ļ������Ѿ�����")
						fileshare_btn.click
						sleep @tc_shareopen_time
						rs = @browser.iframe(src: @ts_file_share_dir).wait_until_present(@tc_wait_time)
						assert(rs, "δ���ļ�����Ŀ¼����")
						@file_share_iframe      = @browser.iframe(src: @ts_file_share_dir)
						sd_dir                  = @file_share_iframe.link(text: @ts_storage_sd)
						@back_to_previous_level = @file_share_iframe.link(text: @ts_tag_back)
						puts "�鿴#{@ts_storage_sd}�е��ļ�".to_gbk
						assert(sd_dir.exists?, "δ��ʾSD��")
						#�鿴SD���е�����
						@file_share_iframe.link(text: @ts_storage_sd).click
						sleep @tc_wait_time
						#�鿴SD���е��ļ�
						file = @file_share_iframe.link(text: @tc_test_file)
						assert(file.exists?, "·����δ��ʾ�����ļ�:#{@tc_test_file}")
						file_name = file.parent.parent[0].text
						file_size = file.parent.parent[1].text
						puts "�����ļ�����#{file_name}------------�ļ���С��#{file_size}".to_gbk
						#���ļ�
						file.click
						sleep @tc_wait_time
						#��ȡ@browser�����¸������ڶ���ľ������
						@tc_handles = @browser.driver.window_handles
						assert(@tc_handles.size==2, "���´���")
						#ͨ��������л���ͬ��windows����
						@browser.driver.switch_to.window(@tc_handles[1])
						content = @browser.pre.text
						print "===================File content=============\n"
						print content.encode("GBK")
						print "\n===================File content============="
						assert_match(/#{@tc_content_cn}/, content, "δ��ʾ��������")
						assert_match(/#{@tc_content_en}/, content, "δ��ʾӢ������")
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
												file_share.wait_while_present(@tc_close_share_time)
										end
								end
						end
				}
		end

}
