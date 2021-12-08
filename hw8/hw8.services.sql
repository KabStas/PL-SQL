create or replace function kabenyk_st.all_doctors_by_hospital (
    p_id_hospital in number,
    p_area in number,
    out_result out integer
)
return kabenyk_st.t_arr_doctor
as

    v_response kabenyk_st.t_arr_doctor := kabenyk_st.t_arr_doctor();
    v_result integer;

begin
    v_response := kabenyk_st.pkg_doctors.all_doctors_by_hospital(
        p_id_hospital => p_id_hospital,
        p_area => p_area,
        out_result => v_result
    );
    out_result := v_result;

    return v_response;
end;

create or replace function kabenyk_st.get_doctor_by_id_doctor_speciality (
    p_id_doctor_speciality in number,
    out_result out integer
)
return kabenyk_st.t_doctor
as

    v_response kabenyk_st.t_doctor;
    v_result integer;

begin
    v_response := kabenyk_st.pkg_doctors.get_doctor_by_id_doctor_speciality(
        p_id_doctor_speciality => p_id_doctor_speciality,
        out_result => v_result
    );
    out_result := v_result;

    return v_response;
end;

create or replace function kabenyk_st.all_hospitals_by_specialty (
    p_id_specialty in number,
    out_result out integer
)
return kabenyk_st.t_arr_hospital
as

    v_response kabenyk_st.t_arr_hospital := kabenyk_st.t_arr_hospital();
    v_result integer;

begin
    v_response := kabenyk_st.pkg_hospitals.all_hospitals_by_specialty(
        p_id_specialty => p_id_specialty,
        out_result => v_result
    );
    out_result := v_result;

    return v_response;
end;

create or replace function kabenyk_st.hospitals_working_time (
    p_id_hospital in number,
    out_result out integer
)
return kabenyk_st.t_arr_hospital_time
as

    v_response kabenyk_st.t_arr_hospital_time := kabenyk_st.t_arr_hospital_time();
    v_result integer;

begin
    v_response := kabenyk_st.pkg_hospitals.hospitals_working_time(
        p_id_hospital => p_id_hospital,
        out_result => v_result
    );
    out_result := v_result;

    return v_response;
end;

create or replace function kabenyk_st.get_hospital_by_id (
    p_id_hospital in number,
    out_result out integer
)
return kabenyk_st.t_hospital
as

    v_response kabenyk_st.t_hospital;
    v_result integer;

begin
    v_response := kabenyk_st.pkg_hospitals.get_hospital_by_id(
        p_id_hospital => p_id_hospital,
        out_result => v_result
    );
    out_result := v_result;

    return v_response;
end;

create or replace function kabenyk_st.all_documents_by_patient (
    p_id_patient in number,
    out_result out integer
)
return kabenyk_st.t_arr_patient_documents_numbers
as
    v_response kabenyk_st.t_arr_patient_documents_numbers :=
        kabenyk_st.t_arr_patient_documents_numbers();
    v_result integer;
begin
    v_response := kabenyk_st.pkg_patients.all_documents_by_patient(
        p_id_patient => p_id_patient,
        out_result => v_result
    );
    out_result := v_result;

    return v_response;
end;

create or replace function kabenyk_st.patients_journal_by_patient (
    p_id_patient in number,
    out_result out integer
)
return kabenyk_st.t_arr_journal
as
    v_response kabenyk_st.t_arr_journal := kabenyk_st.t_arr_journal();
    v_result integer;
begin
    v_response := kabenyk_st.pkg_patients.patients_journal_by_patient(
        p_id_patient => p_id_patient,
        out_result => v_result
    );
    out_result := v_result;

    return v_response;
end;

create or replace function kabenyk_st.get_patient_by_id (
    p_id_patient in number,
    out_result out integer
)
return kabenyk_st.t_patient
as
    v_response kabenyk_st.t_patient;
    v_result integer;
begin
    v_response := kabenyk_st.pkg_patients.get_patient_by_id(
        p_id_patient => p_id_patient,
        out_result => v_result
    );
    out_result := v_result;

    return v_response;
end;

create or replace function kabenyk_st.get_journal_by_id (
    p_id_journal in number,
    out_result out integer
)
return kabenyk_st.t_journal
as
    v_response kabenyk_st.t_journal;
    v_result integer;
begin
    v_response := kabenyk_st.pkg_patients.get_journal_by_id(
        p_id_journal => p_id_journal,
        out_result => v_result
    );
    out_result := v_result;

    return v_response;
end;

create or replace function kabenyk_st.get_all_specialties_by_hospital (
    p_id_hospital in number,
    out_result out integer
)
return kabenyk_st.t_arr_specialty
as
    v_response kabenyk_st.t_arr_specialty := kabenyk_st.t_arr_specialty();
    v_result integer;
begin
    v_response := kabenyk_st.pkg_specialties.get_all_specialties_by_hospital (
        p_id_hospital => p_id_hospital,
        out_result => v_result
    );
    out_result := v_result;

    return v_response;
end;

create or replace function kabenyk_st.all_tickets_by_doctor (
    p_id_doctor in number,
    out_result out integer
)
return kabenyk_st.t_arr_ticket
as
    v_response kabenyk_st.t_arr_ticket := kabenyk_st.t_arr_ticket();
    v_result integer;
begin
    v_response := kabenyk_st.pkg_tickets.all_tickets_by_doctor (
        p_id_doctor => p_id_doctor,
        out_result => v_result
    );
    out_result := v_result;

    return v_response;
end;

create or replace function kabenyk_st.get_ticket_by_id (
    p_id_ticket in number,
    out_result out integer
)
return kabenyk_st.t_ticket
as
    v_response kabenyk_st.t_ticket;
    v_result integer;
begin
    v_response := kabenyk_st.pkg_tickets.get_ticket_by_id (
        p_id_ticket => p_id_ticket,
        out_result => v_result
    );
    out_result := v_result;

    return v_response;
end;

create or replace function check_for_ticket_accept (
    p_id_ticket in number,
    p_id_patient in number,
    out_result out integer
)
return kabenyk_st.t_result_output
as
    v_id_journal number;
    v_id_specialty number;
    v_result boolean;
    v_result_output kabenyk_st.t_result_output;
    v_out_result integer;
begin
    --забираем id специальности из талона для вставки в другие функции
    v_id_specialty := kabenyk_st.pkg_specialties.get_id_specialty_by_ticket (
        p_id_ticket => p_id_ticket,
        out_result => v_out_result
    );

    v_result := kabenyk_st.pkg_patients.is_patient_already_recorded (
        p_id_patient => p_id_patient,
        p_id_ticket => p_id_ticket,
        out_result => v_out_result
    );

    if (
        kabenyk_st.pkg_specialties.is_gender_matched (
            p_id_patient => p_id_patient,
            p_id_specialty => v_id_specialty,
            out_result => v_out_result
        )
        and kabenyk_st.pkg_specialties.is_age_matched (
            p_id_patient => p_id_patient,
            p_id_specialty => v_id_specialty,
            out_result => v_out_result
        )
        and kabenyk_st.pkg_tickets.is_ticket_open (
            p_id_ticket => p_id_ticket,
            out_result => v_out_result
        )
        and kabenyk_st.pkg_tickets.is_time_correct (
            p_id_ticket => p_id_ticket,
            out_result => v_out_result
        )
        and not kabenyk_st.pkg_doctors.is_doctor_marked_as_deleted (
            p_id_ticket => p_id_ticket,
            out_result => v_out_result
        )
        and not kabenyk_st.pkg_specialties.is_specialty_marked_as_deleted (
            p_id_specialty => v_id_specialty,
            out_result => v_out_result
        )
        and not kabenyk_st.pkg_hospitals.is_hospital_marked_as_deleted (
            p_id_ticket => p_id_ticket,
            out_result => v_out_result
        )
        and kabenyk_st.pkg_patients.is_patient_has_oms (
            p_id_patient => p_id_patient,
            out_result => v_out_result
        )
    ) then
        kabenyk_st.pkg_tickets.changing_ticket_flag_to_close (
            p_id_ticket => p_id_ticket,
            out_result => v_out_result
        );
        v_id_journal := kabenyk_st.pkg_patients.inserting_in_journal (
            p_id_ticket => p_id_ticket,
            p_id_patient => p_id_patient,
            out_result => v_out_result
        );
        v_result_output := kabenyk_st.pkg_utils.gathering_info_for_output (
            p_id_journal => v_id_journal
        );
        commit;

    end if;

    out_result := v_out_result;

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

            out_result := kabenyk_st.pkg_code.c_error;

        return null;
end;

    create or replace function check_for_journal_deletion (
        p_id_journal in number,
        p_id_ticket in number,
        out_result out integer
    )
    return kabenyk_st.t_result_output
    as
        v_result integer;
        v_result_output kabenyk_st.t_result_output;
    begin
        if (
            kabenyk_st.pkg_patients.is_time_for_cancelling_correct(
                p_id_ticket => p_id_ticket,
                out_result => v_result
            )
            and kabenyk_st.pkg_hospitals.is_hospital_still_working(
                p_id_ticket => p_id_ticket,
                out_result => v_result
            )
        ) then
            kabenyk_st.pkg_patients.deletion_from_journal(
                p_id_journal => p_id_journal,
                out_result => v_result
            );
            kabenyk_st.pkg_tickets.changing_ticket_flag_to_open(
                p_id_ticket => p_id_ticket,
                out_result => v_result
            );
            commit;
            v_result_output := kabenyk_st.pkg_utils.gathering_info_for_output(
                p_id_journal => p_id_journal
            );
        end if;

        out_result := v_result;

        return v_result_output;
    end;







    declare
    v_response kabenyk_st.t_arr_doctor := kabenyk_st.t_arr_doctor ();
    v_result integer;
begin
    v_response := kabenyk_st.all_doctors_by_hospital (
        p_id_hospital => null,
        p_area => 5,
        out_result => v_result
    );

    if v_response.count>0 then
    for i in v_response.first..v_response.last
    loop
    declare
        v_item kabenyk_st.t_doctor := v_response(i);
    begin
        dbms_output.put_line(kabenyk_st.to_char_t_doctor(v_item));
    end;
    end loop;
    end if;

end;
















