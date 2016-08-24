# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "iam/static_params"
SPEC=Gem::Specification.new do |s|
  s.name        ="iam"
  s.version     =IAMAPI::VERSION
  s.platform    =Gem::Platform::RUBY
  s.authors     =['wuhongliang']
  s.date        = '2016-07-22'
  s.email       ="wuhongliang@zhilutec.com"
  s.homepage    ="http://www.rubyeye.net"
  s.summary     =["iam"]
  s.description =["iam api"]
  condidates    =Dir.glob("**/**.{rb,gemspec,txt,doc,rdoc,exe,erb,html}")
  # condidates2   =Dir.glob("**/**.{log,xml}")
  # condidates    =condidates1|condidates2 #要打包的文件
  # condidates =Dir.glob("**/*.{rb,gemspec,txt,doc,rdoc}")
  s.files       =condidates.delete_if do |item|
    item.include?("CVS") #|| item.include?("rdoc")
  end
  s.add_development_dependency "execjs", "~> 2.7.0"
end
