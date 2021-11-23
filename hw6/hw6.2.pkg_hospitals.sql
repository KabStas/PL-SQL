create or replace package kabenyk_st.pkg_hospitals
as
    c_id_private_hospital constant number := 2;

    type t_record_1 is record (
        specialization varchar2(100),
        hospital varchar2(100),
        hospital_type varchar2(100),
        availability varchar2(100),
        doctors_quantity number,
        is_working number
    );
    type t_record_2 is record (
        name varchar2(100),
        day varchar2(100),
        begin_time varchar2(100),
        end_time varchar2(100)
    );

    function all_hospitals_by_specialization_as_func (
        p_id_specialization in number
    )
    return kabenyk_st.pkg_hospitals.t_record_1;

    function hospitals_working_time_as_func (
        p_id_hospital in number
    )
    return kabenyk_st.pkg_hospitals.t_record_2;

    function is_hospital_marked_as_deleted_as_func (
        p_id_ticket in number
    )
    return boolean;

    function is_hospital_still_working_as_func (
        p_id_ticket in number
    )
    return boolean;

end pkg_hospitals;

create or replace package body kabenyk_st.pkg_hospitals
as
    function all_hospitals_by_specialization_as_func (
       p_id_specialization in number
    )
    return kabenyk_st.pkg_hospitals.t_record_1
    as
        v_all_hospitals_by_specialization_cursor sys_refcursor;
        v_record kabenyk_st.pkg_hospitals.t_record_1;
    begin
        open v_all_hospitals_by_specialization_cursor for
            select
                s.specialization,
                h.name,
                t.type,
                a.availability,
                count (h.id_hospital) as doctors_quantity,
                case
                    when to_char(sysdate, 'hh24:mi') < w.end_time
                    then 0
                    else 1
                end as is_working
            from kabenyk_st.specializations s
                join kabenyk_st.doctors_specializations ds
                    on s.id_specialization = ds.id_specialization
                join kabenyk_st.doctors d
                    on d.id_doctor = ds.id_doctor
                join kabenyk_st.hospitals h
                    on h.id_hospital = d.id_hospital
                join kabenyk_st.hospital_availability a
                    on a.id_hospital_availability = h.id_hospital_availability
                join kabenyk_st.hospital_type t
                    on t.id_hospital_type = h.id_hospital_type
                join kabenyk_st.working_time w
                    on h.id_hospital = w.id_hospital
            where h.data_of_record_deletion is null
                  and
                  (p_id_specialization is null
                  or
                  (p_id_specialization is not null and
                  s.id_specialization = p_id_specialization))
            group by s.specialization, h.name, a.availability, t.type, t.id_hospital_type, w.end_time
            order by specialization,
                case
                    when t.id_hospital_type = c_id_private_hospital then 0
                    else 1
                end,
                doctors_quantity desc, is_working desc;

            loop
                fetch v_all_hospitals_by_specialization_cursor into v_record;

                exit when v_all_hospitals_by_specialization_cursor%notfound;

                dbms_output.put_line (
                    v_record.specialization|| ', ' ||
                    v_record.hospital|| ', ' ||
                    v_record.hospital_type||', врачей - ' ||
                    v_record.doctors_quantity
                );
            end loop;
        close v_all_hospitals_by_specialization_cursor;
        return v_record;
    end;

    function hospitals_working_time_as_func (
        p_id_hospital in number
    )
    return kabenyk_st.pkg_hospitals.t_record_2
    as
        v_hospitals_working_time_cursor sys_refcursor;
        v_record kabenyk_st.pkg_hospitals.t_record_2;
    begin
        open v_hospitals_working_time_cursor for
            select
                h.name,
                wt.day,
                wt.begin_time,
                wt.end_time
            from kabenyk_st.working_time wt
                join kabenyk_st.hospitals h
                    on wt.id_hospital = h.id_hospital
            where p_id_hospital is null
                  or (
                      p_id_hospital is not null and
                      h.id_hospital = p_id_hospital
                  )
            order by h.id_hospital, decode (wt.day, 'Понедельник', 1,
                                                    'Вторник',2,
                                                    'Среда', 3,
                                                    'Четверг', 4,
                                                    'Пятница', 5,
                                                    'Суббота', 6,
                                                    'Воскресенье', 7);
            loop
                fetch v_hospitals_working_time_cursor into v_record;

                exit when v_hospitals_working_time_cursor%notfound;

                dbms_output.put_line (
                    v_record.name|| ', '|| v_record.day||', ' ||
                    v_record.begin_time||', ' || v_record.end_time);
            end loop;
        close v_hospitals_working_time_cursor;
        return v_record;
    end;

    function is_hospital_marked_as_deleted_as_func (
        p_id_ticket in number
    )
    return boolean
    as
        v_deletion_date date;
    begin
        select h.data_of_record_deletion into v_deletion_date
        from kabenyk_st.tickets t
            join kabenyk_st.doctors_specializations ds
                on t.id_doctor_specialization = ds.id_doctor_specialization
            join kabenyk_st.doctors d
                on ds.id_doctor = d.id_doctor
            join kabenyk_st.hospitals h
                on d.id_hospital = h.id_hospital
        where t.id_ticket = p_id_ticket;

        if v_deletion_date is not null then
            raise kabenyk_st.pkg_errors.e_hospital_deleted_exception;
        end if;

        return false;
    exception
        when kabenyk_st.pkg_errors.e_hospital_deleted_exception then
            dbms_output.put_line ('Error. Hospital marked as deleted');
            kabenyk_st.add_error_log(
                $$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2),
                '{"error":"' || sqlerrm
                ||'","value":"' || v_deletion_date
                ||'","backtrace":"' || dbms_utility.format_error_backtrace()
                ||'"}'
            );
        return true;
    end;

    function is_hospital_still_working_as_func (
        p_id_ticket in number
    )
    return boolean
    as
        v_current_day varchar2(100);
        v_current_time varchar2(5);
        v_hospital_end_time varchar2(20);
        v_number_of_day number;
    begin
        v_current_day := to_char(sysdate,'day');
        v_number_of_day := to_char(sysdate,'d');
        v_current_time := to_number(to_char(sysdate,'hh24.mi'), '99.99');

        select wt.end_time into v_hospital_end_time
        from kabenyk_st.tickets t
            join kabenyk_st.doctors_specializations ds
                on t.id_doctor_specialization = ds.id_doctor_specialization
            join kabenyk_st.doctors d
                on ds.id_doctor = d.id_doctor
            join kabenyk_st.working_time wt
                on d.id_hospital = wt.id_hospital
        where t.id_ticket = p_id_ticket and
              decode (wt.day, 'Понедельник', 1,
                              'Вторник',2,
                              'Среда', 3,
                              'Четверг', 4,
                              'Пятница', 5,
                              'Суббота', 6,
                              'Воскресенье', 7) = v_number_of_day;

        v_hospital_end_time := to_number(v_hospital_end_time, '99.99');

        if (v_hospital_end_time - v_current_time) < 2 then
            raise kabenyk_st.pkg_errors.e_hospital_work_exception;
        end if;

        return true;
    exception
        when kabenyk_st.pkg_errors.e_hospital_work_exception then
            dbms_output.put_line ('Error. Less 2 hours of hospital work');
            kabenyk_st.add_error_log(
                $$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2),
                '{"error":"' || sqlerrm
                ||'","value":"' || v_hospital_end_time
                ||'","backtrace":"' || dbms_utility.format_error_backtrace()
                ||'"}'
            );
        return false;
    end;

end pkg_hospitals;