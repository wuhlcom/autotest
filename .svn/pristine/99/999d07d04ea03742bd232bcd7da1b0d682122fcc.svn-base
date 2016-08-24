gem "test-unit"
require 'test/unit'
require 'test/unit/testsuite'
require 'test/unit/autorunner'
require 'test/unit/ui/console/testrunner'
require 'test/unit/ui/xml/testrunner'
require './test_mytest1'
require './test_mytest2'
class TS_MyTests
		def self.suite
				suite = Test::Unit::TestSuite.new("Internet")
				suite << MyTest1.suite
				suite << MyTest2.suite
				return suite
		end
end

Test::Unit::Runner::HTML
# Test::Unit::AutoRunner.default_runner="--runner=html"
Test::Unit::UI::Console::TestRunner.run(TS_MyTests)
#######################################生成xml格式报告############################
# p xml_path = File.absolute_path("../test_unit_all.xml", __FILE__)
# xml_file="test_unit_all.xml"
# unless File.exists?(xml_file)
# 		file = File.open(xml_file, "w+")
# 		file.close
# end
#
# fd = IO.sysopen(xml_file, "w")
# Test::Unit::UI::XML::TestRunner.run(TS_MyTests, output_file_descriptor: fd)
######################################生成html报告##################################
# report_dir = File.expand_path(File.dirname(__FILE__))
# Test::Unit::UI::HTML::TestRunner.run(TS_MyTests, report_dir: report_dir, output_file: "test_unit_all.html")
# Test::Unit::UI::HTML::TestRunner.run(TS_MyTests)
