+++
title = "go命令详解"
date = "2019-07-07"
tags = [ "2019","go","vs" ]
categories = [ "golang" ]
+++

　　go命令使用笔记，对命令的使用做一个总结和归纳
<!--more-->
### `go build`

	编译指定源码文件或包,相关命令`go run`&`go install`。
`go build`命令的常用标记说明

|名称|描述|
|:-----:|:-----|
| -n    |打印编译期间所用到的其它命令，但是并不真正执行它们。|
| -work |打印出编译时生成的临时工作目录的路径，并在编译结束时保留它。在默认情况下，编译结束时会删除该目录。|
| -x    |打印编译期间所用到的其它命令。注意它与-n标记的区别。|
| -v    |打印出那些被编译的代码包的名字。|
|  -a   |强行对所有涉及到的代码包(包含标准库中的代码包)进行重新构建，即使它们已经是最新的了。|
| -p n  |指定编译过程中执行各任务的并行数量(确切地说应该是并发数量)。在默认情况下，该数量等于CPU的逻辑核数。但是在darwin/arm平台(即iPhone和iPad所用的平台)下，该数量默认是1。|
| -tags | 此标记用于指定在实际编译期间需要受理的编译标签(也可被称为编译约束)的列表。|

>编译标签一般会作为源码文件开始处的注释的一部分，例如：

```bash
#template_bindatafs.go
// +build bindatafs

#template.go
// +build !bindatafs
```

当使用`-tags`编译选项编译源码文件或包时候，针对上面的两个文件：

```bash
//template_bindatafs.go文件(满足tag条件)会被编译
go build -tags "bindatafs" main.go
//template.go文件(满足tag条件:非"bindatafs"标签)会被编译
go build main.go
```

演示编译main.go文件

```bash
go build -n -work main.go
#输出如下
mkdir -p $WORK\b001\
cat >$WORK\b001\importcfg.link << 'EOF' # internal
packagefile command-line-arguments=C:\Users\Gerry\AppData\Local\go-build
\a1\a1e309cea1802088ffa62859347b42f2bf1807969efe2fd8cf3018d23374ddec-d
```

`command-line-arguments`:  
命令程序在分析参数的时候如果发现第一个参数是Go源码文件而不是代码包，
则会在内部生成一个虚拟代码包。这个虚拟代码包的导入路径和名称都会是command-line-arguments。
基于`go build` 的 `go install`命令和`go run`命令也有与之一致的操作。  

`$WORK`变量:  
会在windows临时目录创建go-build+随机名称的目录C:\Users\Gerry\AppData\Local\Temp\go-build495563082

```bash
%temp% or %tmp% #查看生成的go-build495563082目录
go env #查看go相关的所有环境变量
```

### Start Without Debugging

go开启了module模式之后，v1.13版本之前倘若未设置`GO111MODULE=on`的环境变量的话，`go build`寻找包依赖规则如下：

1. 如果 `go build` 命令运行目录有go.mod文件，或者父目录有go.mod文件(递归到根目录)，就使用go module的模块加载方式
2. 否则的话使用GOPATH、GOROOT方式加载包

很显然，当我们使用vscode-Start Without Debugging的时候，vscode使用的`go run`命令不是运行在当前project的目录下(猜测应该是运行在vscode安装目录下),
此时vscode按照GOPATH方式查找包依赖。  
因此当我们project使用的是module方式开发的话，必然会提示我们在GOPATH和GOROOT下找不到相关的依赖包文件。    
如果我们强制开启了`GO111MODULE=on`,vscode就使用go.mod来查找相关依赖，但是vscode的`go run`命令又不是运行在当前project目录，所以会提示找不到project
目录下的自定义子包(因为go会去GOPATH/pkg/mod目录下查找所有的包)并报错，我们必须让`Start without Debugging`时`go run`运行在当前目录，
如何处理?(vscode-go插件问题)
