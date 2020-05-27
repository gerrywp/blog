+++
title = "资料和笔记"
date = "2017-04-02"
tags = [ "资料收集" ]
categories = [ "others" ]
+++

计算机相关知识点过于分散，有时候为了找一篇文章，在以后要用到的时候又要去反复查找很耗时。这里罗列出对自己有指导性意见的一些工具及blog文章,以备后用。(热更新)
<!--more-->
### 搜索引擎相关

1. 中文分词分库  
[http://ictclas.nlpir.org/](http://ictclas.nlpir.org/ "点我访问")

2. 全文检索引擎Elasticsearch .net provider  
搜索关键字: **full-text search**  
[https://damienbod.com/2014/09/22/elasticsearch-crud-net-provider/](https://damienbod.com/2014/09/22/elasticsearch-crud-net-provider/ "点我访问")

3. Elasticsearch 指南  
[https://es.xiaoleilu.com/010_Intro/00_README.html](https://es.xiaoleilu.com/010_Intro/00_README.html "点我访问")

4. c++应用领域  
[c++应用领域](http://www.cnblogs.com/duguochao/p/4528001.html "点我访问")  
[c++primerplus](http://faculty.euc.ac.cy/scharalambous/csc132/books/c%2B%2B_book%201.pdf "点我访问")  

5. Javascript使用Phaser引擎开发网页游戏  
[Phaser](https://mozdevs.github.io/html5-games-workshop/en/guides/platformer/start-here/ "点我访问")

6. 正则表达式30分钟入门教程  
[正则表达式](http://deerchao.net/tutorials/regex/regex.htm '点我访问')

7. QT入门之基础篇    
[QT入门基础](<https://www.cnblogs.com/lxmwb/p/6352220.html> '点我访问')

### nodejs
[用webpack构建nodejs后端代码，使其支持js新特性并实现热重载](https://zhuanlan.zhihu.com/p/20782320 "点我访问")

[Backend Apps with Webpack](http://jlongster.com/Backend-Apps-with-Webpack--Part-I "点我访问")

### web后台开发框架

收费

1. [easyweb](https://www.easyweb.vip/index "点我访问") 基于layui
2. [layui-admin](https://www.layui.com/admin/ '点我访问')

免费

1. [vue-element-admin](https://panjiachen.github.io/vue-element-admin-site/zh/guide/ '点我访问')
2. [adminlte](https://adminlte.io/ '点我访问')
3. [ligerui](http://www.ligerui.com/ '点我访问')
4. [ace admin](https://github.com/bopoda/ace '点我访问')

### c++中const组合引用和指针

1. `const`组合引用    
引用结合const,const关键字只有一个位置：指向常量的引用

```c
const int i=7;
const int& ci=i;
```

2. `const`组合指针(因为指针是object类型)
指针结合const,const关键字有两个位置：(1)指向常量的指针 (2)指向常量的常指针

```c
//指向常量的指针
const int i=7;
const int* pci=&i;

//指向常量的常指针
const int* const cpci=&i;
```

### 在线好看的书籍

<https://www.xirenxuan.com/>

### 申请免费300$谷歌云平台(GCP)

<https://zhuanlan.zhihu.com/p/58747135>

<https://www.cnblogs.com/shengwang/p/10567446.html>
