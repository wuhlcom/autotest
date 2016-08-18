gem 'minitest'
require 'minitest/autorun'
class MemeAsker
  def initialize(meme)
    @meme = meme
  end

  def ask(question)
    method = question.tr(" ", "_") + "?"
    @meme.__send__(method)
  end
end

require "minitest/autorun"

describe MemeAsker, :ask do
  describe "when passed an unpunctuated question" do
    it "should invoke the appropriate predicate method on the meme" do
      @meme = Minitest::Mock.new
      @meme_asker = MemeAsker.new @meme
      @meme.expect :will_it_blend?, :return_value

      @meme_asker.ask "will it blend"

      @meme.verify
    end
  end
end