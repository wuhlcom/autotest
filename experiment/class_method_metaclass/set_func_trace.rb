class Test
  def t1
  end
end

set_trace_func proc{|event,file,line,id,binding,classname|
printf( "%8s===%s:%-2d===%10s===%8s===%s\n",event,file,line,id,binding,classname)
}
# t=Test.new
