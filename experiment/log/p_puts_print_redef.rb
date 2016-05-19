#将p,puts,print等方法重构
path = File.dirname(__FILE__)
file_path = path+"/testcase.txt"
file_obj = File.new(file_path, "w+")

#方法重构
=begin
alias old_puts puts
Kernel.send :define_method, :puts do |str|
  old_puts str
  file_obj.write(str<<"\n")
end

alias old_p p
Kernel.send :define_method, :p do |str|
  old_p str
  if str[-1]!~/\\n/
    file_obj.write(str<<"\n")
  end
end

alias old_print print
Kernel.send :define_method, :p do |str|
  old_print str
  if str[-1]!~/\\n/
    file_obj.write(str<<"\n")
  end
end
=end


# File.open(file_path, "w+") { |f|
#     STDOUT.reopen(f)
#   }
