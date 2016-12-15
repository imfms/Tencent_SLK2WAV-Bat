@echo off
setlocal ENABLEDELAYEDEXPANSION

REM 主子程序 call:convert "待转换文件" "转换结束目标路径"
:convert
cd /d "%~dp1"
set/p=^|	正在转换: "%~1" ^> <nul

REM 变量初始化
for %%a in (yuanFile tempFile newWavFileName fileTargetPath convertFailFileList) do set %%a=
set "fileTargetPath=%~2"
set "convertFailFileList=%~3"
set "yuanFile=%~1"
for /f "delims=" %%a in ("%yuanFile%") do (
	set "newWavFileName=%%~na.%outputFormat%"
	set "tempFile=%%~na"
)
set "tempFile=%tempFile: =%"

REM 文件前期处理
call:fileSizeTrue 50 "%~1"
if "%errorlevel%"=="0" (
	echo= #空文件,已跳过
	call:writeErrorLog 空文件 "%~1"
	exit/b 1
)

call:checkFileHeader "%~1"
if "%errorlevel%"=="0" (
	set tempFileSlk2Pcm=%~1
	set tempFilePcm2Wav=%~1.pcm
	goto passSplit
) else if "%errorlevel%"=="1" (
	echo= #文件头信息错误,已跳过
	call:writeErrorLog 文件类型错误	"%~1"
	exit/b 1
) else if "%errorlevel%"=="2" (
	echo= # AMR格式为通用格式,已跳过
	REM 拷贝直接拷贝源文件到目标路径
	if not exist "%fileTargetPath%" md "%fileTargetPath%"
	copy "%~1" "%fileTargetPath%\%newWavFileName%.amr">nul 2>nul
	call:writeErrorLog 通用音频格式	"%~1"
	exit/b 1
)
REM 裁剪无用文件头
call:GetFileSplitSize "%yuanFile%"
if not "%errorlevel%"=="0" (
	echo= #转换失败,疑似文件权限不足
	call:writeErrorLog 无访问权限	"%~1"
)
:passSplit

REM slk2pcm转换
call:slk2pcm "%tempFileSlk2Pcm%" "%tempFilePcm2Wav%"
if not "%errorlevel%"=="0" (
	set kbps=16000
	set tempFilePcm2Wav=%yuanFile%
	goto passSlk2Pcm
)
REM pcm2wav转换
set kbps=
set kbps=44100
:passSlk2Pcm
if not exist "%fileTargetPath%" md "%fileTargetPath%"
call:pcm2wav %kbps% "%tempFilePcm2Wav%" "%fileTargetPath%\%newWavFileName%"
if not "%errorlevel%"=="0" (
	echo= #转换失败,疑似指定文件编码类型错误
	call:writeErrorLog 文件编码错误	"%~1"
	call:DeleteTempFile
	exit/b 1
)

REM 判断是否真正执行成功
call:fileSizeTrue %formatMinSize% "%fileTargetPath%\%newWavFileName%"
if "%errorlevel%"=="0" if "%kbps%"=="44100" (
	set kbps=16000
	set tempFilePcm2Wav=%yuanFile%
	goto passSlk2Pcm
)
if "%errorlevel%"=="0" (
	if exist "%fileTargetPath%\%newWavFileName%" del /f /q "%fileTargetPath%\%newWavFileName%"
	echo= #转换失败,未知错误
	call:writeErrorLog 未知错误	"%~1"
	call:DeleteTempFile
	exit/b 1
)

echo= 转换成功
call:DeleteTempFile
exit/b 0

REM 检查文件文件头，是否为QQ语音文件 call:checkFileHeader file
REM 	返回值：1 - 指定文件错误, 2 - AMR文件, 3 - slk需要截首字节 0 - slk无需截首字节
:checkFileHeader
set fileHeaderTemp=
set /p fileHeaderTemp=<"%~1"
if not defined fileHeaderTemp exit/b 1
if /i "%fileHeaderTemp:~0,5%"=="#!AMR" exit/b 2
if /i "%fileHeaderTemp:~0,10%"=="#!SILK_V3" exit/b 3
if /i "%fileHeaderTemp:~0,9%"=="#!SILK_V3" exit/b 0
exit/b 1


REM 文件前期处理(去除首个字节) call:GetFileSplitSize "%yuanFile%"
:GetFileSplitSize
REM 获取文件后期裁剪长度
set fileSize=0
for  %%a in ("%~1") do set /a fileSize=%%~za+1
set tempFileSlk2Pcm=%tempFile%_ab
set tempFilePcm2Wav=%tempFile%_ab.pcm

REM 处理文件为双倍的长度
copy "%~1" "%~1_2" 0>nul 1>nul 2>nul
if not "%errorlevel%"=="0" exit/b %errorlevel%
copy /b "%~1"+"%~1_2" "%~1_3" 0>nul 1>nul 2>nul
if not "%errorlevel%"=="0" exit/b %errorlevel%
split -b %fileSize% "%~1_3" %tempFile%_ 0>nul 1>nul 2>nul
if not "%errorlevel%"=="0" exit/b %errorlevel%
exit/b 0

REM 判断结果是否为空文件 call:fileSizeTrue size file
REM   返回值：0 - 空, 1 - 非空
:fileSizeTrue
if not exist "%~2" exit/b 0
for %%a in ("%~2") do (
	if %%~za leq %~1 exit/b 0
)
exit/b 1

REM 删除临时文件 call:DeleteTempFile
:DeleteTempFile
for %%a in ("%yuanFile%_2","%yuanFile%_3","%tempFile%_aa" "%tempFile%_ab" "%tempFile%_ab.pcm" "%yuanFile%.pcm") do if exist "%%~a" del /f /q "%%~a"
exit/b 0

REM slk2pcm转换 call:slk2pcm inputFile outputFile
:slk2pcm
slk2pcm.exe "%~1" "%~2" -Fs_API 44100 0>nul 1>nul 2>nul
exit/b %errorlevel%

REM pcm2wav转换 call:pcm2wav 比特率 inputFile outputFile
:pcm2wav
if exist "%~3" del /f /q "%~3"
pcm2wav.exe -f s16le -ar %~1 -ac 1 -i "%~2" -ar 44100 -ac 2 -f %outputFormat% "%~3" 0>nul 1>nul 2>nul
exit/b %errorlevel%

REM 错误日志写入 错误类型 错误文件
:writeErrorLog
if not defined convertFailFileList exit/b

REM 写入错误文件头
if not exist "%convertFailFileList%" echo=#转换错误日志>"%convertFailFileList%"

REM 写入错误主题
echo=	"%~2"	%~1>>"%convertFailFileList%"
exit/b
