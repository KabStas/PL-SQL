    create or replace procedure check_for_ticket_accept_as_proc (
        p_id_ticket in number,
        p_id_patient in number
    )
    as
        v_id_journal number;
        v_id_specialty number;
        v_result boolean;
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
                p_id_specialization => v_id_specialty
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
            kabenyk_st.outputting_result_of_record_to_journal_as_proc (
                p_id_journal => v_id_journal
            );
        end if;

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

    end;

declare
    v_id_ticket number := 3;
    v_id_patient number := 3;
begin
    check_for_ticket_accept_as_proc (
        p_id_ticket => v_id_ticket,
        p_id_patient => v_id_patient
    );
end;

-- Удобнее уже хотя бы из-за того, что отпадает необходимость в большом IF, который все проверяет.
-- Просто вызываем функцию: ошибок нет - вызываем следущую функцию, ошибки есть - сразу проваливаемся в exception
-- без вызова остальных функций.

