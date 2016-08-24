class Test
  def test1
  "test1"
  end

  def method_missing(method,*args)
    puts "You called:#{method}-->parameters:(#{args.join(',')})"
    puts "You called passed it a block" if block_given?
  end

end

t=Test.new
t.a("xxx")
p t.test1
