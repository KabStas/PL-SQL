create or replace package kabenyk_st.pkg_hospitals
as
    c_id_private_hospital constant number := 2;

    function all_hospitals_by_specialization_as_func (
        p_id_specialty in number
    )
    return kabenyk_st.t_arr_hospital;

    function hospitals_working_time_as_func (
        p_id_hospital in number
    )
    return kabenyk_st.t_arr_hospital_time;

    function is_hospital_marked_as_deleted_as_func (
        p_id_ticket in number
    )
    return boolean;

    function is_hospital_still_working_as_func (
        p_id_ticket in number
    )
    return boolean;

    function get_hospital_by_id (
        p_id_hospital number
    )
    return kabenyk_st.t_hospital;



end pkg_hospitals;

create or replace package body kabenyk_st.pkg_hospitals
as
    function all_hospitals_by_specialization_as_func (
       p_id_specialty in number
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
            id_organization => h.id_organization
        )
        bulk collect into v_arr_hospital
        from kabenyk_st.specializations s
            join kabenyk_st.doctors_specializations ds
                on s.id_specialization = ds.id_specialization
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
            s.id_specialization = p_id_specialty
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

        return v_arr_hospital;
    end;

    function hospitals_working_time_as_func (
        p_id_hospital in number
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

        return v_arr_hospital_time;
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
                ||'","id_ticket":"' || p_id_ticket
                ||'","deletion_date":"' || v_deletion_date
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
                ||'","id_ticket":"' || p_id_ticket
                ||'","hospital_end_time":"' || v_hospital_end_time
                ||'","backtrace":"' || dbms_utility.format_error_backtrace()
                ||'"}'
            );
        return false;
    end;

    function get_hospital_by_id (
        p_id_hospital number
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
            id_organization => h.id_organization
        )
        into v_hospital
        from kabenyk_st.hospitals h
        where h.id_hospital = p_id_hospital
            and h.data_of_record_deletion is null;

        return v_hospital;
    end;

end pkg_hospitals;

-- вызов функции и вывод массива в консоль
-- больницы конкретной специальности
declare
    v_arr_hospital kabenyk_st.t_arr_hospital := kabenyk_st.t_arr_hospital();
begin
    v_arr_hospital := kabenyk_st.pkg_hospitals.all_hospitals_by_specialization_as_func(
        p_id_specialty => 5
    );

    if v_arr_hospital.count>0 then
    for i in v_arr_hospital.first..v_arr_hospital.last
    loop
    declare
        v_item kabenyk_st.t_hospital := v_arr_hospital(i);
    begin
        dbms_output.put_line(kabenyk_st.to_char_t_hospital(v_item));
    end;
    end loop;
    end if;
end;

-- расписание больниц
declare
    v_arr_hospital_time kabenyk_st.t_arr_hospital_time := kabenyk_st.t_arr_hospital_time();
begin

    v_arr_hospital_time := kabenyk_st.pkg_hospitals.hospitals_working_time_as_func(
        p_id_hospital => null
    );

    if v_arr_hospital_time.count>0 then
    for i in v_arr_hospital_time.first..v_arr_hospital_time.last
    loop
    declare
        v_item kabenyk_st.t_hospital_time := v_arr_hospital_time(i);
    begin
        dbms_output.put_line(kabenyk_st.to_char_t_hospital_time(v_item));
    end;
    end loop;
    end if;
end;