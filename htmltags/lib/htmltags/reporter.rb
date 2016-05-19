#encoding:utf-8
# io to log
# author : wuhongliang
# date   : 2015-5-25
require 'fileutils'
module HtmlTag
		$reporter ||=""
		module EXT_STDOUT #复写$stdout.write方法
				def write(str)
						if !$reporter.nil?
								$reporter.write(str)
								$reporter.flush
						end
						super
				end
		end

		class EXT_STDERR #复写$stderr.write方法
				def write(str)
						print str
						File.open($reporter, 'a') do |file|
								file.puts(str)
						end
				end
		end

		module Reporter

				def self.included(base)
						base.extend(self) #类扩展混入，扩展self,使得模块被类mixin时，模块内的方法既是类方法又是实例方法
				end


				def reporter(log_path)
						$reporter = File.new(log_path, "a")
				end

				def stdio(file_path, time = Time.new.strftime("%Y%m%d%H%M%S"))
						dirname = File.dirname(file_path)
						FileUtils.mkdir_p(dirname) unless File.exists?(dirname)
						filename = File.basename(file_path, ".*")+"_#{time}.log"
						file_path= File.join(dirname, filename)
						reporter file_path
						$stdout.extend EXT_STDOUT
						$stderr = EXT_STDERR.new
				end

		end
end

if $0==__FILE__
# 	p report_fpath =File.expand_path("../../../ftp_test/reports/reportlog", __FILE__)
# p report_fpath = File..dirname(File.expand_path(__FILE__))+"/report"+"/ftp_test"
# 	HtmlTag::Reporter.stdio(report_fpath)
# 	p "lo22222222222222222222"
end