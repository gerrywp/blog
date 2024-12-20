+++
title = "IDEA中Wildfly配置异常"
date = "2024-05-15"
tags = [ "bug" ]
categories = [ "java" ]
+++
奔跑吧，兄弟。
<!--more-->

IDEA中配置Jboss/wildfly application server启动的时候报告各种乱七八糟的错误，例如：port out of range 端口超出范围。
### wildfly的配置
如图所示（IDEA社区版本是没有setting>application server功能的，只能使用Ultimate版本）

**server标签配置如下**
![server](../../pictures/企业微信截图_17157433832104.png 'wildfly配置')
**Startup/connection标签配置如下**
![Startup/connection](../../pictures/企业微信截图_17157436116328.png 'wildfly配置')
说明：java命令行编译器，有两种参数，一种是**系统参数**以-D传递，另一种是**运行参数**直接传给main函数的args参数。

### 运行报错
按照上述图片配置完成后运行会报错，各种奇怪的错误。

解决办法：因为我的wildfly是直接从公司的公共盘拷贝下载并配置环境变量的，在standalone\configuration里面缺少缺省的standalone.xml文件。
因公司项目对xml文件做了开发、测试、正式环境的区别，所以需要手动指定xml文件。就算在应用程序参数指定了`-c standalone-local.xml`，在IDEA中standalone.xml也是必须存在的，
不然会报各种错误！
![standalone.xml](../../pictures/企业微信截图_17157441595154.png 'wildfly目录配置')

### maven查看plugin插件的goal目标详细信息
进入包含有具体Maven插件配置的pom.xml文件所在目录，运行以下命令：
```bash
mvn ear:help -Ddetail=true -Dgoal=ear
mvn ear:help -Ddetail=true -Dgoal=generate-application-xml
```
![maven/goal](../../pictures/企业微信截图_17157448964896.png 'plugin所有goals')

### goal名字含义
在 Maven 中，goal 中的冒号前后分别代表以下内容：

1. **冒号前的部分**：这部分表示插件的 groupId 和 artifactId，用于唯一标识要使用的插件。通常，冒号前的部分指定了要执行的插件。

2. **冒号后的部分**：这部分表示插件中的具体目标（goal），即要执行的任务或操作。冒号后的部分指定了插件中的一个具体目标，告诉 Maven 执行该目标所定义的操作。

通过冒号前后的组合，Maven 能够准确地定位要执行的插件和插件中的具体目标，从而执行相应的任务。例如，org.apache.maven.plugins:maven-compiler-plugin:compile 中，org.apache.maven.plugins:maven-compiler-plugin 是插件的 groupId 和 artifactId，compile 是插件中的一个目标（goal），表示要执行编译操作。

### artifact和facet
在 Java 开发中，"artifact" 和 "facet" 是两个不同的概念：

1. **Artifact（构件）**：在 Java 开发中，"artifact" 通常指代构建的输出物，例如 JAR 文件、WAR 文件或其他类型的构件。在 Maven 中，"artifact" 通常指代一个项目的输出物，由 groupId、artifactId、version 和打包类型（如 JAR、WAR）等信息组成。通过 Maven 构建项目时，会生成相应的 artifact，用于部署、共享和使用。

2. **Facet（面向）**：在 Java 开发中，"facet" 是 Eclipse IDE 中的一个概念，用于表示项目的特定功能或特性。通过在 Eclipse 中启用不同的 "facet"，可以为项目添加特定的功能支持，例如 Web 项目可以添加 Web facet 来启用 Web 开发支持，Enterprise Java 项目可以添加 Java EE facet 来启用 Java EE 功能等。Facet 功能使开发者能够根据项目需求灵活地配置和扩展项目功能。

备注：善于使用Kimi.chat或者ChatGPT提问找答案。

### 参考链接

> 1. https://www.cnblogs.com/danhuang/p/12762333.html
> 2. https://maven.apache.org/plugins/maven-ear-plugin/plugin-info.html


