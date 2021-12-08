create or replace package kabenyk_st.pkg_utils
as

    function gathering_info_for_output (
        p_id_journal in number
    )
    return kabenyk_st.t_result_output;

    function calc_age_from_date_of_birth (
    p_date in date
    )
    return number;

end;

create or replace package body kabenyk_st.pkg_utils
as

    function gathering_info_for_output (
        p_id_journal in number
    )
    return kabenyk_st.t_result_output
    as
        v_result integer;
        v_journal kabenyk_st.t_journal;
        v_patient kabenyk_st.t_patient;
        v_ticket kabenyk_st.t_ticket;
        v_doctor kabenyk_st.t_doctor;
        v_result_output kabenyk_st.t_result_output;
    begin
        v_journal := kabenyk_st.get_journal_by_id (
            p_id_journal => p_id_journal,
            out_result => v_result
            );
        v_patient := kabenyk_st.get_patient_by_id (
            p_id_patient => v_journal.id_patient,
            out_result => v_result
            );
        v_ticket := kabenyk_st.get_ticket_by_id (
            p_id_ticket => v_journal.id_ticket,
            out_result => v_result
            );
        v_doctor := kabenyk_st.get_doctor_by_id_doctor_speciality (
            p_id_doctor_speciality => v_ticket.id_doctor_specialization,
            out_result => v_result
        );
        v_result_output := kabenyk_st.t_result_output(
            patient_surname => v_patient.surname,
            visit_date => v_journal.day_time,
            doctor_surname => v_doctor.surname
        );
        return v_result_output;
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
end;