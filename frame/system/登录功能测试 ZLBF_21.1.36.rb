#
#description:
#author:wuhongliang
#date:2015-06-30 14:12:41
#modify:
#
testcase {
		attr = {"id" => "ZLBF_21.1.36", "level" => "P1", "auto" => "n"}

		def prepare
				@tc_usr_arr      = ["errname", "admin"]
				@tc_pw_arr       = ["admin", "errpasswd"]
				@tc_null_account = ["", "", "admin"]
				@tc_null_pw      = ["", "admin", ""]
				@tc_usr_pw_err   = "�û������������"
				@tc_usr_pw_null  = "�û��������벻��Ϊ��"
				@tc_login_time   = 2
		end

		def process
				operate("1 ��¼����") {
						rs = ping_recover(@ts_default_ip)
						assert(rs, "�޷�PINGͨ·����")
						@browser.goto(@ts_default_ip)
						@main_page = RouterPageObject::MainPage.new(@browser)
						rs         = @main_page.login_with_exists(@browser.url)
						assert(rs, '�򿪵�¼ҳ��ʧ�ܣ�')
						@tc_usr_arr.each_with_index do |usr, i|
								puts "�����˻��������:��#{i+1}���ʻ�����".to_gbk
								puts "----usrname:#{usr}"
								puts "----passwd:#{@tc_pw_arr[i]}"
								@main_page.login_with(usr, @tc_pw_arr[i], @browser.url)
								sleep @tc_login_time
								errinfo = @main_page.main_error
								puts "ERROR TIP:#{errinfo}".to_gbk
								assert_equal(@tc_usr_pw_err, errinfo, "��������ʻ��������¼�ɹ��ˣ�")
						end

						@tc_null_account.each_with_index do |usr, i|
								puts "�û���������Ϊ�ղ��ԣ���#{i+1}���ʻ�����".to_gbk
								puts "----usrname:#{usr}"
								puts "----passwd:#{@tc_null_pw[i]}"
								@main_page.login_with(usr, @tc_null_pw[i], @browser.url)
								sleep @tc_login_time
								errinfo = @main_page.main_error
								puts "ERROR TIP:#{errinfo}".to_gbk
								assert_equal(@tc_usr_pw_null, errinfo, "��������ʻ�������Ϊ�յ�¼�ɹ��ˣ�")
						end
				}
		end

		def clearup

		end

}
