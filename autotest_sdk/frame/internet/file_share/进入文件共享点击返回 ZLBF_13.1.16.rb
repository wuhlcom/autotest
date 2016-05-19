#
# description:
#bug
# �޷����ص�U�̸�Ŀ¼
# author:wuhongliang
# date:2015-11-05 14:00:18
# modify:
#
testcase {
		attr = {"id" => "ZLBF_13.1.16", "level" => "P2", "auto" => "n"}

		def prepare
				@tc_wait_time        = 2
				@tc_shareopen_time   = 5
				@tc_gap_time         = 3
				@tc_close_share_time = 5
				@tc_share_dir        = "һ��Ŀ¼"
				@tc_second_dir       = "����Ŀ¼"
				@tc_file_name        = "������׿���.apk"
		end

		def process

				operate("1����½·���������ļ�����") {
						@browser.link(id: @ts_tag_options).click
						@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
						assert(@advance_iframe.exists?, "�򿪸߼�ʧ��!")
				}

				operate("2������༶�ļ�Ŀ¼") {
						system_set = @advance_iframe.link(id: @ts_tag_op_system)
						unless system_set.class_name == @ts_tag_select_state
								system_set.click
						end
						fileshare = @advance_iframe.link(id: @ts_tag_fileshare)
						fileshare.parent.class_name
						fileshare.click unless fileshare.parent.class_name==@ts_tag_liclass

						fileshare_btn = @advance_iframe.button(class_name: @ts_tag_filebtn_off)
						assert(fileshare_btn.exists?, "�ļ������Ѿ�����")
						fileshare_btn.click
						sleep @tc_shareopen_time
						rs = @browser.iframe(src: @ts_file_share_dir).wait_until_present(@tc_wait_time)
						assert(rs, "δ���ļ�����Ŀ¼����")
						@file_share_iframe = @browser.iframe(src: @ts_file_share_dir)
						usb_dir            = @file_share_iframe.link(text: @ts_storage_usb)

						puts "�鿴#{@ts_storage_usb}�е��ļ�".to_gbk
						assert(usb_dir.exists?, "δ��ʾSD��")

						#�鿴SD���е��ļ���
						@file_share_iframe.link(text: @ts_storage_usb).click
						sleep @tc_wait_time

						sub_dir =@file_share_iframe.link(text: @tc_share_dir)
						assert(sub_dir.exists?, "δ��ʾSD���е��ļ���:#{@tc_share_dir}")
						dir_name = sub_dir.parent.parent[0].text
						dir_size = sub_dir.parent.parent[1].text
						puts "�ļ�������#{dir_name}----�ļ��д�С:#{dir_size}".to_gbk

						#����һ��Ŀ¼("һ��Ŀ¼"Ŀ¼)
						sub_dir.click
						sleep @tc_wait_time

						second_dir =@file_share_iframe.link(text: @tc_second_dir)
						assert(second_dir.exists?, "δ��ʾSD���е��ļ���:#{@tc_second_dir}")
						second_dir_name = second_dir.parent.parent[0].text
						second_dir_size = second_dir.parent.parent[1].text
						puts "�ļ�������#{second_dir_name}----�ļ��д�С:#{second_dir_size}".to_gbk

						#���¶���Ŀ¼("����Ŀ¼"Ŀ¼)
						second_dir.click
						sleep @tc_wait_time

						second_dir_file =@file_share_iframe.link(text: @tc_file_name)
						assert(second_dir_file.exists?, "δ��ʾSD���е��ļ�:#{@tc_file_name}")
						second_dir_file_name  = second_dir_file.parent.parent[0].text
						dsecond_dir_file_size = second_dir_file.parent.parent[1].text
						puts "�ļ�����#{second_dir_file_name}----�ļ���С:#{dsecond_dir_file_size}".to_gbk
				}

				operate("3��������أ������η��أ��Ƿ���Է��ص��ļ���ҳ") {
						#���ص�����Ŀ¼
						@file_share_iframe.link(id: @ts_tag_return).click
						sleep @tc_wait_time
						second_dir =@file_share_iframe.link(text: @tc_second_dir)
						assert(second_dir.exists?, "δ���ص�SD���ж���Ŀ¼")
						#���ص�һ��Ŀ¼
						@file_share_iframe.link(id: @ts_tag_return).click
						sleep @tc_wait_time
						first_dir =@file_share_iframe.link(text: @tc_share_dir)
						assert(first_dir.exists?, "δ���ص�SD����һ��Ŀ¼")

						#���ص�SD����Ŀ¼
						@file_share_iframe.link(id: @ts_tag_return).click
						sleep @tc_wait_time
						root_dir =@file_share_iframe.link(text: @ts_storage_usb)
						assert(root_dir.exists?, "δ��ʾSD����Ŀ¼")
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
