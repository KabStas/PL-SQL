create or replace function kabenyk_st.is_patient_already_recorded_as_func
                           (p_id_patient in number, p_id_ticket in number)
return number
as
    v_result number;
    v_cursor sys_refcursor;

    type record_1 is record (
        id_patient number,
        id_ticket number
    );
    v_record record_1;
begin
    dbms_output.put_line ('1. Checking patient journal...');
    open v_cursor for
        select pj.id_patient, pj.id_ticket
        from kabenyk_st.patients_journals pj
        where pj.id_patient = p_id_patient and
              pj.id_ticket = p_id_ticket;

        fetch v_cursor into v_record;

        if v_cursor%notfound then
            v_result := 1;
            dbms_output.put_line ('OK');
        else
            v_result := 0;
            dbms_output.put_line ('Error. Patient is already recorded');
        end if;

    close v_cursor;
    return v_result;
end;

create or replace function kabenyk_st.is_gender_matched_as_func
                           (p_id_patient in number, p_id_specialization in number)
return number
as
    v_result number;
    v_id_patient_gender number;
    v_id_specialization_gender number;
begin
    dbms_output.put_line ('2. Checking gender...');

    select pt.id_gender into v_id_patient_gender
    from kabenyk_st.patients pt
    where pt.id_patient = p_id_patient;

    select s.id_gender into v_id_specialization_gender
    from kabenyk_st.specializations s
    where s.id_specialization = p_id_specialization;

    if v_id_patient_gender = v_id_specialization_gender or
       v_id_specialization_gender is null then -- специализация для обоих полов имеет пустое значение в колонке "пол"
        v_result := 1;
        dbms_output.put_line ('OK');
    else
        v_result := 0;
        dbms_output.put_line ('Error. Gender is not correct');
    end if;

    return v_result;
end;

create or replace function kabenyk_st.is_age_correct_as_func
                           (p_id_patient in number, p_id_specialization in number)
return number
as
    v_result number;
    v_id_patient_age number;
    v_min_and_max_age_of_specialization_cursor sys_refcursor;

    type record_1 is record (
        min_age number,
        max_age number
    );
    v_record_1 record_1;

begin
    dbms_output.put_line ('3. Checking age...');

    select trunc(months_between(sysdate, pt.date_of_birth)/12) into v_id_patient_age
    from kabenyk_st.patients pt
    where pt.id_patient = p_id_patient;

    open v_min_and_max_age_of_specialization_cursor for
        select s.min_age, s.max_age
        from kabenyk_st.specializations s
        where s.id_specialization = p_id_specialization;

        fetch v_min_and_max_age_of_specialization_cursor into v_record_1;

        if v_id_patient_age between v_record_1.min_age and v_record_1.max_age then
            v_result := 1;
            dbms_output.put_line ('OK');
        else
            v_result := 0;
            dbms_output.put_line ('Error. Age is not correct');
        end if;

    close v_min_and_max_age_of_specialization_cursor;

    return v_result;
end;

create or replace function kabenyk_st.is_ticket_open_as_func
                           (p_id_ticket in number)
return number
as
    v_result number;
    v_ticket_flag number;
begin
    dbms_output.put_line ('4. Checking ticket...');

    select t.id_ticket_flag into v_ticket_flag
    from kabenyk_st.tickets t
    where t.id_ticket = p_id_ticket;

    if v_ticket_flag = 1 then
        v_result := 1;
        dbms_output.put_line ('OK');
    else
        v_result := 0;
        dbms_output.put_line ('Error. Ticket is not open');
    end if;

    return v_result;
end;

create or replace function kabenyk_st.is_time_correct_as_func
                           (p_id_ticket in number)
return number
as
    v_result number;
    v_begin_time date;
begin
    dbms_output.put_line ('5. Checking time...');

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

create or replace function kabenyk_st.is_doctor_marked_as_deleted_as_func
                           (p_id_ticket in number)
return number
as
    v_result number;
    v_is_doctor_deleted date;
begin
    dbms_output.put_line ('6. Checking doctor...');

    select d.data_of_record_deletion into v_is_doctor_deleted
    from kabenyk_st.tickets t
        join kabenyk_st.doctors d
            on t.id_doctor = d.id_doctor
    where t.id_ticket = p_id_ticket;

    if v_is_doctor_deleted is null then
        v_result := 1;
        dbms_output.put_line ('OK');
    else
        v_result := 0;
        dbms_output.put_line ('Error. Doctor marked as deleted');
    end if;

    return v_result;
end;

create or replace function kabenyk_st.is_specialization_marked_as_deleted_as_func
                           (p_id_specialization in number)
return number
as
    v_result number;
    v_is_specialization_deleted date;
begin
    dbms_output.put_line ('7. Checking specialization...');

    select s.data_of_record_deletion into v_is_specialization_deleted
    from kabenyk_st.specializations s
    where s.id_specialization = p_id_specialization;

    if v_is_specialization_deleted is null then
        v_result := 1;
        dbms_output.put_line ('OK');
    else
        v_result := 0;
        dbms_output.put_line ('Error. Specialization marked as deleted');
    end if;

    return v_result;
end;

create or replace function kabenyk_st.is_hospital_marked_as_deleted_as_func
                           (p_id_ticket in number)
return number
as
    v_result number;
    v_is_hospital_deleted date;
begin
    dbms_output.put_line ('8. Checking hospital...');

    select h.data_of_record_deletion into v_is_hospital_deleted
    from kabenyk_st.tickets t
        join kabenyk_st.doctors d
            on t.id_doctor = d.id_doctor
        join kabenyk_st.hospitals h
            on d.id_hospital = h.id_hospital
    where t.id_ticket = p_id_ticket;

    if v_is_hospital_deleted is null then
        v_result := 1;
        dbms_output.put_line ('OK');
    else
        v_result := 0;
        dbms_output.put_line ('Error. Hospital marked as deleted');
    end if;

    return v_result;
end;

create or replace function kabenyk_st.is_patient_has_oms_as_func
                           (p_id_patient in number)
return number
as
    v_result number;
    v_presence_of_oms number;
begin
    dbms_output.put_line ('9. Checking OMS...');

    select dn.id_document into v_presence_of_oms
    from kabenyk_st.patients p
        join kabenyk_st.documents_numbers dn
            on p.id_patient = dn.id_patient
    where p.id_patient = p_id_patient;

    if v_presence_of_oms = 4 then
        v_result := 1;
        dbms_output.put_line ('OK');
    else
        v_result := 0;
        dbms_output.put_line ('Error. No OMS');
    end if;

    return v_result;
end;

create or replace procedure kabenyk_st.outputting_result_as_procedure(v_id_journal in number)
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
        where pj.id_journal = v_id_journal;

        fetch v_patient_journal_cursor into v_record;
        dbms_output.put_line ('Record successful');
        dbms_output.put_line ('пациент '||v_record.patient|| ', записан на ' ||
                                  to_char(v_record.day_time, 'dd.mm.yyyy hh24:mi') ||', доктор ' ||
                                  v_record.doctor);
    close v_patient_journal_cursor;
end;

declare
    p_id_patient number := 3;
    p_id_ticket number := 3;
    p_id_specialization number := 3;
    v_id_journal number;
    v_begin_time date;
    v_result_1 number;
    v_result_2 number;
    v_result_3 number;
    v_result_4 number;
    v_result_5 number;
    v_result_6 number;
    v_result_7 number;
    v_result_8 number;
    v_result_9 number;

begin
    v_result_1 := kabenyk_st.is_patient_already_recorded_as_func
                           (p_id_patient, p_id_ticket);
    v_result_2 := kabenyk_st.is_gender_matched_as_func
                           (p_id_patient, p_id_specialization);
    v_result_3 := kabenyk_st.is_age_correct_as_func
                           (p_id_patient, p_id_specialization);
    v_result_4 := kabenyk_st.is_ticket_open_as_func (p_id_ticket);
    v_result_5 := kabenyk_st.is_time_correct_as_func (p_id_ticket);
    v_result_6 := kabenyk_st.is_doctor_marked_as_deleted_as_func (p_id_ticket);
    v_result_7 := kabenyk_st.is_specialization_marked_as_deleted_as_func
                           (p_id_specialization);
    v_result_8 := kabenyk_st.is_hospital_marked_as_deleted_as_func (p_id_ticket);
    v_result_9 := kabenyk_st.is_patient_has_oms_as_func (p_id_patient);

    if v_result_1 = 1 and v_result_2 = 1 and
       v_result_3 = 1 and v_result_4 = 1 and
       v_result_5 = 1 and v_result_6 = 1 and
       v_result_7 = 1 and v_result_8 = 1 and
       v_result_9 = 1 then

       update kabenyk_st.tickets t
       set t.id_ticket_flag = 2
       where t.id_ticket = p_id_ticket;

       --забираем время из талона, чтобы вставить в insert
       select t.begin_time into v_begin_time
       from kabenyk_st.tickets t
       where t.id_ticket = p_id_ticket;

       insert into kabenyk_st.patients_journals (id_journal_record_status,
                                                day_time, id_patient, id_ticket)
       values (1, v_begin_time, p_id_patient, p_id_ticket)
       returning id_journal into v_id_journal;

       commit;

       kabenyk_st.outputting_result_as_procedure(v_id_journal);

    else
        dbms_output.put_line ('Error. Record unsuccessful');
    end if;

end;