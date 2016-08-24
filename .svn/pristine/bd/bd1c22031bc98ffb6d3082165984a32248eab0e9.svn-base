testsuite {

	# Called before every ftp_test method runs. Can be used  to set up fixture information.
	def setup

		@browser = Watir::Browser.new :ff, :profile => "default"
		@browser.cookies.clear
		rs = @browser.assert_exists
		assert(rs, "´ò¿ªä¯ÀÀÆ÷Ê§°Ü£¡")
		unless ping(@ts_default_ip)
			rs_login = login_recover(@browser, @ts_powerip, @ts_default_ip)
			if rs_login
				@browser.close
				@browser = Watir::Browser.new :ff, :profile => "default"
			end
		end
	end

	# Called after every ftp_test method runs. Can be used to tear down fixture information.
	def teardown
		 @browser.close
	end

}