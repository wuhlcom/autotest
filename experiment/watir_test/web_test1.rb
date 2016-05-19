require 'watir-webdriver'
# Selenium::WebDriver::Firefox::Binary.path="D:/Program Files (x86)/Mozilla Firefox/firefox.exe"
# Selenium::WebDriver::Chrome::Service.executable_path="D:/Program Files (x86)/Chrome/chrome.exe"
@browser = Watir::Browser.new :ff,:profile=>"default"
# p ip="192.168.100.1"
ip = "www.baidu.com"
@browser.goto(ip)

p @browser.title
p @browser.title.encode("GBK")
p @browser.title.encoding
# puts "11111"
# @browser.goto(ip)
# puts "2222"
# @browser.goto(ip)
# puts "3333"
# @browser.close

