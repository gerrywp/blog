+++
title = "发布项目dll未被msbuild拷贝到输出目录"
date = "2018-03-29"
tags = [ "vs" ]
categories = [ "csharp" ]
+++

　　添加了reference的dll文件并且`Copy Local`值为True为何不拷贝到输出目录？  
<!--more-->
### 间接引用自定义工程程序集

　　造成这个原因的情况是这样的，假定项目结构如下：
 1. Main.Project
 2. Service.Project
 3. Common.Project
 
Main.Project添加了对Service.Project的引用，现假定有一个dll文件MyDll.dll被Service.Project引用，但是实际在编码的时候
Service.Project里面并未用到MyDll.dll文件里面的任何代码。
单独编译Service.Project，MyDll.dll文件会被拷贝到/debug/bin/目录下。但是编译MainProject的时候由于缺少对MyDll.dll的代码的使用，
所以Service.dll文件会被拷贝到Main.Project的/debug/bin/目录下，但是MyDll.dll并不会被copy过去。

因此，当我们需要MyDll.dll文件能够被自动copy到Main.Project的输出目录的话，只需要在Main.Project里面直接引用MyDll.dll程序集文件即可！
