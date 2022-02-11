+++
title = "Redmine部署"
date = "2022-01-22"
tags = [ "bug" ]
categories = [ "pm" ]
+++
不识庐山真面目，只缘身在此山中。
<!--more-->
### 安装Ruby
Redmine是基于Ruby on Rails开发的，参考官方文档，我们需要先在服务器上安装ruby环境。
因为redmine版本4.2，所以需要选择正确的版本，这里选择2.6.0。

必须通过**rubyinstaller-devkit-2.6.0-1-x64.exe**安装**MSYS2 development toolchain**，如图：
![MSYS](../../pictures/C612EBD2-CA9B-4a48-AEAA-0A0EC8758574.png '点我访问')
下面这一步千万不能跳过
![MSYS](../../pictures/35859B89-3453-44af-81EF-3E8789A66E6A.png '点我访问')
本来打算跳过之后通过在cmd中运行
```sh
ridk install
```
安装，是万万不行的，这里踩坑后浪费了大量的时间。
如果这里没有安装后面用`bundle`或者`gem`安装依赖包会报ssl证书失效的错误。

### 安装Rails
```sh
gem install rails -v 5.2.6
```
或者使用`bundle`依据gemfile安装project的依赖包

`gem`是`ruby`的包管理器，`bundle`是ruby的依赖管理器，其它依据redmine[官网](https://www.redmine.org/projects/redmine/wiki/RedmineInstall '点我访问')一步一步操作即可。

```sh
bundle install --without development test
```
### 安装mysql
1. 配置账号可以远程访问
2. 创建redmine数据库、用户并配置权限

### 参考

> https://loof.ca/blog/ruby/gems-bundler/

> https://cloud.tencent.com/developer/article/1596045
