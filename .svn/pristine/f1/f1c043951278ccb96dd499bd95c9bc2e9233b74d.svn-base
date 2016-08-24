#encoding: GBK
# 1.引入'logger'
require 'logger'
# 2.日志输出到控制台还是文件
logger = Logger.new(STDOUT)  #输出到控制台
# logger = Logger.new("log.txt")  #输出到文件，文件名log.txt
# logger = Logger.new(STDERR) #输出到屏幕
logger2 = Logger.new(STDOUT)
 path = File.dirname(File.expand_path(__FILE__))
 file_path = path+"/logger.txt"
logger2 = Logger.new(file_path)
logger.level = Logger::INFO
logger.info("ftp_test"){"日志1啊，好啊好啊"}
# logger2.info("ftp_test"){"日志1啊，好啊好啊"}


