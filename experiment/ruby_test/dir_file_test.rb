#encoding:utf-8
class Float
		def roundf(places)
				size = self.to_s.size
				sprintf("%#{size}.#{places}f", self).to_f
		end

		def round_n(nth)
				num = self*(10**(-nth))
				return num.round*(10**nth).to_f
		end
end
# require 'pp'
# pp Dir.glob("*/*") #当前目录下的子目录下的文件
# p "="*50
# pp Dir.glob("**/*") #当前目录下的所有文件和目录
# p "+"*50
# pp Dir.glob("**/") #当目前目录下的所有子目录
# p "-"*50
# pp Dir.glob("**")
# p Dir.glob("**/*")
# Dir.glob("**/*").each do |f|
#   p File.basename(f,'.*') #去文件后缀名
# end

require 'fileutils'
# currnet_path=File.dirname(File.expand_path(__FILE__))
# dirtest_path=currnet_path+"/dirtest"
#  unless File.exist?(dirtest_path)
#  	Dir.mkdir(dirtest_path)
#  end
# #删除当前目录下的子目录和文件，不包含当前目录
# p f = Dir.glob(dirtest_path+"/*")
# FileUtils.rm_rf(f,:verbose=>true) if File.exist?(dirtest_path)

#
# # p files = Dir.glob("#{dirtest_path}/**/**")
# #  p FileUtils.rm_rf(files)
# # p [1,2].map(&:to_s)
# # p [1,2].any?(&:to_s)
# # dir = 'E:\Automation\frame\downloads'
# p dir ='E:\文件测试'.encode("GBK")
# p dir ="E:\\文件测试".encode("GBK")
# p dir.gsub!("\\", "/")
# p dir.gsub!("/","\\\\")
# p dir.gsub!("\\","/")
# files= Dir.glob("#{dir}/**/*")
# # print files.join("\n").encode("GBK")
# files.each do |file|
# 	next if file !~ /.*\.zip$/
# 	p file.encode("GBK")
# 	p file_size =File.size(file)
# 	p num=file_size/1024.00/1024.00
# 	p num.roundf(2)
# end
#
# @ts_ftp_srv_file   = "QOS_TEST2.zip"
# @ts_ftp_download   = "D:/ftpdownloads/#{@ts_ftp_srv_file}"
# #下载前先删除已经存在的文件
# p file_dir = File.dirname(@ts_ftp_download)
# #如果目录不存在则创建目录
# FileUtils.mkdir_p(file_dir) unless File.exists?(file_dir)
# p file_name = File.basename(@ts_ftp_srv_file, ".*")
# Dir.glob("#{file_dir}/*") { |filename|
# 	filename=~/#{file_name}/ && FileUtils.rm_f(filename) #rm_rf要慎用
# # }
# p __FILE__
#  File.dirname(__FILE__)
# # p File.expand_path("../../../bin", File.dirname(__FILE__))
# p File.expand_path("../../bin", File.dirname(__FILE__))
# p File.expand_path(".../bin", File.dirname(__FILE__))
# p File.expand_path("../bin", File.dirname(__FILE__))
# p File.expand_path("./bin", File.dirname(__FILE__))
# p File.expand_path("/bin", File.dirname(__FILE__))
# p File.expand_path("../../bin", "/tmp/x")   #=> "/bin"
# p Dir.glob(File.dirname(__FILE__)+"/*")
dir = "D:\\webdownloads\\config"
unless File.exists?(dir)
		File.mkdir dir
end
p path = dir.gsub("\\","\/")+"/*"
p files = Dir.glob(path)
# FileUtils.rm files
filename = "222"
filename=~/222/ && FileUtils.rm(files) #ujtf
