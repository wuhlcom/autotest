#encoding:utf-8
# raise "中间"
raise RuntimeError, "中间".encode("GBK")
alias :orginal_raise :raise
Kernel.send :defin_method, :raise do |args|
  if args.kind_of?(String)
    args = args.to_gbk
    orginal_raise args
  else
    super
  end
end