def proc_from
  Proc.new
end
proc = proc_from { "hello" }
# p proc.call   #=> "hello"

 # a = Proc.new{|x,y,z| x=y*z; puts x}
 # a.call(10,20,30)                                        #=>600
a = Proc.new{|x,y,z|x=y*z;puts x}
# a.call(1,2,3)

# def ftp_test(&a)
# 　#a.call            
  # yield             
# end
#test{puts "hello"}            #法一，传递一个块

# a = proc{puts "world"}
# ftp_test(&a)                       #法二，传递一个Proc对象

def test(&a)
a.call
yield
end
# ftp_test{puts "haoba"}

def test2()
  "11"
  yield
end
 test2{|x|
	  111
  }