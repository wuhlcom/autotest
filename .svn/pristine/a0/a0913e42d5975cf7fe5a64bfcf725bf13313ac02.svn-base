#encoding:utf-8
#Ruby文件操作代码示例如下 ：

#2.rb;在同一级目录建立E:/Automation/ruby_test/filecompare/rt2880_settings.dat的文件，输入一些内容

file=File.open("E:/Automation/ruby_test/filecompare/rt2880_settings.dat", "r") #file=File.open("F:\\ruby\\rb\\E:/Automation/ruby_test/filecompare/rt2880_settings.dat","r")绝对路径下
file.each_line do |line|
	puts line.encode("GBK")
end


# another logic

File.open("E:/Automation/ruby_test/filecompare/rt2880_settings.dat", "r") do |file|
	while line=file.gets
		puts file.lineno
		puts line
	end
end
=begin
# the third logic ,the code is copied from someone else ...

IO.foreach("E:/Automation/ruby_test/filecompare/rt2880_settings.dat") do |line|
#puts line if line =~/target/ 
	puts line if line !~/target/
end

#count the number of a file ,the bytes and lines

arr  =IO.read("E:/Automation/ruby_test/filecompare/rt2880_settings.dat")
bytes=arr.size
puts "the byte size is #{bytes}"
arrl  =IO.readlines("E:/Automation/ruby_test/filecompare/rt2880_settings.dat")
lines = arrl.size
puts "the lines number is #{lines}"

#show the file's path

puts File.expand_path("E:/Automation/ruby_test/filecompare/rt2880_settings.dat")

#count chars from a file


file    = File.new("E:/Automation/ruby_test/filecompare/rt2880_settings.dat")
w_count = 0
file.each_byte do |byte|
	w_count += 1 if byte ==?1

end
puts "#{w_count}"


#create new file and write some words there

file= File.new("E:/Automation/ruby_test/filecompare/file2.txt", "w")

puts File.exist?("E:/Automation/ruby_test/filecompare/file2.txt") #judge the file is exist or not
file.write("hehe\nhahah")

#io.stream operation

require 'stringio'

ios = StringIO.new("abcdef\n ABC \n 12345")
ios.seek(5)
ios.puts("xyz3")
puts ios.tell

puts ios.string.dump

#the result is 10,insert xyz3 at the 5th byte


#another example

require 'stringio'

ios = StringIO.new("abcdef\n ABC \n 12345")
ios.seek(3)
ios.ungetc(?w) #replace the char at index 3

puts "Ptr = #{ios.tell}"
s1 = ios.gets #filte the "\n" 
s2 = ios.gets
puts s1
puts s2
=end