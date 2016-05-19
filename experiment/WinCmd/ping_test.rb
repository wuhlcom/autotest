#encoding:utf-8
# class Ping_test
# end
# `ping 192.168.200.1 -t`


# cmd=nil
# while cmd !~/Y|y|N|n/
#   print "continue?(Y/N):"
#   cmd=STDIN.gets
#   cmd.chomp!
# end
# if cmd=~/Y|y/ then
#   puts "continue."
# else
#   puts "exit."
# end

# begin
#   cmd=nil
#   while cmd! ~/Y|y|N|n/
#     print "continue?(Y/N):"
#     cmd=STDIN.gets
#     cmd.chomp!
#   end
#   if cmd=~/Y|y/ then
#     puts "continue."
#   else
#     puts "exit."
#   end
# rescue Interrupt
#   puts "Programmeisinterrupted."
# end
# p "1111"
# exit
# p "2222"
rs = `ping 192.168.100.1`
p rs
str  = "找不到"
str2 = "无法访问目标网"
str3 = "无法访问目标主机"
print rs
rs_utf8 = rs.encode("utf-8")
rs_utf8 =~/\s*\((\d+)\%\s*/
result = true
 if (60<=Regexp.last_match(1).to_i)||rs_utf8=~/#{str}|#{str2}|#{str3}/
result = false
 end
p result