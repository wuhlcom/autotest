module MyMixin2
  # module ClassMethods
  def method2
    "method2"
  end

  # end
  def method3
    "method3"
  end
end

class MyClass
  extend MyMixin2 #类扩展
  def myclass_method1
    'myclass_method1'
  end
end

p MyClass.method2
obj = MyClass.new
obj.extend MyMixin2 #对象扩展
p obj.method2
p "=="*80
class MyClass2
  class <<self
    include MyMixin2 #在eigenclass中包含模块，模块的方法就成eigenclass类的实例方法，eigencalss的实例方法是MyClass2的实例方法，即类方法
  end

  def myclass_method1
    'myclass_method1'
  end
end
p MyClass2.method2
obj = MyClass2.new
class <<obj
  include MyMixin2 #在eigenclass中包含模块，模块的方法就成eigenclass类的实例方法，eigencalss的实例方法是obj对象的方法，即对象的单件方法
end
p obj.method2