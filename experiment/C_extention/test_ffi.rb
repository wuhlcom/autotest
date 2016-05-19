require 'ffi'

module Hello
  extend FFI::Library
  ffi_lib FFI::Library::LIBC
  attach_function :puts, [ :string ], :int
end

# Hello.puts("Hello, World")

#################################################################
module HelloWin
  extend FFI::Library

  ffi_lib 'user32'
  ffi_convention :stdcall

  attach_function :message_box, :MessageBoxA,[ :pointer, :string, :string, :uint ], :int
end

rc = HelloWin.message_box nil, 'Hello Windows!', 'FFI on Windows', 1
puts "Return code: #{rc}"