#encoding:utf-8
require 'minitest/assertions'
module Minitest
		module Assertions

				# def mu_pp obj
				# 		if obj.kind_of?(String)
				# 				s = obj.encode("GBK")
				# 		else
				# 				s = obj.inspect
				# 				s = s.encode Encoding.default_external if defined? Encoding
				# 		end
				# 		s
				# end

				def assert test, msg = nil
						self.assertions += 1
						unless test then
								msg ||= "Failed assertion, no message given."
								msg = msg.call if Proc === msg
								msg=msg.to_gbk
								raise Minitest::Assertion, msg
						end
						true
				end

		end
end

# alias :orginal_raise :raise
# Kernel.send :define_method, :raise do |*args|
#   if args.kind_of?(String)
#     args = args.to_gbk
#     orginal_raise args
#     end
# end
