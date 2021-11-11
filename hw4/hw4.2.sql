create or replace function kabenyk_st.is_patient_already_recorded_as_func (
    p_id_patient in number,
    p_id_ticket in number
)
return boolean
as
    v_result number;
begin
    select count(*)
    into v_result
    from kabenyk_st.patients_journals pj
    where pj.id_patient = p_id_patient
        and pj.id_ticket = p_id_ticket
        and pj.id_journal_record_status in (1,2);

    if (v_result != 0) then
        dbms_output.put_line ('Error. Patient is already recorded');
    end if;
    return v_result > 0;
end;

create or replace function kabenyk_st.is_gender_matched_as_func (
    p_id_patient in number,
    p_id_specialization in number
)
return boolean
as
    v_result number;
begin
    select count(*)
    into v_result
    from kabenyk_st.patients p
    join kabenyk_st.gender g
        on p.id_gender = g.id_gender
    join kabenyk_st.specializations s
        on s.id_gender = g.id_gender
    where p.id_patient = p_id_patient
        and s.id_specialization = p_id_specialization
        and (
            p.id_gender = s.id_gender
            or s.id_gender is null
        );

    if v_result = 0 then
        dbms_output.put_line ('Error. Gender not matched');
    end if;

    return v_result > 0;
end;

create or replace function kabenyk_st.calc_age_from_date_of_birth (
    p_date in date
)
return number
as
    v_age number;
begin
    select months_between(sysdate, p_date)/12
    into v_age
    from dual;

    return v_age;
end;

create or replace function kabenyk_st.get_patient_by_id (
    p_id_patient number
)
return kabenyk_st.patients%rowtype
as
    v_patient kabenyk_st.patients%rowtype;
begin
    select *
    into v_patient
    from kabenyk_st.patients p
    where p.id_patient = p_id_patient;

    return v_patient;
end;

create or replace function kabenyk_st.is_age_matched_as_func (
    p_id_patient in number,
    p_id_specialization in number
)
return boolean
as
    v_patient kabenyk_st.patients%rowtype;
    v_age number;
    v_result number;
begin
    v_patient := kabenyk_st.get_patient_by_id (
        p_id_patient => p_id_patient
    );

    v_age := kabenyk_st.calc_age_from_date_of_birth (
        p_date => v_patient.date_of_birth
    );

    select count(*)
    into v_result
    from kabenyk_st.specializations s
    where s.id_specialization = p_id_specialization
        and (s.min_age <= v_age or s.min_age is null)
        and (s.max_age >= v_age or s.max_age is null);

    if v_result = 0 then
        dbms_output.put_line ('Error. Age not matched');
    end if;

    return v_result > 0;
end;

create or replace function kabenyk_st.is_ticket_open_as_func (
    p_id_ticket in number
)
return boolean
as
    v_ticket_flag number;
begin
    select t.id_ticket_flag into v_ticket_flag
    from kabenyk_st.tickets t
    where t.id_ticket = p_id_ticket;

    if v_ticket_flag != 1 then
        dbms_output.put_line ('Error. Ticket is not open');
    end if;

    return v_ticket_flag = 1;
end;

create or replace function kabenyk_st.is_time_correct_as_func (
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

create or replace function kabenyk_st.is_doctor_marked_as_deleted_as_func (
    p_id_ticket in number
)
return boolean
as
    v_is_doctor_deleted date;
begin
    select d.data_of_record_deletion into v_is_doctor_deleted
    from kabenyk_st.tickets t
        join kabenyk_st.doctors d
            on t.id_doctor = d.id_doctor
    where t.id_ticket = p_id_ticket;

    if v_is_doctor_deleted is not null then
        dbms_output.put_line ('Error. Doctor marked as deleted');
    end if;

    return v_is_doctor_deleted is not null;
end;

create or replace function kabenyk_st.is_specialization_marked_as_deleted_as_func (
    p_id_specialization in number
)
return boolean
as
    v_is_specialization_deleted date;
begin
    select s.data_of_record_deletion into v_is_specialization_deleted
    from kabenyk_st.specializations s
    where s.id_specialization = p_id_specialization;

    if v_is_specialization_deleted is not null then
        dbms_output.put_line ('Error. Specialization marked as deleted');
    end if;

    return v_is_specialization_deleted is not null;
end;

create or replace function kabenyk_st.is_hospital_marked_as_deleted_as_func (
    p_id_ticket in number
)
return boolean
as
    v_is_hospital_deleted date;
begin
    select h.data_of_record_deletion into v_is_hospital_deleted
    from kabenyk_st.tickets t
        join kabenyk_st.doctors d
            on t.id_doctor = d.id_doctor
        join kabenyk_st.hospitals h
            on d.id_hospital = h.id_hospital
    where t.id_ticket = p_id_ticket;

    if v_is_hospital_deleted is not null then
        dbms_output.put_line ('Error. Hospital marked as deleted');
    end if;

    return v_is_hospital_deleted is not null;
end;

create or replace function kabenyk_st.is_patient_has_oms_as_func (
    p_id_patient in number
)
return boolean
as
    v_presence_of_oms number;
begin
    select dn.id_document into v_presence_of_oms
    from kabenyk_st.patients p
        join kabenyk_st.documents_numbers dn
            on p.id_patient = dn.id_patient
    where p.id_patient = p_id_patient;

    if v_presence_of_oms != 4 then
        dbms_output.put_line ('Error. No OMS');
    end if;

    return v_presence_of_oms = 4;
end;

create or replace function kabenyk_st.get_ticket_by_id(
    p_id_ticket number
)
return kabenyk_st.tickets%rowtype
as
    v_ticket kabenyk_st.tickets%rowtype;
begin
    select *
    into v_ticket
    from kabenyk_st.tickets t
    where t.id_ticket = p_id_ticket;

    return v_ticket;
end;
/

create or replace function kabenyk_st.get_doctor_by_id(
    p_id_doctor number
)
return kabenyk_st.doctors%rowtype
as
    v_doctor kabenyk_st.doctors%rowtype;
begin
    select *
    into v_doctor
    from kabenyk_st.doctors d
    where d.id_doctor = p_id_doctor
        and d.data_of_record_deletion is null;

    return v_doctor;
end;

create or replace function kabenyk_st.get_journal_by_id(
    p_id_journal number
)
return kabenyk_st.patients_journals%rowtype
as
    v_journal kabenyk_st.patients_journals%rowtype;
begin
    select *
    into v_journal
    from kabenyk_st.patients_journals pj
    where pj.id_journal = p_id_journal;

    return v_journal;
end;

create or replace procedure kabenyk_st.outputting_result_as_proc (
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

    dbms_output.put_line ('Record successful');
    dbms_output.put_line (
        'пациент '||v_patient.surname|| ', записан на ' ||
        to_char( v_journal.day_time, 'dd.mm.yyyy hh24:mi') ||', доктор ' ||
        v_doctor.surname);
end;

create or replace procedure kabenyk_st.changing_ticket_flag_to_close_as_proc (
    p_id_ticket in number
)
as
begin
    update kabenyk_st.tickets t
    set t.id_ticket_flag = 2
    where t.id_ticket = p_id_ticket;
    commit;
end;


create or replace function kabenyk_st.inserting_in_journal_as_func (
    p_id_ticket in number, p_id_patient in number
)
return number
as
    v_begin_time date;
    v_id_journal number;
begin
    --забираем время из талона, чтобы вставить в insert
    select t.begin_time into v_begin_time
    from kabenyk_st.tickets t
    where t.id_ticket = p_id_ticket;

    insert into kabenyk_st.patients_journals (
        id_journal_record_status, day_time, id_patient, id_ticket
    )
    values (1, v_begin_time, p_id_patient, p_id_ticket)
    returning id_journal into v_id_journal;
    commit;

    return v_id_journal;
end;

declare
    v_id_patient number := 3;
    v_id_ticket number := 3;
    v_ticket kabenyk_st.tickets%rowtype;
    v_id_journal number;
begin
    v_ticket := kabenyk_st.get_ticket_by_id (p_id_ticket => v_id_ticket); --забираем талон, чтобы взять из него id_specialization

    if (
        not kabenyk_st.is_patient_already_recorded_as_func(
            p_id_patient => v_id_patient,
            p_id_ticket => v_id_ticket
        )
        and kabenyk_st.is_gender_matched_as_func(
            p_id_patient => v_id_patient,
            p_id_specialization => v_ticket.id_specialization
        )
        and kabenyk_st.is_age_matched_as_func(
            p_id_patient => v_id_patient,
            p_id_specialization => v_ticket.id_specialization
        )
        and kabenyk_st.is_ticket_open_as_func(
            p_id_ticket => v_id_ticket
        )
        and kabenyk_st.is_time_correct_as_func(
            p_id_ticket => v_id_ticket
        )
        and not kabenyk_st.is_doctor_marked_as_deleted_as_func(
            p_id_ticket => v_id_ticket
        )
        and not kabenyk_st.is_specialization_marked_as_deleted_as_func(
            p_id_specialization => v_ticket.id_specialization
        )
        and not kabenyk_st.is_hospital_marked_as_deleted_as_func(
            p_id_ticket => v_id_ticket
        )
        and kabenyk_st.is_patient_has_oms_as_func(
            p_id_patient => v_id_patient
        )
    ) then
        kabenyk_st.changing_ticket_flag_to_close_as_proc (
            p_id_ticket => v_id_ticket
        );
        v_id_journal := kabenyk_st.inserting_in_journal_as_func (
            p_id_ticket => v_id_ticket,
            p_id_patient => v_id_patient
        );
        kabenyk_st.outputting_result_as_proc (
            p_id_journal => v_id_journal
        );
    else
        dbms_output.put_line ('Record unsuccessful');
    end if;
end;