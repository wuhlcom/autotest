#encoding:utf-8
#iam api,pub http socket
#author:wuhongliang
#date:2016-07-21
module IAMAPI
    module PubSocket
        # url      = "http://192.168.10.9:8082/userid.txt"
        #url不能有中文，首尾不能有空格
        def uri(url)
            uri = URI(url)
        end

        #http get
        #get userid
        # url="http://192.168.10.9:8082/userid.txt
        #get code
        # url="http://192.168.10.9:8082/code.txt
        #HTTP.get(uri_or_host, path = nil, port = nil)
        # print Net::HTTP.get('www.example.com', '/index.html')
        # print Net::HTTP.get(URI('http://www.example.com/index.html'))
        # (+uri+), or as (+host+, +path+, +port+ = 80)
        def get(url, path=nil, port=nil)
            if !path.nil?||!port.nil?
                Net::HTTP.get(url, path, port) # => String
            else
                uri =uri(url)
                Net::HTTP.get(uri) # => String
            end
        end

        #http delete
        def http_del(path, initheader = {'Depth' => 'Infinity'})
            uri =uri(path)
            res = Net::HTTP.start(uri.hostname, uri.port) do |http|
                http.delete(path, initheader) # => String
            end
            res.body
        end

        #=================================
        # http.request_post(uri, data)
        #=============================
        # http.request_post(uri, str) { |response|
        #     response['content-type']
        #     p response.code_type
        #     response.read_body do |str| # read body now
        #         str
        #     end
        # }
        #=================================
        #
        #http post
        # request_post(path, data, initheader = nil, &block)
        def post_data(url, data, initheader = nil, &block)
            uri =uri(url)
            res = Net::HTTP.start(uri.hostname, uri.port) do |http|
                http.request_post(uri, data, initheader, &block)
            end
            res.body
        end

        #http put
        #request_put(path, data, initheader = nil, &block)
        def http_put(url, data, initheader = nil, &block)
            uri =uri(url)
            res = Net::HTTP.start(uri.hostname, uri.port) do |http|
                http.request_put(uri, data, initheader, &block)
            end
            res.body
        end

        # request_get(path, initheader = nil, &block)
        def http_request_get(url, initheader = nil, &block)
            uri =uri(url)
            res = Net::HTTP.start(uri.hostname, uri.port) do |http|
                http.request_get(uri, initheader, &block)
            end
            res.body
        end

        # get(path, initheader = nil, dest = nil, &block)
        def http_get(url, initheader = nil, dest = nil, &block)
            uri =uri(url)
            res = Net::HTTP.start(uri.hostname, uri.port) do |http|
                http.get(uri, initheader, dest, &block)
            end
            res.body
        end

        def doc(html)
            doc = Nokogiri::HTML(html)
        end

        #curl -X POST http://192.168.10.9:8082/mobileCode/18676710461
        #向服务器请求生成验证码
        #return,hash,{"mobile"=>"13766668888", "code"=>5649, "create_time"=>1469783447}
        def request_mobile_code(phone)
            data =""
            url  = MOBILECODE_URL+phone
            rs   = post_data(url, data)
            JSON.parse(rs)
        end

        # curl -X get http://192.168.10.9:8082/mobileCode/18676710461
        # 获取生成的验证码（可能是过期的）
        #return,hash,{"mobile"=>"13766668888", "code"=>5649, "create_time"=>1469783447}
        def get_mobile_code(phone)
            url = MOBILECODE_URL+phone
            rs  = get(url)
            JSON.parse(rs)
        end

    end
end