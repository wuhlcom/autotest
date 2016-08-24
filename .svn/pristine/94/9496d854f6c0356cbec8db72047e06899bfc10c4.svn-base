# $stdout.sync=true
# $stderr.sync=true
 path = File.dirname(__FILE__)
 file_path = path+"/output_test.txt"
# file_path2 = path+"/output_test2.txt"
if !(File.exists?(file_path))
  file_obj = File.open(file_path, "w+")
end
# p $stdout
# p $stderr
# class Report
#   $log_path=nil
#   def initialize(file_path)
#     $log_path = File.new(file_path, 'a')
#   end
#   # class <<$stdout
#   #   def write(str)
#   #     if !$log_path.nil?
#   #       $log_path.write(str)
#   #       $log_path.flush
#   #     end
#   #     super
#   #   end
#   # end
#    class <<$stderr
#      def write(str)
#        if !$log_path.nil?
#          $log_path.write(str)
#          $log_path.flush
#        end
#        super
#      end
#    end
# end

#########################
#将全局变量设置为文件对象就p print等输出就在重定向到这个文件中
# $stdout = File.open(file_path, "w+")
# p "111"
# p "2222"
#######################################
# f1 = File.new(file_path)
# f2 = File.new(file_path)
# p f2.readlines[0]   #=> "This is line one\n"
# p f2.reopen(f1)     #=> #<File:testfile>
# p f2.readlines[0]   #=> "This is line one\n"
#######################################################
#reopen会把输出，输出到文件f
# File.open(file_path, "w+") { |f|
#    STDOUT.reopen(f)
#  }
#  p "hihi"

#reopen会把输出，输出到文件f
 # File.open(file_path, "a") { |f|
 #    STDERR.reopen(f)
 #  }
  # p "hihi"

##################################################
#调用方法，这个方法名就成了参数
# send(:t,"aaa")
#动态定义方法，方法名成了参数，并能参数生成方法
# define_method :t2 do |param|
# end
#重新定义p方法保持打印的同时还会保存一份到文件
# module Kernel
#   path = File.dirname(__FILE__)
#   file_path = path+"/output_test.txt"
#   alias new_p p
#   file_obj = File.new(file_path, "w+")
#   define_method :p do |str|
#     new_p str
#     file_obj.write(str)
#   end
# end

#动态生成p方法保持打印的同时还会保存一份到文件
# alias old_p p
file_obj = File.new(file_path, "w+")
# lambda {
# Kernel.send :define_method, :p do |str|
#   old_p str
#   if str[-1]!~/\\n/
#     file_obj.write(str<<"\n")
#   end
# end
# alias old_puts puts
# Kernel.send :define_method, :puts do |str|
#   old_puts str
#   # if str[-1]!~/\\n/
#   file_obj.write(str<<"\n")
#   # end
# end
# }.call
# p "3322222"
# class Test
#   def self.test1
#     "xxxxxxxxxxxxxxxxx"
#   end
#   # p test1
# end
# puts "hahaha"
# p "tttttttttttttttttttttttttttttttttttttt"
#############################################################
# def redirect_stdout_to(filename)
#   out_save=STDOUT.dup
#   begin
#     File.open(filename, "w+") { |f|
#       STDOUT.reopen(f)
#     }
#     yield if block_given?
#   ensure
#     STDOUT.reopen(out_save)
#     out_save.close
#   end
# end

# redirect_stdout_to(file_path2) {
#   p "111111111"
# }
# p "111"
#####################################################################################
# p IO.new(2,'w')
# p STDOUT.flush
# p STDOUT.class
# STDOUT.write
# STDOUT.read
# require 'pp'
# Report.new(file_path)
# p $stdout
# p $stderr
# p $log_path

# class <<$stderr
#   def write(str)
#     if !$log_path.nil?
#       $log_path.write(str)
#       $log_path.flush
#     end
#     super
#   end
# end
file_path = path+"/output_test.txt"

if !(File.exists?(file_path))
  file_obj = File.open(file_path, "w")
end
file_obj = File.open(file_path, "a")
# class Report
#   $log_path=nil
#   def initialize(file_path)
#     $log_path = File.new(file_path, 'a')
#   end
#
#   # class <<$stdout
#   #    def write(str)
#   #      if !$log_path.nil?
#   #        $log_path.write(str)
#   #        # $log_path.flush
#   #      end
#   #      super
#   #    end
#   # end
#
#   class <<$stderr
#     def write(str)
#       super
#       if !$log_path.nil?
#         # print str
#         $log_path.write(str)
#         $log_path.flush
#       end
#       # super
#     end
#   end
# end

# class Serror
#   def write(str)
#     print str
#     File.open("e:/err.txt",'a') do |file|
#       file.puts(str)
#     end
#   end
# end
require 'pp'
module EXT_STDOUT
  def write(str)
    if !$log_path.nil?
      $log_path.write(str)
      # $log_path.write("\n")
      $log_path.flush
    end
    super
  end
end

# module EXT_STDERR
#
#   # def write(str)
#   #   print str
#   #   if !$log_path.nil?
#   #     $log_path.write(str)
#   #     $log_path.flush
#   #   end
#   # end
#
#   def write(str)
#     print str
#     print "\n"
#     File.open($log_path,'a') do |file|
#       file.puts(str)
#     end
#     super(str)
#   end
#
# end
#
class EXT_STDERR
    def write(str)
       print str
       # print "\n"
      File.open($file_path,'a') do |file|
        file.puts(str)
      end
      # super(str)
    end

  end
$file_path=file_path
$log_path = file_obj
$stdout.extend EXT_STDOUT
# $stderr.extend EX_STDERR
$stderr= EXT_STDERR.new
# def $stderr.write(str)
#   print str
#   print "\n"
#   # File.open($log_path,'a') do |file|
#   #   file.puts(str)
#   # end
#   $log_path.puts(str)
#   super(str)
# end

# $log_path.close
# $stderr= Err.new
# $log_path.close
# $stderr = Serror.new

# Report.new(file_path)
require 'pp'
# pp $stderr.methods.sort
p "dddddd"
p "dddddddddddd"
p "dudu1111111111111111111111"
print "ddddddddddddd"
puts "dddddddddddddddddddddd"
no_method



