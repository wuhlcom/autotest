file_path =File.expand_path('../../lib/htmltags', __FILE__)
require file_path
Minitest.should_shuffle_suites=false
# require 'watir-webdriver'
# @browser = Watir::Browser.new :ff, :profile => "default"
$url      ="wwww.baidu.com"
# @browser.goto($url)
# require 'router_page_object'
 require_relative 'testcases/testcase_001.rb'
# require_relative 'testcases/testcase_002.rb'
# require_relative 'testcases/testcase_003.rb'
# require_relative 'testcases/testcase_004.rb'

