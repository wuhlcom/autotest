#encoding:GBK
class Object
  def eigenclass
    class <<self
      self
    end
  end
end

class C
  def a_method
    "C#a_method"
  end

  class <<self

    def a_class_method
      'C#a_class_method'
    end

  end

end

class D<C;end
obj=D.new
puts obj.a_method

p "D可以直接使用C继承过来的类方法"
p D.a_class_method

class <<obj
  def a_singleton_method
    'Obj#a_singleton_method'
  end
end
p "对象obj的eigenclass的super是定义对象obj的类"
p obj.eigenclass.superclass
p "eigenclass.class返回是Class说明eigenclass是一个类而不是一个对象"
p obj.eigenclass.class
p C
p C.class
p C.eigenclass
p D
p D.eigenclass
p C.eigenclass.superclass
p D.eigenclass.superclass

