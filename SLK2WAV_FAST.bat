@echo off
echo=#注意:
echo=	本方式是采用并发开启转换
echo=	可能对性能有相当的损耗
echo=	按任意键继续，否则请关闭
pause>nul

@"%~dp0\SLK2WAV.bat" /wav "%~1" /fast