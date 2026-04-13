:: Purpose-add [autorun alias commands] batch file
:: Author-Gerry
:: Date-2017-11-26

@echo off
setlocal ENABLEDELAYEDEXPANSION
echo.
cls
title Install auto run bashrc config file
echo.
echo $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
echo Welcome to use bashrc config install functionality
echo.
echo Info:
echo 1.Please run this script with administrator
echo.
echo $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
echo.
echo.

echo beginning write alias to file...
set filename=bashrc.cmd
set filepath=%userprofile%\%filename%
echo.
if exist %filepath% (
	echo recover file?
	set /p isYes="Yes[y] or No[n]:"
	if /i "!isYes!"=="n" (
		echo press any key to exit.
		pause
		exit /b 0
	)
)
set outLineNum=43
more +%outLineNum% %0 > %filepath%
echo creating file finished;path is:%filepath%
echo.
echo beginning write into reg...
reg add "HKCU\Software\Microsoft\Command Processor" /v AutoRun /d "%filepath%" /f > nul
echo installed.
pause
exit /b 0

:: set environment 
:: file auto run with windows started
:: if you need to delete autorun config.please delete AutoRun item under [HKCU\Software\Microsoft\Command Processor]
:: or AutoRun item under [HKCU\Software\Microsoft\Command Processor]
@echo off
doskey ls=dir /b $*
