#
#description:
#author:wuhongliang
#date:2015-06-30 14:12:41
#modify:
#
testcase {
		attr = {"id" => "ZLBF_21.1.72", "level" => "P1", "auto" => "n"}

		def prepare

		end

		def process

				operate("1 ��¼�豸") {
						rs_login = login_recover(@browser, @ts_default_ip)
						assert(rs_login, "·������¼ʧ�ܣ�")
				}

				operate("2 ע������") {
						@main_page = RouterPageObject::MainPage.new(@browser)
						@main_page.logout
						rs = @main_page.login_with_exists(@browser.url)
						assert(rs, 'ע��ʧ�ܣ�')
				}

				operate("3 ע��֮�����µ�¼") {
						#���µ�¼·����
						rs_login = login_no_default_ip(@browser) #���µ�¼
						assert(rs_login[:flag], "��¼ʧ�ܣ�#{rs_login[:message]}")
				}

		end

		def clearup

		end

}
