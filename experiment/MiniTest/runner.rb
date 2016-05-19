# gem包的minitest没有runner方法，不能自定义runner
# 标准库的minitest可以自定义runner
class Burger
		def initialize
				puts "YOU CREATED A BURGER"
		end

		def has_cheese?
				true
		end

		def has_pickle?
				false
		end
end

gem 'minitest'

require 'minitest/autorun'
 MiniTest::Unit.autorun

class MyMiniTest
		class Unit < MiniTest::Unit

				def before_suites
						# code to run before the first test
						p "Before everything"
				end

				def after_suites
						# code to run after the last test
						p "After everything"
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
								suite.before_suite if suite.respond_to?(:before_suite)
								super(suite, type)
						ensure
								suite.after_suite if suite.respond_to?(:after_suite)
						end
				end

		end
end

MiniTest::Unit.runner
MiniTest::Unit.runner = MyMiniTest::Unit.new

class BurgerTest < MiniTest::Unit::TestCase

		def self.before_suite
				p "hi"
		end

		def self.after_suite
				p "bye"
		end

		def setup
				@burger = Burger.new
		end

		def test_has_cheese
				assert_equal true, @burger.has_cheese?
		end

		def test_has_pickle
				assert_equal false, @burger.has_pickle?
		end

end