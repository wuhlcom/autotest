=begin
def event(name)
  puts "Event:#{name}" if yield
end

def setup()
  yield if block_given?
end

Dir.glob('*test_events*').each { |file|
  p file
  load file
}
=end
###############################################################################
=begin
def event(name, &block)
  @events[name]=block
end

def setup(&block)
  @setups<<block
end

Dir.glob('*test_events*').each { |file|
  @setups=[]
  @events={}
  load file
  @events.each_pair do |name, event|
    env=Object.new
    @setups.each do |setup|
      env.instance_eval &setup
    end
    puts "ALERT:#{name}" if env.instance_eval &event
  end
}
=end
##############################################################################################
#创建了一个共享作用域
#动态生成方法
lambda{
  events={}
  setups=[]
  Kernel.send :define_method,:event do |name,&block|
    events[name] = block
  end
  Kernel.send :define_method,:setup do |&block|
    setups << block
  end
  Kernel.send :define_method,:each_event do |&block|
    events.each_pair do |name,event|
      block.call name,event
    end
  end
  Kernel.send :define_method,:each_setup do |&block|
    setups.each do |setup|
      block.call setup
    end
  end
}.call

Dir.glob('*test_events.rb').each { |file|
  load file
  each_event do |name, event|
    env=Object.new
     each_setup do |setup|
       env.instance_eval &setup
     end
    puts "ALERT:#{name}" if env.instance_eval &event
  end
}