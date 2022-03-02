
/*
    PL��procedural language�� SQL ��ϰ����
*/
--����Ļ���
set serverout on
declare
    --˵��
begin
    dbms_output.put_line('Hello world!');
end;
/

desc dbms_output
------------------
set serverout on
declare
    --������������
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
    �����ͺű���
*/
set serverout on
declare 
    pname emp.ename%type;
    psal emp.sal%type;
begin
    select ename,sal into pname,psal from emp where empno=7839;
    dbms_output.put_line(pname||'��нˮ��'||psal);
end;
/
----------------
/*
    ��¼�ͱ���
*/
set serverout on
declare
    --��¼�ͱ���
    emp_rec emp%rowtype;
begin
    select * into emp_rec from emp where empno=7839;
    dbms_output.put_line(emp_rec.ename||'��н����'||emp_rec.sal);
end;
/

------
/*
    ����һ�������������֣�ʹ��if ���� then �����ж�
*/
set serverout on
--���ܼ������룬����prompt����ʾ
--�ر�Ҫע�������num�ǽ�������ĵ�ַ
accept num prompt '����������';
declare
    --����������&num��ʾ��ַ��ֵ
    pnum number := &num;
begin
    --�ж��������������ʹ�� if 
    if pnum=0 then dbms_output.put_line('�������������0');
    elsif pnum=1 then dbms_output.put_line('�������������1');
    elsif pnum=2 then dbms_output.put_line('�������������2');
    else dbms_output.put_line('�����������������');
    end if;
end;
/

-------------------------
/*
    ʹ��while loopѭ��
    ��ӡ1-10���������
*/
set serverout on
declare
    --��ʼ������Ϊ1
    pnum number:=1;
begin
    while pnum<=10 loop
    dbms_output.put_line(pnum);
    --ѭ��+
    pnum := pnum+1;
    end loop;
end;
/


-------------------------
/*
    ʹ��loopѭ��������ʹ�����ַ�ʽ
*/

set serverout on
declare
    pnum number :=1;
begin
    loop
    --�ж�
    exit when pnum>10;
    
    dbms_output.put_line(pnum);
    --ѭ��+
    pnum :=pnum+1;
    end loop;
end;
/


-------------------------
/*
    ʹ��for loopѭ������Χ����������
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
    cursor����꣬Ҳ���α꣬�Ǽ���
    ��ѯ��ӡ��Ա����������н��
*/
set serverout on
declare
    --������
    cursor cemp is select ename,sal from emp;
    --�������
    pename emp.ename%type;
    psal emp.sal%type;
begin
    --�򿪹��
    open cemp;
    --ѭ���ж�
        loop
        --�ӹ������ȡһ����¼
        fetch cemp into pename,psal;
        exit when cemp%notfound;
        --��ӡ
        dbms_output.put_line(pename||'��н����'||psal);
        end loop;
    --�رչ��
    close cemp;
end;
/

-----------------------
/*
    ��Ա����н���ܲ�+1000������+800������+400��ִ����������н���
    ʹ�ù�꣬Ϊ�˲�Ӱ��ԭʼ���ݴ���һ���±��emp��ͬ
    ˼·��
        ��ȡְ�ƣ����ݲ�ְͬ�Ʊ������¹���
*/
---��������emp��
drop table emp1;

create table emp1 as select * from emp;

--�޸��ֶ�����
alter table emp1 rename column job to empjob;

select empno,empjob,sal from emp1 order by sal desc;
---
set serverout on
declare
----������
    cursor cemp is select empno,empjob from emp1;
----�������
    pempno emp1.empno%type;
    pjob emp1.empjob%type;
begin
    ---�򿪹��
    open cemp;
    ---ѭ���ж�
    loop
    ---��ȡһ���¼
    fetch cemp into pempno,pjob;
    --exit�жϣ��˳�
    exit when cemp%notfound;
    ---���²���
    if pjob='PRESIDENT' then update emp1 set sal=sal+1000 where empno=pempno;
    ELSIF pjob='MANAGER' then update emp1 set sal=sal+800 where empno=pempno;
    else update emp1 set sal=sal+400 where empno=pempno;
    end if;
    end loop;
    ---�رչ��
    close cemp;
    ---�ύ����һ��Ҫע��oracleĬ�ϵ���read commite������ACIDԭ��������ύ�����������ĻỰ���޷���ѯ�����µ����ݡ�
    commit;
    --��ӡ��Ϣ
    dbms_output.put_line('��н����!');
end;
/

----
/*
    �������ԣ�
        %found,%notfound
        %isopen ����Ƿ��
        %rowcount ����ܵ�Ӱ�������
    ��������Ӱ��
        ÿ���Ự���ֻ����300�����Ҫ��
        ����ʹ��sys��¼��ѯ��
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

---�������ù������(��Ҫscope�ķ�Χ��bothȫ����memory�����ǵ�ǰ�ڴ�����������Ч��spfile�Ǹ��������ļ���������������Ч)
alter system set open_cursors=400 scope=both;
        
*/
---�����Ƿֱ���ʾ%isopen��%rowcount�İ���
--����һ��%isopen
set serverout on
declare
----������
    cursor cemp is select empno,empjob from emp1;
----�������
    pempno emp1.empno%type;
    pjob emp1.empjob%type;
begin
    --�򿪹��
    open cemp;
    if cemp%isopen then dbms_output.put_line('�򿪹��');
    else dbms_output.put_line('û�д򿪹��');
    end if;
    --�رչ��
    close cemp;
end;
/

--��������%rowcount
set serverout on
declare
----������
    cursor cemp is select empno,empjob from emp1;
----�������
    pempno emp1.empno%type;
    pjob emp1.empjob%type;
begin
    --�򿪹��
    open cemp;
    ---ѭ���ж�
    loop
    --��ȡ��¼
    FETCH cemp into pempno,pjob;
    ---exit�ж�
    exit when cemp%notfound;
    ---if�ж�
    dbms_output.put_line('������Ӱ������'||cemp%rowcount);
    end loop;
    --�رչ��
    close cemp;
end;
/


/*
    ��껹���Դ�����
    cursor xx() is����
    ��ָ�����ŵ�Ա������
*/
set serverout on
declare
    --������
    cursor cemp(dno number) is select ename from emp1 where deptno=dno;
    --�������
    pename emp1.ename%type;
begin
    --�򿪹��,�ر�Ҫע���ʱ�Ĺ�����
    open cemp(20);
    loop
    ---��ȡÿһ����¼
    fetch cemp into pename;
    --exit
    exit when cemp%notfound;
    
    dbms_output.put_line(pename);
    end loop;
    --�رչ��
    close cemp;
end;
/

------
/*
    �������� �쳣����
    not_data_found
    too_many_rows
    zero_divide
    value_error
    timeout_on_resource
*/

---������ⰸ��1:no_data_found
---��Ա�����1234��Ա������
set serverout on
declare
    --�������
    pename emp.ename%type;
begin
    select ename into pename from emp where empno=1234;
    
    --����exception
    exception 
        when no_data_found then dbms_output.put_line('û�в�ѯ������');
        when others then dbms_output.put_line('�����������');
end;
/

---������ⰸ��2��too_many_rows
/*
    ��ѯ����Ϊ20��Ա������
*/
set serverout on
declare
    --�������
    pename emp.ename%TYPE;
begin
    select ename into pename from emp where deptno=20;
    ---�������exception��then��������Ƕ��������ɣ�ʹ��others����������������exception
    exception
        when too_many_rows then dbms_output.put_line('̫��ļ�¼����');
                                dbms_output.put_line('��ѯ������Ҫ��');
        when others then dbms_output.put_line('�������������');
end;
/

---������ⰸ��3:zero_divide
set serverout on
declare
    --�������
    pnumber number(5,0);
begin
    pnumber :=1/0;
    --exception
    exception
        when zero_divide then dbms_output.put_line('zero_error����');
                             dbms_output.put_line('0����Ϊ������');
        when others then dbms_output.put_line('�����������');                     
end;
/


---������ⰸ��4:value_error
set serverout on
declare
    --�������
    pnumber number;
begin
    pnumber :='abcd';
    --exception
    exception
        when value_error THEN dbms_output.put_line('ת��������������');
        when others then dbms_output.put_line('��������');
end;
/

---������ⰸ��5���Զ�������
/*
    ��ѯ����Ϊ50��Ա������
*/
set serverout on
declare
    ---������
    cursor cemp is select ename from emp where deptno=50;
    ---�������
    pename emp.ename%type;
    ---���������Զ���
    no_emp_data exception;
begin
    --�򿪹��
    open cemp;
    --ʹ��loopѭ�������ݹ�궨���ѯ�������ݣ���loopʡ��
    --��������
    FETCH cemp into pename;
    if cemp%notfound then raise no_emp_data;
    end if;
    --�رչ��
    close cemp;
    
    --����
    exception
        when no_emp_data then dbms_output.put_line('��ѯ��������');
        when others then dbms_output.put_line('��������');
end;
/

-----------
/*
    ����ۺϰ���1��
        ����֪�����ְ��Ա������
        total 1980 1981 1982 1987
        14    1    10   1    2
*/

set serverout on
declare
    --������
    cursor cemp is select to_char(hiredate,'YYYY') from emp;
    --�������
    phiredate varchar2(4);
    
    count1980 number :=0;
    count1981 number :=0;
    count1982 number :=0;
    count1987 number :=0;
begin
    --�򿪹��
    open cemp;
    --ѭ���ж�
    loop
        --��ȡÿһ����¼
        fetch cemp into phiredate;
        --exit�˳��ж�
        exit when cemp%notfound;
        
        ---ҵ���жϣ�if�ж�
        if phiredate='1980' then count1980:=count1980+1;
            ELSIF phiredate='1981' then count1981:=count1981+1;
            ELSIF phiredate='1982' then count1982:=count1982+1;
            else count1987:=count1987+1;
        end if;
    end loop;    
    --�رչ��
    close cemp;
    ---��ӡ���
    dbms_output.put_line('total:'||(count1980+count1981+count1982+count1987));
    dbms_output.put_line('1980:'||count1980);
    dbms_output.put_line('1981:'||count1981);
    dbms_output.put_line('1982:'||count1982);
    dbms_output.put_line('1987:'||count1987);
end;
/

-----
/*
    ����ۺϰ���2��
    ΪԱ���ǹ��ʡ�����͹�������ÿ����10%�����ǹ����ܶ�ܳ���5WԪ��������ǹ��ʵ��������ǹ��ʺ�Ĺ����ܶ
    ������ǹ��������Լ������ܶ
    
    ������
        ʹ�ù��--ѭ��-�˳�
        �˳���
            notfound
            �����ܶ����5��Ԫ
    
    ע�⣺
        Ϊ�˲�Ӱ�����ݿ�ԭʼ���ݣ�����emp2����emp�������ͺ�������ȫһ�£�
*/
create table emp2 as select * from emp;
select * from emp2;

------
set serverout on
declare
    --������
    cursor cemp is select empno,sal from emp2 order by sal;
    --�������
    pempno emp2.empno%type;
    psal emp2.sal%type;
    --��н����
    raisecount number :=0;
    --�����ܶ�
    totalsal number;
    
begin
    --��ʼ�������ܶ�
    select sum(sal) into totalsal from emp2;
    --�򿪹��
    open cemp;
    --ѭ���ж�
    loop
    --exit �����ܶ��ж�
    exit when totalsal>50000;
    --��ȡÿ����¼
    fetch cemp into pempno,psal;
    --exit notfound
    exit when cemp%notfound;
    
    ---ҵ�����
    update emp2 set sal=sal*1.1 where empno=pempno;
    raisecount :=raisecount+1;
    totalsal := totalsal +psal*0.1;
    
    end loop;    
    --�رչ��
    close cemp;
    ---�漰�޸����ݲ���������commit
    commit;
    --��ӡ���
    dbms_output.put_line('��н������'||raisecount||',�����ܶ'||totalsal);
    
end;
/

----
/*
    ����ۺϰ���2��
        ��ͬ����н�ʷֲ�������0-3000,3001-6000,60001���ϣ��Լ����ÿ�����ŵĹ����ܶ�
        ����������
        detpno  com1 com2 com3 total
        20      1 ����
        30      1 ����
        40      1 ����
        ������
            ���Ź�� detpno
                Ա����� ���� ���ű��
                    ���Ŷηֲ���ʼ����ע��ֻ���ڲ��Ź��֮��
                    �ܳɼ���ʼ����ע��ֻ���ڲ��Ź��֮��
                ��ÿ��Ա�����رպ�Ҫ�����ݲ��뵽ָ���ı���
            ���Ź��رպ���Ϊ�漰���޸Ĳ���������һ��Ҫcommit    
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
    ---���岿�ű���
    cursor cdept is select deptno from dept;
    ---���岿�ű����
    cdeptno dept.deptno%type;
    
    ---����Ա�����ָ꣬������
    cursor cemp(dno number) is select sal from emp where deptno=dno;
    ---����Ա�������
    psal emp.sal%TYPE;
    
    ----���岿�ŷֶ�Ա������
    count1 number;
    count2 number;
    count3 number;
    ----���岿�Ź����ܶ�
    totalsal number;
begin
    ---���Ź���
    open cdept;
        --ѭ���ж�
        loop
        --��ȡÿ�����ŵı����Ϣ
        fetch cdept into cdeptno;
        --�˳�exit
        exit when cdept%notfound;
        
        --������ҵ������ǰ����Ҫ���ȳ�ʼ��н�ʷֶκͲ��źϼƹ�����
        count1:=0;
        count2:=0;
        count3:=0;
        select sum(sal) into totalsal from emp where deptno=cdeptno;
        
        ---����ҵ������
            --��Ա�����
            open cemp(cdeptno);
            --ѭ���ж�
            loop
                --��ȡÿ��Ա������
                fetch cemp into psal;
                --exit
                exit when cemp%notfound;
                
                --if �ж�
                if psal<=3000 then count1:=count1+1;
                elsif psal>3000 and psal<=6000 then count2:=count2+1;
                else count3:=count3+1;
                end if;
            end loop;
            --���Ա�����
            close cemp;
            
            ---ִ�����ݲ������
            insert into msg values(cdeptno,count1,count2,count3,nvl(totalsal,0));
            
        end loop;
    
    ---���Ź��ر�
    close cdept;
    
    ---�漰��������������Ҫ�ύ����
    commit;
    ---��ӡ���
    dbms_output.put_line('ִ�����');
end;
/



