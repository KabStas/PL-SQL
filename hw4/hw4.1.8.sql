-- 4.выдать журнал пациента

create or replace function
    kabenyk_st.patients_journal_by_patient_as_func
return sys_refcursor
as
    v_patients_journal_by_patient_cursor sys_refcursor;
    v_id_patient number;
begin
    v_id_patient := 1;
    open v_patients_journal_by_patient_cursor for
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
            where v_id_patient is null
                  or
                  (v_id_patient is not null and
                  pj.id_patient = v_id_patient);
    return v_patients_journal_by_patient_cursor;
end;

declare
    v_patients_journal_by_patient_cursor sys_refcursor;

    type record_1 is record (
        patient varchar2(100),
        status varchar2(100),
        day_time date,
        doctor varchar2(100)
    );
    v_record_1 record_1;

begin
    v_patients_journal_by_patient_cursor := kabenyk_st.patients_journal_by_patient_as_func();

        loop
            fetch v_patients_journal_by_patient_cursor into v_record_1;

            exit when v_patients_journal_by_patient_cursor%notfound;

            dbms_output.put_line ('пациент - '||v_record_1.patient|| ', '|| v_record_1.status||', ' ||
                                  to_char(v_record_1.day_time, 'dd.mm.yyyy hh24:mi') ||', доктор - ' ||
                                  v_record_1.doctor);
        end loop;

    close v_patients_journal_by_patient_cursor;
end;