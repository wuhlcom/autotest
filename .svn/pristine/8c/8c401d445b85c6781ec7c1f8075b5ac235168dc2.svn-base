# ==== timer_client.rb

require 'drb/drb'

# SERVER_URI="druby://localhost:8787"
SERVER_URI="druby://192.168.10.75:8787"

# 这句是必要的，因为我们很快会用到回调与引用，一会说。
# 所以纯粹的客户端是不存在的。
DRb.start_service
timeserver = DRbObject.new_with_uri(SERVER_URI)
puts timeserver.get_current_time