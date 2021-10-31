-- Выдать все талоны конкретного врача, не показывать талоны, которые начались
-- раньше текущего времени

create or replace function
    kabenyk_st.all_tickets_by_doctor_as_func
return sys_refcursor
as
    v_all_tickets_by_doctor_cursor sys_refcursor;
    v_id_doctor number;
begin
    v_id_doctor := 8;
    open v_all_tickets_by_doctor_cursor for
        select
        d.surname,
        t.begin_time
    from
        kabenyk_st.doctors d
        join kabenyk_st.tickets t
            on d.id_doctor = t.id_doctor
        where t.begin_time > sysdate
              and
              (v_id_doctor is null
              or
              (v_id_doctor is not null and
               d.id_doctor = v_id_doctor));
    return v_all_tickets_by_doctor_cursor;
end;

declare
    v_all_tickets_by_doctor_cursor sys_refcursor;
    type record_1 is record (
        doctor varchar2(100),
        begin_time date
    );
    v_record_1 record_1;
begin

    v_all_tickets_by_doctor_cursor := kabenyk_st.all_tickets_by_doctor_as_func();

        loop
            fetch v_all_tickets_by_doctor_cursor into v_record_1;

            exit when v_all_tickets_by_doctor_cursor%notfound;

            dbms_output.put_line (v_record_1.doctor|| ', ' ||
                                 to_char(v_record_1.begin_time, 'yyyy.mm.dd hh24:mi'));
        end loop;

    close v_all_tickets_by_doctor_cursor;
end;