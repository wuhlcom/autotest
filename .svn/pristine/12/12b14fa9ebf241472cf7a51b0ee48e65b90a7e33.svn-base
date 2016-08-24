#encoding:utf-8
#不支持中文目录
#在uri的common.rb中正则表达式没有设置 /u选项，需要修改
require 'rubygems'
require 'net/http'
require 'uri'
require 'cgi'
file = "http://192.168.111.1:8080/usbshare/udisk/filetest/pycharm%5FTEST%2Ezip"
file = "http://192.168.111.1:8080/usbshare/udisk/filetest/RubyMineIDEcode%5FTEST%2Epng"
# file = "http://192.168.111.1:8080/usbshare/udisk/文件测试/pycharm%5FTEST%2Eexe".encode("GBK")
p file = CGI::unescape(file)
p filename = "RubyMineIDEcode_TEST.png"
p download_path = File.expand_path("../downloads", __FILE__)

def download(_url, _filename, _download_path = '')
	unless _download_path == ""
		unless File.exists?(_download_path)
			Dir.mkdir(_download_path)
		end
	end

	url = URI.parse _url
	p url
	p url.host
	p url.port
	p url.scheme
	p url.path
	http_object         = Net::HTTP.new(url.host, url.port)
	http_object.use_ssl = true if (url.scheme == 'https' || url.port == 443)

	http_object.start.request_get(url.path) do |response|
		start_time = Time.now
		response["Content-Disposition"] =~ /^.+?filename="(.+?)"$/
		file_name      = $1
		file_name      ||= _filename #如果response中找到不文件名就在这里指定文件名
		file_path_name = _download_path +"/"+file_name
		file           = open(file_path_name, 'wb')
		length         = response['Content-Length'].to_i
		response.read_body do |fragment|
			file.write(fragment)
		end
		file.close
		file_size = File.size(file_path_name)/1024.0/1024.0
		puts "-"*80
		puts "Download time:#{Time.now-start_time}"
		puts "Download speed:#{file_size/(Time.now-start_time)} MB/s"
		puts "-"*80
	end
end

download(file, filename, download_path)