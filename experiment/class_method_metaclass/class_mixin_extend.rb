####����һ
module MyMixin1
  #ģ��Ĺ��ӷ���
  def self.included(base)
    base.extend(ClassMethods1) #ֻ��չ�෽������չʵ������
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

#####������
module MyMixin2
  #ģ��Ĺ��ӷ���
  def self.included(base)
    base.extend(self) #�������ģ���еķ��������෽������ʵ������
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

#ģ���ģ�鷽�����ܱ�include��extendΪ��Ϊģ�鷽���൱����ģ���eigenclass����
#ֻ��ģ���ʵ���������ܱ�include��extend
p MyClass.test1_method_1 #�෽��
p MyClass.test2_method_1 #�෽��
# p MyClass.new.test1_method_1 #�޷�ִ��
# p MyClass.new.test2_method_1 #�޷�ִ��

# p MyClass::ClassMethods1.test1_method_1 #�޷�ִ��
# p MyClass::ClassMethods1.new.test1_method_1 #�޷�ִ��

p MyClass.new.test1_method_2 #ʵ������
p MyClass.test1_method_2 #�෽��

p MyClass.new.test2_method_2 #ʵ������
p MyClass.test2_method_2 #�෽��

p MyClass.new.test1_method_3 #ʵ������
# p MyClass.test3_method_3 #�෽��