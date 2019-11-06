+++
title = "Linux守护进程和自启动"
date = "2018-02-23"
tags = [ "tag1" ]
categories = [ "linux" ]
+++

　　Linux的服务也是以etc配置的形式完成的，启动一个daemon(守护进程)来提供service(服务)。服务的管理是一个既复杂又细致的工作，Linux提供了两种方式来
管理服务：一种是透过`systemctl`这一个命令管理服务，另一种是透过`service`来管理服务的启动、停止、重启等等，透过`chkconfig`来管理服务的开机启动与否。
在此以`systemctl`应用出来之前和`systemctl`应用出来之后的服务管理方式分别作介绍！
<!--more-->
### `service&&chkconfig`管理service(服务)

　　daemon的命名规则，所有服务的开发者，在提供服务应用程序的时候都会在服务的名称后加上字母d，d代表的就是daemon的意思。提供的服务是要与端口一一对应的，
这样守护进程才能对外提供服务。Linux中是通过/etc/services配置文件来定义服务的端口号的。

``` shell
# 查看服务与端口号的对应关系
cat /etc/services
```

#### daemon的启动脚本和启动方式

　　daemon的启动是个复杂的过程，包括侦测环境、配置文件分析加载等等。所以通常服务应用程序在安装完成之后会提供一个script脚本，帮助使用者完成上述一系列操作。
daemon的shell script(启动脚本)通常存放在以下几个路径(*代表应用程序名称)：
* /etc/init.d/* : 启动脚本放置目录
* /etc/* : 服务各自的配置

##### `/etc/init.d`与`/etc/rc.d/init.d`之间的关系

　　透过如下命令我们可以看到，其实`/etc/init.d`是`/etc/rc.d/init.d`的文件夹软链接档：

``` shell
ls -alF /etc/init.d
```

因此我们自定义的服务启动程序可以放在`/etc/init.d`和`/etc/rc.d/int.d`这两个地方。

名词解析
> rc(run level control)运行等级控制。.d(directory)代表路径是一个目录

##### stand alone服务应用(daemon)的启动

* 可以直接运行脚本以启动
``` shell
# 直接运行可以查看服务应用程序脚本的使用方法
/etc/init.d/vsftpd 
```

* 透过`service`命令，其实是一个shell script应用程序脚本,它可以分析下达的参数，完成服务的启动等
``` shell
# 查看帮助说明
service -h
# 查看所有守护进程服务的状态
service --status-all
```

##### 观察系统启动的服务

``` shell
netstat -tulp
netstat -lnp
```

##### 服务的自启动

　　服务启动之后，如果服务器(计算机)重启了，那么服务下次还会自动启动吗？这就需要了解到底我们的Linux主机是如何启动的。
1. 打开计算机电源，开始读取 BIOS 并进行主机的自我测试；
2. 透过 BIOS 取得第一个可启动装置，读取主要启动区 (MBR) 取得启动管理程序；
3. 透过启动管理程序的配置，取得 kernel 并加载内存且侦测系统硬件；
4. 核心主动呼叫 init 程序；
5. init 程序开始运行系统初始化 (/etc/rc.d/rc.sysinit)
6. 依据 init 的配置进行 daemon start (/etc/rc.d/rc[0-6].d/*)
7. 加载本机配置 (/etc/rc.d/rc.local)
Linux系统启动时，会进入不同的运行等级(run level)。不同的运行等级有不同的功能和服务。使用`chkconfig`命令可以查询不同等级有哪些服务会启动！
``` shell
chkconfig --list
# 透过这个命令我们可以看到一共有7个运行等级，并且会显示每个daemon服务在不同run level的运行状态
```
其实`chkconfig`这个命令只是为服务的启动脚本在不同的run level下建立了链接档。
使用如下命令，可以看出来`rc0.d`到`rc6.d`分别对应run level的七个运行等级：

``` shell
ls /etc/rc.d
# 实际上chkconfig改变httpd的状态，是在rc0.d ...... rc6.d 中建立了对应的链接档案到`/etc/rc.d/init.d/*`下的具体文件
chkconfig httpd on
```

##### 创建自己的服务脚本

　　当我们创建自己的shell script服务脚本的时候，如何让chkconfig来管理呢？
我们只需要在`/etc/init.d`或者`/etc/rc.d/init.d`下创建好我们的服务启动脚本，具体的脚本写法我们可以打开系统本有的脚本参照来写！然后我们将自定义的脚本
加入到`chkconfig`的控制范围中即可。
``` shell
# 添加脚本到chkconfig控制
chkconfig --add myscript
# 删除脚本控制
chkconfig --del myscript
```
然后就可以透过chkconfig来管理自定义脚本在不同run level的自启动与否了！
