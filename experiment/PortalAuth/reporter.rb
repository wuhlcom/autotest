#encoding:utf-8
# io to log
# author : wuhongliang
# date   : 2015-5-25
require 'fileutils'
module Portal
	module Reporter

		def self.included(base)
			base.extend(self)
		end

		$reporter ||=""
		module EXT_STDOUT
			def write(str)
				if !$reporter.nil?
					$reporter.write(str)
					$reporter.flush
				end
				super
			end
		end

		class EXT_STDERR
			def write(str)
				print str
				File.open($reporter, 'a') do |file|
					file.puts(str)
				end
			end
		end

		def self.reporter(log_path)
			$reporter = File.new(log_path, "a")
		end

		def self.stdio(file_path)
			dirname = File.dirname(file_path)
			Dir.mkdir(dirname) unless File.exists?(dirname)
			filename = File.basename(file_path, ".*")+"_#{Time.new.strftime("%Y%m%d%H%M%S")}.log"
			file_path=File.join(dirname, filename)
			reporter file_path
			$stdout.extend EXT_STDOUT
			$stderr= EXT_STDERR.new
		end

		def reporter(log_path)
			$reporter = File.new(log_path, "a")
		end

		def stdio(file_path)
			dirname = File.dirname(file_path)
			FileUtils.mkdir_p(dirname) unless File.exists?(dirname)
			filename = File.basename(file_path, ".*")+"_#{Time.new.strftime("%Y%m%d%H%M%S")}.log"
			file_path=File.join(dirname, filename)
			reporter file_path
			$stdout.extend EXT_STDOUT
			$stderr= EXT_STDERR.new
		end

	end
end

if $0==__FILE__
	p report_fpath =File.expand_path("../../../ftp_test/reports/reportlog", __FILE__)
	# p report_fpath = File..dirname(File.expand_path(__FILE__))+"/report"+"/ftp_test"
	HtmlTag::Reporter.stdio(report_fpath)
	p "lo22222222222222222222"
end