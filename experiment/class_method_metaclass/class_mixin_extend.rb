####方法一
module MyMixin1
  #模块的勾子方法
  def self.included(base)
    base.extend(ClassMethods1) #只扩展类方法不扩展实例方法
  end

  module ClassMethods1
    def test1_method_1
      __method__
    end

    def test2_method_1
      __method__
    end

    def self.test1_method_1
      __method__
    end

    def self.test2_method_1
      __method__
    end
  end
end

#####方法二
module MyMixin2
  #模块的勾子方法
  def self.included(base)
    base.extend(self) #这样这个模块中的方法即是类方法又是实例方法
  end

  # module ClassMethods
  def test1_method_2
    __method__
  end

  # end
  def test2_method_2
    __method__
  end
end

module MyMixin3
  def self.test1_method_3
    __method__
  end

  def test1_method_3
    __method__
  end
end

class MyClass
  include MyMixin1
  include MyMixin2
  include MyMixin3
end

class MyClass1
  extend MyMixin1
  extend MyMixin2
  extend MyMixin3
end

#模块的模块方法不能被include和extend为在为模块方法相当于是模块的eigenclass方法
#只有模块的实例方法才能被include和extend
p MyClass.test1_method_1 #类方法
p MyClass.test2_method_1 #类方法
# p MyClass.new.test1_method_1 #无法执行
# p MyClass.new.test2_method_1 #无法执行

# p MyClass::ClassMethods1.test1_method_1 #无法执行
# p MyClass::ClassMethods1.new.test1_method_1 #无法执行

p MyClass.new.test1_method_2 #实例方法
p MyClass.test1_method_2 #类方法

p MyClass.new.test2_method_2 #实例方法
p MyClass.test2_method_2 #类方法

p MyClass.new.test1_method_3 #实例方法
# p MyClass.test3_method_3 #类方法