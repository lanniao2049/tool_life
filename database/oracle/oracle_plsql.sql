
/*
    PL（procedural language） SQL 练习部分
*/
--打开屏幕输出
set serverout on
declare
    --说明
begin
    dbms_output.put_line('Hello world!');
end;
/

desc dbms_output
------------------
set serverout on
declare
    --定义数据类型
    pempno number(7,2);
    pname varchar(20);
    pdate date;
begin
    pempno := 1;
    dbms_output.put_line(pempno);
    pname :='Jack T';
    dbms_output.put_line(pname);
    pdate :=sysdate;
    dbms_output.put_line(pdate);
end;
/

-----------------------------
/*
    引用型号变量
*/
set serverout on
declare 
    pname emp.ename%type;
    psal emp.sal%type;
begin
    select ename,sal into pname,psal from emp where empno=7839;
    dbms_output.put_line(pname||'的薪水是'||psal);
end;
/
----------------
/*
    记录型变量
*/
set serverout on
declare
    --记录型变量
    emp_rec emp%rowtype;
begin
    select * into emp_rec from emp where empno=7839;
    dbms_output.put_line(emp_rec.ename||'的薪资是'||emp_rec.sal);
end;
/

------
/*
    接受一个键盘输入数字，使用if …… then ……判断
*/
set serverout on
--接受键盘输入，其中prompt是提示
--特别要注意下面的num是接受输入的地址
accept num prompt '请输入数字';
declare
    --声明变量，&num表示地址的值
    pnum number := &num;
begin
    --判断输入数字情况，使用 if 
    if pnum=0 then dbms_output.put_line('您输入的数字是0');
    elsif pnum=1 then dbms_output.put_line('您输入的数字是1');
    elsif pnum=2 then dbms_output.put_line('您输入的数字是2');
    else dbms_output.put_line('您输入的是其他数字');
    end if;
end;
/

-------------------------
/*
    使用while loop循环
    打印1-10的数字输出
*/
set serverout on
declare
    --初始化变量为1
    pnum number:=1;
begin
    while pnum<=10 loop
    dbms_output.put_line(pnum);
    --循环+
    pnum := pnum+1;
    end loop;
end;
/


-------------------------
/*
    使用loop循环，建议使用这种方式
*/

set serverout on
declare
    pnum number :=1;
begin
    loop
    --判断
    exit when pnum>10;
    
    dbms_output.put_line(pnum);
    --循环+
    pnum :=pnum+1;
    end loop;
end;
/


-------------------------
/*
    使用for loop循环，范围必须是连续
*/
set serverout on
declare
    pnum number:=1;
begin
    for pnum in 1..10 loop
    dbms_output.put_line(pnum);
    end loop;
end;
/

-----------------------------------
/*
    cursor，光标，也叫游标，是集合
    查询打印出员工的姓名和薪资
*/
set serverout on
declare
    --定义光标
    cursor cemp is select ename,sal from emp;
    --定义变量
    pename emp.ename%type;
    psal emp.sal%type;
begin
    --打开光标
    open cemp;
    --循环判断
        loop
        --从光标中提取一条记录
        fetch cemp into pename,psal;
        exit when cemp%notfound;
        --打印
        dbms_output.put_line(pename||'的薪资是'||psal);
        end loop;
    --关闭光标
    close cemp;
end;
/

-----------------------
/*
    给员工涨薪，总裁+1000，经理+800，其他+400，执行完毕输出涨薪完毕
    使用光标，为了不影响原始数据创建一个新表和emp相同
    思路：
        获取职称，根据不同职称遍历更新工资
*/
---创建类似emp表
drop table emp1;

create table emp1 as select * from emp;

--修改字段名称
alter table emp1 rename column job to empjob;

select empno,empjob,sal from emp1 order by sal desc;
---
set serverout on
declare
----定义光标
    cursor cemp is select empno,empjob from emp1;
----定义变量
    pempno emp1.empno%type;
    pjob emp1.empjob%type;
begin
    ---打开光标
    open cemp;
    ---循环判断
    loop
    ---提取一天记录
    fetch cemp into pempno,pjob;
    --exit判断，退出
    exit when cemp%notfound;
    ---更新操作
    if pjob='PRESIDENT' then update emp1 set sal=sal+1000 where empno=pempno;
    ELSIF pjob='MANAGER' then update emp1 set sal=sal+800 where empno=pempno;
    else update emp1 set sal=sal+400 where empno=pempno;
    end if;
    end loop;
    ---关闭光标
    close cemp;
    ---提交事务，一定要注意oracle默认的是read commite，根据ACID原则，如果不提交事务在其他的会话中无法查询到最新的数据。
    commit;
    --打印信息
    dbms_output.put_line('涨薪结束!');
end;
/

----
/*
    光标的属性：
        %found,%notfound
        %isopen 光标是否打开
        %rowcount 光标受到影响的行数
    光标的其他影响
        每个会话最多只能有300个光标要求
        可以使用sys登录查询下
        connect sys/Admin as sysdba;
        show parameter cursor;
        -----
        NAME                                 TYPE        VALUE
------------------------------------ ----------- ------------
cursor_bind_capture_destination      string      memory+disk
cursor_sharing                       string      EXACT
cursor_space_for_time                boolean     FALSE
open_cursors                         integer     300
session_cached_cursors               integer     50

---更新设置光标数据(主要scope的范围，both全部，memory仅仅是当前内存重启过后不生效，spfile是更新配置文件必须重启才能生效)
alter system set open_cursors=400 scope=both;
        
*/
---下面是分别演示%isopen和%rowcount的案例
--案例一：%isopen
set serverout on
declare
----定义光标
    cursor cemp is select empno,empjob from emp1;
----定义变量
    pempno emp1.empno%type;
    pjob emp1.empjob%type;
begin
    --打开光标
    open cemp;
    if cemp%isopen then dbms_output.put_line('打开光标');
    else dbms_output.put_line('没有打开光标');
    end if;
    --关闭光标
    close cemp;
end;
/

--案例二：%rowcount
set serverout on
declare
----定义光标
    cursor cemp is select empno,empjob from emp1;
----定义变量
    pempno emp1.empno%type;
    pjob emp1.empjob%type;
begin
    --打开光标
    open cemp;
    ---循环判断
    loop
    --提取记录
    FETCH cemp into pempno,pjob;
    ---exit判断
    exit when cemp%notfound;
    ---if判断
    dbms_output.put_line('输出光标影响数：'||cemp%rowcount);
    end loop;
    --关闭光标
    close cemp;
end;
/


/*
    光标还可以带参数
    cursor xx() is……
    求指定部门的员工姓名
*/
set serverout on
declare
    --定义光标
    cursor cemp(dno number) is select ename from emp1 where deptno=dno;
    --定义变量
    pename emp1.ename%type;
begin
    --打开光标,特别要注意此时的光标参数
    open cemp(20);
    loop
    ---提取每一条记录
    fetch cemp into pename;
    --exit
    exit when cemp%notfound;
    
    dbms_output.put_line(pename);
    end loop;
    --关闭光标
    close cemp;
end;
/

------
/*
    光标的例外 异常处理
    not_data_found
    too_many_rows
    zero_divide
    value_error
    timeout_on_resource
*/

---光标例外案例1:no_data_found
---求员工编号1234的员工姓名
set serverout on
declare
    --定义变量
    pename emp.ename%type;
begin
    select ename into pename from emp where empno=1234;
    
    --例外exception
    exception 
        when no_data_found then dbms_output.put_line('没有查询到数据');
        when others then dbms_output.put_line('其他例外情况');
end;
/

---光标例外案例2：too_many_rows
/*
    查询部门为20的员工姓名
*/
set serverout on
declare
    --定义变量
    pename emp.ename%TYPE;
begin
    select ename into pename from emp where deptno=20;
    ---光标例外exception，then后面可以是多条语句组成，使用others是其他的所有例外exception
    exception
        when too_many_rows then dbms_output.put_line('太多的记录数据');
                                dbms_output.put_line('查询不符合要求');
        when others then dbms_output.put_line('其他的例外情况');
end;
/

---光标例外案例3:zero_divide
set serverout on
declare
    --定义变量
    pnumber number(5,0);
begin
    pnumber :=1/0;
    --exception
    exception
        when zero_divide then dbms_output.put_line('zero_error例外');
                             dbms_output.put_line('0不能为被除数');
        when others then dbms_output.put_line('其他例外情况');                     
end;
/


---光标例外案例4:value_error
set serverout on
declare
    --定义变量
    pnumber number;
begin
    pnumber :='abcd';
    --exception
    exception
        when value_error THEN dbms_output.put_line('转换或者算数例外');
        when others then dbms_output.put_line('其他例外');
end;
/

---光标例外案例5：自定义例外
/*
    查询部门为50的员工姓名
*/
set serverout on
declare
    ---定义光标
    cursor cemp is select ename from emp where deptno=50;
    ---定义变量
    pename emp.ename%type;
    ---定义例外自定义
    no_emp_data exception;
begin
    --打开光标
    open cemp;
    --使用loop循环，根据光标定义查询不到数据，故loop省略
    --其他起来
    FETCH cemp into pename;
    if cemp%notfound then raise no_emp_data;
    end if;
    --关闭光标
    close cemp;
    
    --例外
    exception
        when no_emp_data then dbms_output.put_line('查询不到数据');
        when others then dbms_output.put_line('其他例外');
end;
/

-----------
/*
    光标综合案例1：
        求已知年份入职的员工个数
        total 1980 1981 1982 1987
        14    1    10   1    2
*/

set serverout on
declare
    --定义光标
    cursor cemp is select to_char(hiredate,'YYYY') from emp;
    --定义变量
    phiredate varchar2(4);
    
    count1980 number :=0;
    count1981 number :=0;
    count1982 number :=0;
    count1987 number :=0;
begin
    --打开光标
    open cemp;
    --循环判断
    loop
        --提取每一条记录
        fetch cemp into phiredate;
        --exit退出判断
        exit when cemp%notfound;
        
        ---业务判断，if判断
        if phiredate='1980' then count1980:=count1980+1;
            ELSIF phiredate='1981' then count1981:=count1981+1;
            ELSIF phiredate='1982' then count1982:=count1982+1;
            else count1987:=count1987+1;
        end if;
    end loop;    
    --关闭光标
    close cemp;
    ---打印输出
    dbms_output.put_line('total:'||(count1980+count1981+count1982+count1987));
    dbms_output.put_line('1980:'||count1980);
    dbms_output.put_line('1981:'||count1981);
    dbms_output.put_line('1982:'||count1982);
    dbms_output.put_line('1987:'||count1987);
end;
/

-----
/*
    光标综合案例2：
    为员工涨工资。从最低工资涨起每人涨10%，但是工资总额不能超过5W元，请计算涨工资的人数和涨工资后的工资总额，
    并输出涨工资人数以及工资总额。
    
    分析：
        使用光标--循环-退出
        退出：
            notfound
            工资总额大于5万元
    
    注意：
        为了不影响数据库原始数据，创建emp2（和emp数据类型和数据完全一致）
*/
create table emp2 as select * from emp;
select * from emp2;

------
set serverout on
declare
    --定义光标
    cursor cemp is select empno,sal from emp2 order by sal;
    --定义变量
    pempno emp2.empno%type;
    psal emp2.sal%type;
    --涨薪人数
    raisecount number :=0;
    --工资总额
    totalsal number;
    
begin
    --初始化工资总额
    select sum(sal) into totalsal from emp2;
    --打开光标
    open cemp;
    --循环判断
    loop
    --exit 工资总额判断
    exit when totalsal>50000;
    --提取每条记录
    fetch cemp into pempno,psal;
    --exit notfound
    exit when cemp%notfound;
    
    ---业务操作
    update emp2 set sal=sal*1.1 where empno=pempno;
    raisecount :=raisecount+1;
    totalsal := totalsal +psal*0.1;
    
    end loop;    
    --关闭光标
    close cemp;
    ---涉及修改数据操作，必须commit
    commit;
    --打印输出
    dbms_output.put_line('涨薪人数：'||raisecount||',工资总额：'||totalsal);
    
end;
/

----
/*
    光标综合案例2：
        不同部门薪资分布数量，0-3000,3001-6000,60001以上，以及求出每个部门的工作总额
        具体样例：
        detpno  com1 com2 com3 total
        20      1 ……
        30      1 ……
        40      1 ……
        分析：
            部门光标 detpno
                员工光标 传参 部门编号
                    部门段分布初始化，注意只能在部门光标之后
                    总成绩初始化，注意只能在部门光标之后
                在每个员工光标关闭后要将数据插入到指定的表中
            部门光标关闭后，因为涉及的修改操作，索引一定要commit    
*/
----
drop table msg;

create table msg(
    deptno number,
    count1 number,
    count2 number,
    count3 number,
    total number
);

select * from msg;

----
set serverout on
declare
    ---定义部门表光标
    cursor cdept is select deptno from dept;
    ---定义部门表变量
    cdeptno dept.deptno%type;
    
    ---定义员工表光标，指定部门
    cursor cemp(dno number) is select sal from emp where deptno=dno;
    ---定义员工表变量
    psal emp.sal%TYPE;
    
    ----定义部门分段员工个数
    count1 number;
    count2 number;
    count3 number;
    ----定义部门工资总额
    totalsal number;
begin
    ---部门光标打开
    open cdept;
        --循环判断
        loop
        --获取每个部门的编号信息
        fetch cdept into cdeptno;
        --退出exit
        exit when cdept%notfound;
        
        --在正常业务流程前，需要首先初始化薪资分段和部门合计工资数
        count1:=0;
        count2:=0;
        count3:=0;
        select sum(sal) into totalsal from emp where deptno=cdeptno;
        
        ---正常业务流程
            --打开员工光标
            open cemp(cdeptno);
            --循环判断
            loop
                --获取每条员工激励
                fetch cemp into psal;
                --exit
                exit when cemp%notfound;
                
                --if 判断
                if psal<=3000 then count1:=count1+1;
                elsif psal>3000 and psal<=6000 then count2:=count2+1;
                else count3:=count3+1;
                end if;
            end loop;
            --光标员工光标
            close cemp;
            
            ---执行数据插入操作
            insert into msg values(cdeptno,count1,count2,count3,nvl(totalsal,0));
            
        end loop;
    
    ---部门光标关闭
    close cdept;
    
    ---涉及到数据新增，需要提交事务
    commit;
    ---打印输出
    dbms_output.put_line('执行完毕');
end;
/



