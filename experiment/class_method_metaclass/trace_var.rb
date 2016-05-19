#全局变量赋值跟踪
trace_var :$_,proc{|v| puts v}
$_="hello"