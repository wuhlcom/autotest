@echo off
title "HTTP Server WAN"
ruby %cd%\HTTPServer\HTTPServer.rb "192.168.1.57" "80"
@echo. & pause 