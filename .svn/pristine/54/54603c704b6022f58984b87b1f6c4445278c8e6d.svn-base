#encoding: utf-8
require 'watir-webdriver'
###########################Implicit
#WebDriver lets you configure implicit waits, so that a call to
#find_element will wait for a specified amount of time before raising a NoSuchElementError:
# driver = Selenium::WebDriver.for :firefox
# driver.manage.timeouts.implicit_wait = 3 # seconds

#  @browser = Watir::Browser.new(:firefox,:remote_manage,:profile=>"default",)
#  @browser.driver.manage.timeouts.implicit_wait = 3 # seconds

################################
# Internally, WebDriver uses HTTP to communicate with a lot of the drivers (the JsonWireProtocol).
# By default, Net::HTTP from Ruby's standard library is used, which has a default timeout of 60 seconds.
# If you call e.g. Driver#get, Driver#click on a page that takes more than 60 seconds to load,
# you'll see a Timeout::Error raised from Net::HTTP.
# You can configure this timeout (before launching a browser) by doing:
#
# module Selenium
#   module WebDriver
#     module Remote
#       module Http
#        class Default
# client         = Selenium::WebDriver::Remote::Http::Default.new
# client.timeout = 120 # seconds
# driver         = Selenium::WebDriver.for(:remote_manage, :http_client => client)

client                                        = Selenium::WebDriver::Remote::Http::Default.new
client.timeout                                = 120 # seconds
@browser                                      = Watir::Browser.new(:firefox, :profile => "default", :http_client => client)
@browser.driver.manage.timeouts.implicit_wait = 2 # seconds



