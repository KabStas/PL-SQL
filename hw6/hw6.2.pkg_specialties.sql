create or replace package kabenyk_st.pkg_specialties
as
    type t_record_1 is record (
        specialization varchar2(100),
        doctors_quantity varchar2(100)
    );

    function all_specialties_as_func (
        p_id_hospital in number
    )
    return kabenyk_st.pkg_specialties.t_record_1;

    function is_gender_matched_as_func (
        p_id_patient in number,
        p_id_specialization in number
    )
    return boolean;

    function is_age_matched_as_func (
        p_id_patient in number,
        p_id_specialization in number
    )
    return boolean;

    function is_specialty_marked_as_deleted_as_func (
        p_id_specialty in number
    )
    return boolean;

    function get_id_specialty_by_ticket (
        p_id_ticket in number
    )
    return number;

end pkg_specialties;

create or replace package body kabenyk_st.pkg_specialties
as
    function all_specialties_as_func (
       p_id_hospital in number
    )
    return kabenyk_st.pkg_specialties.t_record_1
    as
        v_all_specializations_cursor sys_refcursor;
        v_record kabenyk_st.pkg_specialties.t_record_1;
    begin
        open v_all_specializations_cursor for
            select
                s.specialization,
                count (s.specialization) as doctors_quantity
            from
                kabenyk_st.specializations s
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
                  p_id_hospital is null or
                  (p_id_hospital is not null and
                   h.id_hospital = p_id_hospital
            ))
            group by s.specialization;

            loop
                fetch v_all_specializations_cursor into v_record;

                exit when v_all_specializations_cursor%notfound;

                dbms_output.put_line (
                    v_record.specialization|| ', врачей - '
                    || v_record.doctors_quantity
                );
            end loop;
        close v_all_specializations_cursor;
        return v_record;
    end;

    function is_gender_matched_as_func (
        p_id_patient in number,
        p_id_specialization in number
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
            and s.id_specialization = p_id_specialization
            and (
                p.id_gender = s.id_gender
                or s.id_gender is null
            );

        if v_result = 0 then
            raise kabenyk_st.pkg_errors.e_patient_gender_exception;
        end if;

        return true;
    exception
        when kabenyk_st.pkg_errors.e_patient_gender_exception then
            dbms_output.put_line ('Error. Gender not matched');
            kabenyk_st.add_error_log(
                $$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2),
                '{"error":"' || sqlerrm
                ||'","value":"' || v_result
                ||'","backtrace":"' || dbms_utility.format_error_backtrace()
                ||'"}'
            );
        return false;

    end;

    function is_age_matched_as_func (
        p_id_patient in number,
        p_id_specialization in number
    )
    return boolean
    as
        v_patient kabenyk_st.patients%rowtype;
        v_age number;
        v_result number;
    begin
        v_patient := kabenyk_st.pkg_patients.get_patient_by_id (
            p_id_patient => p_id_patient
        );

        v_age := kabenyk_st.pkg_patients.calc_age_from_date_of_birth (
            p_date => v_patient.date_of_birth
        );

        select count(*)
        into v_result
        from kabenyk_st.specializations s
        where s.id_specialization = p_id_specialization
            and (s.min_age <= v_age or s.min_age is null)
            and (s.max_age >= v_age or s.max_age is null);

        if v_result = 0 then
            raise kabenyk_st.pkg_errors.e_patient_age_exception;
        end if;

        return true;
    exception
        when kabenyk_st.pkg_errors.e_patient_age_exception then
            dbms_output.put_line ('Error. Age not matched');
            kabenyk_st.add_error_log(
                $$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2),
                '{"error":"' || sqlerrm
                ||'","value":"' || v_result
                ||'","backtrace":"' || dbms_utility.format_error_backtrace()
                ||'"}'
            );
        return false;
    end;

    function is_specialty_marked_as_deleted_as_func (
        p_id_specialty in number
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

        return false;
    exception
        when kabenyk_st.pkg_errors.e_specialty_deleted_exception then
            dbms_output.put_line ('Error. Specialty marked as deleted');
            kabenyk_st.add_error_log(
                $$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2),
                '{"error":"' || sqlerrm
                ||'","value":"' || v_deletion_date
                ||'","backtrace":"' || dbms_utility.format_error_backtrace()
                ||'"}'
            );
        return false;
    end;

    function get_id_specialty_by_ticket (
        p_id_ticket in number
    )
    return number
    as
        v_specialty number;
    begin
        select ds.id_specialization
        into v_specialty
        from kabenyk_st.tickets t
            join kabenyk_st.doctors_specializations ds
                on t.id_doctor_specialization = ds.id_doctor_specialization
        where t.id_ticket = p_id_ticket;
        return v_specialty;
    end;
end pkg_specialties;