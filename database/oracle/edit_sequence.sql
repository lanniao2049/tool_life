declare
v_tablename VARCHAR2(64); -- 当前表名
v_maxId number;		-- 当前表 最大id
v_sql VARCHAR2(1024);   -- 查最大id sql
v_sql_updateSeq VARCHAR2(1024);  -- 更新递增值 sql
v_sql_currentSeq VARCHAR2(1024);  -- 查当前表 序列值、递增值
v_sql_addSeq VARCHAR2(1024);  -- 更新当前序列值
v_count number;  -- 判断表是否有id字段的临时标识
v_current_seq number;  -- 当前表的序列值
v_current_increment number;  -- 当前表的递增值
v_temp_add number;  -- 当前表的修改后递增值
v_hasSeq number;  -- 是否存在该序列表的标识 >0 为有
v_tempData number;  -- 临时存放，只是为了select动态sql能够顺利执行，并不拿来使用

cursor tablename_cur is select table_name from user_tables;
rowtypes user_tables%rowtype;

BEGIN
	for rowtypes in tablename_cur loop
	v_tablename := rowtypes.table_name;
	
	select count(1) into v_count from cols where table_name = v_tablename and column_name = 'ID';
	if v_count > 0 then 
		-- 查当前表最大id
		v_sql := 'select max(ID) from '||v_tablename;
		execute immediate v_sql into v_maxId;
		exit when tablename_cur%notfound;

		if v_maxId is not null then 

			-- 递增当前序列
			v_sql_addSeq := 'select '||v_tablename||'_SEQ.nextval from dual';

			-- 查当前表序列值、递增值

			select count(1) into v_hasSeq from user_sequences where sequence_name = v_tablename||'_SEQ';

			if v_hasSeq > 0 then 

			select last_number into v_current_seq from user_sequences where sequence_name = v_tablename||'_SEQ';
			select increment_by into v_current_increment from user_sequences where sequence_name = v_tablename||'_SEQ';

				-- 判断当前表序列值是否小于id,是则修改
				if v_maxId > v_current_seq then 
					-- 计算新递增值
					v_temp_add := v_maxId - v_current_seq + v_current_increment;

dbms_output.put_line(v_tablename||'--'||v_maxId||'--'||v_current_seq||'--'||v_current_increment||'--'||v_temp_add||'             '||v_sql_addSeq);

					-- 修改递增值
					v_sql_updateSeq := 'alter sequence '||v_tablename||'_SEQ increment by '||v_temp_add;
					execute immediate v_sql_updateSeq;

					-- 再查询一次当前序列，修改序列值 
					execute immediate v_sql_addSeq into v_tempData;

					-- 将递增值恢复
					v_sql_updateSeq := 'alter sequence '||v_tablename||'_SEQ increment by '||v_current_increment;
					execute immediate v_sql_updateSeq;

			select last_number into v_current_seq from user_sequences where sequence_name = v_tablename||'_SEQ';
			select increment_by into v_current_increment from user_sequences where sequence_name = v_tablename||'_SEQ';


dbms_output.put_line(v_tablename||'--'||v_maxId||'--'||v_current_seq||'--'||v_current_increment||'--'||v_temp_add);

				end if;

			end if;

		end if;
		
		
			
	end if;
	end loop;
end;
