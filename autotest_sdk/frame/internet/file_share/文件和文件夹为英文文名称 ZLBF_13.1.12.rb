#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:18
# modify:
#
testcase {
		attr = {"id" => "ZLBF_13.1.12", "level" => "P2", "auto" => "n"}

		def prepare
				@ts_download_directory.gsub!("\\", "\/")
				@tc_download_time    = 20
				@tc_wait_time        = 2
				@tc_shareopen_time   = 5
				@tc_gap_time         = 3
				@tc_close_share_time = 5
				@tc_share_dir        = "first_dir"
				@tc_test_file        = "first_file_TEST.txt"
				@tc_download_file    = "first_anzuo.apk"
				@tc_download_path    = @ts_download_directory+"/#{@tc_download_file}"
		end

		def process

				operate("1������Ӣ�������ļ��к��ļ���SD��") {
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

				operate("3�����ļ���������Ӣ���ļ�������Ӣ���ļ�") {
						fileshare_btn = @advance_iframe.button(class_name: @ts_tag_filebtn_off)
						assert(fileshare_btn.exists?, "�ļ������Ѿ�����")
						fileshare_btn.click
						sleep @tc_shareopen_time
						rs = @browser.iframe(src: @ts_file_share_dir).wait_until_present(@tc_wait_time)
						assert(rs, "δ���ļ�����Ŀ¼����")
						@file_share_iframe      = @browser.iframe(src: @ts_file_share_dir)
						sd_dir                 = @file_share_iframe.link(text: @ts_storage_sd)
						@back_to_previous_level = @file_share_iframe.link(text: @ts_tag_back)
						puts "�鿴#{@ts_storage_sd}�е��ļ�".to_gbk
						assert(sd_dir.exists?, "δ��ʾSD��")

						#�鿴SD���е��ļ���
						@file_share_iframe.link(text: @ts_storage_sd).click
						sleep @tc_wait_time
						sub_dir =@file_share_iframe.link(text: @tc_share_dir)
						assert(sub_dir.exists?, "�Ҳ���SD���е��ļ���")
						dir_name = sub_dir.parent.parent[0].text
						dir_size = sub_dir.parent.parent[1].text
						puts "�ļ�������#{dir_name}----�ļ��д�С:#{dir_size}".to_gbk

						#�鿴SD���е��ļ�
						file = @file_share_iframe.link(text: @tc_test_file)
						assert(file.exists?, "·����δ��ʾ�����ļ�:#{@tc_test_file}")
						file_name = file.parent.parent[0].text
						file_size = file.parent.parent[1].text
						puts "�����ļ�����#{file_name}------------�ļ���С��#{file_size}".to_gbk

						#����SD���е��ļ�
						#�жϵ�ǰ����Ŀ¼�Ƿ��������ļ������������������
						dl_file_path = Dir.glob(@ts_download_directory+"/*").find { |file|
								file=~/#{@tc_download_file}$/
						}
						unless dl_file_path.nil?
								puts "ɾ������Ŀ¼�еľ��ļ�:#{dl_file_path}".encode("GBK")
								File.delete(dl_file_path)
						end

						file_state = File.exists?(@tc_download_path)
						refute(file_state, "����Ŀ¼�о��ļ�:#{@tc_download_file}δɾ��")
						file_download = @file_share_iframe.link(text: @tc_download_file)
						assert(file_download.exists?, "·������δ��ʾҪ���ص��ļ�#{@tc_download_file}")
						dl_file_name = file_download.parent.parent[0].text
						dl_file_size = file_download.parent.parent[1].text
						puts "Ҫ���ص��ļ�����#{dl_file_name}------------�ļ���С��#{dl_file_size}".to_gbk
						file_download.click
						sleep @tc_download_time
						dl_file= File.exists?(@tc_download_path)
						assert(dl_file, "�ļ�:#{@tc_download_file}δ���سɹ�")
						dl_filebyte = File.size(@tc_download_path)
						dl_filemb   = (dl_filebyte.to_f/1024/1024).roundf(2)
						dl_fileMB   = "#{dl_filemb}MB"
						puts "����Ŀ¼�е��������ļ���С:#{dl_fileMB}".to_gbk
						assert_equal(dl_file_size, dl_fileMB, "���ص��ļ���С����ʾ�ļ���С����")
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
