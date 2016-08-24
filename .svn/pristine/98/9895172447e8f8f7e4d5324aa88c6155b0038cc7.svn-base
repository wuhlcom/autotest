require 'ffi'
module Win
  extend FFI::Library

  ffi_lib 'user32'
  ffi_convention :stdcall

  # BOOL CALLBACK EnumWindowProc(HWND hwnd, LPARAM lParam)
  callback :enum_callback, [ :pointer, :long ], :bool

  # BOOL WINAPI EnumDesktopWindows(HDESK hDesktop, WNDENUMPROC lpfn, LPARAM lParam)
  attach_function :enum_desktop_windows, :EnumDesktopWindows,
                  [ :pointer, :enum_callback, :long ], :bool

  # int GetWindowTextA(HWND hWnd, LPTSTR lpString, int nMaxCount)
  attach_function :get_window_text, :GetWindowTextA,
                  [ :pointer, :pointer, :int ], :int
end

win_count = 0
title = FFI::MemoryPointer.new :char, 512

Win::EnumWindowCallback = Proc.new do |wnd, param|
  title.clear
  p wnd
  Win.get_window_text(wnd, title, title.size)
  puts "[%03i] Found '%s'" % [ win_count += 1, title.get_string(0) ]
  true
end

if not Win.enum_desktop_windows(nil, Win::EnumWindowCallback, 0)
  puts 'Unable to enumerate current desktop\'s top-level windows'
end