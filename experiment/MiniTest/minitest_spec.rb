gem 'minitest'
require 'minitest/autorun'
class Hipster
	def define
		"you wouldn't understand"
	end
	def walk?

	end
	def preferred_font
		"helvetica"
	end

	def mainstream?

	end

	def destroy!
		false
	end
end

describe Hipster, "Demonstration of MiniTest" do # Runs codes before each expectation
	before do
		@hipster=Hipster.new
	end # Runs code after each expectation

	after do
		@hipster.destroy!
	end # Define accessors - lazily runs code when it's first used

	let(:hipster) { Hipster.new }
	let(:traits) { ["silly hats", "skinny jeans"] }
	let(:labels) { Array.new }

	# Even lazier accessor - assigns `subject` as the name for us# this equivalent to let(:subject) { Hipster.new }
	subject { Hipster.new }

	it "#define" do
		hipster.define.must_equal "you wouldn't understand"
	end

	it "#walk?" do
		skip "I prefer to skip"
	end

	describe "when asked about the font" do
		it "should be helvetica" do
			@hipster.preferred_font.must_equal "helvetica"
		end
	end

	describe "when asked about mainstream" do
		it "won't be mainstream" do
			@hipster.mainstream?.wont_equal true
		end
	end
end