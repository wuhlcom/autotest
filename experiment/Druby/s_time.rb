# ==== 服务端代码，保存为 timer_server.rb
#
require 'drb/drb'

# 监听的地址，你可以改为 0.0.0.0 来支持远程连接
# URI="druby://localhost:8787"
URI="druby://192.168.10.75:8787"

class TimeServer

  def get_current_time
    return Time.now
  end

end

# 被代理的对象，客户端获取的到的对象就是它
FRONT_OBJECT=TimeServer.new

DRb.start_service(URI, FRONT_OBJECT)
#
DRb.thread.join