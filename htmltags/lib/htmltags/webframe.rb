#encoding:utf-8
module HtmlTag
	module WebFrame
		def testsuite(&block)
			block.call
		end

		def testcase(str="")
			puts str.encode("GBK")
			yield
		end

	end
end
