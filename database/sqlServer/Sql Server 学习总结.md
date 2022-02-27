## SQL Server 学习总结

##### 数据库基础

- 数据库技术经历了网状模型(图形)、层次模型（树形）、关系模型（二维表）
- E-R图，其中实体(Entity)使用矩形表示，属性使用椭圆表示，关系使用菱形表示
- 关系：一对一(1对1)、一对多(1对n)、多对多(n对m)
- 关系模型(也就是表)
  - 包含
    - 关系-表
    - 元组-行
    - 属性-列
    - 域-属性的取值范围
  - 特点
    - 元组不可再分
    - 不可出现相同属性
    - 元组和属性顺序任意
  - 新的关系
    - 选择，横向数据，某些元组数据组成新的关系
    - 投影，纵向数据，某些属性数据组成新的关系
    - 连接，多个关系(表)组成新的关系
  - 约束
    - 实体完整性约束（主键约束）
    - 参照完整性约束（外键约束）
    - 域完整性约束（属性取值范围）
  - 范式
    - 1NF：属性不可再分
    - 2NF：满足1NF，且每一个非主键字段完全依赖于主键字段
    - 3NF：满足2NF，且每个非主键字段之间不可有依赖关系
  - 索引
    - 聚集索引，每个表最多仅有一个聚集索引，物理上数据顺序的存放
    - 非聚集索引，每个表可以有多个非聚集索引，建议合理使用，物理上数据不顺序存放，可以逻辑上存放，类似指针关联   


##### SQL Server 2008

   使用server 2008或者server 2008 R2
  - server 2008的对象资源管理器的使用，实现对不同数据库，表等存储空间，大小，排序，模糊匹配等查询功能
  - 安全对象设置
    - 使用sa用户启动
    - 创建一个普通的登录用户
    - 创建一个用户名，与创建的登录用户映射
    - 创建一个架构，使一些表使用该最新的架构
  - 数据库备份、还原、分离、附加
    - 完全备份
    - 差异备份  
    - 还原
    - 分离和附加
  - 表字段类型
    - 整数
      - bigint
      - int
      - smallint
      - tinyint 
    - 时间
      - time
      - date
      - datetime
      - date2 
    - 字符串  
      - char
      - nchar
      - varchar
      - nvarchar 

##### 数据库操作
- 创建数据库脚本

  ```
  create database student
  on primary(
  name=student_data,
  filename='c:\data\student.mdf',
  size=10mb,
  filegrowth=5mb,
  maxsize=unlimited ----不限制大小
  ),
  (
  name=student1
  filename='c:\data\student1.ndf',
  size=10mb,
  filegrowth=25%,
  maxsize=100mb
  )
  log on(
  name=student_log
  filename='c:\data\studen.ldf',
  size=10mb,
  filegrowth=2mb,
  maxsize=50mb
  )
  

**特别要注意name和filename名称不一致会怎么样**

- 修改数据库

```
exec sp_helpdb test1; ---查询数据库的属性
alter database test1 modify name=test;---修改数据库的名称

---修改数据库指定的文件的属性
alter database test modify file(
name=test,----必须写指定要修改的文件
size=20mb,
maxsize=100mb
filegrowth=25%
);
----修改数据库，新增次要文件ndf
alter database test add file(
name=f1,
filename='c:\data\f1.ndf',
size=10mb,
filegrowth=2mb,
maxsize=unlimited
),
(
name=f2,
filename='c:\data\f2.ndf',
size=5mb,
filegrowth=5%,
maxsize=50mb
)
---修改数据库，新增日志文件
alter database test add log file(
name=log1
filename='c:\data\log1.ldf',
size=10mb,
filegrowth=5%,
maxsize=100mb
)
---删除数据库
drop database test;
```




##### 表操作
- 创建表脚本

	```
	create table dept(
	dept_id int primary key,
	dept_name nvarchar(20) not null
	);
	create table emp(
	emp_id int primary key,
	name nvarchar(10) unique not null,
	sex nvarchar(1) default('女'),
	age int,
	sal int check(sal>=18000 and sal<=80000),
	dept_id int constraint fk_dept foreign key references dept(dept_id)
	);
	```
- 表的约束，包含新增、修改和删除约束

	```
	表的约束主要有主键约束、唯一约束、非空约束、默认约束、检查约束、外键约束
    主键约束：唯一且不能为null,主键通常不能修改，可以删除，通常使用整数，集群服务器有时候使用字符串
    唯一约束：可以为null,特别要注意的是在sql server中null只能为一个，而在oracle中可以有多个null(即在oracle中唯一约束仅对不为null的值)
    非空约束：默认是可以null,not null则提示该字段不能为null
    默认约束：插入数据有字段使用插入数据，如果没有该字段则使用默认值default(xx)
    检查约束：check(……)，只有满足条件数据才可以插入
    外键约束：增加与关联表的关系，constraint fk_xx foreign key(xx) references(xx)
	```
- 修改表，包含增、删、改、查
  - 新增

	```
	insert into tablename values(a,b,c);
	insert into tablename(a,b) values(a,b);
	insert into tablename(b,a) values(b,a);
	//批量插入 select 
	insert into tablename(a,b) as select c,d from e;
	//批量插入 top
	insert into tablename(a,b) as select top3 c,d from e;
	insert top 3 into tablename(a,b) as select c,d from e;
	```
  - 删除

	```
	delete from table;
	delete from table where ....;
	delete top 10 from xxx where ....;
	delete from table from a join b on ....; 
	```
  - 修改

	```
	update table set a=xx,b=xx where .....;
	update table set ... from a join b on ...;
	update top 2 table set xx where ....;
	```
  - 查询 

	```
	//计算列
	select * from xxx;
	select id,name from xxx;
	select id,name,sal,sal*12 as 年薪 from xxx;
	select 5 from xxxx;
	select 5;
	//distinct
	select distinct deptno from xxx;
	select distinct sal from xxx; ---可以过滤null
	select distinct deptno,sal from xxx,---deptno,sal整体考虑
	select top 3 distinct sal from xxx;
	select deptno,distinct sal from xxx;----错误查询
	//between
	select * from emp where sal between 2000 and 5000;
	select * from emp where sal not between 2000 and 5000;
	//in
	select * from emp where sal in(3000,4000,5000);
	select * from emp where sal not in(2000,3000,5000);
	select * from emp where sal=1000 or sal=2000 or sal=5000;
	select * from emp where sal<>1000 and sal<>4000 and sal<>5000;--在数据库中不等于可以使用=!或者<>，建议使用<>
	//top
	select top 2 * from emp;
	select top 15 percent * from emp;
	select top 4 * from emp where sal between 1000 and 5000 order by sal desc;---默认是升序，desc是降序,asc是升序。
	//null
	select * from emp where comm is null;
	select * from emp where comm is not null;
	select empno,sal*12+comm from emp;
	select empno,sal*12+isnull(comm,0) from emp;--isnull(comm,0)如果comm为null则设置为0，否则为comm值
	select empno,sal*12+comm "年薪" from emp;--注意该查询结果
	
	0和null的区别:0是确定值,null表示不确定空值，0可以参与运算，空值不可参与运算。
	
	让自己变成硬通货币，让自己不断升值，让自己非常有价值，要有一技之长。
	要自己有文化，有气质，有底蕴。
	电影《华尔街》
	
	//order by
	select * from emp order by sal;
	select * from emp order by deptno,sal;--先按照deptno升序，如果有顺序相同的再按照sal升序排序
	select * from emp order by deptno desc,sal;
	select * from emp order by deptno desc,sal asc;
	//模糊查询，使用通配符，%表示任意字符,_表示任意一字符,[a,f]表示a-f中任意一个字符,[^a-f]表示不是a-f中的任意一字符
	select * from emp where ename like '%a%';
	select * from emp where ename like '%a';
	select * from emp where ename like '_a%';
	select * from emp where ename like '_[a-f]%';
	select * from emp where ename like '_[a,f]%';----[a,f]是a,f中任意一个字符
	select * from emp where ename like '_[^a-c]%';
	select * from emp where ename like '_大小%';
	select * from emp where ename like '%\%%' escape '\';---查询字段中包含%
	select * from emp where ename like '%\_%' escape '_';
	//聚合函数
	
	
	---多表联合查询
	select * from a inner join b on a.xxx=b.xxx inner join c on b.y=c.y where ....;
	```
- 删除表

##### 函数

