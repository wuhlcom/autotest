require 'thread'

N = 10

class MyMutex
  def initialize
    @mutex = Mutex.new
    @full  = ConditionVariable.new
    @empty = ConditionVariable.new
    @count = 0
  end

  def insert
    @mutex.synchronize do
      if @count == N
        puts "Hit the top line"
        @full.wait(@mutex)
      end
      @count += 1
      puts "Count value is #{@count}"
      if @count == 1
        @empty.signal
      end
    end
  end

  def remove
    @mutex.synchronize do
      if @count == 0
        puts "Hit the bottom line"
        @empty.wait(@mutex)
      end
      @count -= 1
      puts "Count value is #{@count}"
      if @count == N - 1
        @full.signal
      end
    end
  end
end

m = MyMutex.new

producer = Thread.start {
  while true
    m.insert
  end
}

consumer = Thread.start {
  while true
    m.remove
  end
}

producer.join
consumer.join