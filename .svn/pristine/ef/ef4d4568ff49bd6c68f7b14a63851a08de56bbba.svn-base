#encoding:utf-8
require 'net/http'
require 'uri'
require 'nokogiri'
# s =  Net::HTTP.get('www.baidu.com', '/index.html') # => String
# p s = Net::HTTP.get('10.10.10.', '/', "80") # => String
# print s.encode("GBK",{:invalid => :replace, :undef => :replace, :replace => '?'})

# require 'open-uri'
#  open("http://locahost:8082/"){|f|
#  print	f.read
#  }

url      = "http://192.168.10.9"
port     = 8092
content  = "userid.txt"
uri_addr = "#{url}:#{port}/#{content}"
uri      = URI(uri_addr)
# p Net::HTTP.get(uri) # => String
#############################################################################################################################
# url      = "http://192.168.10.9"
# port     = 8092
# content  = "/index.php/Oauth/authorize"
# uri_addr = "#{url}:#{port}/#{content}"
# uri      = URI(uri_addr)
# req      = Net::HTTP::Post.new(uri)
# req.set_form_data('from' => '2005-01-01', 'to' => '2005-03-31')
# res = Net::HTTP.start(uri.hostname, uri.port) do |http|
# http.request(req)
# res = Net::HTTP.post_form(uri, params)
# end
# print res.header
# print res.body
# case res
#     when Net::HTTPSuccess, Net::HTTPRedirection
#         # OK
#     else
#         res.value
# end

# print res.body
# res = Net::HTTP.post_form(uri, params)
#返回的cookie
# puts res.header['set-cookie']
#返回的html body
# puts res.body
# http.post_form
#############################################################################################################################
# curl http://192.168.10.9:8092/index.php/Oauth/authorize -d "username=18986681621&encrypt_pwd=9b44e764fb94a12bd799b761ea7db865cb4ab6cbce9a72c8251fcdfcbbe626d7a9fc02a50f124ae3f133ad9aaf4455884f0462b20cd251ebd09298dc1920305a3ed90a242813bd4f8a6c55f9d65072ed6eac723292d6327b9fa0f907ce735d1fbe6ea919010b504b5111ec962cf63299a660a4febdafa9856a7c55c6b70604fe&redirect_uri=http://192.168.10.9/oauthcli/index.php/Login/index&secret=qItiMyKZJtJcggm9YSnqwhMj8li8hJe7&response_type=code&client_id=160518183738"
# curl http://192.168.10.9:8082/index.php/Oauth/authorize -d "username=13760281579&encrypt_pwd=9c76736d8a993299e155c797861d14ef7cd3507c900527e11da5d3357872ba9fb9e2db9511fe2bfafe7a6d4c6f8efdac40425414639e4815069c380c86ef4a7dd121e7db0418919a3ca8de77d745269ad19ea117154411df35f840eb1af5e82383c2d6dc627b3654f15596959e1643707995e9ef3db2847c0ca60de50ac43fc0&redirect_uri=http://192.168.10.9/oauthcli/index.php/Login/index&secret=LIC1qOwYqA4SuCssn5ssQUnUqT4OEa6Q&response_type=code&client_id=160720365321"
url      = "http://192.168.10.9"
port     = 8092
content  = "index.php/Oauth/authorize"
uri_addr = "#{url}:#{port}/#{content}"
str      = "username=18986681621\
&encrypt_pwd=9b44e764fb94a12bd799b761ea7db865cb4ab6cbce9a72c8251fcdfcbbe626d7a9fc02a50f124ae3f133ad9aaf4455884f0462b20cd251ebd09298dc1920305a3ed90a242813bd4f8a6c55f9d65072ed6eac723292d6327b9fa0f907ce735d1fbe6ea919010b504b5111ec962cf63299a660a4febdafa9856a7c55c6b70604fe\
&redirect_uri=http://192.168.10.9/oauthcli/index.php/Login/index\
&secret=qItiMyKZJtJcggm9YSnqwhMj8li8hJe7\
&response_type=code\
&client_id=160518183738"
uri      = URI.parse(uri_addr)
# res      = Net::HTTP.start(uri.hostname, uri.port) do |http|
#     http.request_post(uri, str)
#     # http.request_post(uri, str) { |response|
#     #     response['content-type']
#     #     p response.code_type
#     #     response.read_body do |str| # read body now
#     #         str
#     #     end
#     # }
# end
# # print res.body
# doc      = Nokogiri::HTML(res.body)
# doc.css("form input").each do |input|
#     # p input.attribute_nodes
#     # p input.attributes
#     # 属性
#     # {"type"=>#<Nokogiri::XML::Attr:0x17d4320 name="type" value="hidden">, "name"=>#<Nokogiri::XML::Attr:0x17d42f8 name="name" value="user_id">, "value"=>#<Nokogiri::XML::Attr:0x17d42e4 name="value" value="bf560602-4e33-46cd-b6b0-19200dc46721">}
#     # input.each { |i| p i }
#     name_attr = input.attributes["name"]
#     next if name_attr.nil?
#     name_cont = name_attr.content
#     if name_cont=="user_id"
#         p input.attributes["value"].content
#     end
#     # attr_name = input[].attr("[name='user_id']")
#     # if !attr_name.nil?&&attr_name=="client_id"
#     #     p input.attributes["value"].content
#     # end
# end
# doc = Nokogiri.Slop(res.body)
# doc.form.input("[name='user_id']").content




