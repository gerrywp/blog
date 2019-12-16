+++
title = "Linux(daemon)和管线命令(pipe)"
date = "2017-01-20"
tags = [ "shell" ]
categories = [ "linux" ]
+++

如何将应用程序启动为守护进程(daemon),换言之作为服务(service)启动。
<!--more-->
### 守护进程
[Linux 守护进程的启动方法](http://www.ruanyifeng.com/blog/2016/02/linux-daemon.html "点我访问")


### 管线命令(|)

能接受前一个的指令的输出(standard output)作为输入(standard in)的的指令才能称之为管线命令。
Linux有如下的管线命令：

1. 截取：cut, grep
2. 排序：sort, uniq, wc
3. 双向重导向： tee
4. 字元转换： tr, col, join, paste, expand
5. 分割： split
6. 参数代换： xargs

其中的参数代换指令xargs说明一下。因为很多命令不是管线命令，所以可以使用xargs命令将前面的命令结果转成参数形式传递给后续的指令：

```bash
# 我们要查询系统里面的所有S99local这个名字文件，并且看它的详细链接
updatedb # 更新资料库
locate -i s99local | xargs ls -al
```
>说明:因为ls并不是管线命令，所以通过xargs将输出转成参数传递给ls，来达到目的。  

#### $(指令)和\`指令`` ` ``(推荐)

通过复合指令可以动态的获取指令内容，作为参数传递
```bash
ls -al $(locate -i s99local)
file $(locate -i s99local)
```

### 关于减号的用途(-)

1. 表示标准输出(standard output)
2. 表示前面指令存储的文件的文件名

```bash
# 此时的-代表标准输出，因为小写的-o参数，后面要接outfilename。所以用-符号代替了文件名，输出到标准输出传递给bash
curl -o - https://raw.githubusercontent.com/creationix/nvm/v0.33.6/install.sh | bash
等同
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.6/install.sh | bash \

# 也可以使用以下的方式
curl -O https://raw.githubusercontent.com/creationix/nvm/v0.33.6/install.sh | bash -
# 此时bash后面的 - 表示传入当前目录的install.sh这个文件
等同于
bash ./install.sh
```
