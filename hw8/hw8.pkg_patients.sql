create or replace package kabenyk_st.pkg_patients
as
    function all_documents_by_patient (
        p_id_patient in number,
        out_result out integer
    )
    return kabenyk_st.t_arr_patient_documents_numbers;

    function patients_journal_by_patient (
        p_id_patient in number,
        out_result out integer
    )
    return kabenyk_st.t_arr_journal;

    function is_patient_already_recorded (
        p_id_patient in number,
        p_id_ticket in number,
        out_result out integer
    )
    return boolean;

    function get_patient_by_id (
        p_id_patient number,
        out_result out integer
    )
    return kabenyk_st.t_patient;

    function is_patient_has_oms (
        p_id_patient in number,
        out_result out integer
    )
    return boolean;

    function get_journal_by_id(
        p_id_journal number,
        out_result out integer
    )
    return kabenyk_st.t_journal;

    function inserting_in_journal (
        p_id_ticket in number,
        p_id_patient in number,
        out_result out integer
    )
    return number;

    function is_time_for_cancelling_correct (
        p_id_ticket in number,
        out_result out integer
    )
    return boolean;

    procedure deletion_from_journal (
        p_id_journal in number,
        out_result out integer
    );

end pkg_patients;

create or replace package body kabenyk_st.pkg_patients
as

    function all_documents_by_patient (
        p_id_patient in number,
        out_result out integer
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

        out_result := kabenyk_st.pkg_code.c_ok;
        return v_arr_documents;
    end;

    function patients_journal_by_patient (
        p_id_patient in number,
        out_result out integer
    )
    return kabenyk_st.t_arr_journal
    as
        v_arr_journal kabenyk_st.t_arr_journal := kabenyk_st.t_arr_journal();
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

        out_result := kabenyk_st.pkg_code.c_ok;
        return v_arr_journal;
    end;

    function is_patient_already_recorded (
        p_id_patient in number,
        p_id_ticket in number,
        out_result out integer
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

        out_result := kabenyk_st.pkg_code.c_ok;
        return false;
    end;

    function get_patient_by_id (
        p_id_patient number,
        out_result out integer
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

        out_result := kabenyk_st.pkg_code.c_ok;
        return v_patient;
    end;

    function is_patient_has_oms (
        p_id_patient in number,
        out_result out integer
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

        out_result := kabenyk_st.pkg_code.c_ok;
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
        out_result := kabenyk_st.pkg_code.c_error;
        return false;
    end;

    function get_journal_by_id (
        p_id_journal number,
        out_result out integer
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

        out_result := kabenyk_st.pkg_code.c_ok;
        return v_journal;
    end;

    function inserting_in_journal (
        p_id_ticket in number,
        p_id_patient in number,
        out_result out integer
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

        out_result := kabenyk_st.pkg_code.c_ok;
        return v_id_journal;
    end;

    function is_time_for_cancelling_correct (
        p_id_ticket in number,
        out_result out integer
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

        out_result := kabenyk_st.pkg_code.c_ok;
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
            out_result := kabenyk_st.pkg_code.c_error;
        return false;
    end;

    procedure deletion_from_journal (
        p_id_journal in number,
        out_result out integer
    )
    as
    begin
        update kabenyk_st.patients_journals pj
        set pj.id_journal_record_status = 3,
            pj.data_of_record_deletion = sysdate
        where pj.id_journal = p_id_journal;
        commit;

        out_result := kabenyk_st.pkg_code.c_ok;
    end;

end pkg_patients;





