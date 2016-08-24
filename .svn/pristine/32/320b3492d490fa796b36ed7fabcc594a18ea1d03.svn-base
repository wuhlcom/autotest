testsuite {

  # Called before every ftp_test method runs. Can be used  to set up fixture information.
  def setup
    @browser = Watir::Browser.new :ff, :profile => "default"
    @browser.cookies.clear
    #find_element will wait for a specified amount of time before raising a NoSuchElementError:
    @browser.driver.manage.timeouts.implicit_wait = 2 # seconds
    rs                                            = @browser.assert_exists
    assert(rs, "´ò¿ªä¯ÀÀÆ÷Ê§°Ü£¡")
  end

  # Called after every ftp_test method runs. Can be used to tear down fixture information.
  def teardown
    @browser.close
  end

}