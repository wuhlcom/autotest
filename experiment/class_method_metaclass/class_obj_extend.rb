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
  extend MyMixin2 #����չ
  def myclass_method1
    'myclass_method1'
  end
end

p MyClass.method2
obj = MyClass.new
obj.extend MyMixin2 #������չ
p obj.method2
p "=="*80
class MyClass2
  class <<self
    include MyMixin2 #��eigenclass�а���ģ�飬ģ��ķ����ͳ�eigenclass���ʵ��������eigencalss��ʵ��������MyClass2��ʵ�����������෽��
  end

  def myclass_method1
    'myclass_method1'
  end
end
p MyClass2.method2
obj = MyClass2.new
class <<obj
  include MyMixin2 #��eigenclass�а���ģ�飬ģ��ķ����ͳ�eigenclass���ʵ��������eigencalss��ʵ��������obj����ķ�����������ĵ�������
end
p obj.method2