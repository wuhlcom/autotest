
=begin
require "rexml/document"
file = File.new("ftp_test.xml","w+")    #新建XML文件， 将以下内容写入 。
doc = REXML::Document.new       #创建XML内容
#为REXML文档添加一个节点
element = doc.add_element('book', {'name'=>'Programming Ruby','author'=>'Joe Chu'})
chapter1 = element.add_element( 'chapter',{'title'=>'chapter 1'})
chapter2 = element.add_element('chapter', {'title'=>'chapter 2'})
# #为节点添加包含内容
# chapter1.add_text "Chapter 1 content"
chapter2.add_text "Chapter 2 content"

doc.write()
file.puts doc.write
=end

require'rubygems'
require 'builder'
# require_gem 'builder', '~> 2.0'
xml = Builder::XmlMarkup.new
xml.sample(:escaped=>"This&That", :unescaped=>:"Here&amp;There")
p xml.target!
    # <sample escaped="This&amp;That" unescaped="Here&amp;There"/>
builder = Builder::XmlMarkup.new
p xml = builder.person { |b| b.name("Jim"); b.phone("555-1234") }