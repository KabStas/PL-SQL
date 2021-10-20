--2. Сделайте выборку одного поля из таблицы. запишите результат в переменную:
-- строковую и числовую
declare
    v_result_1 varchar2(20);
    v_result_2 number;
begin
    select h.id_hospital into v_result_1
    from kabenyk_st.hospitals h
    where h.name = 'Авиценна №4';
    select h.id_hospital into v_result_2
    from kabenyk_st.hospitals h
    where h.name = 'Авиценна №4';
end;

--3. Заведите заранее переменные для участия в запросе. создайте запрос на получение
-- чего-то where переменная
declare
    v_variable number := 5;
    v_result varchar(20);
begin
    select h.name into v_result
    from kabenyk_st.hospitals h
    where h.id_hospital = v_variable;
end;

--4. Заведите булеву переменную. создайте запрос который имеет разный результат
-- в зависимости от бул переменной. всеми известными способами
declare
    v_is_condition boolean := true;
    v_result varchar2(200);
begin
    if (v_is_condition = true)
    then select h.name into v_result
         from kabenyk_st.hospitals h
         where id_hospital = 1;
    else select h.name into v_result
         from kabenyk_st.hospitals h
         where id_hospital = 2;
    end if;
    dbms_output.put_line(v_result);
    case
        when v_is_condition != true
        then select h.name into v_result
             from kabenyk_st.hospitals h
             where id_hospital = 1;
        else
             select h.name into v_result
             from kabenyk_st.hospitals h
             where id_hospital = 2;
    end case;
    dbms_output.put_line(v_result);
end;

--5. Заведите заранее переменные даты. создайте выборку между датами, за сегодня.
-- в день за неделю назад. сделайте тоже самое но через преобразование даты из строки

declare
    v_date_1 date := '31-12-2021';
    v_date_2 date := '01-01-2021';
    v_date_3 varchar2(100);
    v_date_4 varchar2(100);
    type arr_type is table of number
    index by binary_integer;
    a_array_of_ticket_id arr_type;
    --a_index binary_integer := 1;

begin
    --между датами
    select t.id_ticket
    bulk collect into a_array_of_ticket_id
    from kabenyk_st.tickets t
    where t.begin_time > v_date_2 and t.begin_time < v_date_1;

    -- за сегодня
    v_date_1 := sysdate - 2/24;
    select t.id_ticket
    bulk collect into a_array_of_ticket_id
    from kabenyk_st.tickets t
    where t.begin_time > v_date_1 and t.begin_time < sysdate;

    -- неделю назад
    v_date_1 := sysdate - 7;
    select t.id_ticket
    bulk collect into a_array_of_ticket_id
    from kabenyk_st.tickets t
    where t.begin_time > v_date_1 and t.begin_time < sysdate;

    --через преобразование даты из строки
    v_date_3 := '31-12-2021';
    v_date_4 := '01-01-2021';
    select t.id_ticket
    bulk collect into a_array_of_ticket_id
    from kabenyk_st.tickets t
    where t.begin_time > to_date(v_date_4, 'dd-mm-yyyy')
      and t.begin_time < to_date(v_date_3, 'dd-mm-yyyy');
    dbms_output.put_line(v_date_4);
    dbms_output.put_line(v_date_3);
end;

--6. Заведите заранее переменную типа строки. создайте выборку забирающую ровну одну строку.
-- выведите в консоль результат
declare
    v_hospital_name varchar2(100);
begin
    select h.name
    into v_hospital_name
    from kabenyk_st.hospitals h
    where h.id_hospital = 5;
    dbms_output.put_line('Hospital name - '||v_hospital_name);
end;

--7. Завести заранее переменную массива строк. сделать выборку на массив строк.
-- записать в переменную. вывести каждую строку в цикле в консоль

declare
    v_date_1 date := '31-12-2021';
    v_date_2 date := '01-01-2021';
    type arr_type is table of varchar2(100)
    index by binary_integer;
    a_array_of_ticket_id arr_type;
    a_index binary_integer := 1;

begin
    select t.id_ticket
    bulk collect into a_array_of_ticket_id
    from kabenyk_st.tickets t
    where t.begin_time > v_date_2 and t.begin_time < v_date_1;
    loop
        exit when a_index = a_array_of_ticket_id.last;
        dbms_output.put_line('id_ticket = '||a_array_of_ticket_id(a_index));
        a_index := a_array_of_ticket_id.next(a_index);
    end loop;
end;