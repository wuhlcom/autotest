#encoding:utf-8
file_path =File.expand_path('../../lib/htmltags', __FILE__)
require file_path
# require 'htmltags'
class MyTestRouter < MiniTest::Unit::TestCase
	include HtmlTag::WinCmd
	include HtmlTag::LogInOut
	include HtmlTag::Reporter
	# Called before every ftp_test method runs. Can be used
	# to set up fixture information.
	def setup
		# Do nothing
	end

	# Called after every ftp_test method runs. Can be used to tear
	# down fixture information.

	def teardown
		# Do nothing
	end


	def test_version
		@ts_default_ip    = "192.168.100.1"
		@ts_version_xpath = ('//*[@id="footer"]/div/p')
		@ts_sys_ver="系统版本"
		@browser          = Watir::Browser.new :ff, :profile => "default"
		rs_login          = login_recover(@browser, @ts_default_ip)
		p @browser.p(xpath: @ts_version_xpath).exists?
		p @browser.p(xpath: @ts_version_xpath).text
		p @browser.p(text: /#{@ts_sys_ver}/).exists?
		p @browser.p(text: /#{@ts_sys_ver}/).text
		# system_ver = @browser.span(id: @ts_tag_systemver).parent.text
		# @ts_lan_mac_pattern1 =~system_ver
		# #xx:yy:xx:yy:xx:yy
		# @ts_lan_mac = Regexp.last_match(1)
		# #------yyxxyy,后6个字节
		# @ts_sub_mac = @ts_lan_mac.gsub(":", "")[-6..-1]

	end

end