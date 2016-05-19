class Object
  def trace!(*methods)
    @_traced||= [] #�Ѿ������ٵķ������� <span></span>
    if methods.empty?
      methods = public_methods(false) #���methods����û�д���Ĭ�ϸ������е�public����
    else
      methods &= public_methods(false) #�������methods������Ϊ��ȷ�����ǵ�ǰ����ķ��������������е�public����������
    end
    methods.map! &:to_sym#������ÿ��ֵת����symbol����
    methods -= @_traced#ȥ����Щ�Ѿ������ٵķ���
    @_traced||= methods #�������ٵķ���

    STDERR<< "Tracing: #{methods.join(', ')} on #{ObjectSpace._id2ref(object_id).inspect}\n"#������ٵ�trace��Ϣ
    eigenclass = class<< self; self; end
    methods.each do|m|
      #���¶�����ٵķ�����������������Ϣ��Ȼ��ʹ��super����ԭ���ķ������ؽ��
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
        remove_method m #ȡ�����Ƕ���ĸ��ٷ���
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