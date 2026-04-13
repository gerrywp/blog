:: Purpose-add [git bash here] to right-click menu
:: Author:Gerry
:: Date:2017-7-7

@echo off
setlocal ENABLEDELAYEDEXPANSION
echo.
cls
title Install git "right-click" menu
echo.
echo $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
echo       Welcome to installing "git-bash here" right-click feature  
echo.                                             
echo       Info:                               
echo   	   1.Please run this script with administrator              
echo.                                             
echo $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
echo.
echo.

set fileName=git-bash.exe
echo Input:(i)or(u)
: predicate
set /p isInstall="Install(i).Uninstall(u). "
if /i not "%isInstall%"=="i" (
    if /i not "%isInstall%"=="u" (
        echo Input wrong，please typein again!
        goto predicate
    ) else (
    reg delete HKCR\Directory\Background\shell\GitBash /f > nul &&^
reg delete HKCR\Directory\Background\shell\GitUI /f >nul &&^
echo Uninstall Successfully!
        rem if !ERRORLEVEL! EQU 0 ( echo "Uninstall Successfully！" )
    )
) else (
    rem "> nul 2>&1"
    : typePath
rem    for %%i in (C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
rem    if exist %%i:\ (
rem    for /f "delims=" %%j in ('where /r %%i: "%fileName%" 2^>nul') do (
rem    if /i "%%~nxj" equ "%fileName%" (
rem    set gitPath=%%~dpj
rem    )
rem    )
rem    )
rem    )
    echo Installing，wait a moment...
    set gitPath=undefined
    for %%i in (C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
        if exist %%i:\ (
            if "!gitPath!" EQU "undefined" (
                pushd %%i:\
                for /r %%j in (*%fileName%) do (
                    if /i "%%~nxj" EQU "%fileName%" (
                        set gitPath=%%~dpj
                    )
                )
                popd
            )
        )
    )
    if "!gitPath!" EQU "undefined" (
        echo Make sure that. did you have installed Git for windows?
        pause
        exit /B 0
    )
    set sysBit=32
    echo %processor_architecture% | find "64" >nul && if %errorlevel% equ 0 (set sysBit=64)
    reg add HKCR\Directory\Background\shell\GitBash /ve /d "Git Bash Here" /f  > nul &&^
reg add HKCR\Directory\Background\shell\GitBash /v "Icon" /d "!gitPath!mingw!sysBit!\share\git\git-for-windows.ico" /f > nul &&^
reg add HKCR\Directory\Background\shell\GitBash\command /ve /d "!gitPath!git-bash.exe" /f > nul &&^
reg add HKCR\Directory\Background\shell\GitUI /ve /d "Git UI Here" /f  > nul &&^
reg add HKCR\Directory\Background\shell\GitUI /v "Icon" /d "!gitPath!mingw!sysBit!\share\git\git-for-windows.ico" /f > nul &&^
reg add HKCR\Directory\Background\shell\GitUI\command /ve /d "!gitPath!cmd\git-gui.exe" /f > nul &&^
echo Install Successfully!
)

pause
exit /B 0
