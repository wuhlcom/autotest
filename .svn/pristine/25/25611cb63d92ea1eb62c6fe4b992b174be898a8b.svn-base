=begin
# sample → obj click to toggle source
# sample(random: rng) → obj
# sample(n) → new_ary
# sample(n, random: rng) → new_ary
p "sample"
p [1,2,4,5,6,9].sample
p [1,2,4,5,6,9].sample(random:1)
p [1,2,4,5,6,9].sample(3,random:5)
p [1,2,4,5,6,9].sample(2)
p [1,2,4,5,6,9].sample(10)
p "rotate"
#改变首元素
a = [ "a", "b", "c", "qos" ]
p a.rotate         #=> ["b", "c", "qos", "a"]
p a                #=> ["a", "b", "c", "qos"]
p a.rotate(2)      #=> ["c", "qos", "a", "b"]
p a.rotate(-3)     #=> ["b", "c", "qos", "a"]
####
a = [ "a", "b", "c", "qos", "e" ]
a.replace([ "x", "y", "z" ])   #=> ["x", "y", "z"]
a                              #=> ["x", "y", "z"]
####
a = [1, 2, 3]
a.repeated_combination(1).to_a  #=> [[1], [2], [3]]
a.repeated_combination(2).to_a  #=> [[1,1],[1,2],[1,3],[2,2],[2,3],[3,3]]
a.repeated_combination(3).to_a  #=> [[1,1,1],[1,1,2],[1,1,3],[1,2,2],[1,2,3],
#    [1,3,3],[2,2,2],[2,2,3],[2,3,3],[3,3,3]]
a.repeated_combination(4).to_a  #=> [[1,1,1,1],[1,1,1,2],[1,1,1,3],[1,1,2,2],[1,1,2,3],
#    [1,1,3,3],[1,2,2,2],[1,2,2,3],[1,2,3,3],[1,3,3,3],
#    [2,2,2,2],[2,2,2,3],[2,2,3,3],[2,3,3,3],[3,3,3,3]]
a.repeated_combination(0).to_a  #=> [[]] # one combination of length 0

####
[1,2,3].product([4,5])     #=> [[1,4],[1,5],[2,4],[2,5],[3,4],[3,5]]
[1,2].product([1,2])       #=> [[1,1],[1,2],[2,1],[2,2]]
[1,2].product([3,4],[5,6]) #=> [[1,3,5],[1,3,6],[1,4,5],[1,4,6],
#     [2,3,5],[2,3,6],[2,4,5],[2,4,6]]
[1,2].product()            #=> [[1],[2]]
[1,2].product([])          #=> []
###
a = [1, 2, 3]
a.permutation.to_a     #=> [[1,2,3],[1,3,2],[2,1,3],[2,3,1],[3,1,2],[3,2,1]]
a.permutation(1).to_a  #=> [[1],[2],[3]]
a.permutation(2).to_a  #=> [[1,2],[1,3],[2,1],[2,3],[3,1],[3,2]]
a.permutation(3).to_a  #=> [[1,2,3],[1,3,2],[2,1,3],[2,3,1],[3,1,2],[3,2,1]]
a.permutation(0).to_a  #=> [[]] # one permutation of length 0
a.permutation(4).to_a  #=> []   # no permutations of length 4
############################
a = ["a", "b", "c"]
# a.cycle {|x| puts x }  # print, a, b, c, a, b, c,.. forever.
a.cycle(2) {|x| puts x }  # print, a, b, c, a, b, c.
#####################################################
a = [ 4, 5, 6 ]
b = [ 7, 8, 9 ]
[1,2,3].zip(a, b)      #=> [[1, 4, 7], [2, 5, 8], [3, 6, 9]]
[1,2].zip(a,b)         #=> [[1, 4, 7], [2, 5, 8]]
a.zip([1,2],[8])       #=> [[4,1,8], [5,2,nil], [6,nil,nil]]
p "222222222222222222222222222222222222222222222"
##############################
p 1  ? "struct" : "2"
=end
# a = [6,7,8,9]
# size = a.size
# a.each_index{|e|
# 	p a[size-e-1]
# 	break if  a[size-e-1]==8
# }
# i=0
# while i<10
# 	a.each_index{|index| p index}
# 	p "=#{i}"*20
# 	i +=1
# end
# steps    = "1111\n2222\n"
# steps    = steps.split("\n")
# step_info=""
# steps.each { |step|
# 	step_info += "operate('#{step}') {
#
# }\n\n" }
# p step_info
# File.open("operate.rb", "w") { |f|
# 	f.puts step_info
# }

arr = ["tcp dpt:10001 to:192.168.100.100:10001",
 "udp dpt:10001 to:192.168.100.100:10001",
 "tcp dpt:10002 to:192.168.100.100:10002",
 "udp dpt:10002 to:192.168.100.100:10002",
 "tcp dpt:10003 to:192.168.100.100:10003",
 "udp dpt:10003 to:192.168.100.100:10003",
 "tcp dpt:10004 to:192.168.100.100:10004",
 "udp dpt:10004 to:192.168.100.100:10004",
 "tcp dpt:10005 to:192.168.100.100:10005",
 "udp dpt:10005 to:192.168.100.100:10005"]
arr1 =[1,2,3]
# p arr1.max
a,b=[[1],[2]]
p a
p b
