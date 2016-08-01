#encoding:utf-8
#iam api
#author:wuhongliang
#date:2016-07-21
module IAMAPI
    $report_date = Time.new.strftime("%Y%m%d")
    require 'pp'
    require 'net/http'
    require 'uri'
    require 'nokogiri'
    require 'json'
    require 'rexml/document'
    require 'fileutils'
    gem 'minitest'
    require 'minitest/autorun'
    libs = Dir.glob(File.expand_path(File.dirname(__FILE__))+"/iam/*")
    libs.each { |lib|
        next unless File.extname(lib)==".rb"
        require lib
    }
end




