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
    url  = "http://192.168.10.9:8082/mobileCode/13544042762"
    data = ""
    p @iam_obj.post_data(url, data)
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
  # Fake ftp_test
  # def test_fail
  #
  #   fail('Not implemented')
  # end

end