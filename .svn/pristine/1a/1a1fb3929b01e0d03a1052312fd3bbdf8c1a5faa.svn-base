require 'test/unit/testsuite'
require 'test/unit/ui/console/testrunner'
require './TestUnit_order'
class AllTests
		def self.suite
				suite = Test::Unit::TestSuite.new("TestUnit")
				suite << UnitTest.suite
				# suite << ResourceTest.suite
				# suite << RESTSessionTest.suite
				# suite << ServerTest.suite
		end
end

Test::Unit::UI::Console::TestRunner.run(AllTests)