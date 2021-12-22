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

    function get_specialty_by_id (
        p_id_specialty in number,
        out_result out integer
    )
    return kabenyk_st.t_specialty;

    procedure merging_specialties_table (
        p_specialty_external kabenyk_st.t_specialty_external,
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
            id_specialty => s.id_specialty,
            specialty => s.specialty,
            min_age => s.min_age,
            max_age => s.max_age,
            id_gender => s.id_gender,
            id_specialty_external => null
        )
        bulk collect into v_arr_specialty
        from kabenyk_st.specialties s
            join kabenyk_st.doctor_specialty ds
                on s.id_specialty = ds.id_specialty
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
        join kabenyk_st.specialties s
            on s.id_gender = g.id_gender
        where p.id_patient = p_id_patient
            and s.id_specialty = p_id_specialty
            and (
                p.id_gender = s.id_gender
                or s.id_gender is null
            );

        if v_result = 0 then
            raise kabenyk_st.pkg_errors.e_patient_gender_exception;
        end if;

        out_result := kabenyk_st.pkg_code.c_ok;

        return true;
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
        from kabenyk_st.specialties s
        where s.id_specialty = p_id_specialty
            and (s.min_age <= v_age or s.min_age is null)
            and (s.max_age >= v_age or s.max_age is null);

        if v_result = 0 then
            raise kabenyk_st.pkg_errors.e_patient_age_exception;
        end if;

        out_result := kabenyk_st.pkg_code.c_ok;

        return true;
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
        from kabenyk_st.specialties s
        where s.id_specialty = p_id_specialty;

        if v_deletion_date is not null then
            raise kabenyk_st.pkg_errors.e_specialty_deleted_exception;
        end if;

        out_result := kabenyk_st.pkg_code.c_ok;

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
        select ds.id_specialty
        into v_specialty_id
        from kabenyk_st.tickets t
            join kabenyk_st.DOCTOR_SPECIALTY ds
                on t.id_doctor_specialization = ds.id_doctor_specialization
        where t.id_ticket = p_id_ticket;

        out_result := kabenyk_st.pkg_code.c_ok;

        return v_specialty_id;
    end;

    function get_specialty_by_id (
        p_id_specialty in number,
        out_result out integer
    )
    return kabenyk_st.t_specialty
    as
        v_specialty kabenyk_st.t_specialty;
    begin
        select kabenyk_st.t_specialty(
            id_specialty => s.id_specialty,
            specialty => s.specialty,
            min_age => s.min_age,
            max_age => s.max_age,
            id_gender => s.id_gender,
            id_specialty_external => null
                   )
        into v_specialty
        from kabenyk_st.specialties s
        where s.id_specialty = p_id_specialty;

        out_result := kabenyk_st.pkg_code.c_ok;

        return v_specialty;
    end;

    procedure merging_specialties_table (
        p_specialty_external kabenyk_st.t_specialty_external,
        out_result out integer
    )
    as
    begin
        merge into kabenyk_st.specialties s
        using (select p_specialty_external.specialty,
                      p_specialty_external.id_specialty_external
            from dual) p
        on (s.id_specialty_external = p_specialty_external.id_specialty_external)
        when matched then update
        set s.specialty = p_specialty_external.specialty
        when not matched then insert (specialty, id_specialty_external)
        values (p_specialty_external.specialty, p_specialty_external.id_specialty_external);

        commit;

        out_result := kabenyk_st.pkg_code.c_ok;
    end;

end pkg_specialties;