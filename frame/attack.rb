testsuite {

  # Called before every ftp_test method runs. Can be used  to set up fixture information.
  def setup

    ####################firefox profile###############################################
    @browser = Watir::Browser.new :firefox, :profile => "default"
    @browser.cookies.clear
    #find_element will wait for a specified amount of time before raising a NoSuchElementError:
    @browser.driver.manage.timeouts.implicit_wait = 2 # seconds
    rs                                            = @browser.assert_exists
    assert(rs, "�������ʧ�ܣ�")
    rs_login = login_recover(@browser, @ts_powerip, @ts_default_ip)
    assert(rs_login, "·������¼ʧ�ܣ�")
  end

  # Called after every ftp_test method runs. Can be used to tear down fixture information.
  def teardown
    @browser.close
  end

}