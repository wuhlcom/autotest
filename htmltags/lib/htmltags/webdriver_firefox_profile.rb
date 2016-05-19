#encoding:utf-8
# config FireFox
# author : wuhongliang
# date   : 2015-8-03
class Selenium::WebDriver::Firefox::Profile
	attr_accessor :model
	def model_windows_format
		@model = model.gsub(/\/|\\/, "\\\\")
	end

	def model_linux_format
		@model = model.gsub(/\\\\|\\/, "\/")
	end
end