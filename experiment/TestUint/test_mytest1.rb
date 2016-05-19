#encoding:utf-8
require 'test/unit'
class MyTest1 < Test::Unit::TestCase
		class << self
				def startup
						p "mytest1 startup"
				end

				def shutdown
						p "mytest1 shutdown"
				end
		end

		# Called before every ftp_test method runs. Can be used
		# to set up fixture information.
		def setup
				p "mytest1 setup"
		end

		# Called after every ftp_test method runs. Can be used to tear
		# down fixture information.
		def clearup
				p "mytest1 clearup"
		end

		def teardown
				p "mytest1 teardown"
		end

		def test_method1
				p "#{self.to_s},method:#{__method__.to_s}"
				assert(true, "haha")
		end

		def test_method2
				p "#{self.to_s},method:#{__method__.to_s}"
				assert(true, "haha")
		end


		# Fake ftp_test
		# def test_fail
		#
		#   fail('Not implemented')
		# end

end

# require 'ftp_test/unit/ui/console/testrunner'
# Test::Unit::UI::Console::TestRunner.run(MyTest1)
# require 'ftp_test/unit/runner/tk'
# Test::Unit::Runner::Tk.run(MyTest1)
