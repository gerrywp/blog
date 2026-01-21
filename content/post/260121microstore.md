+++
title = "代理后微软商店无法打开UWP"
date = "2026-01-21"
tags = [ "tool" ]
categories = [ "windows" ]
+++
落地开花，富贵荣华。2026加油！
<!--more-->

开启代理后微软商店打不开，主要原因是 UWP 应用（如 Microsoft Store）默认无法将流量回环到本地代理端口。解决方法是启用 Loopback 功能，例如使用 EnableLoopback.exe 或系统自带的 CheckNetIsolation.exe，在其中勾选 Microsoft Store 应用即可恢复正常联网。
### 问题成因
* UWP 应用的网络隔离：Microsoft Store、OneDrive、Outlook 等基于 AppContainer 环境运行，默认不允许访问 localhost:代理端口。

* 开启代理后：普通浏览器和桌面应用能正常走代理，但 UWP 应用会直接报“无法联网”或打不开。

### 使用Clash Verge
如图所示：
![设置](../../pictures/Snipaste_2026-01-21_09-50-19.png 'Clash设置')

### edge浏览器无法打开Copilot
需要翻墙才能访问，需要手动将copilot.microsoft.com添加到clash代理规则里面去。

订阅->右键规则，添加新的规则即可
![订阅](../../pictures/Snipaste_2026-01-21_10-21-00.png '编辑规则')

### 参考链接

> 1. https://blog.csdn.net/qq_42679415/article/details/146424251?utm_source=copilot.com

