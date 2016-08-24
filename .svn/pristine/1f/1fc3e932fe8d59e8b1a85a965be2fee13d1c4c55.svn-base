# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "htmltags/version"
SPEC=Gem::Specification.new do |s|
	s.name        ="htmltags"
	s.version     =HtmlTag::VERSION
	s.platform    =Gem::Platform::RUBY
	s.authors     =['wuhongliang']
	s.date        = '2015-06-04'
	s.email       ="wuhongliang@zhilutec.com"
	s.homepage    ="http://www.rubyeye.net"
	s.summary     =["htmltags"]
	s.description =["htmltags for watir-webdriver"]
	condidates    =Dir.glob("**/**.{rb,gemspec,txt,doc,rdoc,exe}")
	# condidates2   =Dir.glob("**/**.{log,xml}")
	# condidates    =condidates1|condidates2 #要打包的文件
	# condidates =Dir.glob("**/*.{rb,gemspec,txt,doc,rdoc}")
	s.files       =condidates.delete_if do |item|
		item.include?("CVS") #|| item.include?("rdoc")
	end
	# s.require_paths=["htmltags"]
	s.add_development_dependency "watir-webdriver", "~> 0.7.0"
	s.add_development_dependency "minitest", "~> 5.7.0"
	s.add_development_dependency "minitest-reporters", "~> 1.0.16"
	s.add_development_dependency "net-http-server", "~> 0.2.2"
	s.add_development_dependency "tardotgz", "~> 1.0.2"
end
