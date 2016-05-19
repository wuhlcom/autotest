#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
testcase {
		attr = {"id" => "ZLBF_21.1.73", "level" => "P3", "auto" => "n"}

		def prepare
				@tc_login_timeout = 5*60+30
				@tc_refresh_time  = 10
		end

		def process

				operate("1����½DUT�����������޸�ҳ�棻") {
						rs_login = login_recover(@browser, @ts_default_ip)
						assert(rs_login, "·������¼ʧ�ܣ�")
				}

				operate("2����ʱΪ15���ӣ���鲻����ʱ�䳬��15���ӣ��Ƿ���Ҫ���µ�¼��֤��") {
						#��ʱʱ��Ϊ5����05��
						@account_page = RouterPageObject::AccountPage.new(@browser)
						logout        = false
						33.times do |i|
								logout= @account_page.login_with_exists(@browser.url)
								puts "sleep #{@tc_refresh_time*(i+1)} seconds for router timeout ..."
								sleep @tc_refresh_time
								break if logout
						end
						assert(logout, "�ȴ�#{@tc_login_timeout}seconds��·������δ��ʱ")
				}

		end

		def clearup

		end

}
