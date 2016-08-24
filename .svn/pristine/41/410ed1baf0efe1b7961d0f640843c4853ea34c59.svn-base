class ClassSuper
  attr_accessor :attr1
  def initialize
    @attr1 = "attr1"
  end
  private
  def privateMethod
    puts "this is private"
  end
  #protected = private which cannot be called directly
  protected
  def protectedMethod
    puts "this is protected"
  end

  public
  def super1
    protectedMethod
    privateMethod
  end

  def objsuper2 obj
    obj.protectedMethod
  end

  def objsuper3 obj
    obj.privateMethod
  end

end

class ClassChild < ClassSuper
  public
  def callProtected
    protectedMethod
  end

  def callPrivate
    privateMethod
  end

  def objProtected obj
    obj.protectedMethod
  end

  #this is invalid
  def objPrivate obj
    obj.privateMethod
  end
end

# “protected”和“private”之间的区别很微妙，
# 如果方法是保护的，它可以被定义了该方法的类或其子类的实例所调用。
# 如果方法是私有的，它只能在当前对象的上下文中被调用--不可能直接访问其他对象的私有方法，即便它与调用者都属同一个类的对象。
# Ruby和其他面向对象语言的差异，还体现在另一个重要的方面。访问控制实在程序运行时动态判定的，而非静态判定。
# 只有当代码试图执行受阻的方法，你才会得到一个访问违规。

b = ClassSuper.new
# b.protectedMethod #fail
# b.privateMethod   #fail
b.super1
b.objsuper2 b #protect可以在类的其它实例方法中以obj.protect方式调用，也就是相当于在类的内部的其它方法中可以调用obj.protect
# b.objsuper3 b #fail
p "======================="
a = ClassChild.new
puts a.attr1
a.callProtected
a.callPrivate #private method is also inherited
# a.privateMethod #fail 子类也不能直接调用父类的private
# a.protectedMethod #fail 子类也不能直接调用父类的protect

a.objProtected a
#a.objPrivate a #this is the difference between protected and private

# 总结一下，Ruby的不同之处在于：
# 1. 父类的的private和protected都可以被子类所继承
# 2. protected和private一样不能被显式调用
# 3. protected和private的区别是protected可以在类的其他方法中以实例形式调用(如: obj.protectedMethod)，而private不行

module Test
  class MyClass
    def prot()
      puts "prot"
    end

    def call_prot(obj)
      obj.prot
    end
    protected :prot
  end
end
p "protect ftp_test"
# include T
tobj=Test::MyClass.new
tobj1=Test::MyClass.new
tobj.call_prot(tobj1)
class MyClass2<Test::MyClass

end
MyClass2.new
