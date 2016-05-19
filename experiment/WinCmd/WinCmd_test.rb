# encoding:GBK
require 'rubygems'
# str = `ping 192.168.200.1`
# p str.encoding
p str="(0% 丢失)"
str=~/\((\d+)\%\s*丢失\s*\)/
p $1
 print str