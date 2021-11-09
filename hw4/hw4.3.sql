create or replace function kabenyk_st.is_time_for_cancelling_correct_as_func (
    p_id_ticket in number
)
return boolean
as
    v_begin_time date;
begin
    select t.begin_time into v_begin_time
    from kabenyk_st.tickets t
    where t.id_ticket = p_id_ticket;

    if v_begin_time < sysdate then
        dbms_output.put_line ('Error. Time is not correct');
    end if;

    return v_begin_time > sysdate;
end;

create or replace function kabenyk_st.is_hospital_still_working_as_func (
    p_id_ticket in number
)
return boolean
as
    v_current_day varchar2(100);
    v_current_time varchar2(5);
    v_hospital_end_time varchar2(20);
    v_number_of_day number;
begin
    v_current_day := to_char(sysdate,'day');
    v_number_of_day := to_char(sysdate,'d');
    v_current_time := to_number(to_char(sysdate,'hh24.mi'), '99.99');

    select wt.end_time into v_hospital_end_time
    from kabenyk_st.tickets t
        join kabenyk_st.doctors d
            on t.id_doctor = d.id_doctor
        join kabenyk_st.working_time wt
            on d.id_hospital = wt.id_hospital
    where t.id_ticket = p_id_ticket and
          decode (wt.day, 'Понедельник', 1,
                          'Вторник',2,
                          'Среда', 3,
                          'Четверг', 4,
                          'Пятница', 5,
                          'Суббота', 6,
                          'Воскресенье', 7) = v_number_of_day;

    v_hospital_end_time := to_number(v_hospital_end_time, '99.99');

    if (v_hospital_end_time - v_current_time) < 2 then
        dbms_output.put_line ('Error. Less 2 hours of hospital work');
    end if;

    return (v_hospital_end_time - v_current_time) >= 2;
end;

create or replace procedure kabenyk_st.outputting_result_of_deletion_as_proc (
    p_id_journal in number
)
as
    v_journal kabenyk_st.patients_journals%rowtype;
    v_patient kabenyk_st.patients%rowtype;
    v_ticket kabenyk_st.tickets%rowtype;
    v_doctor kabenyk_st.doctors%rowtype;
begin
    v_journal := kabenyk_st.get_journal_by_id (p_id_journal => p_id_journal);
    v_patient := kabenyk_st.get_patient_by_id (p_id_patient => v_journal.id_patient);
    v_ticket := kabenyk_st.get_ticket_by_id (p_id_ticket => v_journal.id_ticket);
    v_doctor := kabenyk_st.get_doctor_by_id (p_id_doctor => v_ticket.id_doctor);

    dbms_output.put_line ('Deletion successful');
    dbms_output.put_line (
        'Запись пациента '||v_patient.surname|| ' на ' ||
        to_char( v_journal.day_time, 'dd.mm.yyyy hh24:mi') ||' к доктору ' ||
        v_doctor.surname || ' отменена');
end;

create or replace procedure kabenyk_st.deletion_from_journal_as_proc (
    p_id_journal in number
)
as
begin
    update kabenyk_st.patients_journals pj
    set pj.id_journal_record_status = 3,
        pj.data_of_record_deletion = sysdate
    where pj.id_journal = p_id_journal;
end;

create or replace procedure kabenyk_st.changing_ticket_flag_to_open_as_proc (
    p_id_ticket in number
)
as
begin
    update kabenyk_st.tickets t
    set t.id_ticket_flag = 1
    where t.id_ticket = p_id_ticket;
    commit;
end;

declare
    v_id_journal number := 13;
    v_id_ticket number := 3;
begin
    if (
        kabenyk_st.is_time_for_cancelling_correct_as_func(
            p_id_ticket => v_id_ticket
        )
        and kabenyk_st.is_hospital_still_working_as_func(
            p_id_ticket => v_id_ticket
        )
    ) then
        kabenyk_st.deletion_from_journal_as_proc (
            p_id_journal => v_id_journal
        );
        kabenyk_st.changing_ticket_flag_to_open_as_proc (
            p_id_ticket => v_id_ticket
        );
        kabenyk_st.outputting_result_of_deletion_as_proc (
            p_id_journal => v_id_journal
        );
    else
        dbms_output.put_line ('Deletion unsuccessful');
    end if;

end;