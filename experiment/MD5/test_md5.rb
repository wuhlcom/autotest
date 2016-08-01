require 'digest'
md5 = Digest::MD5.new
str="123456"
md5.update str
p md5.hexdigest

# p Digest::SHA256.hexdigest str
require 'openssl'
require 'cgi'
data = "123456"
md5 = OpenSSL::Digest::MD5.new
digest = md5.digest(data)
p md5.hexdigest
# p str =  OpenSSL::Digest.digest("MD5", "123123")

