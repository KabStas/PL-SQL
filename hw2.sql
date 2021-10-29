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
    dbms_output.put_line(v_result_1);
    dbms_output.put_line(v_result_2);
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
    dbms_output.put_line(v_result);
end;

--4. Заведите булеву переменную. создайте запрос который имеет разный результат
-- в зависимости от бул переменной. всеми известными способами
declare
    v_is_condition boolean := false;
    v_result varchar2(200);
    --v_number := sys.diutil.bool_to_int(v_is_condition);
begin
    select p.surname
    into v_result
    from kabenyk_st.patients p
    where (sys.diutil.bool_to_int(v_is_condition) = 1 and p.id_patient = 1)
          --(v_is_condition = true and p.id_patient = 1)
          or
          --(v_is_condition = false and p.id_patient = 2);
          (sys.diutil.bool_to_int(v_is_condition) = 0 and p.id_patient = 2);
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
    a_index binary_integer := 1;

begin
    --между датами
    select t.id_ticket
    bulk collect into a_array_of_ticket_id
    from kabenyk_st.tickets t
    where t.begin_time > v_date_2 and t.begin_time < v_date_1;
    loop
        exit when a_index = a_array_of_ticket_id.last;
        dbms_output.put_line('id_ticket = '||a_array_of_ticket_id(a_index));
        a_index := a_array_of_ticket_id.next(a_index);
    end loop;

    -- за сегодня
    v_date_1 := trunc(sysdate, 'ddd');
    select t.id_ticket
    bulk collect into a_array_of_ticket_id
    from kabenyk_st.tickets t
    where t.begin_time > v_date_1 and t.begin_time < sysdate;
    dbms_output.put_line(v_date_1);

    -- неделю назад
    v_date_1 := trunc(sysdate, 'iw');
    select t.id_ticket
    bulk collect into a_array_of_ticket_id
    from kabenyk_st.tickets t
    where t.begin_time > v_date_1 and t.begin_time < sysdate;
    dbms_output.put_line(v_date_1);

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
    v_patient kabenyk_st.patients%rowtype;
begin
    select *
    into v_patient
    from kabenyk_st.patients p
    where p.id_patient = 2;
    dbms_output.put_line( 'пациент - ' || v_patient.name ||' '|| v_patient.patronymic ||' '|| v_patient.surname);
end;

--7. Завести заранее переменную массива строк. сделать выборку на массив строк.
-- записать в переменную. вывести каждую строку в цикле в консоль

declare
    type arr_type is table of kabenyk_st.hospitals%rowtype
    index by binary_integer;
    a_array_of_hospitals arr_type;
    a_index binary_integer := 1;
begin
    select *
    bulk collect into a_array_of_hospitals
    from kabenyk_st.hospitals h
    where h.id_hospital_availability = 1;

    for a_index in a_array_of_hospitals.first..a_array_of_hospitals.last
    loop
        dbms_output.put_line('id = '||a_array_of_hospitals(a_index).id_hospital || ', name - '
                                 || a_array_of_hospitals(a_index).name);
        a_index := a_array_of_hospitals.next(a_index);
    end loop;
end;