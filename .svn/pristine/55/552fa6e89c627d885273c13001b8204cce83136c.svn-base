testsuite {

		# Called before every ftp_test method runs. Can be used  to set up fixture information.
		def setup
				####################firefox profile###############################################
				@ts_upload_directory   = File.expand_path("../uploads", __FILE__)
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
				@browser                                                      = Watir::Browser.new :firefox, :profile => @ts_default_profile
				@browser.cookies.clear
				#find_element will wait for a specified amount of time before raising a NoSuchElementError:
				@browser.driver.manage.timeouts.implicit_wait = 2 # seconds
				rs                                            = @browser.assert_exists
				assert(rs, "打开浏览器失败！")

				rs_login = login_recover(@browser, @ts_default_ip)
				assert(rs_login, "路由器登录失败！")

				#"\u7CFB\u7EDF\u7248\u672C\uFF1A V100R003SPC010 MAC\uFF1A00:0C:43:76:20:66"
				system_ver = @browser.p(text: /#{@ts_tag_sys_ver}/).text
				@ts_wan_mac_pattern1 =~system_ver
				#xx:yy:xx:yy:xx:yy
				@ts_wan_mac = Regexp.last_match(1)
				#------yyxxyy,后6个字节
				@ts_sub_mac = @ts_wan_mac.gsub(":", "")[-6..-1]
				system_ver =~/(V\d+R\d+[SPC|C]\d+.*)\s+MAC/i
				@ts_current_ver = Regexp.last_match(1).strip
				puts "Current Version #{@ts_current_ver}"
				@ts_download_directory.gsub!("\\", "/")
		end

		# Called after every ftp_test method runs. Can be used to tear down fixture information.
		def teardown
				 @browser.close
		end

}