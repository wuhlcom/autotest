require 'htmltags'
p download_directory = "#{Dir.pwd}/downloads"
download_directory.gsub!("/", "\\\\") if Selenium::WebDriver::Platform.windows?
# p Selenium::WebDriver.root
#读取默认配置文件对象
default_profile = Selenium::WebDriver::Firefox::Profile.from_name("default")
# p default_profile
default_profile.model_linux_format
# p default_profile
# p default_profile.native_events = true
# p default_profile.class
# p @browser.fetch_profile

default_profile['browser.download.folderList']               = 2 # custom location
default_profile['browser.download.dir']                      = download_directory
#default_profile['browser.helperApps.alwaysAsk.force']        = false
#default_profile['browser.helperApps.neverAsk.openFile']      = false#"text/txt,application/doc,application/xslx"
default_profile['browser.helperApps.neverAsk.saveToDisk']    = "text/txt,application/octet-stream"
@browser                                                     = Watir::Browser.new :firefox, :profile => default_profile
default_profile['browser.download.dir']                      = "e:/test"