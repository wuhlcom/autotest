# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "router_page_object/version"
GEM_SPEC = Gem::Specification.new do |s|
		s.name        ="router_page_object"
		s.version     =RouterPageObject::VERSION
		s.platform    =Gem::Platform::RUBY
		s.authors     =['wuhongliang']
		s.date        = '2016-02-26'
		s.email       ="wuhongliang@zhilutec.com"
		s.homepage    ="http://www.rubyeye.net"
		s.summary     =["router page-object"]
		s.description =["router page-object for zl-router"]
		condidates    =Dir.glob("**/**.{rb,gemspec,txt,doc,rdoc,exe}")
		# condidates2   =Dir.glob("**/**.{log,xml}")
		# condidates    =condidates1|condidates2 #要打包的文件
		# condidates =Dir.glob("**/*.{rb,gemspec,txt,doc,rdoc}")
		s.files       =condidates.delete_if do |item|
				item.include?("CVS") #|| item.include?("rdoc")
		end
		# s.require_paths=["router_page_object"]
		s.add_development_dependency "page-object", "~> 1.1.1"
end
