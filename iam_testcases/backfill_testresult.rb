#encoding: utf-8
#将自动化执行结果回填到指定目录下的excel基线用例文件中
# author : liluping
# date   : 2016-6-16

require './parser_excel'
require './parser_frame_xml'

module TestTool
    class BackFill

        def initialize(excel_path, xml_path, backfill_file)
            @excel_baseline_path  = excel_path
            @xml_test_result_path = xml_path
            @excel_obj            = TestTool::Excel.new(@excel_baseline_path)
            @backfill_file        = backfill_file
        end

        #定位excel
        def location_workbook
            @excel_obj.workbook
        end

        #定位到sheet
        def location_sheet(index=1)
            @excel_obj.worksheet_select(index) #定位到sheet
        end

        #获取excel中sheet中的总行数
        def get_rows_num
            # @excel_obj.worksheet(index) #定位到sheet
            line = 1
            while @excel_obj.range_select("C#{line}").value
                line=line+1
            end #line的值为第一处空白行的行数
            line #总行数
        end

        #获取excel文件中的用例id
        def get_tc_id(line)
            tc_id = @excel_obj.range_select("D#{line}").value
            tc_id
        end

        #回填结果到excel
        def write_excel(line, key, tc_msg)
            result = "failed"
            result = "pass" if key.to_s == "success"
            @excel_obj.range_select("L#{line}:N#{line}")
            @excel_obj.set_range(["autotest", result, tc_msg])
        end

        #获取自动化测试结果
        def get_test_result
            TestTool::XML.get_test_result(@xml_test_result_path)
        end

        #获取测试结果中的用例名称和信息
        def get_tc_name_msg(item, key)
            if key.to_s == "failure"
                tc_name = item[:name]
                tc_msg  = item[:message]
            else
                tc_name = item
                tc_msg  = " "
            end
            {:name => tc_name, :msg => tc_msg}
        end

        #保存退出
        def save_and_quit
            @excel_obj.saveas_workbook(@backfill_file)
            @excel_obj.close_workbook unless @excel_obj.nil?
            @excel_obj.close_excel unless @excel_obj.nil?
        end

        #执行操作
        def operation(test_result, index=1)
            location_sheet(index) #定位sheet
            all_line = get_rows_num #获取总行数
            test_result.each do |key, value|
                value.each do |item|
                    line_flag = []
                    for i in 2..all_line-1
                        next if line_flag.include?(i)
                        tc_id         = get_tc_id(i) #获取excel文件中的用例id
                        tc_info       = get_tc_name_msg(item, key)
                        tc_name       = tc_info[:name]
                        tc_msg        = tc_info[:msg]
                        tc_name_slice = tc_name.slice(/IAM.+/i)
                        if tc_name_slice == tc_id
                            write_excel(i, key, tc_msg)
                            line_flag << i
                            break
                        end
                    end
                end
            end
        end

        #将测试结果回填到指定excel文件中
        def backfill_result
            begin
                test_result = get_test_result #获得自动化测试结果
                workbook_obj  = location_workbook #定位excel
                worksheet_obj = workbook_obj.worksheets
                sheet_count   = worksheet_obj.count #获取excel中页签的个数
                operation(test_result)
            rescue => ex
                p "==========================================================="
                p "回填数据过程中出现异常！".encode("GBK")
                p ex.message
                p "==========================================================="
            ensure
                save_and_quit
            end
        end

    end
end

if __FILE__ ==$0
    report_dir     = "20160830"
    excel_name     = "IAM"
    excel_baseline = File.expand_path("./reports") # "D:/autotest/iam_testcases/reports"
    excel_log_dir  = File.expand_path("./reports/#{report_dir}") # "D:/autotest/iam_testcases/reports/20160826"

    excel_baseline_path = excel_baseline+"/#{excel_name}.xls" #原始基线用例存放路径，如：E:/autotest/frame/report/baseline_tcs.xls
    xml_path = Dir.glob("#{excel_log_dir}/*.xml") #xml日志路径，如：E:/autotest/frame/report/20160616/*.xml
    backfill_file = excel_log_dir+"/#{excel_name}_#{report_dir}.xls" #回填后的基线用例存放路径，如：E:/autotest/frame/report/20160616/baseline_tcs.xls
    backfill_obj = TestTool::BackFill.new(excel_baseline_path, xml_path, backfill_file)
    backfill_obj.backfill_result
end





























































