module Autoload
	module A
		autoload(:B, './autoload_testb')
	end
end
p Autoload
p Autoload::A::Autoload_testb.method1
