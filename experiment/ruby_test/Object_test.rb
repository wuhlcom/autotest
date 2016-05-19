require 'pp'
# #遍历现存对象
# ObjectSpace.each_object(Numeric){|x| p x}
def a
  __method__
end
# pp Object.methods().sort
# pp Kernel.methods().sort
pp Kernel.instance_methods().sort
# pp Object.instance_methods().sort

