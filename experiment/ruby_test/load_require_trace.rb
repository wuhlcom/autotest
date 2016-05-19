#encoding: utf-8
module ClassTrace
  T= [] #定义数组常量T，存放trace信息
  if x = ARGV.index("--traceout") #如果ruby命令后面有--traceout参数，则记录到文件中，否则输出
    OUT= File.open(ARGV[x + 1], 'w')
    ARGV[x, 2] = nil
  else
    OUT= STDERR
  end
end

alias origin_require require #给require定义别名方法origin_require，下面要重新定义
alias origin_load load #给load方法定义别名方法origin_load，下面要重新定义load方法

def require(file)
  ClassTrace::T<< [file, caller[0]] #将require方式加载的文件和加载该文件的位置放入一个数组，并添加到T常量中
  origin_require(file) #require加载文件
end

def load(*args)
  ClassTrace::T<< [args[0], caller[0]] #将load方式加载的文件和加载该文件的位置放入一个数组
  origin_load(*args) #load加载文件
end

def Object.inherited(c) #定义钩子方法inherited方法，当有新的类定义时调用此方法将类名和定义的位置加入到T常量
  ClassTrace::T<< [c, caller[0]]
end

at_exit {#当程序退出执行时
  o = ClassTrace::OUT
  o.puts '='* 60
  o.puts 'Files Loaded and Classes Defined:'
  o.puts '='* 60
  ClassTrace::T.each do |what, where| #遍历trace信息数组T，将信息写入到文件或输出
    if what.is_a? Class
      o.puts "Defined: #{what.ancestors.join('<-')} at #{where}"
    else
      o.puts "Loaded: #{what} at #{where}"
    end
  end
}