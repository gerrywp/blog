+++
title = "iisexpress-config"
date = "2017-03-14"
tags = [ "tag1" ]
categories = [ "others" ]
+++

iisexpress轻量，易于安装，安装包不到5M。
<!--more-->
### 全局配置文件

默认情况下IIS Express使用的配置文件位于"我的文档"中，路径如下:"我的文档\IIS Express\Config"。

```shell
%homepath%\documents\iisexpress\config
```

其中，applicationhost.config 是核心的配置文件，它用于承载站点的定义、应用程序和应用程序池以及整个WEB服务器的配置。

### 项目配置文件

visual studio web项目自身的IIS Express配置文件,放置在项目文件夹下的隐藏文件夹下，路径如下:"project\.vs\config\applicationhost.config"
针对项目自身的站点的配置都在这里面。
1. <sites>下面的每一个<site>就是一个站点。
2. <bindings>设置了这个站点的绑定信息。
3. <application> 这个节设置了站点使用的的应用程序池。
