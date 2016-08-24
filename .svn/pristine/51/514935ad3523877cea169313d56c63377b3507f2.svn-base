#encoding:utf-8
require 'timeout'
# s = Timeout::timeout(5, "超时了") {
# 	 # Time.now.strftime("%Y-%m-%d %H:%M:%S")
# 		# sleep
# 		i =1
# 		while true
# 				sleep 1
# 				p i+=1
# 				break if i == 10
# 		end
# 		p "tttt"
# }
begin
s = Timeout::timeout(5) {
		i =1
		while true
				sleep 1
				p i+=1
				break if i == 10
		end
}
rescue =>ex
p ex.message
		end

# print ["aaa", "中间"].join("\n").encode("GBK")
# p File.size(__FILE__)