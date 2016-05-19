#
# description:
#  ���볤�Ⱥ������������ַ�
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
testcase {
		attr = {"id" => "ZLBF_21.1.68", "level" => "P4", "auto" => "n"}

		def prepare
				@tc_pw_length_err  = "�û���������ĳ�����4-16���ַ�"
				@tc_pw_null_err    = "�û��������벻��Ϊ��"
				@tc_pw_notsame_err = "�������벻һ��"
				@tc_pw_content_err = "����ֻ�������ֺ���ĸ"
				@tc_wait_time      = 5
				@tc_new_pw1        = "01234567890123456"
				# @tc_new_pw2        = "0123456789012345"
				@tc_new_pw3        = "123"
				@tc_pw_special1    = "`-=[];'\\,./ !@#"
				@tc_pw_special2    = "$%^&*()_+{}:\"|<>"
				@tc_pw_special3    = "whl?"
				@tc_pw_null        = ""
				@tc_pw_confirm     = "confirmpw"
		end

		def process

				operate("1����½DUT�����������޸�ҳ�棻") {
						rs_login = login_recover(@browser, @ts_default_ip)
						assert(rs_login, "·������¼ʧ�ܣ�")
						@browser.link(id: @ts_tag_modify_pw).click
						@account_iframe = @browser.iframe(src: @ts_tag_account_manage)
						assert(@account_iframe.exists?, "���û��������޸�ҳ��ʧ�ܣ�")

						puts("�޸�����Ϊ��".encode("GBK"))
						puts("�޸��û���Ϊ��#{@ts_default_usr}".encode("GBK"))
						@account_iframe.text_field(id: @ts_tag_aduser).set(@ts_default_usr)
						@account_iframe.text_field(id: @ts_tag_adpass).set(@tc_pw_null)
						@account_iframe.text_field(id: @ts_tag_adpass2).set(@ts_default_pw)
						@account_iframe.button(id: @ts_tag_sbm).click
						rs = @account_iframe.p(id: @ts_tag_modify_pw_error).wait_until_present(@tc_wait_time)
						sleep @tc_wait_time
						assert(rs, "����������ʾ")
						error_info = @account_iframe.p(id: @ts_tag_modify_pw_error).text
						puts("������ʾ����:#{error_info}".encode("GBK"))
						assert_equal(@tc_pw_null_err, error_info, "������ʾ���ݲ���ȷ")

						puts("�޸�ȷ������Ϊ��".encode("GBK"))
						puts("�޸��û���Ϊ��#{@ts_default_usr}".encode("GBK"))
						@account_iframe.text_field(id: @ts_tag_aduser).set(@ts_default_usr)
						3.times do
								break if !@account_iframe.text_field(id: @ts_tag_aduser).value.empty?
								@account_iframe.text_field(id: @ts_tag_aduser).set(@ts_default_usr)
						end
						@account_iframe.text_field(id: @ts_tag_adpass).set(@ts_default_pw)
						@account_iframe.text_field(id: @ts_tag_adpass2).set(@tc_pw_null)
						@account_iframe.button(id: @ts_tag_sbm).click
						rs = @account_iframe.p(id: @ts_tag_modify_pw_error).wait_until_present(@tc_wait_time)
						sleep @tc_wait_time
						assert(rs, "����������ʾ")
						error_info = @account_iframe.p(id: @ts_tag_modify_pw_error).text
						puts("������ʾ����:#{error_info}".encode("GBK"))
						assert_equal(@tc_pw_notsame_err, error_info, "������ʾ���ݲ���ȷ")

						puts("�޸��û���Ϊ��#{@ts_default_usr}".encode("GBK"))
						puts("�޸�����Ϊ:#{@ts_default_pw}".encode("GBK"))
						puts("�޸�ȷ������Ϊ:#{@tc_pw_confirm}".encode("GBK"))
						@account_iframe.text_field(id: @ts_tag_aduser).set(@ts_default_usr)
						3.times do
								break if !@account_iframe.text_field(id: @ts_tag_aduser).value.empty?
								@account_iframe.text_field(id: @ts_tag_aduser).set(@ts_default_usr)
						end
						@account_iframe.text_field(id: @ts_tag_adpass).set(@ts_default_pw)
						@account_iframe.text_field(id: @ts_tag_adpass2).set(@tc_pw_confirm)
						@account_iframe.button(id: @ts_tag_sbm).click
						rs = @account_iframe.p(id: @ts_tag_modify_pw_error).wait_until_present(@tc_wait_time)
						sleep @tc_wait_time
						assert(rs, "����������ʾ")
						error_info = @account_iframe.p(id: @ts_tag_modify_pw_error).text
						puts("������ʾ����:#{error_info}".encode("GBK"))
						assert_equal(@tc_pw_notsame_err, error_info, "������ʾ���ݲ���ȷ")

						puts("�޸�����Ϊ#{@tc_new_pw1.size}�ַ�".encode("GBK"))
						puts("�޸��û���Ϊ��#{@ts_default_usr}".encode("GBK"))
						puts("�޸�����Ϊ��#{@tc_new_pw1}".encode("GBK"))
						@account_iframe.text_field(id: @ts_tag_aduser).set(@ts_default_usr)
						3.times do
								break if !@account_iframe.text_field(id: @ts_tag_aduser).value.empty?
								@account_iframe.text_field(id: @ts_tag_aduser).set(@ts_default_usr)
						end
						@account_iframe.text_field(id: @ts_tag_adpass).set(@tc_new_pw1)
						@account_iframe.text_field(id: @ts_tag_adpass2).set(@tc_new_pw1)
						@account_iframe.button(id: @ts_tag_sbm).click
						rs = @account_iframe.p(id: @ts_tag_modify_pw_error).wait_until_present(@tc_wait_time)
						sleep @tc_wait_time
						assert(rs, "����������ʾ")
						error_info = @account_iframe.p(id: @ts_tag_modify_pw_error).text
						puts("������ʾ����:#{error_info}".encode("GBK"))
						assert_equal(@tc_pw_length_err, error_info, "������ʾ���ݲ���ȷ")
						#��߽�
						# puts("�޸�����Ϊ#{@tc_new_pw2.size}�ַ�".encode("GBK"))
						# puts("�޸��û���Ϊ��#{@ts_default_usr}".encode("GBK"))
						# puts("�޸�����Ϊ��#{@tc_new_pw2}".encode("GBK"))
						# @account_iframe.text_field(id: @ts_tag_aduser).set(@ts_default_usr)
						# @account_iframe.text_field(id: @ts_tag_adpass).set(@tc_new_pw2)
						# @account_iframe.text_field(id: @ts_tag_adpass2).set(@tc_new_pw2)
						# @account_iframe.button(id: @ts_tag_sbm).click
						# rs=@account_iframe.div(text: @ts_tag_modify_pw_tip).wait_until_present(@tc_wait_time)
						# sleep @tc_wait_time
						# assert(rs, "�޸�����Ϊ#{@tc_new_pw2.size}�ַ�ʧ��")

						puts("�޸�����Ϊ#{@tc_new_pw3.size}�ַ�".encode("GBK"))
						puts("�޸��û���Ϊ��#{@ts_default_usr}".encode("GBK"))
						puts("�޸�����Ϊ��#{@tc_new_pw3}".encode("GBK"))
						@account_iframe.text_field(id: @ts_tag_aduser).set(@ts_default_usr)
						3.times do
								break if !@account_iframe.text_field(id: @ts_tag_aduser).value.empty?
								@account_iframe.text_field(id: @ts_tag_aduser).set(@ts_default_usr)
						end
						@account_iframe.text_field(id: @ts_tag_adpass).set(@tc_new_pw3)
						@account_iframe.text_field(id: @ts_tag_adpass2).set(@tc_new_pw3)
						@account_iframe.button(id: @ts_tag_sbm).click
						rs = @account_iframe.p(id: @ts_tag_modify_pw_error).wait_until_present(@tc_wait_time)
						sleep @tc_wait_time
						assert(rs, "����������ʾ")
						error_info = @account_iframe.p(id: @ts_tag_modify_pw_error).text
						puts("������ʾ����:#{error_info}".encode("GBK"))
						assert_equal(@tc_pw_length_err, error_info, "������ʾ���ݲ���ȷ")

						puts("�޸�����Ϊ#{@ts_default_pw.size}�ַ�".encode("GBK"))
						puts("�޸��û���Ϊ��#{@ts_default_usr}".encode("GBK"))
						puts("�޸�����Ϊ��#{@ts_default_pw}".encode("GBK"))
						@account_iframe.text_field(id: @ts_tag_aduser).set(@ts_default_usr)
						3.times do
								break if !@account_iframe.text_field(id: @ts_tag_aduser).value.empty?
								@account_iframe.text_field(id: @ts_tag_aduser).set(@ts_default_usr)
						end
						@account_iframe.text_field(id: @ts_tag_adpass).set(@ts_default_pw)
						@account_iframe.text_field(id: @ts_tag_adpass2).set(@ts_default_pw)
						@account_iframe.button(id: @ts_tag_sbm).click
						rs=@account_iframe.div(text: @ts_tag_modify_pw_tip).wait_until_present(@tc_wait_time)
						sleep @tc_wait_time
						assert(rs, "�޸�����Ϊ#{@ts_default_pw.size}�ַ�ʧ��")
				}

				operate("2�����뵱ǰ���룬�������������ȷ�������������������~!@#$%^&*()_+{}|:\"<>?�� ������33�������ַ���������ַ��� �� �Ƿ���Ա��� �� ���޸ĳɹ� �� ") {
						puts("�޸��û���Ϊ��#{@ts_default_usr}".encode("GBK"))
						puts("�޸�����Ϊ��#{@tc_pw_special1}".encode("GBK"))
						@account_iframe.text_field(id: @ts_tag_aduser).set(@ts_default_usr)
						3.times do
								break if !@account_iframe.text_field(id: @ts_tag_aduser).value.empty?
								@account_iframe.text_field(id: @ts_tag_aduser).set(@ts_default_usr)
						end
						@account_iframe.text_field(id: @ts_tag_adpass).set(@tc_pw_special1)
						@account_iframe.text_field(id: @ts_tag_adpass2).set(@tc_pw_special1)
						@account_iframe.button(id: @ts_tag_sbm).click
						#������������ַ�
						# rs=@account_iframe.div(text: @ts_tag_modify_pw_tip).wait_until_present(@tc_wait_time)
						# sleep @tc_wait_time
						# assert(rs, "�޸�����Ϊ#{@tc_pw_special1}ʧ��")
						#���������
						rs = @account_iframe.p(id: @ts_tag_modify_pw_error).wait_until_present(@tc_wait_time)
						sleep @tc_wait_time
						assert(rs, "����������ʾ")
						error_info = @account_iframe.p(id: @ts_tag_modify_pw_error).text
						puts("������ʾ����:#{error_info}".encode("GBK"))
						assert_equal(@tc_pw_content_err, error_info, "������ʾ���ݲ���ȷ")

						puts("�޸��û���Ϊ��#{@ts_default_usr}".encode("GBK"))
						puts("�޸�����Ϊ��#{@tc_pw_special2}".encode("GBK"))
						@account_iframe.text_field(id: @ts_tag_aduser).set(@ts_default_usr)
						3.times do
								break if !@account_iframe.text_field(id: @ts_tag_aduser).value.empty?
								@account_iframe.text_field(id: @ts_tag_aduser).set(@ts_default_usr)
						end
						@account_iframe.text_field(id: @ts_tag_adpass).set(@tc_pw_special1)
						@account_iframe.text_field(id: @ts_tag_adpass2).set(@tc_pw_special1)
						@account_iframe.button(id: @ts_tag_sbm).click
						# rs=@account_iframe.div(text: @ts_tag_modify_pw_tip).wait_until_present(@tc_wait_time)
						# sleep @tc_wait_time
						# assert(rs, "�޸�����Ϊ#{@tc_pw_special2}ʧ��")
						rs = @account_iframe.p(id: @ts_tag_modify_pw_error).wait_until_present(@tc_wait_time)
						sleep @tc_wait_time
						assert(rs, "����������ʾ")
						error_info = @account_iframe.p(id: @ts_tag_modify_pw_error).text
						puts("������ʾ����:#{error_info}".encode("GBK"))
						assert_equal(@tc_pw_content_err, error_info, "������ʾ���ݲ���ȷ")

						puts("�޸��û���Ϊ��#{@ts_default_usr}".encode("GBK"))
						puts("�޸�����Ϊ��#{@tc_pw_special3}".encode("GBK"))
						@account_iframe.text_field(id: @ts_tag_aduser).set(@ts_default_usr)
						3.times do
								break if !@account_iframe.text_field(id: @ts_tag_aduser).value.empty?
								@account_iframe.text_field(id: @ts_tag_aduser).set(@ts_default_usr)
						end
						@account_iframe.text_field(id: @ts_tag_adpass).set(@tc_pw_special1)
						@account_iframe.text_field(id: @ts_tag_adpass2).set(@tc_pw_special1)
						@account_iframe.button(id: @ts_tag_sbm).click
						# rs=@account_iframe.div(text: @ts_tag_modify_pw_tip).wait_until_present(@tc_wait_time)
						# sleep @tc_wait_time
						# assert(rs, "�޸�����Ϊ#{@tc_pw_special3}ʧ��")
						rs = @account_iframe.p(id: @ts_tag_modify_pw_error).wait_until_present(@tc_wait_time)
						sleep @tc_wait_time
						assert(rs, "����������ʾ")
						error_info = @account_iframe.p(id: @ts_tag_modify_pw_error).text
						puts("������ʾ����:#{error_info}".encode("GBK"))
						assert_equal(@tc_pw_content_err, error_info, "������ʾ���ݲ���ȷ")
				}


		end

		def clearup

				operate("�ָ�Ĭ���˻�") {

						if @browser.div(class_name: @ts_aui_state_full).exists?
								@browser.execute_script(@ts_close_div)
						end

						if @browser.link(id: @ts_tag_modify_pw).exists?
								@browser.link(id: @ts_tag_modify_pw).click
								@account_iframe = @browser.iframe(src: @ts_tag_account_manage)
								@account_iframe.text_field(id: @ts_tag_aduser).set(@ts_default_usr)
								@account_iframe.text_field(id: @ts_tag_adpass).set(@ts_default_pw)
								@account_iframe.text_field(id: @ts_tag_adpass2).set(@ts_default_pw)
								@account_iframe.button(id: @ts_tag_sbm).click
								sleep @tc_wait_time
						end

				}

		end

}
