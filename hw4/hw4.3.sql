create or replace function kabenyk_st.is_time_for_cancelling_correct_as_func (
    p_id_ticket in number
)
return number
as
    v_result number;
    v_begin_time date;
begin
    dbms_output.put_line ('1. Checking time...');

    select t.begin_time into v_begin_time
    from kabenyk_st.tickets t
    where t.id_ticket = p_id_ticket;

    if v_begin_time > sysdate then
        v_result := 1;
        dbms_output.put_line ('OK');
    else
        v_result := 0;
        dbms_output.put_line ('Error. Time is not correct');
    end if;

    return v_result;
end;

create or replace function kabenyk_st.is_hospital_still_working_as_func (
    p_id_ticket in number
)
return number
as
    v_result number := 1;
    v_current_day varchar2(100);
    v_current_time varchar2(5);
    v_hospital_end_time varchar2(20);
    v_number_of_day number;
begin
    dbms_output.put_line ('2. Checking hospital working time...');

    v_current_day := to_char(sysdate,'day');
    v_number_of_day := to_char(sysdate,'d');
    v_current_time := to_number(to_char(sysdate,'hh24.mi'), '99.99');
    dbms_output.put_line (v_current_time);

    select wt.end_time into v_hospital_end_time
    from kabenyk_st.tickets t
        join kabenyk_st.doctors d
            on t.id_doctor = d.id_doctor
        join kabenyk_st.working_time wt
            on d.id_hospital = wt.id_hospital
    --where t.id_ticket = p_id_ticket and wt.day = v_current_day;  --не работает!!!
    where t.id_ticket = p_id_ticket and
          decode (wt.day, 'Понедельник', 1,
                          'Вторник',2,
                          'Среда', 3,
                          'Четверг', 4,
                          'Пятница', 5,
                          'Суббота', 6,
                          'Воскресенье', 7) = v_number_of_day;

    v_hospital_end_time := to_number(v_hospital_end_time, '99.99');

    if (v_hospital_end_time - v_current_time) > 2 then
        v_result := 1;
        dbms_output.put_line ('OK');
    else
        v_result := 0;
        dbms_output.put_line ('Error. Less 2 hours of hospital work');
    end if;

    return v_result;
end;

create or replace procedure kabenyk_st.outputting_result_as_proc (
    p_id_journal in number
)
as
    v_patient_journal_cursor sys_refcursor;
    type record_1 is record (
        patient varchar2(100),
        day_time date,
        doctor varchar2(100)
    );
    v_record record_1;

begin

    open v_patient_journal_cursor for
        select
            p.surname,
            pj.day_time,
            d.surname
        from
            kabenyk_st.patients_journals pj
            join kabenyk_st.patients p
                on pj.id_patient = p.id_patient
            join kabenyk_st.tickets t
                on pj.id_ticket = t.id_ticket
            join kabenyk_st.doctors d
                on t.id_doctor = d.id_doctor
        where pj.id_journal = p_id_journal;

        fetch v_patient_journal_cursor into v_record;
        dbms_output.put_line ('Deletion successful');
        dbms_output.put_line ('Запись пациента '||v_record.patient|| ' на ' ||
                                  to_char(v_record.day_time, 'dd.mm.yyyy hh24:mi') ||' к доктору ' ||
                                  v_record.doctor || ' отменена');
    close v_patient_journal_cursor;
end;


declare
    v_id_journal number := 9;
    v_id_ticket number := 3;
    v_result_1 number;
    v_result_2 number;
begin
    v_result_1 := kabenyk_st.is_time_for_cancelling_correct_as_func (
        p_id_ticket => v_id_ticket
    );
    v_result_2 := kabenyk_st.is_hospital_still_working_as_func (
        p_id_ticket => v_id_ticket
    );

    if v_result_1 = 1 and v_result_2 = 1 then

        update kabenyk_st.patients_journals pj
        set pj.id_journal_record_status = 3,
            pj.data_of_record_deletion = sysdate
        where pj.id_journal = v_id_journal;

        update kabenyk_st.tickets t
        set t.id_ticket_flag = 1
        where t.id_ticket = v_id_ticket;
        commit;

        kabenyk_st.outputting_result_as_proc (
            p_id_journal => v_id_journal
        );
    else
        dbms_output.put_line ('Error. Deletion unsuccessful');
    end if;

end;