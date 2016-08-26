#encoding:utf-8
gem 'minitest'
require 'minitest/autorun'
file_path =File.expand_path('../../lib/iam', __FILE__)
require file_path
class MyTestString < MiniTest::Unit::TestCase
  # Called before every ftp_test method runs. Can be used
  # to set up fixture information.
  def setup
    @iam_obj = IAMAPI::IAM.new
    # Do nothing
  end

  # Called after every ftp_test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end

  def test_del
    url = "http://192.168.10.9:8082/apps?id=160517254512&admin_id=1&token=125e0d6b0cf379e4d51fbf47bdd9598c"
    p @iam_obj.http_del(url)
  end

  def test_post
    # curl -X POST http://192.168.10.9:8082/mobileCode/18676710461
    # curl -X POST "http://192.168.10.9/zlapi/index.php/Acdev/dologin" -d 'username=admin&password=123123'
    # url  = "http://192.168.10.9:8082/mobileCode/13544042762"
    url  = "http://192.168.10.9/zlapi/index.php/Acdev/dologin"
    data = "username=admin&password=123123"
    # curl -X POST http://192.168.10.9:8082/mobileCode/13823 652367
    url  = "http://192.168.10.9:8082/mobileCode/13823652367"
    path = "/mobileCode/138236 52367"
    data = "13823 652367"
    # p @iam_obj.post_data(url, data)
    ip   = "192.168.10.9"
    port = "8082"
    res  = Net::HTTP.start(ip, port) do |http|
      # http.request_post("/mobileCode/#{data}", "") { |response|
      #   # p response.status
      #   # p response['content-type']
      #   # p response
      #   p "11111111111111111111"
      #   p response.read_body
      #   # response.read_body do |str| # read body now
      #   #    print str
      #   # end
      p rs = http.send_request("POST", path)
      p rs.body
      # }

    end
      # p res.body
  end

  def test_phone_code
    phone = "13766668888"
    # phone = "18899856781"
    p @iam_obj.request_mobile_code(phone)
    p @iam_obj.get_mobile_code(phone)
  end

  def test_http_del
    # curl -X DELETE "http://192.168.10.9:8091/userApps?id=a7dff902-b80b-4cd7-9208-cdd856bddcd0&token=6442491a795e6bd5d700a81b24d336f4"
    # -d '{"client_id":"160510579648"}'
    usrid ="eb4bb4d2-e4c8-4a15-940f-91abb2ab418c"
    token = "1069fc73d8b7f269608d10981641f8dc"
    url   = "http://192.168.10.9:8082/userApps?id=#{usrid}&token=#{token}"
    data  = '{"client_id":"160801462660"}'
    # ha = {"client_id" => "160510579648"}
    # p @iam_obj.http_del(url, ha)
    p @iam_obj.http_del_data(url, data)
  end


  def test_nouri
    url = "http://192.168.10.9:8082/index.php/admins/index/uid/1/name/dengfei/token/34d5aeb4b075ef65f6aa156f202127e4"
    p host="192.168.10.9"
    p port= "8082"
    p path = "/index.php/admins/index/uid/1/name/牛B/token/9b88e94137f093148d20cb3fcedc6f6e"

    def uri(url)
      uri = URI(url)
    end

    p uri =uri(url)
    uri.hostname
    uri.port
    p Net::HTTP.get(uri)
    p Net::HTTP.get(host, path, port)
    # uri =uri(url)
    # res = Net::HTTP.start(uri.hostname, uri.port) do |http|
    #     http.get(uri, initheader, dest, &block)
    # end
    # res.body
  end

  def test_get
    # GET http://192.168.10.9:8092/index.php/admins/index/uid/1/name/dengfei/token/34d5aeb4b075ef65f6aa156f202127e4
    admin ="admin@zhilutec.com"
    pw    ="123123"
    rs    = @iam_obj.manager_login(admin, pw) #管理员登录->得到uid和token
    token = rs["token"]
    uid   = rs["uid"]
    name  = "zhilu123@@zhilutec.com"
    url   = "http://192.168.10.9:8082/index.php/admins/index/uid/#{uid}/name/#{name}/token/#{token}"
    p @iam_obj.get(url)
  end
  # Fake ftp_test
  # def test_fail
  #
  #   fail('Not implemented')
  # end

end