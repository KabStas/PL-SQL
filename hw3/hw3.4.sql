-- 4.выдать журнал пациента

declare
    cursor patient_journal_cursor (
        p_id_journal in number
    )
    is
    select
        p.surname,
        s.status,
        pj.day_time,
        d.surname
    from
        kabenyk_st.patients_journals pj
        join kabenyk_st.patients p
            on pj.id_patient = p.id_patient
        join kabenyk_st.journal_record_status s
            on pj.id_journal_record_status = s.id_journal_record_status
        join kabenyk_st.tickets t
            on pj.id_ticket = t.id_ticket
        join kabenyk_st.doctors d
            on t.id_doctor = d.id_doctor
    where (
          pj.id_journal = p_id_journal and
          p_id_journal is not null
          ) or
          (
          pj.id_journal is not null and
          p_id_journal is null
          );

    type record_1 is record (
        patient varchar2(100),
        status varchar2(100),
        day_time date,
        doctor varchar2(100)
    );

    v_record_1 record_1;
    v_record_2 record_1;

    v_patient_journal_cursor sys_refcursor;

begin

    open patient_journal_cursor(4);

        dbms_output.put_line ('first cursor:');

        loop
            fetch patient_journal_cursor into v_record_1;

            exit when patient_journal_cursor%notfound;

            dbms_output.put_line ('пациент - '||v_record_1.patient|| ', '|| v_record_1.status||', ' ||
                                  to_char(v_record_1.day_time, 'dd.mm.yyyy hh24:mi') ||', доктор - ' ||
                                  v_record_1.doctor);
        end loop;

    close patient_journal_cursor;

    open v_patient_journal_cursor for
        select
        p.surname,
        s.status,
        pj.day_time,
        d.surname
    from
        kabenyk_st.patients_journals pj
        join kabenyk_st.patients p
            on pj.id_patient = p.id_patient
        join kabenyk_st.journal_record_status s
            on pj.id_journal_record_status = s.id_journal_record_status
        join kabenyk_st.tickets t
            on pj.id_ticket = t.id_ticket
        join kabenyk_st.doctors d
            on t.id_doctor = d.id_doctor
    where pj.id_journal = 5;

        dbms_output.put_line ('second cursor:');

        loop
            fetch v_patient_journal_cursor into v_record_2;

            exit when v_patient_journal_cursor%notfound;

            dbms_output.put_line ('пациент - '||v_record_2.patient|| ', '|| v_record_2.status||', ' ||
                                  to_char(v_record_2.day_time, 'dd.mm.yyyy hh24:mi') ||', доктор - ' ||
                                  v_record_2.doctor);
        end loop;

    close v_patient_journal_cursor;

    dbms_output.put_line ('third cursor:');

    for i in (
        select
        p.surname as patient,
        s.status as status,
        pj.day_time as day_time,
        d.surname as doctor
    from
        kabenyk_st.patients_journals pj
        join kabenyk_st.patients p
            on pj.id_patient = p.id_patient
        join kabenyk_st.journal_record_status s
            on pj.id_journal_record_status = s.id_journal_record_status
        join kabenyk_st.tickets t
            on pj.id_ticket = t.id_ticket
        join kabenyk_st.doctors d
            on t.id_doctor = d.id_doctor
    )
    loop
        dbms_output.put_line ('пациент - '||i.patient|| ', '|| i.status||', ' ||
                                  to_char(i.day_time, 'dd.mm.yyyy hh24:mi') ||', доктор - ' ||
                                  i.doctor);
    end loop;

end;