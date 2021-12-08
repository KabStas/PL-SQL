create or replace package kabenyk_st.pkg_doctors
as

    function all_doctors_by_hospital (
        p_id_hospital in number,
        p_area in number,
        out_result out integer
    )
    return kabenyk_st.t_arr_doctor;

    function is_doctor_marked_as_deleted (
        p_id_ticket in number,
        out_result out integer
    )
    return boolean;

    function get_doctor_by_id_doctor_speciality (
        p_id_doctor_speciality in number,
        out_result out integer
    )
    return kabenyk_st.t_doctor;

    procedure merging_doctors_data (
        p_doctor in kabenyk_st.t_doctor,
        out_result out integer
    );

end pkg_doctors;

create or replace package body kabenyk_st.pkg_doctors
as

    function all_doctors_by_hospital (
        p_id_hospital in number,
        p_area in number,
        out_result out integer
    )
    return kabenyk_st.t_arr_doctor
    as
        v_arr_doctor kabenyk_st.t_arr_doctor := kabenyk_st.t_arr_doctor();
    begin
        select kabenyk_st.t_doctor(
            id_doctor => d.id_doctor,
            id_hospital => d.id_hospital,
            surname => d.surname,
            name => d.name,
            patronymic => d.patronymic,
            area => d.area,
            id_doctors_qualifications => d.id_doctors_qualifications,
            external_id_doctor => null,
            external_id_hospital => null,
            external_id_specialty => null
        )
        bulk collect into v_arr_doctor
        from kabenyk_st.doctors d
            join kabenyk_st.doctors_qualifications q
                on d.id_doctors_qualifications = q.id_doctors_qualifications
        where d.data_of_record_deletion is null and (
            p_id_hospital is null or (
            p_id_hospital is not null and
            d.id_hospital = p_id_hospital
            )
        )
        order by qualification,
            case
                when d.area = p_area then 0
                else 1
            end;
        out_result := kabenyk_st.pkg_code.c_ok;
        return v_arr_doctor;
    end;

    function is_doctor_marked_as_deleted (
        p_id_ticket in number,
        out_result out integer
    )
    return boolean
    as
        v_deletion_date date;

    begin
        select d.data_of_record_deletion into v_deletion_date
        from kabenyk_st.tickets t
            join kabenyk_st.doctors_specializations ds
                on t.id_doctor_specialization = ds.id_doctor_specialization
            join kabenyk_st.doctors d
                on ds.id_doctor = d.id_doctor
        where t.id_ticket = p_id_ticket;

        if v_deletion_date is not null then
            raise kabenyk_st.pkg_errors.e_doctor_deleted_exception;
        end if;
        out_result := kabenyk_st.pkg_code.c_ok;
        return false;
    exception
        when kabenyk_st.pkg_errors.e_doctor_deleted_exception then
            dbms_output.put_line ('Error. Doctor marked as deleted');
            kabenyk_st.add_error_log(
                $$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2),
                '{"error":"' || sqlerrm
                ||'","id_ticket":"' || p_id_ticket
                ||'","deletion_date":"' || v_deletion_date
                ||'","backtrace":"' || dbms_utility.format_error_backtrace()
                ||'"}'
            );
        out_result := kabenyk_st.pkg_code.c_error;
        return true;
    end;

    function get_doctor_by_id_doctor_speciality (
        p_id_doctor_speciality number,
        out_result out integer
    )
    return kabenyk_st.t_doctor
    as
        v_doctor kabenyk_st.t_doctor;
    begin
        select kabenyk_st.t_doctor(
            id_doctor => d.id_doctor,
            id_hospital => d.id_hospital,
            surname => d.surname,
            name => d.name,
            patronymic => d.patronymic,
            area => d.area,
            id_doctors_qualifications => d.id_doctors_qualifications,
            external_id_doctor => null,
            external_id_hospital => null,
            external_id_specialty => null
        )
        into v_doctor
        from kabenyk_st.doctors d
            join kabenyk_st.doctors_specializations ds
                on d.id_doctor = ds.id_doctor
        where ds.id_doctor_specialization = p_id_doctor_speciality
            and d.data_of_record_deletion is null;

        out_result := kabenyk_st.pkg_code.c_ok;
        return v_doctor;
    exception
        when no_data_found then
            dbms_output.put_line ('Error. No data found');
            kabenyk_st.add_error_log(
                $$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2),
                '{"error":"' || sqlerrm
                ||'","id_doctor_speciality":"' || p_id_doctor_speciality
                ||'","backtrace":"' || dbms_utility.format_error_backtrace()
                ||'"}'
            );
            out_result := kabenyk_st.pkg_code.c_error;
        return null;
    end;

    procedure merging_doctors_data (
        p_doctor kabenyk_st.t_doctor,
        out_result out integer
    )
    as
    begin
        merge into kabenyk_st.doctors d
        using (select p_doctor.surname,
                      p_doctor.name,
                      p_doctor.patronymic,
                      p_doctor.external_id_doctor,
                      p_doctor.external_id_hospital,
                      p_doctor.external_id_specialty
            from dual) p
        on (d.external_id_doctor = p_doctor.external_id_doctor)
        when matched then update
        set d.surname = p_doctor.surname,
            d.name = p_doctor.name,
            d.patronymic = p_doctor.patronymic,
            d.external_id_hospital = p_doctor.external_id_hospital,
            d.external_id_specialty = p_doctor.external_id_specialty
        when not matched then insert (surname, name, patronymic, external_id_doctor, external_id_hospital, external_id_specialty)
        values (
            p_doctor.surname, p_doctor.name, p_doctor.patronymic, p_doctor.external_id_doctor,
            p_doctor.external_id_hospital, p_doctor.external_id_specialty
        );
        out_result := kabenyk_st.pkg_code.c_ok;
    end;

end pkg_doctors;
