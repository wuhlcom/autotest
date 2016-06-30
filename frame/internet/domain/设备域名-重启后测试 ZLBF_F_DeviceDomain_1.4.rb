#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
testcase {
		attr = {"id" => "ZLBF_30.1.13", "level" => "P3", "auto" => "n"}

		def prepare
				@tc_domain       = "zhiludomain.com"
				@tc_total_domain = "www.#{@tc_domain}"
				@browser_domain  = Watir::Browser.new(@ts_browser_ff, :profile => @ts_ff_profile)
		end

		def process

				operate("1��AP��������������Ϊ·��ģʽ��") {
				}

				operate("2�����뵽�豸���������У�����#{@tc_total_domain}�����棻") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.set_domain(@tc_total_domain, @browser.url)
				}

				operate("3����LAN��PC���������������#{@tc_total_domain}���鿴�Ƿ����ת��AP��¼���棻") {
						begin
								rs = login_default(@browser_domain, @tc_total_domain)
								assert(rs, "ʹ������#{@tc_total_domain}��¼·����ʧ�ܣ�")
						rescue => ex
								p ex.message.to_s
								@browser_domain.close if @browser_domain.exists?
						end

				}

				operate("4������·������������#{@tc_total_domain}���鿴�ܹ���ת��AP��¼���档") {
						@browser.refresh
						@options_page.reboot
						begin
								@browser_domain.cookies.clear
								@browser_domain.refresh
								rs = login_default(@browser_domain, @tc_total_domain)
								assert(rs, "������ʹ��������¼·����ʧ�ܣ�")
						rescue => ex
								p ex.message.to_s
								@browser_domain.close if @browser_domain.exists?
						end

				}


		end

		def clearup
				operate("�ر������") {
						@browser_domain.close if @browser_domain.exists?
				}
		end

}
