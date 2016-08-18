require 'active_record'
require 'sqlite3/sqlite3_native'
ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database  => ":memory:")
ActiveRecord::Base.logger = Logger.new(File.open('d:/database.log', 'a'))
class ErrCode < ActiveRecord::Base
end

p user = ErrCode.find(1)
