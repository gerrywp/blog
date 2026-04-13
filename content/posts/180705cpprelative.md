+++
title = "c++开发环境"
date = "2018-07-05"
tags = [ "cpp","tool" ]
categories = [ "others" ]
+++

在windows下做c++开发，不想使用微软系的IDE开发工具。  
<!--more--> 
### minGW(Minimalist GNU for Windows)
目的：开发Window原生应用，可以使用`gcc`、`g++`编译器，不使用~~微软的cl编译器~~。使用qt开发windows应用,若仅使用标准c++库，
并用minGW编译可实现跨平台。  
功能：用于开发原生(32位)Windows 应用的开发环境。它主要提供了针对win32应用的GCC、GNU (bin,utils)等工具，
以及对等于Windows SDK（的子集）的头文件和用于 MinGW 版本 linker 的库文件（so、a等，而不是 VC 的 lib）。     
下载：
* minGW官网 [minGW](https://www.mingw-w64.org/ '点我访问')

在`Downloads`页签下找到`MinGW-W64-builds`下载即可，会跳转到Github进行下载。
* sourceforge网站下载 [MinGW-w64](https://sourceforge.net/projects/mingw-w64/files/Toolchains%20targetting%20Win64/Personal%20Builds/mingw-builds/8.1.0/threads-win32/seh/) 

说明：各版本(下载的文件版本名称)的区别：

1. DWARF或DWARF-2(DW2)EH这需要使用DWARF-2(或DWARF-3)调试信息DW-2EH可以导致可执行文件略显膨胀，因为大的调用堆栈表必须包含在可执行文件中。
2. setjmp/longjmp(SJLJ)基于SJLJ的EH比DW2 EH慢得多(在没有异常时会惩罚甚至正常执行)，但是可以在没有使用GCC编译的代码或没有调用堆栈的代码上工作。
3. 结构化异常处理SEH(Structured Exception Handling)Windows使用自己的异常处理机制。

* 使用choco安装
```bash
# choco必须使用翻墙才能安装软件，不然的话特别慢
choco search mingw
choco install mingw-w64 -y
```

### Cygwin(cygnus win)
目的：提供完整的类Unix环境，适用于在windows桌面下，开发运行于linux系统上的应用   
功能：提供了一整套的类linux环境，GCC、GNU工具    
下载：[Cygwin](https://cygwin.com/install.html '点我访问')
  
**备注**:Cyg是*cygnus solutions*公司的简称(Cygnus有中文含义:天鹅)

> [MinGW-w64安装教程](https://zhuanlan.zhihu.com/p/76613134 '点我访问')

### 安装android-sdk
[安装android sdk](https://blog.csdn.net/naipeng/article/details/72722682 '点我访问')

### QT实战教程
[QT实战123](https://blog.csdn.net/liang19890820/article/details/50277095 '点我访问')
[QT入门基础](<https://www.cnblogs.com/lxmwb/p/6352220.html> '点我访问')

### 实战make
```makefile
#获取所有cpp文件
files=$(wildcard *.cpp)
objs=$(patsubst %.cpp,%.o,$(files))
BIN=./bin/
OBJ=./obj/
exename=$(BIN)example.exe
object=$(addprefix $(OBJ),$(objs))
all:$(exename)

.PHONY:all clean createDir build
$(exename):$(files)
	g++ $^ -o $@ 
$(object):$(OBJ)%.o:%.cpp
	g++ -c $^ -o $@
createDir:
#for windows
	#if not exist "obj" (mkdir obj)
	#if not exist "bin" (mkdir bin)
#end for windows
#for linux
	if [ ! -d "obj" ]; then \
	mkdir "obj"; \
	fi
	if [ ! -d "bin" ]; then \
	mkdir "bin"; \
	fi
#end for linux
build:createDir $(object)
clean:
	@-del /s .\obj\$(objs) .\bin\*.exe 2>nul
	
debug:
	echo $(OS)
```
`objects=*.o`通配符同样可以用在变量中,但是*.o不会展开！object的值就是`*.o`。  
如果你要让通配符在变量中展开,也就是让objects的值是所有.o的文件名的集合，那么你可以这样(参考[文档](https://www.gnu.org/software/make/manual/make.html#toc-An-Introduction-to-Makefiles '点我访问')第13页 )：
```makefile
objects:=$(wildcard *.o)
``` 
**说明**：在makefile文件中的linux命令，每一行都被当成是一条单独的指令，运行在各自不同的shell实例中。当使用
`\`换行组合多条指令,shell会把多行指令作为长字符串，回车将会被删除。所以`\`与指令之间需要有一个空格，因缺少回车每个指令的结尾需强制用分号
隔离命令！

#### 通过target创建目录
上文makefile文件创建目录部分代码不够优雅，有更好的方式来处理目录的创建！因为目录是真实存在的文件,所以可以通过target来创建
```makefile
#此处只列出目录创建部分
OBJDIR=obj
BINDIR=bin
exename=$(BINDIR)/$(notdir $(CURDIR)).exe
srcfiles:=$(wildcard *.cpp)
destfiles:=$(patsubst %.cpp,%.o,$(srcfiles))
objs=$(addprefix $(OBJDIR)/,$(destfiles))
build:$(objs)
$(objs): |$(OBJDIR)
$(OBJDIR)/%.o:%.cpp
	$(CXX) -c $(OUTPUT_OPTION) $<
$(OBJDIR):
	mkdir $@
```
脚本用makefile内置变量替换了g++命令和参数，并用pipe管道定义了一个$(OBJDIR)的`order-only-prerequisite`先决条件。仅第一次构造targets会使用`order-only-prerequisite`,往后即使`order-only-prerequisite`时间戳发生了改变，也不会重新构造targets！

#### .PHONY
伪目标：如果没有真实存在的**文件**与target目标形成一一对应关系，最好就是将该目标设置成**伪目标**。这样每次make phonyname都会被执行！而不管真实文件存在与否

#### 常用变量

获取当前操作系统：`$(OS)`

```makefile
clean:
  ifeq ($(OS),Windows_NT)
      del /s *.o *.d *.elf *.map *.log
  endif
```

#### VS2017创建vc++ general makefile project

1. 首先需要安装`Windows Universal C Runtime`。
打开vs安装程序，选中`Individual Components`->`Windows Universal C Runtime`(若不安装创建makefile project的时候就会提示找不到很多头文件！)

2. 在项目下新建makefile文件，并编写编译过程。

3. 安装`mingw`或者`cygwin`并配置好环境变量,使用g++来编译生成目标文件。

4. 目标生成文件(.exe)需要生成到相对应的项目`Debug`和`Release`目录下，否则运行的时候窗口会一闪而过。

5. 因为使用的是makefile文件，编译器使用的g++，**暂时还未找到如何使用VS2017的集成调试工具来调试程序？？？**。

```makefile
#附上makefile文件
exe=$(notdir $(CURDIR)).exe
dbgexe=Debug/$(exe)
rlexe=Release/$(exe)
build:$(dbgexe)
build-release:$(rlexe)
$(dbgexe) $(rlexe):
	g++ -g main.cpp -o $@
rebuild:

clean:

.PHONY:build build-release rebuild rebuild-release clean
```
> [跟我一起写Makefile](https://seisman.github.io/how-to-write-makefile/Makefile.pdf '点我访问')
>
> [在线Html版本](https://seisman.github.io/how-to-write-makefile/introduction.html '点我访问')
>
> [官方文档](https://www.gnu.org/software/make/manual/make.html#toc-An-Introduction-to-Makefiles '点我访问')