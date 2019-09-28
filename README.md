`V0.5` `20161203`
# Tencent_SLK2WAV

[直接下载](https://github.com/imfms/Tencent_SLK2WAV-Bat/releases)

## 功能简介
本工具用于转换腾讯系列产品语音文件(slk格式)为通用格式wav、mp3
使用了以下三方工具，在此感谢原作者的辛劳付出

- FFmpeg
	- [FFmpeg developers](http://ffmpeg.org/)
- slk2pcm
	- https://tools.ietf.org/html/draft-vos-silk-02#page-545
- split
	- Torbjorn Granlund 
	- Richard M. Stallman

### 功能列表

- `SLK2WAV.bat` SLK转换为WAV格式工具
- `SLK2WAV_FAST.bat` SLK转换为WAV格式工具_快速并发模式(并发数无限制,可能会使机器卡顿)
- `SLK2MP3.bat` SLK转换为MP3格式工具
- `SLK2MP3_FAST.bat` SLK转换为为Mp3格式工具_快速并发模式(并发数无限制,可能会使机器卡顿)

- `tool\FileName2CreateTime.bat` 小工具：更改文件名为其修改时间，微信、PCQQ音频存储为加密码，在分类时不太容易分辨，可以使用此工具进行重命名

## 使用方法

直接将语音音频文件或包含语音音频文件的目录`拖拽到指定功能程序上`即可

![](img/help.gif)
	
### 各客户端语音文件位置
- Android版QQ
	
		/sdcard/Tencent/MobileQQ/*QQ号*/ptt/*

- PC版QQ

		当前登录用户我的文档路径\Tencent Files\532273319\Audio\*

- 微信

		/sdcard/Tencent/MicroMsg\*最长的文件夹(密文长码)*\voices2

## 注意事项

1. 转换期间如有错误崩溃提示直接确定忽略即可，内部算法当一种方案无法施行时会切换到另一种方案进行转换
2. 并发模式转换可能造成电脑卡顿
3. 某些包含特殊符号文件名的文件可能会无法转换

## 相关链接
- [silk2pcm](https://tools.ietf.org/html/draft-vos-silk-02#page-545) silk2pcm
- [ffmpeg](http://ffmpeg.org/) 伟大开源解码工具
- [FolderListToCallBack-Bat](https://github.com/imfms/FolderListToCallBack-Bat) 遍历文件夹工具
