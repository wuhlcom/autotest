module TM
	R1 = "1"
	def meth1
    R1
  end
end

class M2
  include TM
end

require 'pp'
M2.new.meth1
# pp Class.instance_methods.sort
p Class.class
p Object.class
p Module.class
p Array.class
p M2.class
p TM.class
p TM.class.class
p "="*30
p Object.superclass
p Class.superclass
p Module.superclass
p "="*30
p Array.superclass
p Array.superclass.superclass
p Array.superclass.superclass.superclass