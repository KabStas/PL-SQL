create or replace package kabenyk_st.pkg_specialties
as
    function get_all_specialties_by_hospital (
        p_id_hospital in number,
        out_result out integer
    )
    return kabenyk_st.t_arr_specialty;

    function is_gender_matched (
        p_id_patient in number,
        p_id_specialty in number,
        out_result out integer
    )
    return boolean;

    function is_age_matched (
        p_id_patient in number,
        p_id_specialty in number,
        out_result out integer
    )
    return boolean;

    function is_specialty_marked_as_deleted (
        p_id_specialty in number,
        out_result out integer
    )
    return boolean;

    function get_id_specialty_by_ticket (
        p_id_ticket in number,
        out_result out integer
    )
    return number;

    procedure merging_specialties_data (
        p_specialty kabenyk_st.t_specialty,
        out_result out integer
    );

end pkg_specialties;

create or replace package body kabenyk_st.pkg_specialties
as
    function get_all_specialties_by_hospital (
       p_id_hospital in number,
       out_result out integer
    )
    return kabenyk_st.t_arr_specialty
    as
        v_arr_specialty kabenyk_st.t_arr_specialty;
    begin
        select kabenyk_st.t_specialty (
            id_specialty => s.id_specialization,
            specialty => s.specialization,
            min_age => s.min_age,
            max_age => s.max_age,
            id_gender => s.id_gender,
            external_id_specialty => null,
            external_id_hospital => null
        )
        bulk collect into v_arr_specialty
        from kabenyk_st.specializations s
            join kabenyk_st.doctors_specializations ds
                on s.id_specialization = ds.id_specialization
            join kabenyk_st.doctors d
                on ds.id_doctor = d.id_doctor
            join kabenyk_st.hospitals h
                on d.id_hospital = h.id_hospital
        where (
            s.data_of_record_deletion is null and
            d.data_of_record_deletion is null and
            h.data_of_record_deletion is null
        ) and (
            p_id_hospital is null or (
            p_id_hospital is not null and
            h.id_hospital = p_id_hospital
            )
        );

        out_result := kabenyk_st.pkg_code.c_ok;

        return v_arr_specialty;
    end;

    function is_gender_matched (
        p_id_patient in number,
        p_id_specialty in number,
        out_result out integer
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
            and s.id_specialization = p_id_specialty
            and (
                p.id_gender = s.id_gender
                or s.id_gender is null
            );

        if v_result = 0 then
            raise kabenyk_st.pkg_errors.e_patient_gender_exception;
        end if;

        out_result := kabenyk_st.pkg_code.c_ok;

        return true;
    exception
        when kabenyk_st.pkg_errors.e_patient_gender_exception then
            dbms_output.put_line ('Error. Gender not matched');
            kabenyk_st.add_error_log(
                $$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2),
                '{"error":"' || sqlerrm
                ||'","id_patient":"' || p_id_patient
                ||'","id_specialty":"' || p_id_specialty
                ||'","result":"' || v_result
                ||'","backtrace":"' || dbms_utility.format_error_backtrace()
                ||'"}'
            );
            out_result := kabenyk_st.pkg_code.c_error;
        return false;

    end;

    function is_age_matched (
        p_id_patient in number,
        p_id_specialty in number,
        out_result out integer
    )
    return boolean
    as
        v_patient kabenyk_st.t_patient;
        v_age number;
        v_result number;
        v_out_result integer;
    begin
        v_patient := kabenyk_st.get_patient_by_id (
            p_id_patient => p_id_patient,
            out_result => v_out_result
        );

        v_age := kabenyk_st.pkg_utils.calc_age_from_date_of_birth (
            p_date => v_patient.date_of_birth
        );

        select count(*)
        into v_result
        from kabenyk_st.specializations s
        where s.id_specialization = p_id_specialty
            and (s.min_age <= v_age or s.min_age is null)
            and (s.max_age >= v_age or s.max_age is null);

        if v_result = 0 then
            raise kabenyk_st.pkg_errors.e_patient_age_exception;
        end if;

        out_result := kabenyk_st.pkg_code.c_ok;

        return true;
    exception
        when kabenyk_st.pkg_errors.e_patient_age_exception then
            dbms_output.put_line ('Error. Age not matched');
            kabenyk_st.add_error_log(
                $$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2),
                '{"error":"' || sqlerrm
                ||'","id_patient":"' || p_id_patient
                ||'","id_specialty":"' || p_id_specialty
                ||'","result":"' || v_result
                ||'","backtrace":"' || dbms_utility.format_error_backtrace()
                ||'"}'
            );
            out_result := kabenyk_st.pkg_code.c_error;
        return false;
    end;

    function is_specialty_marked_as_deleted (
        p_id_specialty in number,
        out_result out integer
    )
    return boolean
    as
        v_deletion_date date;
    begin
        select s.data_of_record_deletion into v_deletion_date
        from kabenyk_st.specializations s
        where s.id_specialization = p_id_specialty;

        if v_deletion_date is not null then
            raise kabenyk_st.pkg_errors.e_specialty_deleted_exception;
        end if;

        out_result := kabenyk_st.pkg_code.c_ok;

        return false;
    exception
        when kabenyk_st.pkg_errors.e_specialty_deleted_exception then
            dbms_output.put_line ('Error. Specialty marked as deleted');
            kabenyk_st.add_error_log(
                $$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2),
                '{"error":"' || sqlerrm
                ||'","id_specialty":"' || p_id_specialty
                ||'","deletion_date":"' || v_deletion_date
                ||'","backtrace":"' || dbms_utility.format_error_backtrace()
                ||'"}'
            );
        out_result := kabenyk_st.pkg_code.c_error;
        return false;
    end;

    function get_id_specialty_by_ticket (
        p_id_ticket in number,
        out_result out integer
    )
    return number
    as
        v_specialty_id number;
    begin
        select ds.id_specialization
        into v_specialty_id
        from kabenyk_st.tickets t
            join kabenyk_st.doctors_specializations ds
                on t.id_doctor_specialization = ds.id_doctor_specialization
        where t.id_ticket = p_id_ticket;

        out_result := kabenyk_st.pkg_code.c_ok;

        return v_specialty_id;
    end;

    procedure merging_specialties_data (
        p_specialty kabenyk_st.t_specialty,
        out_result out integer
    )
    as
    begin
        merge into kabenyk_st.specializations s
        using (select p_specialty.specialty,
                      p_specialty.external_id_specialty,
                      p_specialty.external_id_hospital
            from dual) p
        on (s.external_id_specialty = p_specialty.external_id_specialty)
        when matched then update
        set s.specialization = p_specialty.specialty,
            s.external_id_hospital = p_specialty.external_id_hospital
        when not matched then insert (specialization, external_id_specialty, external_id_hospital)
        values (p_specialty.specialty, p_specialty.external_id_specialty, p_specialty.external_id_hospital);

        out_result := kabenyk_st.pkg_code.c_ok;
    end;

end pkg_specialties;
