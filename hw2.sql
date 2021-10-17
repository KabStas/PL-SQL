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
/*
declare
    v_date_1 date := '31-12-2021';
    v_date_2 date := '17-10-2021';
    v_result_1 varchar2(100);

begin
    select t.id_ticket into v_result_1
    from kabenyk_st.tickets t
    where t.begin_time > v_date_2 and t.begin_time < v_date_1;


end;*/

--dbms_output.enable();
--dbms_output.put_line();

--6. Заведите заранее переменную типа строки. создайте выборку забирающую ровну одну строку.
-- выведите в консоль результат


--7. Завести заранее переменную массива строк. сделать выборку на массив строк.
-- записать в переменную. вывести каждую строку в цикле в консоль