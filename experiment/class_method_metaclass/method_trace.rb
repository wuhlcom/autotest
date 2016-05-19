class Object
  def trace!(*methods)
    @_traced||= [] #已经被跟踪的方法数组 <span></span>
    if methods.empty?
      methods = public_methods(false) #如果methods参数没有传，默认跟踪所有的public方法
    else
      methods &= public_methods(false) #如果传了methods参数，为了确保它是当前对象的方法，跟对象所有的public方法做交集
    end
    methods.map! &:to_sym#将数组每个值转换成symbol类型
    methods -= @_traced#去掉那些已经被跟踪的方法
    @_traced||= methods #将被跟踪的方法

    STDERR<< "Tracing: #{methods.join(', ')} on #{ObjectSpace._id2ref(object_id).inspect}\n"#输出跟踪的trace信息
    eigenclass = class<< self; self; end
    methods.each do|m|
      #重新定义跟踪的方法，里面加入跟踪信息，然后使用super调用原来的方法返回结果
      eigenclass.class_eval %Q{
        def #{m}(*args, &block)
          STDERR<< "Entering: #{m}(\#{args.join(', ')})\n"
          result = super
          STDERR<< "Exiting: #{m} with \#{result}\n"
          result
        rescue
          STDERR<< "Aborting: #{m}: \#{$!.class}: \#{$!.message}\n"
          raise
        end
      }
    end
  end
  def untrace!(*methods)
    if methods.size == 0
      methods = @_traced
    else
      methods.map! &:to_sym
      methods &= @_traced
    end
    STDERR<< "Untracing: #{methods.join(', ')} on #{ObjectSpace._id2ref(object_id).inspect}\n"
    @_traced-= methods

    (class<< self; self; end).class_eval do
      methods.each do|m|
        remove_method m #取消我们定义的跟踪方法
      end
    end
    remove_instance_variable(:@_traced) if @_traced.empty?
  end
end

str = "fxhover"
str = "testing"
str.trace!(:reverse, :split, :chop, :strip)
puts str.reverse
puts str.strip
str.untrace!(:strip)
puts str.strip