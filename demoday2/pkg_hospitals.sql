create or replace package kabenyk_st.pkg_hospitals
as
    c_id_private_hospital constant number := 2;

    function all_hospitals_by_specialty (
        p_id_specialty in number,
        out_result out integer
    )
    return kabenyk_st.t_arr_hospital;

    function hospitals_working_time (
        p_id_hospital in number,
        out_result out integer
    )
    return kabenyk_st.t_arr_hospital_time;

    function is_hospital_marked_as_deleted (
        p_id_ticket in number,
        out_result out integer
    )
    return boolean;

    function is_hospital_still_working (
        p_id_ticket in number,
        out_result out integer
    )
    return boolean;

    function get_hospital_by_id (
        p_id_hospital number,
        out_result out integer
    )
    return kabenyk_st.t_hospital;

    procedure merging_hospital_table (
        p_hospital_external kabenyk_st.t_hospital_external,
        out_result out integer
    );

    function clob_from_http(
        p_table in varchar2,
        out_result out integer
    )
    return clob;


end pkg_hospitals;

create or replace package body kabenyk_st.pkg_hospitals
as
    function all_hospitals_by_specialty (
       p_id_specialty in number,
       out_result out integer
    )
    return kabenyk_st.t_arr_hospital
    as
        v_arr_hospital kabenyk_st.t_arr_hospital := kabenyk_st.t_arr_hospital();
    begin
        select kabenyk_st.t_hospital(
            id_hospital => h.id_hospital,
            name => h.name,
            id_hospital_availability => h.id_hospital_availability,
            id_hospital_type => h.id_hospital_type,
            id_organization => h.id_organization,
            address => h.address,
            id_hospital_external => h.id_hospital_external
        )
        bulk collect into v_arr_hospital
        from kabenyk_st.specialties s
            join kabenyk_st.DOCTOR_SPECIALTY ds
                on s.id_specialty = ds.ID_SPECIALTY
            join kabenyk_st.doctors d
                on d.id_doctor = ds.id_doctor
            join kabenyk_st.hospitals h
                on h.id_hospital = d.id_hospital
            join kabenyk_st.hospital_availability a
                on a.id_hospital_availability = h.id_hospital_availability
            left join kabenyk_st.working_time w
                on h.id_hospital = w.id_hospital
            join kabenyk_st.hospital_type t
                on t.id_hospital_type = h.id_hospital_type
        where h.data_of_record_deletion is null and (
            p_id_specialty is null or (
            p_id_specialty is not null and
            s.id_specialty = p_id_specialty
            )
        )
        order by
            case
                when t.id_hospital_type = c_id_private_hospital then 0
                else 1
            end,
            case
                when to_char(sysdate, 'hh24:mi') < w.end_time
                then 0
                else 1
            end;

        out_result := kabenyk_st.pkg_code.c_ok;
        return v_arr_hospital;
    end;

    function hospitals_working_time (
        p_id_hospital in number,
        out_result out integer
    )
    return kabenyk_st.t_arr_hospital_time
    as
        v_arr_hospital_time kabenyk_st.t_arr_hospital_time := kabenyk_st.t_arr_hospital_time();
    begin
        select kabenyk_st.t_hospital_time (
            id_time => wt.id_time,
            day => wt.day,
            begin_time => wt.begin_time,
            end_time => wt.end_time,
            id_hospital => wt.id_hospital
        )
        bulk collect into v_arr_hospital_time
        from kabenyk_st.working_time wt
            where p_id_hospital is null or (
                p_id_hospital is not null and
                wt.id_hospital = p_id_hospital
            )
        order by wt.id_hospital, decode(
            wt.day, 'Понедельник', 1,
                    'Вторник',2,
                    'Среда', 3,
                    'Четверг', 4,
                    'Пятница', 5,
                    'Суббота', 6,
                    'Воскресенье', 7
        );

        out_result := kabenyk_st.pkg_code.c_ok;
        return v_arr_hospital_time;
    end;

    function is_hospital_marked_as_deleted (
        p_id_ticket in number,
        out_result out integer
    )
    return boolean
    as
        v_deletion_date date;
    begin
        select h.data_of_record_deletion into v_deletion_date
        from kabenyk_st.tickets t
            join kabenyk_st.DOCTOR_SPECIALTY ds
                on t.id_doctor_specialization = ds.id_doctor_specialization
            join kabenyk_st.doctors d
                on ds.id_doctor = d.id_doctor
            join kabenyk_st.hospitals h
                on d.id_hospital = h.id_hospital
        where t.id_ticket = p_id_ticket;

        if v_deletion_date is not null then
            raise kabenyk_st.pkg_errors.e_hospital_deleted_exception;
        end if;
        out_result := kabenyk_st.pkg_code.c_ok;
        return false;

    end;

    function is_hospital_still_working (
        p_id_ticket in number,
        out_result out integer
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
            join kabenyk_st.DOCTOR_SPECIALTY ds
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
        out_result := kabenyk_st.pkg_code.c_ok;
        return true;
    exception
        when kabenyk_st.pkg_errors.e_hospital_work_exception then
            dbms_output.put_line ('Error. Less 2 hours of hospital work');
            kabenyk_st.add_error_log(
                $$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2),
                '{"error":"' || sqlerrm
                ||'","id_ticket":"' || p_id_ticket
                ||'","hospital_end_time":"' || v_hospital_end_time
                ||'","backtrace":"' || dbms_utility.format_error_backtrace()
                ||'"}'
            );
            out_result := kabenyk_st.pkg_code.c_error;
        return false;
    end;

    function get_hospital_by_id (
        p_id_hospital number,
        out_result out integer
    )
    return kabenyk_st.t_hospital
    as
        v_hospital kabenyk_st.t_hospital;
    begin
        select kabenyk_st.t_hospital(
            id_hospital => h.id_hospital,
            name => h.name,
            id_hospital_availability => h.id_hospital_availability,
            id_hospital_type => h.id_hospital_type,
            id_organization => h.id_organization,
            address => h.address,
            id_hospital_external => h.id_hospital_external
        )
        into v_hospital
        from kabenyk_st.hospitals h
        where h.id_hospital = p_id_hospital
            and h.data_of_record_deletion is null;

        out_result := kabenyk_st.pkg_code.c_ok;
        return v_hospital;
    end;

    procedure merging_hospital_table (
        p_hospital_external kabenyk_st.t_hospital_external,
        out_result out integer
    )
    as
    begin

        kabenyk_st.caching_external_towns(p_hospital_external => p_hospital_external);

        merge into kabenyk_st.hospitals h
        using (select p_hospital_external.id_hospital_external,
                      p_hospital_external.name,
                      p_hospital_external.address
            from dual) p
        on (h.id_hospital_external = p_hospital_external.id_hospital_external)
        when matched then update
        set h.name = p_hospital_external.name,
            h.address = p_hospital_external.address
        when not matched then insert (name, address, id_hospital_external)
        values (
            p_hospital_external.name, p_hospital_external.address,
            p_hospital_external.id_hospital_external
        );
        commit;

        out_result := kabenyk_st.pkg_code.c_ok;
    end;

    function clob_from_http(
        p_table in varchar2,
        out_result out integer
    )
    return clob
    as

        v_success boolean;
        v_code number;
        v_clob clob;

    begin

        v_clob := kabenyk_st.http_fetch(
            p_url => 'http://virtserver.swaggerhub.com/AntonovAD/DoctorDB/1.0.0/' || p_table,
            p_debug => true,
            out_success => v_success,
            out_code => v_code
        );

        out_result := case when v_success
            then kabenyk_st.pkg_code.c_ok
            else kabenyk_st.pkg_code.c_error
        end;

        return v_clob;

    end;

end pkg_hospitals;
