p file_path =File.expand_path('../../lib/htmltags', __FILE__)
require file_path
# include HtmlTag::TestHttpClient
p HtmlTag::TestHttpClient.new("192.168.0.57","/","80").get
# p HtmlTag::TestHttpClient.new("10.10.10.57").get