#encoding:utf-8
# convert chinese
# author : wuhongliang
# date   : 2015-6-05
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