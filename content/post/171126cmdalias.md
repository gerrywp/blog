+++
title = "cmd实现类似linux下的alias并模拟加载bashrc文件"
date = "2017-11-26"
tags = [ "shell" ]
categories = [ "windows" ]
+++

　　cmd可以使用`doskey`命令来定义命令的别名，但是windows要实现自动加载配置文件，似乎只能通过修改注册表来达到目的。
<!--more-->
### 实现dir的别名`ls`

```bash
# 创建批处理文件bashrc.cmd,内容如下
@echo off
doskey ls=dir /b $*
# $* 代表ls命令后面还可以带其他的参数。如:ls /d
```

### 让bashrc.cmd命令开机自动启动

实现这个功能需要修改注册表,在[HKEY_LOCAL_MACHINE]\[Software\Microsoft]\[Command Processor]或者「HKEY_CURRENT_USER」下，添加项"AutoRun",值为bashrc.cmd的绝对路径。  
提供一个批处理文件来实现这个功能：

批处理文件下载地址：[实现别名并开机启动](../assets/bashrc.cmd "点我下载")
一定要使用ASIN编码

```bash
:: Purpose-add [autorun alias commands] batch file
:: Author-Gerry
:: Date-2017年11月26日

@echo off
:: 开启变量延迟(必须开启，养成良好习惯),默认变量扩展ENABLEEXTENSIONS是开启的
setlocal ENABLEDELAYEDEXPANSION
echo.
cls
title 安装开机启动类bashrc配置文件
echo.
echo $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
echo       欢迎使用bashrc配置文件安装功能         
echo.                                             
echo       使用指南:                              
echo       1.请使用管理员权限执行脚本
echo.                                             
echo $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
echo.
echo.

echo 开始写入别名到文件...
set filename=bashrc.cmd
set filepath=%userprofile%\%filename%
echo.
set outLineNum=35
del /f /q %filepath%
more +%outLineNum% %0 >> %filepath%
echo 文件创建完成！路径为:%filepath%
echo.
echo 开始写入注册表...
reg add "HKEY_CURRENT_USER\Software\Microsoft\Command Processor" /v AutoRun /d %filepath% /f > nul
echo 安装已完成.
pause
exit /b 0

:: 配置系统环境变量
:: 此配置文件会随windows开机启动
:: 如需删除启动项，请手动删除「HKEY_CURRENT_USER\Software\Microsoft\Command Processor」下的AutoRun
:: 如需删除启动项，请手动删除「HKCU\Software\Microsoft\Command Processor」下的AutoRun
@echo off
doskey ls=dir /b $*
```
