#encoding: utf-8
$ec1 = Encoding::Converter.new("GBK", "UTF-8", :universal_newline => true)
$ec2 = Encoding::Converter.new("UTF-8", "GBK", :universal_newline => true)
class String

  def to_utf8
    $ec1.convert self rescue self
  end

  def to_gbk
    $ec2.convert self rescue self
  end

end
str = "你乱不1"
# str = "defd "
puts str
puts str.encoding
puts "ppppppppppppppppppp"
str = "你乱不1"
p str
p str.encoding
p str=str.to_utf8
puts "=============================="
str = "你乱不2"
puts str
puts str.encoding
# puts str.encode "GBK"
puts str=str.to_gbk
puts str.encoding
puts "ppppppppppppppppppp"
str = "你乱不2"
p str
p str.encoding
# p str.encode "GBK"
p str=str.to_gbk
p str.encoding
p self.to_s
