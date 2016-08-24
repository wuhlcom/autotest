#encoding:utf-8
# http://ruby-doc.org/stdlib-1.9.3/libdoc/minitest/unit/rdoc/MiniTest.html
# 自定义执行器
# gem包的minitest没有runner方法，不能自定义runner
# 标准库的minitest可以自定义runner
gem 'minitest'
 require 'minitest/autorun'
 # require 'minitest/unit'
require "minitest/reporters"
p MiniTest::Unit.new
p  MiniTest::Unit.runner
module MiniTestWithHooks
	class MiniTestWithHooks::Unit < MiniTest::Unit
		def before_suites
		end

		def after_suites
		end

		def _run_suites(suites, type)
			begin
				before_suites
				super(suites, type)
			ensure
				after_suites
			end
		end

		def _run_suite(suite, type)
			begin
				suite.before_suite
				super(suite, type)
			ensure
				suite.after_suite
			end
		end
	end
end

module MiniTestWithTransactions
	class Unit < MiniTestWithHooks::Unit
		# include TestSetupHelper

		def before_suites
			super
			setup_nested_transactions
			# load any data we want available for all tests
		end

		def after_suites
			teardown_nested_transactions
			super
		end
	end
end
# require 'pp'
# MiniTest::Unit
#  pp MiniTest::Unit.methods.sort
# pp MiniTest::Unit.instance_methods(false).sort
# MiniTest::Unit.runner = MiniTestWithTransactions::Unit.new