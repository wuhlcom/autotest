gem 'minitest'
require 'minitest/autorun'
file_path =File.expand_path('../../lib/htmltags', __FILE__)
require file_path
#require 'htmltags'
class MyTest < MiniTest::Unit::TestCase
  include HtmlTag::LogInOut
  # Called before every ftp_test method runs. Can be used
  # to set up fixture information.
  def setup
    # Do nothing
  end

  def testlogin_no_url
    # @default_url= "192.168.111.1"
    # @browser    = Watir::Browser.new :ff, :profile => "default"
    # @browser.goto @default_url
    # login_no_url(@browser)
  end

  def testreboot
    @default_url= "192.168.111.1"
    @browser    = Watir::Browser.new :ff, :profile => "default"
    @browser.goto @default_url
    login_no_url(@browser)
    reboot ="aui_state_highlight"
    div    ="aui_state_noTitle aui_state_focus aui_state_lock"

    rebooting     ="aui_content"
    @ts_tag_reboot="reboottxt"
    # /html/body/div[1]/div/table/tbody/tr[2]/td[2]/div/table/tbody/tr[3]/td/div/button[1]
    path          = "/html/body/div[1]/div/table/tbody/tr[2]/td[2]/div/table/tbody/tr[3]/td/div/button[1]"
    # path2         = "/html/body/div[1]/div/table/tbody/tr[1]/td[1]/div/table/tbody/tr[2]/td/div/button[0]" #´íÎó
    # aui_state_noTitle aui_state_focus aui_state_lock

    @browser.span(id: @ts_tag_reboot).click
    div_p = @browser.div(class_name: div)
    p div_p.exists?
    p "1111111111111111111111111"
    div_c = div_p.button(class_name: reboot)
    p div_c.exists?
    if div_c.exists?
      div_c.click
    end
  end

  def testping_rs
    @@default_url="192.168.111.1"
    p ping_rs @@default_url
  end

  def test_login_recover
    @browser    = Watir::Browser.new :ff, :profile => "default"
    @default_ip ="192.168.100.1"
    login_recover(@browser, "50.50.50.101", @default_ip,)
  end

  def testlogin
    @browser     = Watir::Browser.new :ff, :profile => "default"
    @@default_url="192.168.111.1"
    login(@browser, @@default_url)
    sleep 5
    login(@browser, @@default_url)
  end

  def testMultiWindows
    @browser     = Watir::Browser.new :ff, :profile => "default"
    @default_url = "192.168.111.1"

    @browser.goto("www.baidu.com")
    #´ò¿ªÐÂµÄä¯ÀÀÆ÷
    p @browser.execute_script('window.open("http://192.168.111.1")')
    p @browser.driver.window_handles
    p @browser.windows
    #Ê¹ÓÃµÚ¶þ¸öä¯ÀÀÆ÷
    # @browser.window(:url,/#{@default_url}/).use
    @browser.driver.switch_to.window(@browser.driver.window_handles[1])
    login_no_default_ip(@browser)
    # @browser.driver.switch_to.window(@browser.driver.window_handles[0])

    # @browser.link(:text, 'A/B Testing').click(:command, :shift)
    # @browser.windows.last.use
    #@browser.link(src:@default_url).click :shift

    #ÔÚÐÂµÄä¯ÀÀÆ÷´ò¿ª
    # @browser.element.send_keys([:control, 'T'])
    #@browser.send_keys([:control, 'T'])
    # p @browser.windows

    # browser = Watir::Browser.new(:firefox) # could be :chrome or :ie
    # browser.goto(an_initial_url)
    # browser.link(:text, 'Open This Window').click # opens a new window
    # browser.driver.switch_to.window(browser.driver.window_handles[0])
    # popup = browser.window(:url, /newwindow/).use
    # popup.close
    # browser.driver.switch_to.window(browser.driver.window_handles[0])
    # browser = browser.window(how, /#{uri_decoded_pattern}/).use
    # browser.link(:text, 'Open This Window').click # open it again

  end

  # Called after every ftp_test method runs. Can be used to tear
  # down fixture information.

  def testlogin_router_recover
    browser      = Watir::Browser.new :ff, :profile => "default"
    @@default_url="192.168.111.1"
    usrname      ="admin"; passwd="admin"; nicname="dut"; count="5"
    login_router_recover(browser, @@default_ip, usrname, passwd, nicname, count)
  end

  def testlogin_noip
    ip      = "192.168.100.1"
    usr     = "admin"
    pw      = "admin"
    browser = Watir::Browser.new :ff, :profile => "default"
    browser.goto(ip)
    rs = login_no_default_ip(browser)
  end


  def teardown
    # Do nothing
  end

end