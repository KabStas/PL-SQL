-- 3.выдать расписание больниц

create or replace function
    kabenyk_st.hospitals_working_time_as_func
return sys_refcursor
as
    v_hospitals_working_time_cursor sys_refcursor;
    v_id_hospital number;
begin
    v_id_hospital := 2;
    open v_hospitals_working_time_cursor for
        select
            h.name,
            wt.day,
            wt.begin_time,
            wt.end_time
        from
            kabenyk_st.working_time wt
            join kabenyk_st.hospitals h
                on wt.id_hospital = h.id_hospital
        where v_id_hospital is null
              or
              (v_id_hospital is not null and
              h.id_hospital = v_id_hospital)
        order by h.id_hospital, decode (wt.day, 'Понедельник', 1,
                                                'Вторник',2,
                                                'Среда', 3,
                                                'Четверг', 4,
                                                'Пятница', 5,
                                                'Суббота', 6,
                                                'Воскресенье', 7);
    return v_hospitals_working_time_cursor;
end;

declare
    v_hospitals_working_time_cursor sys_refcursor;

    type record_1 is record (
        name varchar2(100),
        day varchar2(100),
        begin_time varchar2(100),
        end_time varchar2(100)
    );
    v_record_1 record_1;

begin
    v_hospitals_working_time_cursor := kabenyk_st.hospitals_working_time_as_func();

        loop
            fetch v_hospitals_working_time_cursor into v_record_1;

            exit when v_hospitals_working_time_cursor%notfound;

            dbms_output.put_line (v_record_1.name|| ', '|| v_record_1.day||', ' ||
                                  v_record_1.begin_time||', ' || v_record_1.end_time);
        end loop;

    close v_hospitals_working_time_cursor;
end;