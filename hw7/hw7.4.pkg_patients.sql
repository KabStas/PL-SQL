create or replace package kabenyk_st.pkg_patients
as
    function all_documents_by_patient_as_func (
        p_id_patient in number
    )
    return kabenyk_st.t_arr_patient_documents_numbers;

    function patients_journal_by_patient_as_func (
        p_id_patient in number
    )
    return kabenyk_st.t_arr_journal;

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
    return kabenyk_st.t_patient;

    function is_patient_has_oms_as_func (
        p_id_patient in number
    )
    return boolean;

    function get_journal_by_id(
        p_id_journal number
    )
    return kabenyk_st.t_journal;

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
    return kabenyk_st.t_arr_patient_documents_numbers
    as
        v_arr_documents kabenyk_st.t_arr_patient_documents_numbers :=
            kabenyk_st.t_arr_patient_documents_numbers();
    begin
        select kabenyk_st.t_patient_documents_numbers (
            id_document_number => dn.id_document_number,
            id_patient => dn.id_patient,
            id_document => dn.id_document,
            value => dn.value
        )
        bulk collect into v_arr_documents
        from kabenyk_st.documents d
            join kabenyk_st.documents_numbers dn
                on d.id_document = dn.id_document
            join kabenyk_st.patients p
                on dn.id_patient = p.id_patient
        where p_id_patient is null or (
            p_id_patient is not null and p.id_patient = p_id_patient
        );

        return v_arr_documents;
    end;

    function patients_journal_by_patient_as_func (
        p_id_patient in number
    )
    return kabenyk_st.t_arr_journal
    as
        v_arr_journal kabenyk_st.t_arr_journal;
    begin
        select kabenyk_st.t_journal (
            id_journal => pj.id_journal,
            id_journal_record_status => pj.id_journal_record_status,
            day_time => pj.day_time,
            id_patient => pj.id_patient,
            id_ticket => pj.id_ticket
        )
        bulk collect into v_arr_journal
        from kabenyk_st.patients_journals pj
            join kabenyk_st.patients p
                on pj.id_patient = p.id_patient
        where pj.data_of_record_deletion is null and (
            p_id_patient is null or (
            p_id_patient is not null and
            pj.id_patient = p_id_patient
            )
        );

        return v_arr_journal;
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
            raise kabenyk_st.pkg_errors.e_patient_recorded_exception;
        end if;

        return false;
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
    return kabenyk_st.t_patient
    as
        v_patient kabenyk_st.t_patient;
    begin
        select kabenyk_st.t_patient (
            id_patient => p.id_patient,
            surname => p.surname,
            name => p.name,
            patronymic => p.patronymic,
            date_of_birth => p.date_of_birth,
            id_gender => p.id_gender,
            area => p.area,
            id_account => p.id_account
        )
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
            raise kabenyk_st.pkg_errors.e_patient_oms_exception;
        end if;

        return true;
    exception
        when kabenyk_st.pkg_errors.e_patient_oms_exception then
            dbms_output.put_line ('Error. No OMS');
            kabenyk_st.add_error_log(
                $$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2),
                '{"error":"' || sqlerrm
                ||'","id_patient":"' || p_id_patient
                ||'","backtrace":"' || dbms_utility.format_error_backtrace()
                ||'"}'
            );
        return false;
    end;

    function get_journal_by_id (
        p_id_journal number
    )
    return kabenyk_st.t_journal
    as
        v_journal kabenyk_st.t_journal;
    begin
        select kabenyk_st.t_journal (
            id_journal => pj.id_journal,
            id_journal_record_status => pj.id_journal_record_status,
            day_time => pj.day_time,
            id_patient => pj.id_patient,
            id_ticket => pj.id_ticket
        )
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
            raise kabenyk_st.pkg_errors.e_ticket_time_exception;
        end if;

        return true;
    exception
        when kabenyk_st.pkg_errors.e_ticket_time_exception then
            dbms_output.put_line ('Error. Time is not correct');
            kabenyk_st.add_error_log(
                $$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2),
                '{"error":"' || sqlerrm
                ||'","id_ticket":"' || p_id_ticket
                ||'","begin_time":"' || v_begin_time
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

--проверка работы getter'ов
declare
    v_patient kabenyk_st.t_patient;
begin
    v_patient := kabenyk_st.pkg_patients.get_patient_by_id (
        p_id_patient => 2
    );
    dbms_output.put_line(
        kabenyk_st.to_char_t_patient(v_patient)
    );
end;

declare
    v_journal kabenyk_st.t_journal;
begin
    v_journal := kabenyk_st.pkg_patients.get_journal_by_id(
        p_id_journal => 4
    );
    dbms_output.put_line(
        kabenyk_st.to_char_t_journal(v_journal)
    );
end;

-- вызов функции документы пациента и вывод массива в консоль
declare
    v_arr_documents kabenyk_st.t_arr_patient_documents_numbers :=
        kabenyk_st.t_arr_patient_documents_numbers();
begin
    v_arr_documents := kabenyk_st.pkg_patients.all_documents_by_patient_as_func(
        p_id_patient => 2
    );

    if v_arr_documents.count>0 then
    for i in v_arr_documents.first..v_arr_documents.last
    loop
    declare
        v_item kabenyk_st.t_patient_documents_numbers := v_arr_documents(i);
    begin
        dbms_output.put_line(kabenyk_st.to_char_t_documents(v_item));
    end;
    end loop;
    end if;
end;

-- вызов функции журнал пациента и вывод массива в консоль

declare
    v_arr_journal kabenyk_st.t_arr_journal := kabenyk_st.t_arr_journal();
begin
    v_arr_journal := kabenyk_st.pkg_patients.patients_journal_by_patient_as_func(
        p_id_patient => null
    );

    if v_arr_journal.count>0 then
    for i in v_arr_journal.first..v_arr_journal.last
    loop
    declare
        v_item kabenyk_st.t_journal := v_arr_journal(i);
    begin
        dbms_output.put_line(kabenyk_st.to_char_t_journal(v_item));
    end;
    end loop;
    end if;
end;

