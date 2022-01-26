+++
title = "EmuELEC杂谈"
date = "2022-01-26"
tags = [ "tool" ]
categories = [ "linux" ]
+++
夜阑卧听风吹雨，铁马冰河入梦来。
<!--more-->
### CPU架构体系
1. 复杂指令集CISC（Complex Instruction Set Computing）：X86
2. 精简指令集RISC（Reduced Instruction Set Computer ）：ARM（ARM11以后的产品改用Cortex命名）
3. 精简指令集RISC-V（发音为“risk-five”）: 开源架构，未来的方向

总结：EmuELEC系统是针对AMLogic芯片开发的，AMLogic芯片是基于ARM架构的，支持aarch64指令集 。

### 安装EmuELEC
准备条件
1. U盘一个
2. 烧录软件:Win32DiskImager或者Rufus（貌似这个更优秀）
3. 镜像文件bilibili:人中日月镜像包
[EmuELEC中文网](https://www.emuelec.cn/229.html '点我访问')

前置条件
1. 晶晨系列CPU的盒子

延申话题：看了大多数盒子的配置参数，最终发现**当贝**的盒子产品不错，价格较贵。并且看到了一款当贝的3200ASNI的投影仪很给力，与任天堂的Nintendo Switch打包卖，当贝OS比什么大米好多了，后悔买了大米投影仪。

#### 方案1
直接使用烧录软件将系统烧录进入U盘，系统开机后会自动扩容，但是我的N1扩容出了问题，稍后详述！

#### 方案2
使用DiskGenius手动分区，并进行硬盘分区对克,详见：<https://www.znds.com/tv-1172068-1-1.html>

### 扩容失败
【人中日月】的镜像第一次启动后会自动扩容，但是/storage文件系统容量未增加。

#### 使用`df`（**disk free**）命令查看文件系统：
```sh
# df -hT
```
#### 但是使用`parted`命令显示出来的分区容量是扩容后的
```sh
# parted /dev/sda2 print
```
#### 说明，分区容量是扩展了，但是文件系统并未扩展，使用`resize2fs`调整文件系统大小
```sh

```
> https://linux.vbird.org/linux_basic/centos7/0420quota.php#lvm_hint
#### resize2fs: Permission denied to resize filesystem
使用`resize2fs`提示没有权限，解决方案如下：
1. 卸载文件系统。
```sh
umount /storage
```
2. 执行文件系统检查。
```sh
e2fsck -y /dev/sda2
```
3. 调整文件系统大小
```sh
resize2fs /dev/sda2
```
4. 重新挂载
```sh
mount /dev/sda2 /storage
```
5. 检查文件系统是否扩容成功
```sh
df -hT
```
#### umount: can't umount /storage : Device or resource busy
使用`fuser`查看哪些进程使用了该文件系统，并`kill`掉进程
```sh
fuser -m /storage
umount -l /storage #强行解除挂载
```

> 参考

> https://www.thegeekdiary.com/resize2fs-permission-denied-to-resize-filesystem-error-while-online-resize-of-a-filesystem/


