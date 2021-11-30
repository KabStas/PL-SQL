create or replace package kabenyk_st.pkg_specialties
as
    function all_specialties_as_func (
        p_id_hospital in number
    )
    return kabenyk_st.t_arr_specialty;

    function is_gender_matched_as_func (
        p_id_patient in number,
        p_id_specialty in number
    )
    return boolean;

    function is_age_matched_as_func (
        p_id_patient in number,
        p_id_specialty in number
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
    return kabenyk_st.t_arr_specialty
    as
        v_arr_specialty kabenyk_st.t_arr_specialty;
    begin
        select kabenyk_st.t_specialty (
            id_specialty => s.id_specialization,
            specialty => s.specialization,
            min_age => s.min_age,
            max_age => s.max_age,
            id_gender => s.id_gender
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

        return v_arr_specialty;
    end;

    function is_gender_matched_as_func (
        p_id_patient in number,
        p_id_specialty in number
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
        return false;

    end;

    function is_age_matched_as_func (
        p_id_patient in number,
        p_id_specialty in number
    )
    return boolean
    as
        v_patient kabenyk_st.t_patient;
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
        where s.id_specialization = p_id_specialty
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
                ||'","id_patient":"' || p_id_patient
                ||'","id_specialty":"' || p_id_specialty
                ||'","result":"' || v_result
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
                ||'","id_specialty":"' || p_id_specialty
                ||'","deletion_date":"' || v_deletion_date
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
        v_specialty_id number;
    begin
        select ds.id_specialization
        into v_specialty_id
        from kabenyk_st.tickets t
            join kabenyk_st.doctors_specializations ds
                on t.id_doctor_specialization = ds.id_doctor_specialization
        where t.id_ticket = p_id_ticket;
        return v_specialty_id;
    end;

end pkg_specialties;

-- вызов функции и вывод массива в консоль
declare
    v_arr_specialty kabenyk_st.t_arr_specialty := kabenyk_st.t_arr_specialty();
begin
    v_arr_specialty := kabenyk_st.pkg_specialties.all_specialties_as_func(
        p_id_hospital => null
    );

    if v_arr_specialty.count>0 then
    for i in v_arr_specialty.first..v_arr_specialty.last
    loop
    declare
        v_item kabenyk_st.t_specialty := v_arr_specialty(i);
    begin
        dbms_output.put_line(kabenyk_st.to_char_t_specialty(v_item));
    end;
    end loop;
    end if;
end;