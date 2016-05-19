# ClassA = Class.new do
#
# end
# p ClassA.new.class
# p ClassA.name
# class B
#
# end
# p B.name

# def add_class
arr=[]
for i in 0..1
  arr << Class.new do
    def test
     "aaa"
    end
  end
end
# p arr[0].new.ftp_test
# p arr[1].new.ftp_test

#t3是动态方法-实例方法
#t3虽是实例方法但它依赖于t2方法的调用,
#如果self.t2未被调用t3方法是不可见的，此时实例对象a也无法调用t3方法
#这种依赖关系可以应用到方法的顺序调用中
class Test
  # p self
  def t1
    p "t1"
    self
  end

  def self.test
    p "tttttttttttttttttt1111"
  end

  def test
    p "tttttttttttttttttt"
  end

  def self.t2
    p "t2"
    # p self
    def t3
      test
       "t3"
    end
  end

end
# a = Test.new
# # p a.t1
# p "11"*50
# p Test.t2
# p a.t3
# p "="*80
# p Test.methods(false)
# p Test.instance_methods(false)