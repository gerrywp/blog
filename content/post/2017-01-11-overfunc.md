+++
title = " Ms-SqlServer开窗函数(over())"
date = "2017-01-11"
tags = [ "sql" ]
categories = [ "sql" ]
+++

开窗函数用在ms的group by分组无法迄及的地方。
<!--more-->
### 应用场景

*数据库表数据*(表名tb_student)：

| id | name | datetime |
| :---: | :---: | :---: |
| 1 | 张三  | 2016-01-22 08:00:27.000 |
| 2 | 张三  | 2016-01-22 08:23:27.000 |
| 3 | 张三  | 2016-01-22 09:23:27.000 |
| 4 | 张三  | 2016-01-22 09:23:27.000 |
| 5 | 李四  | 2016-01-22 10:15:35.000 |
| 6 | 李四  | 2016-01-22 10:17:35.000 |
| 7 | 王五  | 2016-01-22 15:15:41.000 |
| 8 | 王五  | 2016-01-22 15:26:41.000 |
| 9 | 王五  | 2016-01-22 15:27:41.000 |

*期望结果*:要求根据name进行分组，取出datetime最大的**一整行记录**(请注意是一整行)

| id | name | datetime |
| :---: | :---: | :---: |
| 3 | 张三  | 2016-01-22 09:23:27.000 |
| 6 | 李四  | 2016-01-22 10:17:35.000 |
| 9 | 王五  | 2016-01-22 15:27:41.000 |

>说明：在ms-sqlserver里面通过group by 是不能实现这样的要求的请思考

### 实现方式

只用通过开窗函数over()来实现(oracle通过group by就可以，ms真是蠢),sql语句如下：

```sql
select t2.id,t2.name,t2.datetime from (
select row_number() over(partition by t1.name order by t1.datetime desc) rnum,
t1.id id,
t1.name name,
t1.datetime datetime
from tb_student t1
) t2 where t2.rnum=1;
```

### 总结

以上只是提供了一种思路解决，只给出了最简单的over()方法，我们还能根据ROWS 和 RANGE 来过滤 over 的partition,
具体可以参考msdn。

>[https://technet.microsoft.com/en-us//library/ms189461.aspx](https://technet.microsoft.com/en-us//library/ms189461.aspx "点我访问")
