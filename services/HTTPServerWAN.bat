@echo off
title "HTTP Server WAN"
ruby %cd%\HTTPServer\HTTPServer.rb "192.168.0.57" "80"
@echo. & pause 