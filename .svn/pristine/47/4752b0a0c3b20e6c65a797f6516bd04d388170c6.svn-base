#encoding:utf-8
require 'win32ole'
require './parser_frame_xml'
#解析任务执行结果，将xml中的失败的用例结果，写到excel表便于分析
module TestTool
    class CreateExcel

        # excel.visible = true    # in case you want to see what happens
        def initialize(excel_path, xml_dir, flag=false)
            @workbook      = nil
            @worksheet     = nil
            @xml_dir       = xml_dir
            @sheet_index   = 1
            @excel_path    = excel_path.gsub("\/", "\\\\") #必须作转换
            @excel         = WIN32OLE::new('excel.Application')
            @excel.visible = flag
            @excel
        end

        #打开excel工作簿，对其中的sheet进行访问 add by liluping 2016/0126
        def open_excel_workbook
            unless File.exists?(@excel_path)
                fail "Excel file is not exists!"
            else
                @workbook = @excel.Workbooks.Open(@excel_path)
            end
        end

        #创建工作簿对象
        def create_excel_workbook
            if File.exists?(@excel_path)
                fail "Excel file exists!"
            else
                @workbook = @excel.workbooks.add
            end
        end

        #创建工作表对象
        #params
        #-name
        #-index
        def worksheet(args)
            args[:index] = @sheet_index if args[:index].nil?
            args[:name]  = @xml_dir if args[:name].nil?
            @worksheet   = @workbook.worksheets(args[:index]) #定位到第一个sheet
            @worksheet.select
            unless @worksheet.name.encode("UTF-8") == args[:name]
                @worksheet.name = args[:name] #修改sheet名
            end
            @worksheet
        end

        #创建单元格或行，列对象
        #params
        # -args,	string,"A1","a1:a3"
        #samples
        # obj.rangeobj("a1:a3")
        def rangeobj(args)
            @range = @worksheet.range(args)
        end

        #设置单元格，行，列的值
        #params
        # -args,string;"11"
        #samples
        # worksheet.Range('e2')['Value']= Time.now.strftime '%d/%m/%Y' #单个值
        # worksheet.Range('a5:c5')['Value'] = ['Test', '25', 'result'] #将一个数组写入
        # obj.set_range("11")
        def set_range(args)
            @range.value=args
        end

        def set_color(color=ExcelConst::XlColorIndexNone)
            @range.Interior['ColorIndex'] = color #pale yellow
        end

        #将xml中所有用例名转到excel中 add by liluping 2016/01/26
        def xml_to_excel(args)
            #获取xml中所有存在的用例名数组
            xml_path = "e:/autotest/frame/frame_all.xml"
            xml_obj  = TestTool::XML.new(xml_path)
            all_arr  = xml_obj.get_testcase
            params   = {
                :range => "A1:D1",
                :value => ["功能".encode("GBK"),
                           "测试用例".encode("GBK"),
                           "测试套".encode("GBK"),
                           "是否执行".encode("GBK")]
            }
            #创建excel
            create_excel_workbook
            worksheet(args)
            rangeobj(params[:range])
            set_range(params[:value])
            line = 2
            all_arr.each do |key, value|
                value.each do |item|
                    rangeobj("B#{line}:D#{line}")
                    set_range([item[:tc_name], key.to_s, "Y"])
                    line+=1
                end
            end
        end

        #遍历excel，获取是否执行的值为"Y"的用例名 add by liluping 2016/01/26
        def get_tcname(args)
            execute_file = {}
            open_excel_workbook
            worksheet(args)
            line_total = excel_row
            for i in 2..line_total-1
                execute_data             = @worksheet.range("D#{i}").value.encode("UTF-8")
                if execute_data == "Y"
                    execute_ts               = @worksheet.range("C#{i}").value.encode("UTF-8")
                    execute_file[execute_ts] = []
                end
            end
            for i in 2..line_total-1
                execute_data = @worksheet.range("D#{i}").value.encode("UTF-8")
                if execute_data == "Y"
                    execute_ts = @worksheet.range("C#{i}").value.encode("UTF-8")
                    execute_file[execute_ts] << @worksheet.range("B#{i}").value.encode("UTF-8")
                end
            end
            execute_file
        end

        #得到excel总行数 add by liluping 2016/01/26
        def excel_row
            line = 1
            while @worksheet.range("D#{line}").value
                line+=1
            end
            line
        end

        #
        #将xml中失败日志转到excel表中
        #params
        #-index inter,sheet index
        #-name string,sheet name
        #-version
        #-analyst
        def create_log_report(args)
            args[:index]   = @sheet_index if args[:index].nil?
            args[:name]    = @xml_dir if args[:name].nil?
            args[:version] = "请输入版本" if args[:version].nil?
            args[:analyst] = "吴洪亮" if args[:analyst].nil?
            current        = File.expand_path("./reports/#{@xml_dir}")
            xml_path_arr   = Dir.glob("#{current}/*.xml")
            failures_log   = TestTool::XML.get_failure(xml_path_arr)
            index          = args[:index].to_i
            params         = {
                :range => "A1:K1",
                :value => ["用例名称".encode("GBK"),
                           "分类".encode("GBK"),
                           "现象".encode("GBK"),
                           "错误信息".encode("GBK"),
                           "原因".encode("GBK"),
                           "解决方案".encode("GBK"),
                           "分析人".encode("GBK"),
                           "版本".encode("GBK"),
                           "测试套".encode("GBK"),
                           "是否解决".encode("GBK"),
                           "备注".encode("GBK")]
            }
            #创建
            create_excel_workbook
            worksheet(args)
            rangeobj(params[:range])
            set_range(params[:value])
            # set_color(36)
            line = 2
            failures_log.each { |ts, tc_failures|
                unless tc_failures.empty?
                    tc_failures.each do |tc_failure|
                        rangeobj("A#{line}")
                        set_range(tc_failure["type"]) #用例名称
                        rangeobj("C#{line}:D#{line}")
                        set_range([tc_failure["text"], tc_failure["message"]]) #现象和Message
                        rangeobj("G#{line}")
                        set_range(args[:analyst]) #分析人
                        rangeobj("H#{line}")
                        set_range(args[:version]) #版本
                        rangeobj("I#{line}")
                        set_range(ts) #测试套
                        line+=1
                    end
                end
            }
        end

        # workbook.save #保存
        def save_workbook
            if @workbook.nil?
                fail "excel workbook obj is nil"
            else
                @workbook.save
            end
        end

        # workbook.SaveAs'myfile.xls'
        def saveas_workbook(name="myfile.xls", path=File.dirname(__FILE__))
            file_path = "#{path}/#{name}"
            file_path = file_path.gsub("\/", "\\\\")
            if @workbook.nil?
                fail "excel workbook obj is nil"
            else
                @workbook.saveas(file_path)
            end
        end

        # workbook.close#关闭
        def close_workbook
            if @workbook.nil?
                fail "excel workbook obj is nil"
            else
                @workbook.close
            end
        end

        # excel.close#关闭
        def close_excel
            @excel.quit
        end

    end
end

if __FILE__ ==$0
    require 'pp'
    #########################汇总xml报告############
    # report_dir  = "20160121"
    # report_path = File.expand_path("./reports/#{report_dir}")
    # xml_arr     = Dir.glob("#{report_path}/*.xml")
    # log_summary = TestTool::XML.summary_log_root(xml_arr)
    # file_name   = report_dir+"summary.txt"
    # file_path   = report_path+"/#{file_name}"
    # summary_log = File.new(file_path, "w+")
    # summary_log.puts "#{log_summary}"
    # summary_log.close
    # ############################汇总失败日志并保存到excel
    report_dir       = "20160225"
    excel_name    = "#{report_dir}.xlsx"
    excel_log_dir = File.expand_path("./reports/#{report_dir}")
    excel_path    = excel_log_dir+"/#{excel_name}"
    creater       = TestTool::CreateExcel.new(excel_path, report_dir, false)
    begin
        args = {
            :index   => 1,
            :xml_dir => report_dir,
            :version => "V100R003C037",
            :analyst => "李路平"
        }
        creater.create_log_report(args)
        creater.saveas_workbook(excel_name, excel_log_dir)
    rescue => ex
        p ex
        print ex.backtrace.join("\n")
    ensure
        creater.close_workbook unless creater.nil?
        creater.close_excel unless creater.nil?
    end

    ########################frame_all.xml所有用例保存到excel..
    # excel_sheet    = "用例"
    # excel_file     = "excel_switch_xml"
    # excel_name     = "#{excel_file}.xlsx"
    # excel_file_dir = File.dirname(__FILE__)
    # excel_path     = excel_file_dir+"/#{excel_name}"
    # creater        = TestTool::CreateExcel.new(excel_path, excel_sheet, false)
    # begin
    #     args = {
    #         :index   => 1,
    #         :xml_dir => excel_sheet,
    #     }
    #     creater.xml_to_excel(args)
    #     creater.saveas_workbook(excel_name, excel_file_dir)
    # rescue => ex
    #     p ex
    #     print ex.backtrace.join("\n")
    # ensure
    #     creater.close_workbook unless creater.nil?
    #     creater.close_excel unless creater.nil?
    # end

    ##################执行的用例
    # excel_sheet    = "用例"
    # excel_file     = "excel_switch_xml"
    # excel_name     = "#{excel_file}.xlsx"
    # excel_file_dir = File.dirname(__FILE__)
    # excel_path     = excel_file_dir+"/#{excel_name}"
    # creater        = TestTool::CreateExcel.new(excel_path, excel_sheet, false)
    # begin
    #     args = {
    #         :index   => 1,
    #         :xml_dir => excel_sheet,
    #     }
    #     p rs = creater.get_tcname(args)
    #     p rs.size
    # rescue => ex
    #     p ex
    #     print ex.backtrace.join("\n")
    # ensure
    #     creater.close_workbook unless creater.nil?
    #     creater.close_excel unless creater.nil?
    # end
end