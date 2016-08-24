require 'active_record'
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'TestSuite'
#
# ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database  => ":memory:")
ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database  => "sqlite3_test.db")
ts = TsSuit.all
ts.each{|r|p r.ts_name}

require 'sqlite3'
sqldb = SQLite3::Database.new("sqlite3_test.db")
p sqldb.execute("select * from ts_suits")