testsuite {

  # Called before every ftp_test method runs. Can be used  to set up fixture information.
  def setup

    ####################firefox profile###############################################
    @ts_file_type        = "text/txt,application/rar,application/zip,application/octet-stream"
    @ts_backup_directory = File.expand_path("../backups", __FILE__)
    @ts_backup_directory.gsub!("/", "\\\\") if Selenium::WebDriver::Platform.windows?
    #@ts_download_directory = @ts_download_directory.gsub("/", "\\") if Selenium::WebDriver::Platform.windows?
    #ä¯ÀÀÆ÷Ä¬ÈÏÏÂÔØÉèÖÃ
    # The easiest and best way of dealing with file downloads is to avoid the pesky file download dialogs altogether.
    # This is done by programatically telling the browser to automatically save files to a certain directory,
    # that your ftp_test can access.
    @ts_default_profile = Selenium::WebDriver::Firefox::Profile.from_name("default")
    @ts_default_profile.model_linux_format
    @ts_default_profile['browser.download.folderList']            = 2 # custom location
    @ts_default_profile['browser.download.dir']                   = @ts_backup_directory #download path
    @ts_default_profile['browser.helperApps.neverAsk.saveToDisk'] = @ts_file_type
    # @ts_default_profile['browser.link.open_newwindow']            = 3 #link open on newwindow ÔÝ²»Ö§³Ö
    @browser                                                      = Watir::Browser.new :firefox, :profile => @ts_default_profile
    @browser.cookies.clear
    #find_element will wait for a specified amount of time before raising a NoSuchElementError:
    @browser.driver.manage.timeouts.implicit_wait = 2 # seconds
    rs                                            = @browser.assert_exists
    assert(rs, "´ò¿ªä¯ÀÀÆ÷Ê§°Ü£¡")
    rs_login = login_recover(@browser, @ts_powerip, @ts_default_ip)
    assert(rs_login, "Â·ÓÉÆ÷µÇÂ¼Ê§°Ü£¡")
    @ts_backup_directory.gsub!("\\", "/")
  end

  # Called after every ftp_test method runs. Can be used to tear down fixture information.
  def teardown
    @browser.close
  end

}