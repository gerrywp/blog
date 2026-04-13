+++
title = "发布项目dll未被msbuild拷贝到输出目录"
date = "2018-03-29"
tags = [ "vs" ]
categories = [ "csharp" ]
+++

　　添加了reference的*dll*文件并且`Copy Local`值为True为何不拷贝到输出目录？  
<!--more-->
### 间接引用自定义工程程序集

造成这个原因的情况是这样的，假定项目结构如下：

 1. **Main.Project**
 2. **Service.Project**
 3. **Common.Project**
 
**Main.Project**添加了对**Service.Project**的引用，现假定有一个*dll*文件*MyDll.dll*被**Service.Project**引用，但是实际在编码的时候
**Service.Project**里面并未用到*MyDll.dll*文件里面的任何代码。
单独编译**Service.Project**，*MyDll.dll*文件会被拷贝到```/debug/bin/```目录下。但是编译**MainProject**的时候由于缺少对*MyDll.dll*的代码的使用，
所以*Service.dll*文件会被拷贝到**Main.Project**的```/debug/bin/```目录下，但是*MyDll.dll*并不会被copy过去。  
　　因此，当我们需要*MyDll.dll*文件能够被自动copy到**Main.Project**的输出目录的话，只需要在
**Main.Project**里面直接引用*MyDll.dll*程序集文件即可！
