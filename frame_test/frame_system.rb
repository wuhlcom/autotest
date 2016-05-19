#encoding: utf-8
require '../frame_test/public_instance_variable'
# require '../frame/public_instance_variable'
module Frame
		class WebTestSystem<WebTestNameSpace
				current_path      = File.dirname(File.expand_path(__FILE__))
				p $report_date
				p @@report_path_sys = current_path+"/reports/#{$report_date}/system"
				#stdio("#{@@report_path_sys}/system.log")
				# i_suck_and_my_tests_are_order_dependent! #alpha，按顺序执行

				def operate(str="")
						puts str.to_gbk
						yield
				end

				frame = File.new("frame.xml")
				doc   = REXML::Document.new frame

				@ts_el=""
				doc.root.elements.each("//TestSuite") do |ts|
						ts.elements["name"]
						if ts.elements["name"].text=~/system/
								@ts_el=ts
						end
				end

				# ts_el =doc.root.elements["TestSuite"]
				ts_name     = @ts_el.elements["name"].text
				ts_path     = @ts_el.elements["path"].text
				ts_abs_path = File.absolute_path(ts_path, __FILE__)
				ts_file     = ts_abs_path+"/"+ts_name+".rb"
				if File.exist?(ts_file)
						File.open(ts_file, "r") { |ts| eval(ts.read.encode("UTF-8")) }
				else
						puts("Cant't find testcase file--> #{ts_file}".encode("GBK"))
						fail("Cant't find testcase file--> #{ts_file}".encode("GBK"))
				end

				i      =0
				tcs_el =@ts_el.elements["TestCases"]
				tc_el  =tcs_el.elements.each("TestCase") { |tc|
						tc_name     = tc.elements["name"].text
						# next if tc_name !~ /注销功能测试 ZLBF_21.1.40/
						tc_path     = tc.elements["path"].text
						tc_abs_path = File.absolute_path(tc_path, __FILE__)
						tc_file     = tc_abs_path+"/"+tc_name+".rb"
						# tc.attributes["auto"]
						if File.exist?(tc_file) && tc.attributes["auto"]=~/y/i
								File.open(tc_file, "r") { |tc|
										tc_content  = tc.read.to_utf8
										new_prepare = "prepare#{i}"
										new_process = "process#{i}"
										new_clearup = "clearup#{i}"
										tc_content.gsub!("prepare", new_prepare)
										tc_content.gsub!("process", new_process)
										tc_content.gsub!("clearup", new_clearup)
										eval(tc_content)
										tc_name=tc_name.to_gbk
										define_method "test_#{tc_name}" do
												report_fpath = @@report_path_sys+"/#{tc_name}"
												stdio(report_fpath)
												begin
														send new_prepare
														send new_process
												rescue => ex1
														puts "[ERROR INFO]:excute error"
														puts err = ex1.message.to_s
														print ex1.backtrace.join("\n")
														print("\n")
														assert(false, err)
												ensure
														begin
																send new_clearup
														rescue => ex2
																puts "[ERROR INFO]:clearup error:"
																puts err = ex2.message.to_s
																print ex2.backtrace.join("\n")
																print("\n")
																assert(false, err)
														end
												end
										end
								}
						elsif !File.exist?(tc_file) && tc.attributes["auto"]=~/y/i
								puts("Cant't find testcase file--> #{tc_file}".encode("GBK"))
						end #if
						i+=1
				}
		end
end





