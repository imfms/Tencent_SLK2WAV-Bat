@echo off

set version=20161203
title 更改文件名为其创建时间 ^| F_Ms - %version% ^| f-ms.cn
color 0a

if "%1"=="" (
	echo=#本工具可以将目录中的文件名称修改为该文件的创建时间
	echo=
	echo=	本意用于更改微信导出后的语音文件名称
	echo=
	echo=#错误: 未指定目录, 将目录拖动到本程序即可
	pause
	exit/b 0
) else if not exist "%~1" (
	echo=#本工具可以将目录中的文件名称修改为该文件的创建时间
	echo=
	echo=	本意用于更改微信导出后的语音文件名称
	echo=
	echo=#错误: 指定目录不存在
	echo=	"%~1"
	pause
	exit/b 0
)

echo=#正在更改
echo=

REM 单文件
if not exist "%~1\" (
	call:fileName2Time "%~1"
) else for /r "%~1\" %%a in (*) do if exist "%%~a" call:fileName2Time "%%~a"

echo=
echo=#更改完成
pause>nul

::-------------------------------------子程序-------------------------------------::
goto end

REM 修改指定文件名为该文件的时间
REM call:fileName2Time File
:fileName2Time

call:getFileTime "%~1"

set fileTimeName=%fileTimeName%_%random%%random%

REM 获取文件扩展名
set fileExName=
for %%B in ("%~1") do set fileExName=%%~xB
if defined fileExName (
	set fileTimeName=%fileTimeName%%fileExName%
)

REM 执行文件名更改
echo=^| "%~1" -^> %fileTimeName%
ren "%~1" %fileTimeName%

exit/b 0


REM 获取文件时间
REM call:getFileTime File
:getFileTime
 
set fileTimeName=
for %%A in ("%~1") do (
	set "fileTimeName=%%~tA"
)
set fileTimeName=%fileTimeName: =%
set fileTimeName=%fileTimeName::=%
set fileTimeName=%fileTimeName:/=%
exit/b 0

:end