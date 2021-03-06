#encoding:utf-8
# result summary
# author : wuhongliang
# date   : 2015-7-27
#reporters
# Minitest::Reporters::DefaultReporter :color => true # => Redgreen-capable version of standard Minitest reporter #颜色标识
# Minitest::Reporters::SpecReporter     # => Turn-like output that reads like a spec #不生成日志文件，有颜色
# Minitest::Reporters::ProgressReporter # => Fuubar-like output with a progress bar
# Minitest::Reporters::RubyMateReporter # => Simple reporter designed for RubyMate #依赖ide
# Minitest::Reporters::RubyMineReporter # => Reporter designed for RubyMine IDE and TeamCity CI server #依赖ide
# Minitest::Reporters::JUnitReporter    # => JUnit ftp_test reporter designed for JetBrains TeamCity 生成xml报告

require "minitest/reporters"
file_path1 =File.expand_path('../float', __FILE__)
require file_path1
module Minitest
		module Reporters
				class MyJUnitReporter<JUnitReporter
						private
						def filename_for(suite)
								file_counter = 0
								time         = Time.new.strftime("%Y%m%d%H%M%S")
								filename     = "TEST-#{suite.to_s[0..240].gsub(/[^a-zA-Z0-9]+/, '-')}_#{time}.xml" #restrict max filename length, to be kind to filesystems
								FileUtils.mkdir_p(@reports_path) unless File.exists?(@reports_path)

								while File.exists?(File.join(@reports_path, filename)) # restrict number of tries, to avoid infinite loops
										file_counter += 1
										filename     = "TEST-#{suite}-#{file_counter}.xml"
										puts "Too many duplicate files, overwriting earlier report #{filename}" and break if file_counter >= 99
								end
								File.join(@reports_path, filename)
						end
				end

				class MyHtmlReporter<HtmlReporter
						# The percentage of tests that passed, calculated in a way that avoids rounding errors
						def percent_passes
								100 - percent_skipps - percent_errors_failures
						end

						# The percentage of tests that were skipped
						def percent_skipps
								p_skipps = (skips/count.to_f * 100)
								unless p_skipps.to_s =~ /0$/
										p_skipps = p_skipps.roundn(-2)
								end
								return p_skipps
						end

						# The percentage of tests that failed
						def percent_errors_failures
								p_errors=((errors+failures)/count.to_f * 100)
								unless p_errors.to_s =~ /0$/
										p_errors = p_errors.roundn(-2)
								end
								return p_errors
						end
				end

		end
end

templates_path ="#{File.dirname(__FILE__)}/templates/index.html.erb"
log_time       = Time.new.strftime("%Y%m%d%H%M%S")
args           ={title:           "测试结果".encode("GBK"),
                 reports_dir:     "html_reports/#{$report_date}",
                 erb_template:    templates_path,
                 output_filename: "index_#{log_time}.html"
}
reporters      = [
		Minitest::Reporters::DefaultReporter.new(:color => true),
		Minitest::Reporters::MyHtmlReporter.new(args),
		Minitest::Reporters::MyJUnitReporter.new("reports/#{$report_date}", false)
]
Minitest::Reporters.use!(reporters)

