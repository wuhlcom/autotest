require "drb"
require "drb/observer"
class Counter
  include DRb::DRbObservable
  def run
    5.times do |count|
      changed
      notify_observers(count)
    end
  end
end
counter=Counter.new
# DRb.start_service("druby://localhost:9001",counter)
DRb.start_service("druby://192.168.10.75:8787",counter)
DRb.thread.join



