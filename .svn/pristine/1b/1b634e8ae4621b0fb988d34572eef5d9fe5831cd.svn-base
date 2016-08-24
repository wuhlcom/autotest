#encoding:utf-8
# 解压缩
require "tardotgz"
class FruitRollup
    include Tardotgz
end

module HtmlTag
    module Tardotgz
        # 读取压缩文件中的内容
        def get_tgz_content(tgz_path, str)
            fr = FruitRollup.new
            fr.read_from_archive(tgz_path, /#{str}/)
        end
    end
end