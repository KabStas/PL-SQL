create or replace function kabenyk_st.json_all_doctors_by_hospital (
    p_id_hospital in number,
    p_area in number
)
return clob
as

    v_result integer;
    v_response kabenyk_st.t_arr_doctor := kabenyk_st.t_arr_doctor();
    v_return_clob clob;

begin
    v_response := kabenyk_st.all_doctors_by_hospital (
        p_id_hospital => p_id_hospital,
        p_area => p_area,
        out_result => v_result
    );

    v_return_clob := packing_doctors_to_clob (
        p_response => v_response,
        p_result => v_result
    );

    return v_return_clob;

    exception when others then
        kabenyk_st.add_error_log(
            $$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2),
            '{"error":"' || sqlerrm
            ||'","id_hospital":"' || p_id_hospital
            ||'","area":"' || p_area
            ||'","result":"' || v_result
            ||'","backtrace":"' || dbms_utility.format_error_backtrace()
            ||'"}'
        );
        return null;
end;

create or replace function kabenyk_st.json_get_doctor_by_id_doctor_speciality (
    p_id_doctor_speciality in number
)
return clob
as

    v_result integer;
    v_response kabenyk_st.t_doctor;
    v_return_clob clob;

begin
    v_response := kabenyk_st.get_doctor_by_id_doctor_speciality (
        p_id_doctor_speciality => p_id_doctor_speciality,
        out_result => v_result
    );

    v_return_clob := packing_doctor_to_clob (
        p_response => v_response,
        p_result => v_result
    );

    return v_return_clob;

    exception when others then
        kabenyk_st.add_error_log(
            $$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2),
            '{"error":"' || sqlerrm
            ||'","id_doctor_speciality":"' || p_id_doctor_speciality
            ||'","result":"' || v_result
            ||'","backtrace":"' || dbms_utility.format_error_backtrace()
            ||'"}'
        );
        return null;
end;

create or replace function kabenyk_st.json_all_hospitals_by_specialty (
    p_id_specialty in number
)
return clob
as

    v_result integer;
    v_response kabenyk_st.t_arr_hospital := kabenyk_st.t_arr_hospital();
    v_return_clob clob;

begin
    v_response := kabenyk_st.all_hospitals_by_specialty (
        p_id_specialty => p_id_specialty,
        out_result => v_result
    );

    v_return_clob := packing_hospitals_to_clob (
        p_response => v_response,
        p_result => v_result
    );

    return v_return_clob;

    exception when others then
        kabenyk_st.add_error_log(
            $$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2),
            '{"error":"' || sqlerrm
            ||'","id_specialty":"' || p_id_specialty
            ||'","result":"' || v_result
            ||'","backtrace":"' || dbms_utility.format_error_backtrace()
            ||'"}'
        );
        return null;

end;

create or replace function kabenyk_st.json_hospitals_working_time (
    p_id_hospital in number
)
return clob
as

    v_result integer;
    v_response kabenyk_st.t_arr_hospital_time := kabenyk_st.t_arr_hospital_time();
    v_return_clob clob;

begin
    v_response := kabenyk_st.hospitals_working_time (
        p_id_hospital => p_id_hospital,
        out_result => v_result
    );

    v_return_clob := packing_hospitals_working_time_to_clob (
        p_response => v_response,
        p_result => v_result
    );

    return v_return_clob;

    exception when others then
        kabenyk_st.add_error_log(
            $$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2),
            '{"error":"' || sqlerrm
            ||'","id_hospital":"' || p_id_hospital
            ||'","result":"' || v_result
            ||'","backtrace":"' || dbms_utility.format_error_backtrace()
            ||'"}'
        );
        return null;
end;

create or replace function kabenyk_st.json_get_hospital_by_id (
    p_id_hospital in number
)
return clob
as

    v_result integer;
    v_response kabenyk_st.t_hospital;
    v_return_clob clob;

begin
    v_response := kabenyk_st.get_hospital_by_id (
        p_id_hospital => p_id_hospital,
        out_result => v_result
    );

    v_return_clob := kabenyk_st.packing_hospital_to_clob (
        p_response => v_response,
        p_result => v_result
    );

    return v_return_clob;

    exception when others then
        kabenyk_st.add_error_log(
            $$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2),
            '{"error":"' || sqlerrm
            ||'","id_hospital":"' || p_id_hospital
            ||'","result":"' || v_result
            ||'","backtrace":"' || dbms_utility.format_error_backtrace()
            ||'"}'
        );
        return null;
end;

create or replace function kabenyk_st.json_all_documents_by_patient (
    p_id_patient in number
)
return clob
as

    v_result integer;
    v_response kabenyk_st.t_arr_patient_documents_numbers :=
        kabenyk_st.t_arr_patient_documents_numbers();
    v_return_clob clob;

begin
    v_response := kabenyk_st.all_documents_by_patient (
        p_id_patient => p_id_patient,
        out_result => v_result
    );

    v_return_clob := packing_documents_to_clob (
        p_response => v_response,
        p_result => v_result
    );

    return v_return_clob;

    exception when others then
        kabenyk_st.add_error_log(
            $$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2),
            '{"error":"' || sqlerrm
            ||'","id_patient":"' || p_id_patient
            ||'","result":"' || v_result
            ||'","backtrace":"' || dbms_utility.format_error_backtrace()
            ||'"}'
        );
        return null;
end;

create or replace function kabenyk_st.json_patients_journal_by_patient (
    p_id_patient in number
)
return clob
as

    v_result integer;
    v_response kabenyk_st.t_arr_journal := kabenyk_st.t_arr_journal();
    v_return_clob clob;

begin
    v_response := kabenyk_st.patients_journal_by_patient (
        p_id_patient => p_id_patient,
        out_result => v_result
    );

    v_return_clob := packing_journals_to_clob (
        p_response => v_response,
        p_result => v_result
    );

    return v_return_clob;

    exception when others then
        kabenyk_st.add_error_log(
            $$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2),
            '{"error":"' || sqlerrm
            ||'","id_patient":"' || p_id_patient
            ||'","result":"' || v_result
            ||'","backtrace":"' || dbms_utility.format_error_backtrace()
            ||'"}'
        );
        return null;
end;

create or replace function kabenyk_st.json_get_patient_by_id (
    p_id_patient in number
)
return clob
as

    v_result integer;
    v_response kabenyk_st.t_patient;
    v_return_clob clob;

begin
    v_response := kabenyk_st.get_patient_by_id (
        p_id_patient => p_id_patient,
        out_result => v_result
    );

    v_return_clob := packing_patient_to_clob (
        p_response => v_response,
        p_result => v_result
    );

    return v_return_clob;

    exception when others then
        kabenyk_st.add_error_log(
            $$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2),
            '{"error":"' || sqlerrm
            ||'","id_patient":"' || p_id_patient
            ||'","result":"' || v_result
            ||'","backtrace":"' || dbms_utility.format_error_backtrace()
            ||'"}'
        );
        return null;
end;

create or replace function kabenyk_st.json_get_journal_by_id (
    p_id_journal in number
)
return clob
as

    v_result integer;
    v_response kabenyk_st.t_journal;
    v_return_clob clob;

begin
    v_response := kabenyk_st.get_journal_by_id (
        p_id_journal => p_id_journal,
        out_result => v_result
    );

    v_return_clob := packing_journal_to_clob (
        p_response => v_response,
        p_result => v_result
    );

    return v_return_clob;

    exception when others then
        kabenyk_st.add_error_log(
            $$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2),
            '{"error":"' || sqlerrm
            ||'","id_journal":"' || p_id_journal
            ||'","result":"' || v_result
            ||'","backtrace":"' || dbms_utility.format_error_backtrace()
            ||'"}'
        );
    return null;
end;

create or replace function kabenyk_st.json_get_all_specialties_by_hospital (
    p_id_hospital in number
)
return clob
as

    v_result integer;
    v_response kabenyk_st.t_arr_specialty := kabenyk_st.t_arr_specialty();
    v_return_clob clob;

begin
    v_response := kabenyk_st.get_all_specialties_by_hospital (
        p_id_hospital => p_id_hospital,
        out_result => v_result
    );

    v_return_clob := packing_specialties_to_clob (
        p_response => v_response,
        p_result => v_result
    );

    return v_return_clob;

    exception when others then
        kabenyk_st.add_error_log(
            $$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2),
            '{"error":"' || sqlerrm
            ||'","id_hospital":"' || p_id_hospital
            ||'","result":"' || v_result
            ||'","backtrace":"' || dbms_utility.format_error_backtrace()
            ||'"}'
        );
        return null;
end;

create or replace function kabenyk_st.json_all_tickets_by_doctor (
    p_id_doctor in number
)
return clob
as

    v_result integer;
    v_response kabenyk_st.t_arr_ticket := kabenyk_st.t_arr_ticket();
    v_return_clob clob;

begin
    v_response := kabenyk_st.all_tickets_by_doctor (
        p_id_doctor => p_id_doctor,
        out_result => v_result
    );

    v_return_clob := packing_tickets_to_clob (
        p_response => v_response,
        p_result => v_result
    );

    return v_return_clob;

    exception when others then
        kabenyk_st.add_error_log(
            $$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2),
            '{"error":"' || sqlerrm
            ||'","id_doctor":"' || p_id_doctor
            ||'","result":"' || v_result
            ||'","backtrace":"' || dbms_utility.format_error_backtrace()
            ||'"}'
        );
        return null;
end;

create or replace function kabenyk_st.json_get_ticket_by_id (
    p_id_ticket in number
)
return clob
as

    v_result integer;
    v_response kabenyk_st.t_ticket;
    v_return_clob clob;

begin
    v_response := kabenyk_st.get_ticket_by_id (
        p_id_ticket => p_id_ticket,
        out_result => v_result
    );

    v_return_clob := packing_ticket_to_clob (
        p_response => v_response,
        p_result => v_result
    );

    return v_return_clob;

    exception when others then
        kabenyk_st.add_error_log(
            $$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2),
            '{"error":"' || sqlerrm
            ||'","id_ticket":"' || p_id_ticket
            ||'","result":"' || v_result
            ||'","backtrace":"' || dbms_utility.format_error_backtrace()
            ||'"}'
        );
        return null;
end;

create or replace function kabenyk_st.json_check_for_ticket_accept (
    p_id_ticket in number,
    p_id_patient in number
)
return clob
as

    v_result integer;
    v_response kabenyk_st.t_result_output;
    v_return_clob clob;

begin
    v_response := kabenyk_st.check_for_ticket_accept (
        p_id_ticket => p_id_ticket,
        p_id_patient => p_id_patient,
        out_result => v_result
    );

    v_return_clob := packing_result_output_to_clob (
        p_response => v_response,
        p_result => v_result
    );

    return v_return_clob;

    exception when others then
        kabenyk_st.add_error_log(
            $$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2),
            '{"error":"' || sqlerrm
            ||'","id_ticket":"' || p_id_ticket
            ||'","id_patient":"' || p_id_patient
            ||'","result":"' || v_result
            ||'","backtrace":"' || dbms_utility.format_error_backtrace()
            ||'"}'
        );
        return null;
end;

create or replace function kabenyk_st.json_check_for_journal_deletion (
    p_id_journal in number,
    p_id_ticket in number
)
return clob
as

    v_result integer;
    v_response kabenyk_st.t_result_output;
    v_return_clob clob;

begin
    v_response := kabenyk_st.check_for_journal_deletion (
        p_id_journal => p_id_journal,
        p_id_ticket => p_id_ticket,
        out_result => v_result
    );

    v_return_clob := packing_result_output_to_clob (
        p_response => v_response,
        p_result => v_result
    );

    return v_return_clob;

    exception when others then
        kabenyk_st.add_error_log(
            $$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2),
            '{"error":"' || sqlerrm
            ||'","id_journal":"' || p_id_journal
            ||'","id_ticket":"' || p_id_ticket
            ||'","result":"' || v_result
            ||'","backtrace":"' || dbms_utility.format_error_backtrace()
            ||'"}'
        );
        return null;
end;

-- Проверка работы
declare
    v_clob clob;
begin
    v_clob := kabenyk_st.json_all_doctors_by_hospital(
        p_id_hospital => null,
        p_area => 5
    );
    dbms_output.put_line(v_clob);
end;

declare
    v_clob clob;
begin
    v_clob := kabenyk_st.json_get_patient_by_id(
        p_id_patient => 3
    );
    dbms_output.put_line(v_clob);
end;

declare
    v_clob clob;
begin
    v_clob := kabenyk_st.json_get_all_specialties_by_hospital (6);
    dbms_output.put_line(v_clob);
end;


