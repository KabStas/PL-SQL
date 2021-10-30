-- Выдать все талоны конкретного врача, не показывать талоны, которые начались
-- раньше текущего времени

declare
    cursor tickets_by_doctor_cursor (
        p_doctor_name in varchar2
    )
    is
    select
        d.surname,
        t.begin_time
    from
        kabenyk_st.doctors d
        join kabenyk_st.tickets t
            on d.id_doctor = t.id_doctor
    where (
          t.begin_time > sysdate) and
          ((
          d.surname = p_doctor_name and
          p_doctor_name is not null
          ) or
          (
          d.surname is not null and
          p_doctor_name is null
          ));

    type record_1 is record (
        doctor varchar2(100),
        begin_time date
    );

    v_record_1 record_1;
    v_record_2 record_1;

    v_tickets_by_doctor_cursor sys_refcursor;

begin
    open tickets_by_doctor_cursor('Жуладзе');

        dbms_output.put_line ('first cursor:');

        loop
            fetch tickets_by_doctor_cursor into v_record_1;

            exit when tickets_by_doctor_cursor%notfound;

            dbms_output.put_line (v_record_1.doctor|| ', ' ||
                                 to_char(v_record_1.begin_time, 'yyyy.mm.dd hh24:mi'));
        end loop;

    close tickets_by_doctor_cursor;

    open v_tickets_by_doctor_cursor for

        select
        d.surname,
        t.begin_time
        from
            kabenyk_st.doctors d
            join kabenyk_st.tickets t
                on d.id_doctor = t.id_doctor
        where t.begin_time > sysdate and
              d.surname = 'Денисов';

        dbms_output.put_line ('second cursor:');

        loop
            fetch v_tickets_by_doctor_cursor into v_record_2;

            exit when v_tickets_by_doctor_cursor%notfound;

            dbms_output.put_line (v_record_2.doctor|| ', ' ||
                                 to_char(v_record_2.begin_time, 'yyyy.mm.dd hh24:mi'));
        end loop;

    close v_tickets_by_doctor_cursor;

    dbms_output.put_line ('third cursor:');

    for i in (
        select d.surname    as doctor,
               t.begin_time as time
        from kabenyk_st.doctors d
                 join kabenyk_st.tickets t
                      on d.id_doctor = t.id_doctor
        where t.begin_time > sysdate
    )
    loop
        dbms_output.put_line (i.doctor|| ', ' || to_char(i.time, 'yyyy.mm.dd hh24:mi'));
    end loop;

end;