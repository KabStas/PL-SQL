create or replace package kabenyk_st.pkg_patients
as
    type t_record_1 is record (
        name varchar2(100),
        value varchar2(100),
        patient varchar2(100)
    );
    type t_record_2 is record (
        patient varchar2(100),
        status varchar2(100),
        day_time date,
        doctor varchar2(100)
    );

    function all_documents_by_patient_as_func (
        p_id_patient in number
    )
    return kabenyk_st.pkg_patients.t_record_1;

    function patients_journal_by_patient_as_func (
        p_id_patient in number
    )
    return kabenyk_st.pkg_patients.t_record_2;

    function is_patient_already_recorded_as_func (
        p_id_patient in number,
        p_id_ticket in number
    )
    return boolean;

    function calc_age_from_date_of_birth (
    p_date in date
    )
    return number;

    function get_patient_by_id (
    p_id_patient number
    )
    return kabenyk_st.patients%rowtype;

    function is_patient_has_oms_as_func (
        p_id_patient in number
    )
    return boolean;

    function get_journal_by_id(
        p_id_journal number
    )
    return kabenyk_st.patients_journals%rowtype;

    function inserting_in_journal_as_func (
        p_id_ticket in number, p_id_patient in number
    )
    return number;

    function is_time_for_cancelling_correct_as_func (
        p_id_ticket in number
    )
    return boolean;

    procedure deletion_from_journal_as_proc (
        p_id_journal in number
    );

end pkg_patients;

create or replace package body kabenyk_st.pkg_patients
as
    function all_documents_by_patient_as_func (
        p_id_patient in number
    )
    return kabenyk_st.pkg_patients.t_record_1
    as
        v_all_documents_by_patient_cursor sys_refcursor;
        v_record kabenyk_st.pkg_patients.t_record_1;
    begin
        open v_all_documents_by_patient_cursor for
            select
                d.name,
                dn.value,
                p.surname
            from kabenyk_st.documents d
                join kabenyk_st.documents_numbers dn
                    on d.id_document = dn.id_document
                join kabenyk_st.patients p
                    on dn.id_patient = p.id_patient
            where p_id_patient is null
                  or (p_id_patient is not null and p.id_patient = p_id_patient);

            loop
                fetch v_all_documents_by_patient_cursor into v_record;

                exit when v_all_documents_by_patient_cursor%notfound;

                dbms_output.put_line (
                    v_record.name || ', ' || v_record.value ||
                    ', ' || v_record.patient
                );
            end loop;
        close v_all_documents_by_patient_cursor;
        return v_record;
    end;

    function patients_journal_by_patient_as_func (
        p_id_patient in number
    )
    return kabenyk_st.pkg_patients.t_record_2
    as
        v_patients_journal_by_patient_cursor sys_refcursor;
        v_record kabenyk_st.pkg_patients.t_record_2;
    begin
        open v_patients_journal_by_patient_cursor for
            select
                p.surname,
                s.status,
                pj.day_time,
                d.surname
            from kabenyk_st.patients_journals pj
                join kabenyk_st.patients p
                    on pj.id_patient = p.id_patient
                join kabenyk_st.journal_record_status s
                    on pj.id_journal_record_status = s.id_journal_record_status
                join kabenyk_st.tickets t
                    on pj.id_ticket = t.id_ticket
                join kabenyk_st.doctors_specializations dt
                    on t.id_doctor_specialization = dt.id_doctor_specialization
                join kabenyk_st.doctors d
                    on dt.id_doctor = d.id_doctor
            where pj.data_of_record_deletion is null and (
                p_id_patient is null or (
                p_id_patient is not null and
                pj.id_patient = p_id_patient
                )
            );

            loop
                fetch v_patients_journal_by_patient_cursor into v_record;

                exit when v_patients_journal_by_patient_cursor%notfound;

                dbms_output.put_line (
                    'пациент - '||v_record.patient|| ', '|| v_record.status||', ' ||
                    to_char(v_record.day_time, 'dd.mm.yyyy hh24:mi') ||', доктор - ' ||
                    v_record.doctor
                );
            end loop;
        close v_patients_journal_by_patient_cursor;
        return v_record;
    end;

    function is_patient_already_recorded_as_func (
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
            raise kabenyk_st.pkg_error.e_patient_recorded_exception;
        end if;

        return false;
    exception
        when kabenyk_st.pkg_error.e_patient_recorded_exception then
            dbms_output.put_line ('Error. Patient is already recorded');
            kabenyk_st.add_error_log(
                $$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2),
                '{"error":"' || sqlerrm
                ||'","value":"' || v_result
                ||'","backtrace":"' || dbms_utility.format_error_backtrace()
                ||'"}'
            );
        return true;
    end;

    function calc_age_from_date_of_birth (
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

    function get_patient_by_id (
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

    function is_patient_has_oms_as_func (
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
            raise kabenyk_st.pkg_error.e_patient_oms_exception;
        end if;

        return true;
    exception
        when kabenyk_st.pkg_error.e_patient_oms_exception then
            dbms_output.put_line ('Error. No OMS');
            kabenyk_st.add_error_log(
                $$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2),
                '{"error":"' || sqlerrm
                ||'","value":"' || p_id_patient
                ||'","backtrace":"' || dbms_utility.format_error_backtrace()
                ||'"}'
            );
        return false;
    end;

    function get_journal_by_id (
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

    function inserting_in_journal_as_func (
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

    function is_time_for_cancelling_correct_as_func (
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
            raise kabenyk_st.pkg_error.e_ticket_time_exception;

        end if;

        return true;
    exception
        when kabenyk_st.pkg_error.e_ticket_time_exception then
            dbms_output.put_line ('Error. Time is not correct');
            kabenyk_st.add_error_log(
                $$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2),
                '{"error":"' || sqlerrm
                ||'","value":"' || v_begin_time
                ||'","backtrace":"' || dbms_utility.format_error_backtrace()
                ||'"}'
            );
        return false;
    end;

    procedure deletion_from_journal_as_proc (
        p_id_journal in number
    )
    as
    begin
        update kabenyk_st.patients_journals pj
        set pj.id_journal_record_status = 3,
            pj.data_of_record_deletion = sysdate
        where pj.id_journal = p_id_journal;
        commit;
    end;


end pkg_patients;

