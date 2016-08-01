#encoding: utf-8
#测试套的集合，测试区间
#auto是否实现自动化，result执行结果，executed是否执行,tested是否已经执行
# <TestSuites>
# <TestSuite>
# <name>ts1</name>
#  <path>qos:/</path>
# <TestCases>
# <TestCase auto="y" result="f" executed="y" tested="n">
#  <name>Testcase1</name>
# <path>"qos:/"</path>
#  </TestCase>
# </TestCases>
#  </TestSuite>
# <TestSuite>
# <name>ts2</name>
#  <path>qos:/</path>
# <TestCases>
# <TestCase auto="y" result="f" executed="y" tested="n">
#  <name>Testcase2</name>
# <path>"qos:/"</path>
#  </TestCase>
# </TestCases>
#  </TestSuite>
# </TestSuites>

# #为REXML文档添加一个节点
#     element = doc.add_element ('book', {'name' => 'Programming Ruby', 'author' => 'Joe Chu'})
#     chapter1 = element.add_element('chapter', {'title' => 'chapter 1'})
#     chapter2 = element.add_element ('chapter', {'title' => 'chapter 2'})
# #为节点添加包含内容
#     chapter1.add_text "Chapter 1 content"
#     chapter2.add_text "Chapter 2 content"

# 1 生成测试套与测试用例关系的xml
# 2 生成用例模板
require 'fileutils'
require "rexml/document"
require './parser_excel'
module TestTool
    class Template

        attr_accessor :doc, :root_el

        def initialize()
            @doc         = REXML::Document.new #创建XML内容
            @root_el     = @doc.add_element("TestSuites")
            current_path = File.dirname(File.expand_path(__FILE__))
            @tcs_path    = current_path+"/tcs"
            #新建目录
            File.exist?(@tcs_path) || Dir.mkdir(@tcs_path)
            ##删除当前目录下的子目录和文件，不包含当前目录
            files = Dir.glob(@tcs_path+"/*")
            FileUtils.rm_rf(files, :verbose => true) if File.exist?(@tcs_path)
        end

        # <xx namespace="xxx">
        def add_ns(uri="http://www.microsoft.com/networking/WLAN/profile/v1")
            @root_el.add_namespace(uri)
        end

        #在根节点下添加节点
        def root_add_el(el_name)
            @root_el.add_element(el_name)
        end

        #添加节点
        def add_el(el, el_name)
            el.add_element(el_name)
        end

        #添加文本节点内容
        def add_txt(el, txt)
            el.add_text(txt)
        end

        #添加name节点
        def add_name(ssid_name, el_name="name")
            element = root_add_el(el_name)
            add_txt(element, ssid_name)
        end

        #添加TestSuite节点
        # <TestSuites>
        #   <TestSuite>
        #   </TestSuite>
        #</TestSuites>
        def add_testsuit(ts_name, ts_path, el_name="TestSuite")
            testsuite = root_add_el(el_name)
            add_ts_name_path(testsuite, ts_name, ts_path)
            testsuite
        end

        # <TestSuites>
        #   <TestSuite>
        #     <name></name>
        #     <path></path>
        #   </TestSuite>
        #</TestSuites>
        def add_ts_name_path(ts_el, ts_name, tspath)
            ts_name_el = add_el(ts_el, "name")
            add_txt(ts_name_el, ts_name)
            ts_path_el = add_el(ts_el, "path")
            add_txt(ts_path_el, tspath)
        end

        # <TestSuites>
        #   <TestSuite>
        #     <name></name>
        #     <path></path>
        #     <TestCases></TestCases>
        #   </TestSuite>
        #</TestSuites>
        def add_testcases(ts_name, ts_path, el_name="TestCases")
            testsuite = add_testsuit(ts_name, ts_path)
            tcs_el    = add_el(testsuite, el_name)
        end

        # <TestCases "x"="","y"="","z"="">
        def add_tcattr(testcase_el, args="")
            default_args = {
                "auto"      => "n",
                "result"    => "f",
                "executed"  => 'n',
                "tested"    => "n",
                "beginTime" => "",
                "endTime"   => ""
            }
            if args.empty?
                args = default_args
            else
                args.merge!(default_args).delete_if { |key, _value| key=="path"||key=="steps"|| key=="module" }
            end
            testcase_el.add_attributes(args)
        end

        # <TestSuites>
        #   <TestSuite>
        #     <name></name>
        #     <path></path>
        #     <TestCases "x"="","y"="","z"="">
        #        <TestCase>
        #          <name></name>
        #          <path></path>
        #        <TestCase>
        #     </TestCases>
        #   </TestSuite>
        #</TestSuites>
        #tc_names
        # -- Array,tc_names
        #attr_args
        # --Array,tc_attr
        def add_testcase(xmlpath, ts_name, ts_path, tc_names, tc_path, tc_module, attr_args, el_name="TestCase")
            testcases = add_testcases(ts_name, ts_path)
            tc_names.each_with_index { |tc_name, index|
                testcase = add_el(testcases, el_name)
                add_tcattr(testcase, attr_args[index])
                add_tc_name_path(testcase, tc_name, tc_path, tc_module)
            }
            save_xml(xmlpath)
        end

        #通过读取实际路径中脚本数据来生成xml add by liluping 2016/06/28
        def add_testcase_for_path(xmlpath, ts_name, ts_path, tc_hash, el_name="TestCase")
            testcases = add_testcases(ts_name, ts_path)
            tc_hash.each { |key, value|
                tc_path   = value["path"]
                tc_module = value["module"]
                testcase  = add_el(testcases, el_name)
                add_tcattr(testcase, value)
                add_tc_name_path(testcase, key, tc_path, tc_module)
            }
            save_xml(xmlpath)
        end

        #        <TestCase>
        #          <name></name>
        #          <path></path>
        #        <TestCase>
        def add_tc_name_path(testcase, tc_name, tc_path, tc_module)
            ts_name_el = add_el(testcase, "name")
            add_txt(ts_name_el, tc_name)
            ts_path_el = add_el(testcase, "path")
            add_txt(ts_path_el, tc_path)
            ts_module_el = add_el(testcase, "module")
            add_txt(ts_module_el, tc_module)
        end

        def total_xml(args)
            #add_ts_name_path(ts_name, tspath)
        end

        #保存xml
        def save_xml(xmlpath)
            open(xmlpath, "w") { |file|
                file.puts @doc.to_s
            }
        end

        #生成脚本模板的内容
        def creat_tc_template(tc_name, steps, tc_info)
            time           = Time.new.strftime("%Y-%m-%d %H:%M:%S")
            author_default = "wuhongliang"
            step_info      = create_operation(steps)
            content        = <<"EOF";
#
# description:
# author:#{author_default}
# date:#{time}
# modify:
#
    testcase{
      attr = {
        "level" => "",
        "name" => "",
        "auto" => ""
     }
    def prepare

    end

    def process

      #{step_info}

    end

    def clearup
    operate("1.恢复默认设置"){

    }
    end

    }
EOF
            content = content.sub(/\{\s*\"level\"\s*.*\"auto\"\s*=>\s*\"\"\s*\}/im, tc_info.to_s)
            filepath=@tcs_path+"/"+tc_name+".rb"
            File.open(filepath, "w+") { |file|
                file.puts content
            }
        end


        #生成脚本步骤
        def create_operation(steps)
            steps     = steps.split("\n")
            step_info = ""
            steps.each { |step|
                step      = step.encode("utf-8")
                step_info += "operate(\"#{step.strip}\") {
}\n\n"
            }
            step_info
        end

        # args = {
        #   tcname=>{"id"=>xxx,"level"=>xxx,"path"=>xxx,"steps"=>xxx},
        #   tcname=>{"id"=>xxx,"level"=>xxx,"path"=>xxx,"steps"=>xxx}
        # }
        def create_multi_tc_temp(args)
            args.each do |tc_name, tc_info|
                steps  = tc_info["steps"]
                tc_info= tc_info.delete_if { |key, _value| key=="path"|| key=="steps" }
                creat_tc_template(tc_name, steps, tc_info)
            end
        end

    end
end

if $0==__FILE__
    #############################解析excel文件############################################
    file_name="IAM用例_gaohui.xlsx"
    begin
        p exel_file = File.expand_path("../../../#{file_name}", __FILE__)
        p exel_file.encode("GBK")
        # p File.exists?(exel_file)
        excelobj =TestTool::Excel.new(exel_file)
        args     ={
            # :condition     => "一期|二期|三期|四期".encode("GBK"), #转成gbk
            # :condition_col => "F", #过滤条件列
            # :condition_col => "F",  #过滤条件列
            # :id_col        => ["D", "E"], #id列
            :name_col    => "C",
            :id_col      => ["D"], #id列
            :line        => "2", #从哪一行开始查找
            # :level_col     => "F", #用例优先级
            :level_col   => "E", #用例优先级

            :lines       => "1000", #到哪一行结束
            :sheet_index => 1, #表单编号
            :tc_path     => File.dirname(__FILE__),
            :step_col    => "i" #操作步骤列
            # :step_col      => "H"   #操作步骤列
        }

        # excelobj.create_tcname(args) #路由器用例模板
        p args
        excelobj.create_tcname_no_condtion(args) #IAM用例模板
        p testcases_hash = excelobj.testcase_hash
        p "用例数量:#{testcases_hash.keys.size}".encode("GBK")

        # testcases_hash.each { |key, value|
        #  	print key.encode("GBK"), "=>", value, "\n"
        #  }
        #print testcase["点击向导进入到向导页面 ZLBF_3.1.4"]["steps"].encode("GBK")
        excelobj.close_excel()
    rescue => ex
        puts ex.backtrace.join("\n")
        # excel.Quit
        excelobj.close_excel()
    end

    attr_args = {
        "auto"      => "n",
        "result"    => "f",
        "executed"  => 'n',
        "tested"    => "n",
        "beginTime" => "",
        "endTime"   => ""
    }
    xml       = TestTool::Template.new()

    ######################create tc templates####################
    #注意先创建tc模板再创建xml,因为创建xml会修改testcases_hash的内容会导致创建tc_temp失败
    p "######################create tc templates####################"
    xml.create_multi_tc_temp(testcases_hash)


    p "######################创建xml文件####################".encode("GBK")
    passwd_xml = "iam.xml"
    ts_name    = "manager"
    ts_path    = "../../iam_testcases"
    tc_names   = testcases_hash.keys
    attr_args  = testcases_hash.values
    tc_path    = "../../iam_testcases/internet"
    #tc_names = ["tc1", "tc2", "tc3", "tc4"]
    #tc_paths = ["tc1_path", "tc2_path", "tc3_path", "tc4_path"]
    xml.add_testcase(passwd_xml, ts_name, ts_path, tc_names, tc_path, ts_name, attr_args)
end
