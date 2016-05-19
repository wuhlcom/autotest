# Configure the serial port. You can pass a hash or multiple values as separate arguments. Invalid or unsupported values will raise an ArgumentError.
#  When using a hash the following keys are recognized:
#
# “baud”
# Integer from 50 to 256000, depending on platform
# “data_bits”
# Integer from 5 to 8 (4 is allowed on Windows too)
# “stop_bits”
# Integer, only allowed values are 1 or 2 (1.5 is not supported)
# “parity”
# One of the constants NONE, EVEN or ODD (Windows allows also MARK and SPACE)
# When using separate arguments, they are interpreted as:
#  (baud, data_bits = 8, stop_bits = 1, parity = (previous_databits == 8 ? NONE : EVEN))
# NONE =# 		0# INT2FIX(NONE) #校验 无校验
# HARD =# 		1# INT2FIX(HARD)
# SOFT =# 		2# INT2FIX(SOFT)
# SPACE =# 		0# INT2FIX(SPACE) #校验 空白
# MARK =# 		1# INT2FIX(MARK) #校验 标记
# EVEN =# 		2# INT2FIX(EVEN) #校验 偶数
# ODD =# 		3# INT2FIX(ODD)    #校验 奇数

require 'serialport'
require 'pp'
port       = 2
args       ={"baud" => 57600, "data_bits" => 8, "stop_bits" => 1, "parity" => SerialPort::NONE}
##################new
serial_obj = SerialPort.new(port, args)
# serial_obj.read_timeout
p serial_obj.read_timeout=5000
# serial_obj.write("\x0003")
serial_obj.write("reboot\n")
p "="*30
# serial_obj.write("ifconfig\n")
 # serial_obj.write("top\n")
# serial_obj.write("reboot\n")
print serial_obj.read

# p serial_obj.flow_control
# p serial_obj.dsr
# # p serial_obj.dtr
# # p serial_obj.rts
# p serial_obj.cts
#################open##############
# SerialPort.open(port, args) { |serial_obj|
# 	serial_obj.read_timeout=100
# p serial_obj.flow_control
# p serial_obj.dsr
# p serial_obj.dtr
# p serial_obj.rts
# 	p serial_obj.cts
# p serial_obj.get_signals
# p serial_obj.modem_params
# p serial_obj.get_modem_params
# p serial_obj.flush_input
# p serial_obj.flush_output
# serial_obj.write("\n")
# serial_obj.write("top\n")
# serial_obj.write("0x03")
# sleep 1
# print serial_obj.read
# p serial_obj.gets
# serial_obj.print "AI"
# p "="*30
# p serial_obj.class
# pp serial_obj.class.instance_methods(false).sort
# pp serial_obj.methods(false).sort
# p serial_obj.readlines
# }
