# ¿Í»§¶Ë³ÌÐò
require "drb"
class Listener
  include DRbUndumped
  def update(value)
    puts value
  end
end
DRb.start_service
# counter=DRbObject.new(nil, "druby://localhost:9001")
counter=DRbObject.new(nil, "druby://192.168.10.79:8787")
listener=Listener.new
counter.add_observer(listener)
counter.run