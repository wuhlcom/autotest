#encoding:utf-8
#wuhongliang 2015-10-20
#统计frame_all.xml中脚本数量等信息
#按测试套和脚本优先级修改脚本frame_all.xml中的auto属性值，以达到筛选哪些级别脚本来执行的目的
#修改xml脚本名字,只是修改xml中脚本名字，没有修改实际脚本名字
# 解析frame_all.xml
# 解析脚本生成的报告xml
# 修改frame_all.xml中的指定属性
# 核对frame_all.xml中用例名中的Id与属性ID是否一致
# 核对frame_all.xml中的Id，level与用例表中的的ID是否致
require "rexml/document"
require 'fileutils'
class Float
    def roundf(places)
        size = self.to_s.size
        sprintf("%#{size}.#{places}f", self).to_f
    end
end
require './parser_excel'
module TestTool
    class XML
        attr_accessor :default_new_xml, :doc

        def initialize(xml)
            xml_obj = File.open(xml)
            fail "xml must be File obj" unless xml_obj.kind_of?(File)
            @doc      = REXML::Document.new(xml_obj)
            curr_path = File.dirname(__FILE__)
            dirname   = "#{curr_path}/new_xml"
            FileUtils.mkdir_p(dirname) unless File.exists?(dirname)
            @default_new_xml = "#{dirname}/new.xml"
        end

        #获取所有测试套节点对象
        def get_testsuite(ts_name=nil)
            ts_hash ={}
            @doc.root.elements.each("//TestSuite") do |ts|
                unless ts_name.nil?
                    next if ts.elements["name"].text==ts_name
                end
                ts_name         = ts.elements["name"].text
                ts_path         = ts.elements["path"].text
                ts_hash[ts_name]={:ts_el => ts, :ts_path => ts_path}
            end
            ts_hash
        end

        #获取测试套中用例组对象
        def get_testcases()
            ts             = get_testsuite
            testcases_hash ={}
            ts.each_pair { |key, value|
                ts_el               = value[:ts_el]
                tcs_el              = ts_el.elements["TestCases"]
                testcases_hash[key] = tcs_el
            }
            testcases_hash
        end

        #获取用例组中用例对象
        def get_testcase()
            tc            = get_testcases
            testcase_hash ={}
            tc.each_pair { |key, testcases|
                testcase_hash[key.to_sym] =[]
                testcases.elements.each("TestCase") { |testcase|
                    testcase_hash[key.to_sym]<<{:tc_name  => testcase.elements["name"].text,
                                                :tc_level => testcase.attributes["level"],
                                                :tc_id    => testcase.attributes["id"],
                                                :auto     => testcase.attributes["auto"],
                                                :tc_path  => testcase.elements["path"].text
                    }
                }
            }
            testcase_hash
        end

        #获取xml所有用例的ID和Level，未区分测试套
        def get_id_level
            rs       = get_testcase
            new_hash = {}
            rs.each_value { |value|
                value.each { |item|
                    new_hash[item[:tc_name]] = {"id" => item[:tc_id], "level" => item[:tc_level]}
                }
            }
            new_hash
        end

        #根据优先级修改脚本的auto属性的值
        # params
        # -tsname,String,testsuit name
        # -level String ["P1"]
        #-flag,true 将auto=n改成y,false将y改成n
        def change_tc_auto_bylevel(tsname, level, flag=true)
            testcases_hash = get_testcases()
            testcases_el   =testcases_hash[tsname]
            testcases_el.elements.each("TestCase") { |tc|
                tc_level = tc.attributes["level"]
                if level.any? { |l| l==tc_level }
                    if flag
                        tc.attributes["auto"]="y"
                    else
                        tc.attributes["auto"]="n"
                    end
                end
            }
            save_xml
        end

        #修改frame_xml中指定脚本的相对路径属性
        # params
        # -tsname,String,eg,"internet"
        # -tcnames,Array eg,[27.1.3]
        # -newpath,String eg,"../../reset"
        def change_tc_path_byname(tsname, tc_names, newpath)
            testcases_hash = get_testcases()
            testcases_el   =testcases_hash[tsname]
            testcases_el.elements.each("TestCase") { |tc|
                tc_name = tc.elements["name"].text
                if tc_names.any? { |name| tc_name=~/#{name}/ }
                    tc.elements["path"].text = newpath
                end
            }
            save_xml
        end

        #修改frame_xml中指定脚本的相对路径属性
        # params
        # -tsname,String,eg,"internet"
        # -tcnames,Array eg,[27.1.3]
        # -level,String eg,"P1"，修改level
        def change_tc_level_byname(tsname, tc_names, level)
            testcases_hash = get_testcases()
            testcases_el   =testcases_hash[tsname]
            testcases_el.elements.each("TestCase") { |tc|
                tc_name = tc.elements["name"].text
                if tc_names.any? { |name| tc_name=~/#{name}/ }
                    tc.attributes["level"]=level
                end
            }
            save_xml
        end

        #修改脚本名
        # params
        # -tsname String,eg:"internet"
        # -currname String,eg:""
        def change_tc_name(tsname, currname, newname)
            testcases_hash = get_testcases()
            testcases_el   = testcases_hash[tsname]
            testcases_el.elements.each("TestCase") { |tc|
                tc_name = tc.elements["name"].text
                if tc_name=~/#{currname}/i
                    tc.elements["name"].text = newname
                end
            }
            save_xml
        end

        #修改xml中指定脚本的auto属性的值 add by liluping 2016/01/26
        def change_tc_auto_byname(tsname, tc_names, auto, xmlpath=@default_new_xml)
            testcases_hash = get_testcases()
            testcases_el   =testcases_hash[tsname]
            testcases_el.elements.each("TestCase") { |tc|
                tc_name = tc.elements["name"].text
                if tc_names.any? { |name| tc_name=~/#{name}/ }
                    tc.attributes["auto"]=auto
                end
            }
            save_xml(xmlpath)
        end

        #修改xml中所有用例的auto属性值
        def change_all_tc_auto(auto, xmlpath=@default_new_xml)
            testcases_hash = get_testcases()
            testcases_hash.each do |key, value|
                testcases   =testcases_hash[key]
                testcases.elements.each("TestCase") { |tc|
                    tc.attributes["auto"]=auto
                }
            end
            save_xml(xmlpath)
        end

        #保存xml
        def save_xml(xmlpath=@default_new_xml)
            open(xmlpath, "w") { |file|
                file.puts @doc.write()
            }
        end

        #解析frame_xml,分类统计脚本数量
        def statistics_testcase
            rs                 = get_testcase
            y                  = 0
            n                  = 0
            t                  = 0
            auto_y             = []
            auto_y_no_file     = []
            auto_y_no_file_num = 0
            auto_n             = []
            auto_n_no_file     = []
            auto_n_no_file_num = 0
            tc_path_error      = []
            path_error_num     = 0
            tc_auto_error      = []
            rs.each_pair { |key, testcases|
                testcases.each { |el|
                    tc_path     = el[:tc_path]
                    tc_name     = el[:tc_name]
                    # next if tc_name=~/中继|桥接/ #排除中继和桥接脚本
                    #根据xml tc_path 生成脚本完整的绝对路径
                    tc_abs_path = File.absolute_path(tc_path, __FILE__)
                    tc_file     = tc_abs_path+"/"+tc_name+".rb"
                    #判断脚本是否存在，如果不存在，要么是xml中记录的路径错误，要么脚本不存在
                    unless File.exists?(tc_file)
                        tc_path_error<<tc_name
                        path_error_num+=1
                    end
                    #自动化auto=y且脚本存在
                    if el[:auto]=="y"&&File.exists?(tc_file)
                        auto_y<<tc_name
                        y+=1
                        #自动化auto=y且脚本不存在，要么是脚本不存在，要么是路径错误
                    elsif el[:auto]=="y" && !(File.exists?(tc_file))
                        auto_y_no_file << tc_name
                        auto_y_no_file_num +=1
                        #自动化auto=n且脚本存在
                    elsif el[:auto]=="n"&& File.exists?(tc_file)
                        auto_n<<tc_name
                        n+=1
                        #自动化auto=n且脚本不存在，要么是脚本不存在，要么是路径错误
                    elsif el[:auto]=="n" && !(File.exists?(tc_file))
                        auto_n_no_file << tc_name
                        auto_n_no_file_num +=1
                        #没有auto属性的脚本
                    elsif el[:auto] !="y" && el[:auto] != "n"
                        puts "auto attr value error!!!"
                        tc_auto_error<<tc_name
                    end
                    t+=1
                }
            }
            statistics_hash ={
                :total              => t, #xml中记录的脚本总数
                :auto_y_num         => y, #xml中记录auto=y的数量，不论脚本是否存在
                :auto_y             => auto_y, #自动化auto=y且脚本存在的脚本名构成的数组
                :auto_n_num         => n, #xml中记录auto=n的数量，不论脚本是否存在
                :auto_n             => auto_n, #自动化auto=n且脚本存在的脚本名构成的数组
                :auto_y_no_file     => auto_y_no_file, #自动化auto=y且脚本不存在的脚本名构成的数组
                :auto_y_no_file_num => auto_y_no_file_num, #自动化auto=y且脚本不存在的数量
                :auto_n_no_file     => auto_n_no_file, #自动化auto=n且脚本不存在的脚本名构成的数组
                :auto_n_no_file_num => auto_n_no_file_num, #自动化auto=n且脚本不存在的数量
                :path_error         => tc_path_error, #路径找不到的脚本名称数组
                :path_error_num     => path_error_num, #路径找不到的脚本名构成的数组
                :auto_error         => tc_auto_error #没有设置auto属性的脚本名构成的数组
            }
        end

        #解析reports目录的脚本执行结果中的xml报告，取出报告头的汇总信息
        def log_root
            root_el    = @doc.root
            sucess_num = root_el.attributes["tests"].to_i-root_el.attributes["skipped"].to_i-root_el.attributes["failures"].to_i-root_el.attributes["errors"].to_i
            root_hash  ={
                :sucesses   => sucess_num,
                :errors     => root_el.attributes["errors"],
                :failures   => root_el.attributes["failures"],
                :tests      => root_el.attributes["tests"],
                :time       => root_el.attributes["time"],
                :name       => root_el.attributes["name"],
                :assertions => root_el.attributes["assertions"],
                :skipped    => root_el.attributes["skipped"],
                :root_el    => root_el
            }
        end

        def self.summary_log_root(args)
            sum_successes = 0
            sum_errors    = 0
            sum_failures  = 0
            sum_tests     = 0
            sum_time      = 0
            sum_assertions= 0
            summary       ={}
            args.each { |xml|
                xmlobj        = XML.new(xml).log_root
                sum_successes +=xmlobj[:sucesses].to_i
                sum_errors    +=xmlobj[:errors].to_i
                sum_failures  +=xmlobj[:failures].to_i
                sum_tests     +=xmlobj[:tests].to_i
                sum_time      +=xmlobj[:time].to_i
                sum_assertions+=xmlobj[:assertions].to_i
            }
            sum_time_hour = (sum_time.to_f/60/60).roundf(2)
            summary       ={
                :sum_successes  => sum_successes,
                :sum_errors     => sum_errors,
                :sum_failures   => sum_failures,
                :sum_tests      => sum_tests,
                :sum_time       => sum_time,
                :sum_time_hour  => sum_time_hour,
                :sum_assertions => sum_assertions
            }
        end

        #解析reports目录的脚本执行结果中的xml报告，取出所有脚本名保存到数组
        def log_testcase
            root_el      = log_root[:root_el]
            testcase_arr = []
            root_el.elements.each("testcase") { |el|
                el.attributes["name"]=~/test_(.*)/
                testcase_arr << Regexp.last_match(1)
            }
            testcase_arr
        end

        #按测试套，获取xml中失败的脚本名和失败信息
        def self.get_failure(args)
            ts_failure = {}
            args.each { |xml|
                failure_arr= []
                xmlobj     = XML.new(xml)
                root_el    = xmlobj.log_root[:root_el]
                ts_class   = root_el.attributes["name"]
                /\w+::WebTest(?<ts_name>\w+)/i=~ ts_class
                root_el.elements.each("//failure") { |el|
                    failure = {}
                    /^test_(?<tc_name>.+)/ =~ el.attributes["type"]
                    failure["type"]    = tc_name
                    failure["message"] = el.attributes["message"]
                    failure["text"]    = el.text
                    failure_arr<<failure
                }
                ts_failure[ts_name]=failure_arr
            }
            ts_failure
        end
    end
end

if __FILE__==$0
    require 'pp'
    #########################汇总xml报告############
    report_dir  = "20160119"
    report_path = File.expand_path("./reports/#{report_dir}")
    xml_arr     = Dir.glob("#{report_path}/*.xml")
    log_summary = TestTool::XML.summary_log_root(xml_arr)
    file_name = report_dir+"summary.txt"
    file_path = report_path+"/#{file_name}"
    summary_log   = File.new(file_path, "w+")
    summary_log.puts "#{log_summary}"
    summary_log.close
    #######################取出xml失败的用例
    # current = File.expand_path("./reports/20160113", File.dirname(__FILE__))
    # xml_arr = Dir.glob("#{current}/*.xml")
    # pp TestTool::XML.get_failure(xml_arr)
    #######################统计frame_xml中的脚本###############################################
    # 取出frame_all中的脚本名保存到数组
    xml_all   = "frame_all.xml"
    # xml_obj   = TestTool::XML.new(xml_all)
    # statistics = xml_obj.statistics_testcase
    # pp statistics[:auto_y].sort
    # 这里保存的用例名都是Unicode编码utf-8编码
    # auto_y_arr     = statistics[:auto_y]
    # auto_n_arr     = statistics[:auto_n]
    # auto_y_new_arr = []
    # auto_n_new_arr = []
    # p statistics[:total]
    # p statistics[:path_error][0].encode("GBK") #路径错误的脚本
    # p statistics[:path_error_num] #路径错误的脚本数
    # p statistics[:auto_y_num] #auto为y的脚本数
    # p statistics[:auto_y_no_file_num] #auto为y但找不到文件
    # 	y_no_file = 	statistics[:auto_y_no_file] #auto为y但找不到文件
    # y_no_file.each{|x|p x.encode("GBK")}
    # p statistics[:auto_n_num] #auto为n的脚本数
    # n_file = statistics[:auto_n] #auto为y但找不到文件
    # n_file.each { |x| p x.encode("GBK") }
    # p statistics[:auto_n_no_file_num] #auto为n但找不到文件的数量
    # p statistics[:auto_n_no_file][0].encode("GBK") #auto为n但找不到文件
    #将数组元素转码
    # auto_y_arr.each { |tc|
    # 		auto_y_new_arr<< tc.encode("GBK")
    # }
    #
    # auto_n_arr.each { |tc|
    # 		auto_n_new_arr<< tc.encode("GBK")
    # }
    # auto_yn_new_arr=auto_y_new_arr+auto_n_new_arr
    #  file_tc_autoyn = File.new("d:/tc_autoyn.txt", "w")
    #  auto_yn_new_arr.sort.each { |tc|
    #  		tc.encode("GBK")
    #  		file_tc_autoyn.puts tc.encode("GBK")
    #  }
    #  file_tc_autoyn.close

    # #将解析出来的脚本名，写入到文件中
    # file_tc_autoy = File.new("d:/tc_autoy.txt", "w")
    # auto_y_new_arr.sort.each { |tc|
    # 		tc.encode("GBK")
    # 		file_tc_autoy.puts tc.encode("GBK")
    # }
    # file_tc_autoy.close
    ##########################检查用例名中的ID与属性中ID是否一致######
    # xml_all   = "frame_all.xml"
    # xml_obj   = TestTool::XML.new(xml_all)
    # xml_rs    = xml_obj.get_id_level
    # nameid_id = File.new("D:/nameid_id_notmatch.txt", "w+")
    # xml_rs.each { |key, value|
    # 		unless key =~ /#{value["id"]}/i
    # 				nameid_id.puts key
    # 		end
    # }
    # nameid_id.close
    #############################按测试和优先级修改auto值##################################
    # p xml.change_tc_auto_bylevel("internet", ["P1"], false)
    #####################################对比frame_xml与用例excel表中的ID和用例级别是否一致###
    #注意这里使用的是模糊匹配，反回的frame_xml的用例可能不是对应的
    # xml_all = "frame_all.xml"
    # xml_obj = TestTool::XML.new(xml_all)
    # xml_rs  = xml_obj.get_id_level
    # excel中Id
    # begin
    # 		file_name="E:/工作管理/基线用例_V1.0.7_2015.10.29.xls"
    # 		excelobj =TestTool::Excel.new(file_name)
    # 		args     ={
    # 				:condition_col => "G",
    # 				:condition     => "一期|二期|三期".encode("GBK"),
    # 				:name_col      => "C",
    # 				:level_col     => "F",
    # 				:id_col        => ["D", "E"],
    # 				:line          => "1",
    # 				:lines         => "800"
    # 		}
    # 		excel_rs = excelobj.get_name_id_level(args)
    # rescue => ex
    # 		p ex.message.to_s
    # 		puts ex.backtrace.join("\n")
    # 		# excel.Quit
    # 		excelobj.close_excel()
    # end
    # id_error    = "d:/id_error.txt"
    # level_error = "d:/level_error.txt"
    # id_err_file = File.new(id_error, "w+")
    # id_err_file.puts "################ID ERROR ############"
    # level_err_file = File.new(level_error, "w+")
    # level_err_file.puts "################Level ERROR ############"
    # xml_rs.each_key { |xml_tcname|
    # 		excel_rs.each_key { |excel_tcname|
    # 				next if xml_tcname !~/#{excel_tcname}/i
    # 				#如查xml中用例名匹配，用例表中用例名，再判断id和level是否相等
    # 				if xml_tcname =~/#{excel_tcname}/i
    # 						p xml_tcname.encode("GBK")
    # 						if xml_rs[xml_tcname]["id"] != excel_rs[excel_tcname]["id"]
    # 								id_err_file.puts("#{xml_tcname}->xml id:#{  xml_rs[xml_tcname]["id"]}::#{excel_tcname}->excel id:#{excel_rs[excel_tcname]["id"]}")
    # 						end
    # 						if xml_rs[xml_tcname]["level"] != excel_rs[excel_tcname]["level"]
    # 								level_err_file.puts("#{xml_tcname}->xml level:#{xml_rs[xml_tcname]["level"]}::#{excel_tcname}->excel level:#{excel_rs[excel_tcname]["level"]}")
    # 						end
    # 				end
    # 		}
    # }

end
