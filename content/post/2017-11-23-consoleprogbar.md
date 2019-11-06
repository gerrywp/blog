+++
title = "console应用程序progressbar（进度条的实现）"
date = "2017-11-23"
tags = [ "tag1" ]
categories = [ "csharp" ]
+++

　　控制台应用程序，有时候需要做文件上传、压缩等(网络/磁盘)I/O处理。为了得到更友好的界面交互，所以需要用到progress bar 进度条。
github上有很多现成的可以使用。
<!--more-->
### 实现机制

使用的主要方法:
1. `Console.SetCursourPosition()`

定位光标的位置，在同一个位置上覆盖输出数据即可！

### nodejs下的console应用程序实现机制也是一样的

1. `process.stderr`
2. `stderr.cursorTo(0)`
3. `stderr.clearLine(1)`

参考一下nodejs官方文档的：

[process_process_stderr](https://nodejs.org/dist/latest-v8.x/docs/api/process.html#process_process_stderr "点我访问")

`process.stderr` 是[Writable Streams] `stream` 对象的实例。所有的`stream`对象都继承自`EventEmitter`，可以监听事件！

[stream_writable_streams](https://nodejs.org/dist/latest-v8.x/docs/api/stream.html#stream_writable_streams "点我访问")

> 参考

1. [shellprogressbar](https://github.com/Mpdreamz/shellprogressbar "点我访问")
2. [用C#实现控制台进度条](http://www.cnblogs.com/zhanghuabin/p/5310680.html "点我访问")
3. [node-progress](https://github.com/visionmedia/node-progress "点我访问")
