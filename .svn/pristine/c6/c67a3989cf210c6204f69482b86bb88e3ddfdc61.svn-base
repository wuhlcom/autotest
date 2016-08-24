#     <TestSuites> #测试套的集合，测试区间
# <TestSuite name="Internet">
#
# <TestCases>
# #auto是否实现自动化，result执行结果，executed是否执行,tested是否已经执行
# <TestCase auto="y" result="f" executed='y' tested="n">Testcase1</TestCase>
#       <TestCase auto="y" result="f" executed='y' tested="n">testcase2</TestCase>
# </TestCases>
#   </TestSuite>
#
# <TestSuite name="LAN">
# <TestCases>
# #auto是否实现自动化，result执行结果，executed是否执行,tested是否已经执行
# <TestCase auto="y" result="f" executed='y' tested="n">Testcase1</TestCase>
#       <TestCase auto="y" result="f" executed='y' tested="n">testcase2</TestCase>
# </TestCases>
#   </TestSuite>
#
# </TestSuites>
#encoding: utf-8
require 'rubygems'
require 'builder'
module TestTool
  # xml_markup.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"
  # #=>  <?xml version="1.0" encoding="UTF-8"?>
  # xml = builder.person { |b| b.name("Jim"); b.phone("555-1234") }
  # xml #=> <person><name>Jim</name><phone>555-1234</phone></person>
  class Tsp
    def initialize(file)
      @file = file
      @xml_markup = Builder::XmlMarkup.new
    end

    def instruct
      @xml_markup.instruct! :xml, :version => "1.0", :encoding => "UTF-8"
    end

    def xml_create(args=nil)
      @xml_markup.testsuites { |tsw| tsw.testsuite("Jim"); tsw.phone("555-1234") }
    end

    def save_xml
      @xml_markup
    end

  end

end


if $0==__FILE__
  f = TestTool::Tsp.new("tsp_test.xml").xml_create()
  File.open("builder_xml.xml", "w+") { |file|
    p f
    file.puts f

  } #新建XML文件， 将以下内容写入
  # require 'builder'
  # a = Builder::XmlMarkup.new()
  # builder = Builder::XmlMarkup.new(:target=>STDOUT, :indent=>2)
  # builder.person { |b| b.name("Jim"); b.phone("555-1234") }
  # p a
end
