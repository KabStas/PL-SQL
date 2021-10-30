-- 3.выдать расписание больниц

declare
    cursor working_time_cursor (
        p_id_hospital in number
    )
    is
    select
        h.name,
        wt.day,
        wt.begin_time,
        wt.end_time
    from
        kabenyk_st.working_time wt
        join kabenyk_st.hospitals h
            on wt.id_hospital = h.id_hospital
    where (
          h.id_hospital = p_id_hospital and
          p_id_hospital is not null
          ) or
          (
          h.id_hospital is not null and
          p_id_hospital is null
          )
    order by h.name,
             case
                 when wt.day = 'Понедельник' then 1
                 when wt.day = 'Вторник' then 2
                 when wt.day = 'Среда' then 3
                 when wt.day = 'Четверг' then 4
                 when wt.day = 'Пятница' then 5
                 when wt.day = 'Суббота' then 6
                 when wt.day = 'Воскресенье' then 7
             end;

    type record_1 is record (
        name varchar2(100),
        day varchar2(100),
        begin_time varchar2(100),
        end_time varchar2(100)
    );

    v_record_1 record_1;
    v_record_2 record_1;

    v_working_time_cursor sys_refcursor;

begin

    open working_time_cursor(1);

        dbms_output.put_line ('first cursor:');

        loop
            fetch working_time_cursor into v_record_1;

            exit when working_time_cursor%notfound;

            dbms_output.put_line (v_record_1.name|| ', '|| v_record_1.day||', ' ||
                                  v_record_1.begin_time||', ' || v_record_1.end_time);
        end loop;

    close working_time_cursor;

    open v_working_time_cursor for
        select
        h.name,
        wt.day,
        wt.begin_time,
        wt.end_time
        from
            kabenyk_st.working_time wt
            join kabenyk_st.hospitals h
                on wt.id_hospital = h.id_hospital
        where h.id_hospital = 2
        order by h.name,
             case
                 when wt.day = 'Понедельник' then 1
                 when wt.day = 'Вторник' then 2
                 when wt.day = 'Среда' then 3
                 when wt.day = 'Четверг' then 4
                 when wt.day = 'Пятница' then 5
                 when wt.day = 'Суббота' then 6
                 when wt.day = 'Воскресенье' then 7
             end;

        dbms_output.put_line ('second cursor:');

        loop
            fetch v_working_time_cursor into v_record_2;

            exit when v_working_time_cursor%notfound;

            dbms_output.put_line (v_record_2.name|| ', '|| v_record_2.day||', ' ||
                                  v_record_2.begin_time||', ' || v_record_2.end_time);
        end loop;

    close v_working_time_cursor;

    dbms_output.put_line ('third cursor:');

    for i in (
        select
        h.name as name,
        wt.day as day,
        wt.begin_time as begin_time,
        wt.end_time as end_time
        from
            kabenyk_st.working_time wt
            join kabenyk_st.hospitals h
                on wt.id_hospital = h.id_hospital
        order by h.id_hospital,
             case
                 when wt.day = 'Понедельник' then 1
                 when wt.day = 'Вторник' then 2
                 when wt.day = 'Среда' then 3
                 when wt.day = 'Четверг' then 4
                 when wt.day = 'Пятница' then 5
                 when wt.day = 'Суббота' then 6
                 when wt.day = 'Воскресенье' then 7
             end
    )
    loop
        dbms_output.put_line (i.name|| ', '|| i.day||', ' ||
                             i.begin_time||', ' || i.end_time);
    end loop;

end;