# require 'win32/process'
# p = fork{
# exec("ping www.baidu.com")
# }
# p = fork{
# exec("ping www.baidu.com")
# }
# pid = fork {
# 	# child
# 	sleep 3
# }
#
# th = Process.detach(pid)
# p th.value
#
p pid =  Process.spawn("ping www.baidu.com -t",STDOUT=>:out)
p Process.detach(pid)

