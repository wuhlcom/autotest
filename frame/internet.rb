testsuite {

		# Called before every ftp_test method runs. Can be used  to set up fixture information.
		def setup
				####################firefox profile###############################################
				@ts_file_type          = "text/txt,application/rar,application/zip,application/octet-stream"
				# @ts_download_directory = File.expand_path("../downloads", __FILE__)
				# @ts_download_directory.gsub!("/", "\\\\") if Selenium::WebDriver::Platform.windows?
				@ts_download_directory = "D:\\webdownloads" #WEB下载默认路径修改到D盘
				###@ts_download_directory = @ts_download_directory.gsub("/", "\\") if Selenium::WebDriver::Platform.windows?
				#浏览器默认下载设置
				# The easiest and best way of dealing with file downloads is to avoid the pesky file download dialogs altogether.
				# This is done by programatically telling the browser to automatically save files to a certain directory,
				# that your ftp_test can access.
				@ts_default_profile    = Selenium::WebDriver::Firefox::Profile.from_name("default")
				@ts_default_profile.model_linux_format
				@ts_default_profile['browser.download.folderList']            = 2 # custom location
				@ts_default_profile['browser.download.dir']                   = @ts_download_directory #download path
				@ts_default_profile['browser.helperApps.neverAsk.saveToDisk'] = @ts_file_type
				# @ts_default_profile['browser.link.open_newwindow']            = 3 #link open on newwindow 暂不支持
				# Internally, WebDriver uses HTTP to communicate with a lot of the drivers (the JsonWireProtocol).
				# By default, Net::HTTP from Ruby's standard library is used, which has a default timeout of 60 seconds.
				# If you call e.g. Driver#get, Driver#click on a page that takes more than 60 seconds to load,
				# you'll see a Timeout::Error raised from Net::HTTP.
				# You can configure this timeout (before launching a browser) by doing:
				client                                                        = Selenium::WebDriver::Remote::Http::Default.new
				client.timeout                                                = 120 # seconds
				@browser                                                      = Watir::Browser.new :firefox, :http_client => client, :profile => @ts_default_profile
				@browser.cookies.clear
				#find_element will wait for a specified amount of time before raising a NoSuchElementError:
				@browser.driver.manage.timeouts.implicit_wait = 2 # seconds
				###############################login################################################################
				rs                                            = @browser.assert_exists
				assert(rs, "打开浏览器失败！")

				rs_login = login_recover(@browser, @ts_default_ip)
				assert(rs_login, "路由器登录失败！")
				############################get verion and mac##########################################################
				@browser.p(text: @ts_tag_sys_vers).wait_until_present(5) #登录后等待对象出现 add by liluping 2016/01/06
				if @browser.p(text: /#{@ts_tag_sys_ver}/).exist?
						system_ver = @browser.p(text: /#{@ts_tag_sys_ver}/).text
						@ts_wan_mac_pattern1 =~system_ver
				elsif @browser.span(id: @ts_tag_systemver).exist?
						system_ver = @browser.span(id: @ts_tag_systemver).parent.text
						@ts_wan_mac_pattern1 =~system_ver
				end
				#xx:yy:xx:yy:xx:yy
				@ts_wan_mac = Regexp.last_match(1)
				#------yyxxyy,后6个字节
				@ts_sub_mac = @ts_wan_mac.gsub(":", "")[-6..-1]

		end

		# Called after every ftp_test method runs. Can be used to tear down fixture information.
		def teardown
				 @browser.close
		end

}