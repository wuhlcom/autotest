require 'serialport'
port       = 2
args       ={"baud" => 57600, "data_bits" => 8, "stop_bits" => 1, "parity" => SerialPort::NONE}
serial_obj = SerialPort.new(port, args)
serial_obj.read_timeout=1000 #指定接收多久数据
# serial_obj.write("top\n")
serial_obj.write("free\n")
p "111111111111111111111111"
sleep 2
# print serial_obj.read
# serial_obj.write("\cc\n") #Ctrl-c
serial_obj.write("\C-c\n") #Ctrl-c
p "222222222222222222222"
print serial_obj.read
# p "197".chr