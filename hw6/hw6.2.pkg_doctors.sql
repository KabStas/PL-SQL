create or replace package kabenyk_st.pkg_doctors
as
    type t_record_1 is record (
        hospital varchar2(100),
        doctor varchar2(100),
        qualification varchar2(100),
        area number
    );

    function all_doctors_by_hospital_as_func (
        p_id_hospital in number,
        p_area in number
    )
    return kabenyk_st.pkg_doctors.t_record_1;

    function is_doctor_marked_as_deleted_as_func (
        p_id_ticket in number
    )
    return boolean;

    function get_doctor_by_id_doctor_speciality (
        p_id_doctor_speciality number
    )
    return kabenyk_st.doctors%rowtype;

end pkg_doctors;

create or replace package body kabenyk_st.pkg_doctors
as
    function all_doctors_by_hospital_as_func (
       p_id_hospital in number,
       p_area in number
    )
    return kabenyk_st.pkg_doctors.t_record_1
    as
        v_all_doctors_by_hospital_cursor sys_refcursor;
        v_record kabenyk_st.pkg_doctors.t_record_1;
    begin
        open v_all_doctors_by_hospital_cursor for
            select
                h.name,
                d.surname,
                q.qualification,
                d.area
            from kabenyk_st.doctors d
                join kabenyk_st.hospitals h
                    on d.id_hospital = h.id_hospital
                join kabenyk_st.doctors_qualifications q
                    on d.id_doctors_qualifications = q.id_doctors_qualifications
            where d.data_of_record_deletion is null
                  and
                  (p_id_hospital is null
                  or
                  (p_id_hospital is not null and
                  d.id_hospital = p_id_hospital))
            order by qualification,
                case
                    when d.area = p_area then 0
                    else 1
                end;

            loop
                fetch v_all_doctors_by_hospital_cursor into v_record;

                exit when v_all_doctors_by_hospital_cursor%notfound;

                dbms_output.put_line (
                    v_record.hospital|| ', ' || v_record.doctor ||
                    ', ' || v_record.qualification||', ' || v_record.area ||
                    ' участок'
                );
            end loop;
        close v_all_doctors_by_hospital_cursor;
        return v_record;
    end;

    function is_doctor_marked_as_deleted_as_func (
        p_id_ticket in number
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
        return true;
    end;

    function get_doctor_by_id_doctor_speciality (
        p_id_doctor_speciality number
    )
    return kabenyk_st.doctors%rowtype
    as
        v_doctor kabenyk_st.doctors%rowtype;
    begin
        select d.*
        into v_doctor
        from kabenyk_st.doctors d
            join kabenyk_st.doctors_specializations ds
                on d.id_doctor = ds.id_doctor
        where ds.id_doctor_specialization = p_id_doctor_speciality
            and d.data_of_record_deletion is null;

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
        return null;
    end;

end pkg_doctors;