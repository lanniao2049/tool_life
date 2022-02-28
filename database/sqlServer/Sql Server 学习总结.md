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
- 数据库语言分类
  - DDL(data definition language) 
    - create,alter,drop,truncate
  - DML(data manipulation language)
    - insert,update,delete,select
  - DCL(date control language)
    - grant,deny,revoke


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
    
    ```
        bitint 8个字节 -2^63,2^63-1
        int 4个字节 -2^31,2^31-1
        small 2个字节 -2^15,2^15-1
        tinyint 1个字节 0-255
        bit, 0,1
        deciaml(p,x)  --p总长度，x为小数长度
        datetime
        smalldatetime
        
        char(n)  ---默认为1，小于指定长度填满，超过长度截取
        varchar(n)---可变的
        nvarchar(n)
    ```
    
    
    
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
  
  ```

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
	
- 修改数据库表结构
```
    alter table xx alter column name nvarchar(100) not null;
    
    alter table xxx drop colum name;
    
    alter table xxx add address nvarchar(50);
    
    alter table xx add constraint zz primary key(id);
    
    alter table xx add constraint pk_grade foreign key(cid) references class(id);
    
    alter table xxx drop constraint pk-xxx;
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
	  
	  
	  --主键约束,表中只有一个主键，主键约束时候是not null ,字段允许null，则该字段不能添加主键约束
	    alter table student
	    add constraint pk_sid primary key(sid);
	    
	--唯一约束
	    alter table student
	    add constraint un_name unique(sname);
	    
	--检查约束
	    alter table student
	    add constraint check_age check(age>=10 and age<=110);
	    
	    alter table university
	    add constraint check_un_name check(un_name='Qsinghua' or un_name='Peking');
	    
	--默认约束
	    alter table student
	    add constraint default_sex default 'man' for sex;
	    
	--外键约束
	    需要满足一定的条件：
	        1.外键字段类型必须和引用字段类型一致，包含长度。
	        2.引用字段必须是主键或者唯一约束字段。
	        
	    alter table teacher
	    add constraint fk_courseid foreign key(courseid) references course(courseid);
	    
	    
	--删除约束
	
	    alter table student
	    drop constraint fk_courseid;
	    
	    
	--联合主键
	    create table xx
	    (
	      sid int foreign key references student(sid),
	      courseid int foreign key references course(courseid),
	      xx char(20) not null,
	      xx char(20) default 'man',
	      xx int unique,
	      xx int check (xx>=50 and xx<=1000),
	      primary key(sid,courseid)
	    )
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
	//聚合函数，聚合函数分类：单行聚合函数和多行聚合函数
	select lower(ename),upper(ename) from emp;
	select max(sal),min(sal),sum(sal),count(sal),avg(sal) from emp
	select count(distinct(deptno)) from emp;
	select count(comm) frome emp;---注意为null的字段不户籍当做有效的记录
	select count(*) from emp;----特别是要注意计算null的值
	//group by 分组
	select deptno,avg(sal),max(avg) from emp group by deptno;----只能使用分组后的整体信息，不能是组的具体信息
	select deptno,job,count(sal),max(sal),min(sal),avg(sal) from emp group by deptno,job order by job desc;---多个分组信息，以最新的分组信息为准，后面只能跟多行聚合函数
	group by a,b,c分组 表示先按照a分组，a相同后再按照b分组，b相同了在按照c分组
	select comm from emp group by comm;---null分组多行只能算一行
	//having，只能使用在group by 聚合函数之后
	select deptno,avg(sal) from emp group by deptno having avg(sal)>2000;
	select depnto,avg(sal) from emp group by depnto having deptno>10;
	select depnto,avg(sal) from emp group by depnto having count(*)>1;
	select depnto,avg(sal) '平均工资' from emp group by deptno having avg(sal) >2000;--注意having后面不能使用别名，having后面的判断条件只能使用聚合函数即只能使用分组的整体信息
	select deptno,avg(sal) from emp where name like '%A%' group by deptno having avg(sal)>3000;
	select deptno,avg(sal) from emp where sal>2000 group by deptno having avg(sal)>4000;
	where与having的区别:
	相同点：
		都是过滤查询，并且都不能使用列的别名
	不同点：
		where是原始数据过滤，having是分组过后的过滤，并且where必须在having之前
	select * from xxx where ... group by ....having ....order by ....;	
	
	---多表联合查询
	select * from a inner join b on a.xxx=b.xxx inner join c on b.y=c.y where ....;
	//连接查询
	select e.ename,d.dname from emp e join dept d on e.deptno=d.deptno;
	select * from emp,dept;---笛卡尔积
	select e.ename,d.dname from emp e,dept d where e.deptno=d.deptno;
	select e.ename,d.dname from emp e,dept d on 1=1;---笛卡尔积 有join 必须有on ,不能省略
	select * from a,b where ...和select * frome a join b on xxxx的区别？到底使用哪个比较好？sql92标准和sql99标准，第二种更容易理解 on连接条件,where是过滤，分工不同
	select * from emp e,dept d where e.sal>2000 and e.deptno=d.deptno;
	select * from emp e join dept d on e.deptno=d.deptno where e.sal>2000;----注意on和wehre的顺序有什么不同？？
	大于2000的员工姓名，部门名称，工资等级
  sql99标准
    select e.ename,d.dname,s.grade from emp e join dept d on e.deptno=d.deptno join salgrade s on e.sal>=s.losal and e.sal<=s.hisal and e.sal>2000;
  sql92标准
    select e.ename,d.dname,s.grade from emp e,dept d,salgrade s where e.deptno=d.deptno and (e.sal>=s.losal and e.sal<=s.hisal) and s.sal>2000;
    select * from emp e,dept d where e.deptno=10;
	转为sql99标准
	select * from emp e join dept d on 1=1 where e.deptno=10;
	       
	输出不包含'A'的最高工资的前三名的员工姓名、部门编号、工资等级    
	select top 3 e.ename,d.dname,s.grade from emp e join dept d on e.deptno=d.deptno join salgrade s on e.sal between s.losal and s.hisal where e.ename not like '%A%' order by e.sal desc;
	     
	select * from emp A, dept B;   ---笛卡尔积,有A*B行数据，有A+B列数据
	select * from emp,dept where empno=7369
	   
	select e.ename,d.deptname from emp e join dept d on e.deptno=d.deptno;  --- join 后面必须有on，不可省略
	   
	select e.ename,d.deptname from emp e join dept d on 1=1;  ---笛卡尔积
	   
	select deptno from emp e join dept d on 1=1;  ---错误查询 不确定是哪个列
	   
	select * from a,b where a.xx=b.xx和select * from a join b on a.xx=b.xx的区别
	a,b where 是sql92标准，a join b on a.xx=b.xx是sql99标准，推荐使用sql99标准，它更容易理解
	   
	--sql92标准实现
	select * from emp e,dept d where e.sal>2000 and e.deptno=d.deptno;   
	--sql99标准实现    
	select * from emp e join dept d on e.deptno=d.deptno where e.sal>2000;
	
	习题1
	   求出每个员工的姓名、部门编号、薪水和薪水的等级
	   
	   select e.ename,e.deptno,e.sal,s.grade from emp e join salgrade s on e.sal>=s.losal and e.sal<=s.hisal;
	   
	   
	   习题2
	   查找每个部门的编号，该部门所有员工的平均工资，平均工资的等级
	   
	   select e.deptno,e.sal_avg,s.grade from
	   (select e.deptno,avg(e.sal) sal_avg from emp e group by e.deptno) e join salgrade s on e.sal_avg between s.losal and s.hisal;
	   
	   
	   习题3
	   求出emp表中所有领导的姓名
	   
	   select ename from emp where empno in(select mgr from emp);
	   
	   求出emp表中不是领导的姓名
	   select ename from emp where empno not in(select mgr from emp);
	   
	   ---注意in 与null的组合问题
	   
	   习题4
	   求出平均薪水最高的部门的编号和部门的平均工资
	   
	   select top 1 deptno,avg(sal) from emp group by deptno order by avg(sal) desc;
	   
	   习题5
	   把工资大于所有员工中工资最低的前3个人的姓名、工资、部门编号、部门名、工资等级
	   --下面那个是正确的？？？
	   
	   select e.ename,e.sal,e.deptno,d.deptname,s.grade from (
	   select top 3 ename,sal,deptno from emp where sal>(select min(sal) from emp) order by sal asc
	   ) e join dept d on e.deptno=d.deptno join salgrade s on e.sal between s.losal and s.hisal;
	  
	   或者
	   select e.ename,e.sal,e.deptno,d.deptname,s.grade from (
	   select top 3 ename,sal,deptno from emp where sal>(select min(sal) from emp)
	   ) e join dept d on e.deptno=d.deptno join salgrade s on e.sal between s.losal and s.hisal order by sal asc;
	  
	  ---把工资大于1500的所有的员工按照部门分组、输出部门平均工资大于2000的最高的前两个部门的部门编号、部门名称、平均工资的等级
	    select d.detpno,d.deptname,s.grade from dept d join
	    (select top 2 deptno,avg(sal) avg_sal from emp where sal>1500 group by deptno having avg(sal)>2000 order by avg_sal desc) t
	    on d.deptno = t.deptno join salgrade s on t.avg_sal between s.losal and s.hisal;
	    
	//外连接
		左连接 左表对应有右边一条或者多条数据，若右表无数据则对应一条null
	    select * from emp e left join dept d on e.deptno = d.deptno;
	    完全连接 左表对应右边有数据，若无数据则右边显示null，右表在左右无数据，则左表显示null
	    select * from emp e full join dept d on e.deptno = d.deptno;
	    交叉连接
	    select * from emp e cross join dept d on e.deptno = d.deptno;  --相等于笛卡尔积
	    自连接 自己连接自己
	    ----不允许使用聚合函数求emp中最高的工资信息
	    select * from emp where sal not in(
	    select distinct(e1.empno) from emp e1
	    join emp e2 on e1.sal<e2.sal
	    );
	//联合查询 union
    --员工的姓名、工资、上司的名称
   select e1.ename,e1.sal,e2.ename from emp e1
	   join emp e2
	   on e1.mgr=e2.empno
	   union
	   select ename,sal,'已经是大boss' from emp where mgr is null;
	   ---满足联合查询的条件
	   1.select 查询列字段个数一致
	   2.select 查询列字段是兼容的

	//分页查询
	---n是表示显示条数，m表示第几页
	      select top n * from A where a_id not in(select top (m-1)*n a_id from A);
	
	//exist的使用
	---判断true或者false，true查询显示，false查询不显示
	        select * from emp e where exist(select * from dept d where d.deptno=e.deptno);
	        
	//获取数据库服务器时间
	      select getdate();
	      
	      select * from xxx  where createdate between '2020-01-01' and getdate();        
	      
	
	
	```
	
- 删除表

- 主键自增

```
	//主键自动 identity
	create table student
	    (
	      st_id int primary key identity(100,5),
	      st_name nvarchar(20) not null
	    )
	    
	    insert into student values('张三')；
	    insert into student(st_name) values('李四');
	    
	    --identity(m,n) m表示起始之，n表示自增值
	    主键可以不连续
	    比如删除一条数据后再插入数据则是从110开始
	    delete from student st_name ='李四';
	    insert into student values('王五');
```
- 视图

```
	create view v$_xxx
     as select * xxxxxx;
     ---使用视图，简化查询，减少代码冗余，增加数据的保密性，虚拟的临时表
    
     alter view v$_xxx as ******;
    
     exec sp_help v$_xxx;
     exec sp_helptext v$_xxx;
      
     drop view v$_xxx;
      
     视图的缺点：
        增加了数据库的维护成本，原表删除或者字段删除或者修改，则依附于原表的视图可能无效
        只是简化了查询，并不能优化查询
        
    视图应该注意的事项：
        1.视图中的列建议使用别名
        2.视图是虚拟表，不是物理表
        3.建议不要使用视图更新数据，更新数据使用原表更新
```
- 事务

```
	  1.避免不合理的中间状态
      2.多用户共享数据的时候
      
      开启事务
      begin transaction
      提交事务
      commit transaction
      回滚事务
      rollback transaction
      
      事务的特性：
        原子性
        一致性
        隔离性
        持久性
        
    begin transaction
    insert into tablex(xx) ,values(xxx);
    insert into tablex(xx) ,values(xxx);
    insert into tablex(xx) ,values(xxx);
    insert into tablex(xx) ,values(xxx);
    declare @studentcount int
    select @studentcount=select count(*) from xxx)
    if @studentcount>10
        begin
        rollback transaction
        print '插入数据过多，插入失败'
        end
    else
        begin
        commit transaction
        print '插入成功'
        end
        
        
```
- 存储过程、游标

```
      游标
        --声明游标
        declare cusor_fruit cusor for select f_name,f_price from fruite;
        --打开游标
        open cusor_fruit;
        --读取游标
        FETCH NEXT FROM cusor_fruit
        while @@FETCH_STATUS=0
        BEGIN
            FETCH NEXT FROM cusor_fruit
        END
        ---关闭游标
        close cusor_fruit
        --释放游标，释放资源
        DEALLOCATE cusor_fruit;
        
        --样例
        DECLARE @VarCusor Cursor --- 声明游标
        DECLARE cusor_fruit CURSOR FOR --创建游标
        select f_name,f_price from fruite;
        open cusor_fruit
        set @VarCusor=cusor_fruit ---为游标赋值
        FETCH NEXT FROM @VarCusor
        WHILE @@FETCH_STATUS=0 ---判断FETCH 语句是否执行成功
        BEGIN
            FETCH NEXT FROM @VarCusor
        END
        close cusor_fruit  --关闭游标
        DEALLOCATE cusor_fruit ---释放游标
        
        
        存储过程
        create procedure CoutPorc
        as select count(*) as 总数 from fruite;
        ---调用存储过程
        exec CoutPorc;
        
        ---指定的存储过程
        create procedure QueryByid @sId int
        as select * from fruite where s_id=@sId;
        --调用存储过程
        exec QueryByid 101;
        exec QueryByid @sId=101;
        
        ---创建默认的存储过程
        create procedure QueryByid2 @sId int=101
        as select * from fruite where sId=@sId;
        
        --删除存储过程
        drop procedure xxx;
```





- 触发器

  ```
  ---触发器的使用
          CREATE TRIGGER Insert_Student
          on stu_info
          AFTER INSERT
          AS
          BEGIN
              IF OBJECT_ID(N'stu_Sum',N'U') IS NULL ------判断stu_Sum表是否存在
                  Create table stu_Sum(number int default 0);--------创建存储学生人数的stu_Sum表
              DECLARE @stuNuber int;
              select @stuNuber=count(*) from stu_info;
              if not exist(select * from stu_Sum)   ---判断表中是否有记录
                  insert into stu_Sum values(0);
              update stu_Sum set number=@stuNuber;----把更新后的总学生人数插入到stu_Sum表中    
          END
          
          ---插入数据
          select count(*) stu_info表中总人数  from stu_info;
          insert into stu_info(s_id,s_name,s_score,s_sex) values(20,'Rose',87,'女');
          select count(*) stu_info表中总人数  from stu_info;
          select number as stu_Sum表中总人数 from stu_Sum;
          
          ---触发器 样例2
          
          create trigger insert_forbidden
          on stu_Sum
          after insert
          as
          begin
              raiserror('不允许直接向该表插入记录，操作被禁止',1,1)
          rollback transaction    
          end
          
          insert into stu_Sum values(5);
          
          --删除触发器
          create trigger delete_student
          on stu_info
          after delete
          as
          begin
              select s_id as 已经删除学生编号，s_name,s_score,s_sex from delete
          end
          
          delete from stu_info where s_id=6;
          
          ---更新操作触发器
          create trigger update_student
          on stu_info
          after update
          as
          begin
          declare @stuCount int;
          select @stuCount=count(*) from stu_info;
          update stu_Sum set number=@stuCount;
          
          select s_id as 更新前学生编号,s_name 更新前学生姓名 from deleted
          select s_id as 更新后学生编号,s_name 更新后学生姓名 from inserted
          end
          
          update stu_info set s_name='kit' where s_id=1;
          
          
          ----
          select db_id('xxxdata');
          
          select object_id('student','U');--U表示用户表
  ```

  

- 索引

```
    create unique clustered index xx on table_xx(xx_id desc) with fillfactor=30;
    
     ---clustered 聚集索引
     ---nonclustered 非聚集索引
     ---默认是非聚集索引
    
     --查询索引
     exec sp_helpindex 'table_xx';
     --删除索引
     exec sp_helpindex 'table_xx' drop index table_xx.xxx;
    
     drop index table.索引名
```
- 触发器

##### 函数

- 常见函数

```
        len('xxxx')
        select rand();
        select floor(rand()*10),ceiling(rand()*10);
        select getdate(),getutcdate();
        datediff(day/month/year,startdate,enddate)
        select date(getdate()),moth(getdate()),year(getdate());
        substring(xxx),ltrim(xxx),rtrim(xxx),
        upper(xxx),lower(xxx)
        reverse(xxxx);
        select * from emp
        case when sal>5000 then 'A++'
        when sal <=5000 then 'B++'
        else 'C++' end;
```
- 其他函数

  - 变量

  ```
     --变量
       select @@VERSION,@@SERVERNAME;
      
       DECLARE @mycount int;
  
  
      
  --局部变量
      declare @studentnum varchar(100)  --declare
      
      declare @name,@age;
      ---赋值
      set @name=expression；---一次仅仅可以赋值一个
      set @name='Licy'
      set @age=10
      select @name=expression,@age=expression;---一次可以赋值多个
      
      select @name='ly',@age=34;
      
      --全部变量
      @@version,@@connections,@@cpu_busy
      
      
      ---print
      print 'hello everyone'
      print @name
  ```

  

  - 表达式

    ```
    ---表达式
        begin
            
        end
        ----
        declare @x int，@y int, @z int
        set @x=10
        set @y=5
        begin
            set @z=@x
            set @x=@y
            set @y=@z
        end
        print @x
        print @y
        
        
        
        
        if expression
        else expression
        ---
        declare @x int,@y int
        set @x=10
        set @y=9
        if @x>@y
            print 'true'
        else
            print 'false'
        
        
        ---
        while expression
        begin
            
        end
        ---计算1到10之间的和
        declare @x int ,@sum int
        set @x=1
        set @sum=0
        while @x<=10
        begin
            set @sum=@sum+@x
            set @x=@x+1
        end
        print @sum
        
        
        ---case
        
        declare @grade int,@msg varchar(100)
        set @grade=91
        set @msg=
        case
            when @grade>=90 then   'A++'
            when @grade>=80 then   'B++'
            when @grade>=70 then  'C++'
            else 'D+'
        end
        print  @msg
    ```

    