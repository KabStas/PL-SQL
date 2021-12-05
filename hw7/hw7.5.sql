create or replace type kabenyk_st.t_result_output as object(
    patient_surname varchar2(100),
    visit_date date,
    doctor_surname varchar2(100)
);

create or replace function gathering_info_for_output_as_func (
    p_id_journal in number
)
return kabenyk_st.t_result_output
as
    v_journal kabenyk_st.t_journal;
    v_patient kabenyk_st.t_patient;
    v_ticket kabenyk_st.t_ticket;
    v_doctor kabenyk_st.t_doctor;
    v_result_output kabenyk_st.t_result_output;
begin
    v_journal := kabenyk_st.pkg_patients.get_journal_by_id (p_id_journal => p_id_journal);
    v_patient := kabenyk_st.pkg_patients.get_patient_by_id (p_id_patient => v_journal.id_patient);
    v_ticket := kabenyk_st.pkg_tickets.get_ticket_by_id (p_id_ticket => v_journal.id_ticket);
    v_doctor := kabenyk_st.pkg_doctors.get_doctor_by_id_doctor_speciality (
        p_id_doctor_speciality => v_ticket.id_doctor_specialization
    );
    v_result_output := kabenyk_st.t_result_output(
        patient_surname => v_patient.surname,
        visit_date => v_journal.day_time,
        doctor_surname => v_doctor.surname
    );
    return v_result_output;
end;

create or replace function check_for_ticket_accept_as_func (
    p_id_ticket in number,
    p_id_patient in number
)
return kabenyk_st.t_result_output
as
    v_id_journal number;
    v_id_specialty number;
    v_result boolean;
    v_result_output kabenyk_st.t_result_output;
begin
    --забираем id специальности из талона для вставки в другие функции
    v_id_specialty := kabenyk_st.pkg_specialties.get_id_specialty_by_ticket (
        p_id_ticket => p_id_ticket
    );

    v_result := kabenyk_st.pkg_patients.is_patient_already_recorded_as_func (
        p_id_patient => p_id_patient,
        p_id_ticket => p_id_ticket
    );

    if (
        kabenyk_st.pkg_specialties.is_gender_matched_as_func (
            p_id_patient => p_id_patient,
            p_id_specialty => v_id_specialty
        )
        and kabenyk_st.pkg_specialties.is_age_matched_as_func (
            p_id_patient => p_id_patient,
            p_id_specialization => v_id_specialty
        )
        and kabenyk_st.pkg_tickets.is_ticket_open_as_func (
            p_id_ticket => p_id_ticket
        )
        and kabenyk_st.pkg_tickets.is_time_correct_as_func (
            p_id_ticket => p_id_ticket
        )
        and not kabenyk_st.pkg_doctors.is_doctor_marked_as_deleted_as_func (
            p_id_ticket => p_id_ticket
        )
        and not kabenyk_st.pkg_specialties.is_specialty_marked_as_deleted_as_func (
            p_id_specialty => v_id_specialty
        )
        and not kabenyk_st.pkg_hospitals.is_hospital_marked_as_deleted_as_func (
            p_id_ticket => p_id_ticket
        )
        and kabenyk_st.pkg_patients.is_patient_has_oms_as_func (
            p_id_patient => p_id_patient
        )
    ) then
        kabenyk_st.pkg_tickets.changing_ticket_flag_to_close_as_proc (
            p_id_ticket => p_id_ticket
        );
        v_id_journal := kabenyk_st.pkg_patients.inserting_in_journal_as_func (
            p_id_ticket => p_id_ticket,
            p_id_patient => p_id_patient
        );
        v_result_output := kabenyk_st.gathering_info_for_output_as_func (
            p_id_journal => v_id_journal
        );
        commit;

    end if;

    return v_result_output;

    exception
        when kabenyk_st.pkg_errors.e_patient_recorded_exception then
            dbms_output.put_line ('Error. Patient is already recorded');
            kabenyk_st.add_error_log(
                $$plsql_unit_owner||'.'||$$plsql_unit,
                '{"error":"' || sqlerrm
                ||'","id_ticket":"' || p_id_ticket
                ||'","id_patient":"' || p_id_patient
                ||'","backtrace":"' || dbms_utility.format_error_backtrace()
                ||'"}'
            );
        return null;
end;

create or replace function check_for_journal_record_deletion_as_func (
    p_id_journal in number,
    p_id_ticket in number
)
return kabenyk_st.t_result_output
as
    v_result_output kabenyk_st.t_result_output;
begin
    if (
        kabenyk_st.pkg_patients.is_time_for_cancelling_correct_as_func(
            p_id_ticket => p_id_ticket
        )
        and kabenyk_st.pkg_hospitals.is_hospital_still_working_as_func(
            p_id_ticket => p_id_ticket
        )
    ) then
        kabenyk_st.pkg_patients.deletion_from_journal_as_proc(
            p_id_journal => p_id_journal
        );
        kabenyk_st.pkg_tickets.changing_ticket_flag_to_open_as_proc(
            p_id_ticket => p_id_ticket
        );
        commit;
        v_result_output := kabenyk_st.gathering_info_for_output_as_func(
            p_id_journal => p_id_journal
        );
    else
        dbms_output.put_line ('Deletion unsuccessful');
    end if;
    return v_result_output;
end;

declare
    v_id_ticket number := 3;
    v_id_patient number := 3;
    v_result_output kabenyk_st.t_result_output;
begin
    v_result_output := check_for_ticket_accept_as_func (
        p_id_ticket => v_id_ticket,
        p_id_patient => v_id_patient
    );
    if v_result_output is not null then
        dbms_output.put_line ('Record successful');
        dbms_output.put_line (
        'пациент '||v_result_output.patient_surname||
        ', записан на ' || to_char( v_result_output.visit_date, 'dd.mm.yyyy hh24:mi') ||
        ', доктор ' || v_result_output.doctor_surname);
    end if;
end;

declare
    v_id_ticket number := 3;
    v_id_journal number := 21;
    v_result_output kabenyk_st.t_result_output;
begin
    v_result_output := check_for_journal_record_deletion_as_func (
        p_id_journal => v_id_journal,
        p_id_ticket => v_id_ticket
    );
    if v_result_output is not null then
        dbms_output.put_line ('Deletion successful');
        dbms_output.put_line (
        'Запись пациента '||v_result_output.patient_surname||
        ' на ' || to_char( v_result_output.visit_date, 'dd.mm.yyyy hh24:mi') ||
        ' к доктору ' || v_result_output.doctor_surname || ' отменена');
    end if;
end;





