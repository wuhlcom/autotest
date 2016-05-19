#encoding:utf-8
module HtmlTag
	$report_date = Time.new.strftime("%Y%m%d")
	require 'net/ftp'
	require 'watir-webdriver'
	gem 'minitest'
	require 'minitest/autorun'
	require 'rexml/document'
	require 'drb/drb'
	require 'fileutils'
	require 'timeout'
	require 'time'
	libs = Dir.glob(File.expand_path(File.dirname(__FILE__))+"/htmltags/*")
	libs.each { |lib|
		next unless File.extname(lib)==".rb"
		require lib
	}
end




