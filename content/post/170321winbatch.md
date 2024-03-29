+++
title = "cmd批处理"
date = "2017-03-21"
tags = [ "shell" ]
categories = [ "windows" ]
+++

最近被外甥问到一个初中的奥数题目，涉及到高中的排列组合问题。因想求证一下答案，故考虑到使用"穷举法"编程来解决这个问题。
一开始使用的是高级语言c#来解决但是觉得不够大众化，并且不便与之交流。思考了下，觉得脚本文件可以解决这个问题，
由于batch script很少用，使用起来并不方便，而且有很多坑，因此引出了这篇博客。
<!--more-->
### 复合语句、批处理预处理、变量延迟

#### 1. 复合语句
什么是复合语句？通过组合命令、重定向、管道命令串联起来的,或者以()括号包含起来的就是复合语句。如下：

```bash
@echo off
set a=4
set a=5 & echo %a%
pause
::result is：4,why?
::以下也是复合语句
(
set /A a=5
set /A b=16
)
```
#### 2. 预处理
批处理运作方式:批处理命令式按行读取的，所有的复合语句被当做一行来处理。并且执行该行之前，要对行变量进行预处理(变量赋值),然后再执行

#### 3. 变量延迟和!variable!
结合1、2可知,预处理变量会造成变量不会根据上下文进行动态更新，这个问题在for/if等syntax语法构造里面尤为突出。因此需要变量延迟，
即延迟了对变量的预处理，相当于让复合语句，能够一条一条的预处理->执行，这样就可以解决问题。  
读取延迟变量的语法为: `!variable!`

```bash
@echo off
::开启变量扩展和变量延迟
setlocal ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

@echo off
set a=10
for /L %%i in (1,1,5) do (
set a=%%i
:: 这里只会输出10
echo %a%
# echo !a! # 这样可以解决问题
)
:: 循环体外输出5
echo %a%
pause
endlocal
```
解释：因为do后面的 ()是一个复合语句，每次for循环进入，批处理预处理会先解析后面代码成为如下代码

```bash
do (
:: a的值根据循环次数来
set a=[1,2,3,4,5]
:: 这里永远是10
echo 10
)
```

### 管道(pipe)命令
cmd下的管道命令|，以这种方式传输,请看以下代码：

```bash
set input=empty
echo test | set /p input=
echo %input%
```
>结果：empty.看似上面的第二个语句没有赋值成功。

```bash
set input=empty
echo test | (set /p input= & set input)
echo %input%
```
结果:set显示input实际上是赋值成功的，为什么？  
答案可以参照这篇文章，[Pipes and CMD.exe](https://ss64.com/nt/syntax-redirection.html '点我访问')   
结论：因为管道命令会为后面的命令创建一个新的子进程，子进程里面的变量和父进程的变量不是同一个，故有以上的问题！  
译文：当command以管道的方式传送输出给'| batch_command'的时候，将创建一个新的cmd.exe实例，效果等同于：
```bash
C:\Windows\system32\cmd.exe /C /S /D "batch_command"
```
这会产生一系列的副作用

### linux下的xargs在cmd下的替代
首先明确一下什么是管道命令，管道命令就是，需要从键盘输入(stdin)参数的命令就是管道命令，因此`dir`不是一个管道命令。   
管道|作用："将前面的标准输出(stdout)作为后面的标准输入(stdin)"  
xargs作用："将标准输入作为命令的参数"  
因此dir命令不能跟在管道的后面，因为dir不需要标准输入

```bash
::linux下这样
find . -name "*.java" | xargs accurev keep -c "comment"
::cmd下通过for循环来实现
FOR /F %k in ('dir /s /b *.java') DO accurev keep -c "comment" %k
```
["pipe xargs" in DOS](https://davidpthomas.wordpress.com/2007/01/04/xargs-in-dos/ '点我访问')

### 重定向
有时候我们希望不显示信息到输出界面，可以将输出流定向到垃圾桶

```bash
del /s  bin\*.exe >nul 2>&1
#从右往左读，将2错误输出重定向到1标准输出(&取地址操作，取标准输出设备的地址)，然后是>nul将标准输出重定向到垃圾桶
```

### WSH(windows script host)
bat批处理脚本功能实在有限，远不如Linux-shell那般强大！且本文前半部分有些"学究式"，只为探讨for-loop以及变量延迟，
非常不适用！dos-bat性能低下，处理一些复制、粘贴、改名等重复性操作尚可，如涉及到稍微复杂的需求还是要寻求更加高级脚本语言。

### Powershell
让 ***.ps1*** 文件双击可以运行，需要修改注册表如下：
```sh
HKEY_CLASSES_ROOT\Microsoft.PowerShellScript.1\Shell\open\command
###默认编辑值如下
"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -noLogo -ExecutionPolicy unrestricted -file "%1"
```
powershell相关命令
```sh
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
#显示当前可执行策略
Get-ExecutionPolicy
```
按任意键继续
```sh
echo "powershell scripts"
Read-Host "Press Enter key to exit"
```
> 脚本编辑工具`Windows PowerShell ISE` 

#### npm script运行.ps1脚本
两种方式运行powershell脚本
1. 修改上方文档提到的注册表内容，将ps1文件关联到powershell命令(相当于将文件变成了可执行文件)。
```json
"scripts": {
"路径存放方式1":"文件放入系统环境变量目录内，配置如下",
"pstask":"pstask.ps1"
"路径存放方式2":"文件放再package.json同目录，配置如下",
"pstask":".\pstask.ps1"
}
```
2. 不修改注册表，使用`powershell`加载脚本
```json
"scripts": {
"pstask":"powershell -noLogo  -ExecutionPolicy Unrestricted -Command .\pstask.ps1"
}
```

#### 环境支持
windows98以后(98,2000,xp)都支持WSH,可以告别批处理了!
1. 宿主环境是wscript.exe或cscript.exe
2. 开发语言可以使用jscript(微软的垃圾玩意.js)和vbscript(.vbs)

#### .js/.vbs脚本文件的调试

1. ⌘+Q -> cmd -> run >wscript /X filename.js 选择visual studio调试即可
2. 新建项目->属性->Debugger->键入wscript $(DIR)/$(filename)

#### 使用jscript写console程序

[jscript for WSH](../170725jsforwsh/)

#### WSH技术指南

[Windows Script Host 2.0 Developer's Guide](../../cmd/WSH2.0DevGuide.pdf "点我访问")

>参考文献

1. [windows batch scripting](http://steve-jansen.github.io/guides/windows-batch-scripting/index.html "点我访问")
2. [手册](https://ss64.com/nt/for_f.html "点我访问")
3. [cnblog](http://www.cnblogs.com/glaivelee/archive/2009/10/07/1578737.html "点我访问")
