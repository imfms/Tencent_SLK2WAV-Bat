@echo off
setlocal ENABLEDELAYEDEXPANSION
set "path=%path%;%~dp0\bin"
set version=20161203
title QQ_SLK2WAV QQ音频文件slk转wav批处理工具 ^| F_Ms - %version% ^| f-ms.cn

REM 输出格式设置
if /i "%~1"=="/mp3" (
	REM MP3
	set "outputFormat=mp3"
	set "formatMinSize=1"
	shift/1
) else if /i "%~1"=="/wav" (
	REM DEFAULT WAV
	set "outputFormat=wav"
	set "formatMinSize=40000"
	shift/1
) else (
	REM WAV
	set "outputFormat=wav"
	set "formatMinSize=40000"
)

REM 判断运行环境
if "%~1"=="" (
	echo=#简介
	echo=		 QQ_SLK2WAV
	echo=
	echo=     腾讯qq语音音频文件slk转wav批处理工具
	echo=  作者：F_Ms ^| 博客：f-ms.cn ^| 版本：%version%
	echo=
	echo=#使用方法：
	echo=	将要转换的QQ语音音频文件^(.slk^)或文件夹
	echo=	   拖动到本程序文件上即可^(非本窗口^)
	pause>nul
	exit/b
) else if not exist "%~1" if not exist "%~1\" (
	echo=#简介
	echo=		 QQ_SLK2WAV
	echo=
	echo=     腾讯qq语音音频文件slk转wav批处理工具
	echo=  作者：F_Ms ^| 博客：f-ms.cn ^| 版本：%version%
	echo=
	echo=#警告：
	echo=	指定文件或文件夹不存在
	pause>nul
	exit/b
)

color 0a
echo=
echo=#简介
echo=
echo=		 QQ_SLK2WAV
echo=
echo=     腾讯qq语音音频文件slk转wav批处理工具
echo=
echo=	  -使用到的第三方命令行工具-
echo=	      split(textutils)
echo=	  SilkDecoder(无原作者信息)
echo=	  FFmpeg (FFmpegDevelopers)
echo=	             敬上
echo=
echo=  作者：F_Ms ^| 博客：f-ms.cn ^| 版本：%version%
echo=
echo=#转换开始
echo=

REM 单文件转换
if not exist "%~1\" (
	REM 将转换路径设置为源文件路径下新文件夹内
	set "descDir=%~dpnx1"
	set "errorListFile=%~1.convert_error_infor.txt"
	
	call convert.bat "%~1" "!descDir!_after_convert" "!errorListFile!"
	
	if "%~2"=="/fast" shift/2
	goto convertEnd
)

REM 相对全路径中截取子路径变量
set "baseDir=%~1"
if not "%baseDir:~-1%"=="\" set "baseDir=%baseDir%\"

REM 转换结果目录
set "descDir=%~1"
if "%descDir:~-1%"=="\" set "descDir=%descDir:~0,-1%"
set "descDir=%descDir%_after_convert\"

REM 转换错误信息路径
set "errorListFile=%baseDir:~0,-1%.convert_error_list.txt"

REM 目录遍历转换
for /r "%~1\" %%a in (*) do if exist "%%~a" (
	REM 将装换路径设置为原路径下新文件夹内,如果有子文件夹则拼合到新文件夹下
	set "targetDir=%%~dpa"
	set "targetDir=!targetDir:%baseDir%=!"
	
	if /i "%~2"=="/FAST" (
		echo=	-^> %%~a
		start /min cmd /c convert.bat "%%~a" "%descDir%!targetDir!" "%errorListFile%"
	) else call convert.bat "%%~a" "%descDir%!targetDir!" "%errorListFile%"
	
)

:convertEnd

REM 正常模式
if /i not "%~2"=="/FAST" (
	REM 如果有错误日志则打开错误日志
	if exist "%errorListFile%" start "" "%errorListFile%"
	
	echo=#转换结束
	echo=
) else (
	echo=#并发命令传输结束, 请关注后台
	echo=
)
pause>nul

exit/b