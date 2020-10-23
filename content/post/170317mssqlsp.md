+++
title = "拾遗stored procedure"
date = "2017-03-17"
tags = [ "sql" ]
categories = [ "sql" ]
+++

长久以来仅仅使用了数据库最简单的功能，譬如增删改查。最近因项目需要，须将所有的查询都改用存储过程。也就是说要将所有的业务逻辑放在数据库端来处理。
老实说以前业务的东西都是用高级语言代码来做，存储过程写的少，所以还是有很多东西不熟悉并值得学习得，仅以文字记之。
<!--more-->
### 判断存储过程存在与否

sql脚本常用语句。

```sql
--第一参数，存储过程名称。第二参数，对象类型为存储过程
IF OBJECT_ID('sp_name','P') IS NOT NULL
DROP PROCEDURE sp_name
GO
--或者
IF EXISTS(SELECT 1 FROM SYSOBJECTS WHERE NAME='sp_name' AND TYPE='P')
DROP PROCEDURE sp_name
GO
```
### declare variable and set value(变量声明和赋值)

**关键字declare/set**
使用`declare`声明变量，并使用`set`给变量赋值。  
本地变量使用@前缀标示,全局变量使用@@前缀标示。

```sql
--声明变量
declare @local_variable INT; --局部变量  
declare @@global_variable INT;--全局
--或者这样
declare @local_variable INT,@@global_variable INT;
--赋值变量
set @local_variable=1;
set @@global_variable=1;
--初始化变量
declare @local_variable INT=1;--声明并赋值
```
#### select @variable=column与set赋值区别

推荐使用`set`对变量进行赋值，以避免不必要的错误。

1. 查询返回多个值

``` sql
decalre @id uniqueidentifier;
--返回多个值，set报错
set @id=(select id from student);
--错误信息：子查询返回的值多于一个。当子查询跟随在 =、!=、<、<=、>、>= 之后，或子查询用作表达式时，这种情况是不允许的。
select @id=id from student;--此时@id的值为查询结果集中，最后一行的值。
```
2. 查询返回`NULL`

`set`赋值情况：变量为空，`select`赋值情况:变量保持原有值

``` sql
decalre @name nvarchar(100);
set @name='pai';
set @name=(select name from student where id='-1');
print @name;--null值
set @name='pai';
select @name=name from student where id='-1';
print @name;-- pai
```

### table variable&temporary table(表变量和临时表)

```sql
declare @table-variable TABLE(
    column-name datatype,
    column-name datatype
);--声明表变量

select * into #temporary-table from table;--取出数据插入临时表
--must drop #temporary-table
drop table #temporary-table
```
1. 使用**临时表**可以声明也可以不声明，临时表命名必须以#开头，标示是一张临时表。
临时表存放在本地*System Databases*下的*tempdb*数据库*Temporary Tables*下面。
2. 临时表使用完成之后必须手动显式删除、表变量在变量生命期结束时会自动删除。

### select * [into]|insert [into]与表

`select * into` 后面接的一定是**表**(或者临时表)，不可以使用变量、表变量。    
`insert into` 后面可以接表变量。  
语法：`select * into [table|#temporary-table]`
  
```sql
declare @users table(
    userName varchar(50)
});
select name into @users from users; --错误用法
select name into #tempUser from users;--正确用法

--insert into 后面可接表变量

--方式1
insert into @users select name from users;
--方式2
insert into @users exec sp_executesql N'sqlstr',param-string,param
```

### 存储过程返回数据集和变量赋值

存储过程默认会返回所有`select`查询的数据集，有几个`select`语句就会返回几个数据集。  
如果想让查询出来的数据集结果只做中间表，需要将查询结果赋值给变量，有以下几种方式：

```sql
declare @name varchar(50);
--以下查询结果并不会返回给存储过程调用者
--方式1
select @name=name from users;
--方式2
set @name=(select name from users);
--将查询结果返回给调用者
select @name;
--方式3(with as子查询部分)
with A as (select * from users)
select name from A;

-- Define the CTE expression name and column list.  
WITH Sales_CTE (SalesPersonID, SalesOrderID, SalesYear)  
AS  
-- Define the CTE query.  
(  
    SELECT SalesPersonID, SalesOrderID, YEAR(OrderDate) AS SalesYear  
    FROM Sales.SalesOrderHeader  
    WHERE SalesPersonID IS NOT NULL  
)  
-- Define the outer query referencing the CTE name.  
SELECT SalesPersonID, COUNT(SalesOrderID) AS TotalSales, SalesYear  
FROM Sales_CTE  
GROUP BY SalesYear, SalesPersonID  
ORDER BY SalesPersonID, SalesYear; 
```
### exec & exec sp_executesql

`exec`和`exec sp_executesql`都可以用来执行**dynamic sql**(动态sql语句),后者的功能强大很多，并且允许有返回值。

```tsql
DECLARE @result int   
DECLARE @sqlStr nvarchar(500);
DECLARE @paramDefinition nvarchar(500);

DECLARE @tableName nvarchar(50)  
SET @tableName = N'products'  

SELECT @sqlStr = N'SELECT @resultOut = MAX(ID) FROM ' + @tablename;-- exec sp_executesql 必须使用unicode字符串，因此字符串前面要带上N 
SET @paramDefinition = N'@resultOut int OUTPUT';

EXEC sp_executesql @sqlStr, @paramDefinition, @resultOut=@result OUTPUT;
--返回结果集给调用者
SELECT @retval; 
```

> 参考

[代码获取sql的print message信息](https://www.tf3604.com/2016/03/01/capturing-output-from-sql-server-using-c/ '点我访问')
