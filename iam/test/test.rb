#encoding:utf-8
module Test1
    def a
        "a"
    end
end
module APP
    NODE="nn"
    module Test2
        include Test1

        def b(x=NODE)
            x
        end
    end
end

#  include APP::Test2
# # p a
# # p "zhilu_123456789012345678@126.com".size
# arr = ["a"]
# arr.push "b","c"
# p arr

# 电信号段:133/153/180/181/189/177；
# 联通号段:130/131/132/155/156/185/186/145/176；
# 移动号段：134/135/136/137/138/139/150/151/152/157/158/159/182/183/184/187/188/147/178
# 130-139  #180-189 # 150-153 155-159
# phone_nums=[]
# 10.times do |num|
#     phone_nums.push "13#{num}66668888"
#     phone_nums.push "18#{num}66668888"
#     phone_nums.push "15#{num}66668888" unless num == "4"
# end
# phone_nums.push "145","147","176","177","178"
# p phone_nums.sort!
#
# comment1     = "经常练习，学习才能进步"*9
# comment2     = "~!@#$%^&*()_+{}|\":?><-=[];'\\.,/'"
# comment3     = "abdefghijklmnopqrstuvwxyz"
# comment=comment1+comment2+comment3+comment1
# p comment.size
# s = "aa,'123'"
# r = /aa,'.*'/.match(s)
# p r
# p r[0]
# summary=0;32.times{|money|summary+=2**money}
# p summary