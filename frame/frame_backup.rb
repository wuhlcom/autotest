#encoding:utf-8
require '../frame/public_instance_variable'
module Frame
		class WebTestBackup<WebTestNameSpace
				current_path      = File.dirname(File.expand_path(__FILE__))
				@@report_path_backup = current_path+"/reports/#{$report_date}/backup"
				frame             = File.new("frame_all.xml")
				doc               = REXML::Document.new frame

				@ts_el=""
				doc.root.elements.each("//TestSuite") do |ts|
						if ts.elements["name"].text=~/backup/
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

				i      = 0
				tcs_el = @ts_el.elements["TestCases"]
				tc_el  = tcs_el.elements.each("TestCase") { |tc|
						tc_name     = tc.elements["name"].text
						tc_path     = tc.elements["path"].text
						tc_abs_path = File.absolute_path(tc_path, __FILE__)
						tc_file     = tc_abs_path+"/"+tc_name+".rb"
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
												report_fpath = @@report_path_backup+"/#{tc_name}.log"
												time         = Time.new.strftime("%Y%m%d%H%M%S")
												stdio(report_fpath, time)
												begin
														send new_prepare
														send new_process
												rescue => ex1
														puts "======================================================="
														puts "[ERROR INFO]:============PROCESS ERROR!==============="
														puts "======================================================="
														report_image1 = @@report_path_backup+"/images/#{tc_name}_progress.png"
														save_screenshot(@browser, report_image1, time) #截图
														puts "======================PROCESS ERROR MSG==============================="
														err = ex1.message.to_s
														puts "======================PROCESS ERROR MSG================================"
														print ex1.backtrace.join("\n")
														print("\n")
														assert(false, err)
												ensure
														begin
																send new_clearup
														rescue => ex2
																puts "======================================================="
																puts "[ERROR INFO]:============CLEARUP ERROR!================"
																puts "======================================================="
																report_image2 = @@report_path_backup+"/images/#{tc_name}_clearup.png"
																save_screenshot(@browser, report_image2, time) #截图
																puts "======================CLEARUP ERROR MSG================================="
																puts err = ex2.message.to_s
																puts "======================CLEARUP ERROR MSG================================="
																print ex2.backtrace.join("\n")
																print("\n")
																assert(false, err)
														end #begin
												end #begin
										end
								}
						elsif !File.exist?(tc_file) && tc.attributes["auto"]=~/y/i
								puts("Cant't find testcase file--> #{tc_file}".encode("GBK"))
						end
						i+=1
				}
		end
end





