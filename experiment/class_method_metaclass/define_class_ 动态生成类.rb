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

#t3�Ƕ�̬����-ʵ������
#t3����ʵ����������������t2�����ĵ���,
#���self.t2δ������t3�����ǲ��ɼ��ģ���ʱʵ������aҲ�޷�����t3����
#����������ϵ����Ӧ�õ�������˳�������
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