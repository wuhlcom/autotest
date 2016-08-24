require 'ffi'

module Hello
  extend FFI::Library
  ffi_lib FFI::Library::LIBC
  attach_function :puts, [:string], :int
end

# Hello.puts("Hello, World")
#################################################################
# module HelloWin
#   extend FFI::Library
#   ffi_lib 'user32'
#   ffi_convention :stdcall
#
#   attach_function :message_box, :MessageBoxA,[ :pointer, :string, :string, :uint ], :int
# end
#
# rc = HelloWin.message_box nil, 'Hello Windows!', 'FFI on Windows', 1
# puts "Return code: #{rc}"
#########################
# Send a keystroke
module Win
  VK_VOLUME_DOWN = 0xAE; VK_VOLUME_UP = 0xAF; VK_VOLUME_MUTE = 0xAD; KEYEVENTF_KEYUP = 2

  extend FFI::Library
  ffi_lib 'user32'
  ffi_convention :stdcall

  attach_function :keybd_event, [:uchar, :uchar, :int, :pointer], :void

  # simulate pressing the mute key on the keyboard
  keybd_event(VK_VOLUME_MUTE, 0, 0, nil);
  keybd_event(VK_VOLUME_MUTE, 0, KEYEVENTF_KEYUP, nil);

end
# System Local Time
# This example shows the common task of calling a native function with a pointer to a new struct,
# then using that same struct once it has been populated and returned by the native function.
require 'ffi'

module Win
  extend FFI::Library

  class SystemTime < FFI::Struct
    layout :year, :ushort,
           :month, :ushort,
           :day_of_week, :ushort,
           :day, :ushort,
           :hour, :ushort,
           :minute, :ushort,
           :second, :ushort,
           :millis, :ushort
  end

  ffi_lib 'kernel32'
  ffi_convention :stdcall
  # attach_function :localtime,:GetLocalTime, [ :pointer ], :void
  attach_function :GetLocalTime, [:pointer], :void
end

mytime = Win::SystemTime.new
Win.GetLocalTime(mytime)
# Win.localtime(mytime)
args = [
    mytime[:month], mytime[:day], mytime[:year],
    mytime[:hour], mytime[:minute], mytime[:second]
]

puts "Date: %u/%u/%u\nTime: %02u:%02u:%02u" % args