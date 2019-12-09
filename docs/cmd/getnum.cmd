:: Name: getnum.cmd
:: Purpose: used to generate num from 1to9 that plus total =2016
:: Author: Gerry Wang
:: Version: 2017-03-21 20:35
::			v1.0

@echo off
setlocal enableextensions ENABLEDELAYEDEXPANSION
call :initArray numArr
set /A count=0
::numArr 0 2
for /F "delims==[] tokens=2,3" %%a in ('set numArr') do (
	::delete item
	call :initArray left7
	set left7[%%a]=
	for /F "delims==[] tokens=2,3" %%c in ('set left7') do (
		call :initArray left6
		set left6[%%a]=
		set left6[%%c]=
		for /F "delims==[] tokens=2,3" %%e in ('set left6') do (
				set /A fourNum=1000+%%b*100+%%d*10+%%f
				call :initArray left5
				set left5[%%a]=
				set left5[%%c]=
				set left5[%%e]=
				for /F "delims==[] tokens=2,3" %%g in ('set left5') do (
					call :initArray left4
					set left4[%%a]=
					set left4[%%c]=
					set left4[%%e]=
					set left4[%%g]=
					for /F "delims==[] tokens=2,3" %%i in ('set left4') do (
						call :initArray left3
						set left3[%%a]=
						set left3[%%c]=
						set left3[%%e]=
						set left3[%%g]=
						set left3[%%i]=
						for /F "delims==[] tokens=2,3" %%k in ('set left3') do (
							set /A threeNum=%%h*100+%%j*10+%%l
							call :initArray left2
							set left2[%%a]=
							set left2[%%c]=
							set left2[%%e]=
							set left2[%%g]=
							set left2[%%i]=
							set left2[%%k]=
							for /F "delims==[] tokens=2,3" %%m in ('set left2') do (
								call :initArray left1
								set left1[%%a]=
								set left1[%%c]=
								set left1[%%e]=
								set left1[%%g]=
								set left1[%%i]=
								set left1[%%k]=
								set left1[%%m]=
								for /F "delims==[] tokens=2,3" %%o in ('set left1') do (
									set /A twoNum=%%n*10+%%p
									set /A result=fourNum+threeNum+twoNum
									::echo !fourNum!+!threeNum!+!twoNum!=!result!
									if "!result!" EQU "2016" (
										echo !fourNum!+!threeNum!+!twoNum!=!result! 
										set /A count=!count!+1
									)
								)
							)
						)
					)
				)
		)
	)
)
echo "have done total count is :%count%"
pause
:end
endlocal
echo on
@exit /B 0

:: a function to initial array
:initArray
if not "%~1"=="" (
	set index=0
	for /L %%i in (2,1,9) do (
		set /A %~1[!index!]=%%i
		set /A index=!index!+1
	)
) else (
	echo "please input array-name"
	set errorno=1
)

exit /B %errorno%