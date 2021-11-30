create or replace package kabenyk_st.pkg_tickets
as
    function all_tickets_by_doctor_as_func (
        p_id_doctor in number
    )
    return kabenyk_st.t_arr_ticket;

    function get_ticket_by_id (
        p_id_ticket in number
    )
    return kabenyk_st.t_ticket;

    function is_ticket_open_as_func (
        p_id_ticket in number
    )
    return boolean;

    function is_time_correct_as_func (
        p_id_ticket in number
    )
    return boolean;

    procedure changing_ticket_flag_to_close_as_proc (
        p_id_ticket in number
    );

    procedure changing_ticket_flag_to_open_as_proc (
        p_id_ticket in number
    );

end pkg_tickets;

create or replace package body kabenyk_st.pkg_tickets
as
    function all_tickets_by_doctor_as_func (
        p_id_doctor in number
    )
    return kabenyk_st.t_arr_ticket
    as
        v_arr_ticket kabenyk_st.t_arr_ticket := kabenyk_st.t_arr_ticket();
    begin
        select kabenyk_st.t_ticket(
            id_ticket => t.id_ticket,
            id_ticket_flag => t.id_ticket_flag,
            begin_time => t.begin_time,
            end_time => t.end_time,
            id_doctor_specialization => t.id_doctor_specialization
        )
        bulk collect into v_arr_ticket
        from kabenyk_st.doctors d
            join kabenyk_st.doctors_specializations ds
                on d.id_doctor = ds.id_doctor
            join kabenyk_st.tickets t
                on ds.id_doctor_specialization = t.id_doctor_specialization
        where t.begin_time > sysdate and (
            p_id_doctor is null or (
            p_id_doctor is not null and d.id_doctor = p_id_doctor
            )
        );
        return v_arr_ticket;
    end;

    function get_ticket_by_id (
        p_id_ticket in number
    )
    return kabenyk_st.t_ticket
    as
        v_ticket kabenyk_st.t_ticket;
    begin
        select kabenyk_st.t_ticket(
            id_ticket => t.id_ticket,
            id_ticket_flag => t.id_ticket_flag,
            begin_time => t.begin_time,
            end_time => t.end_time,
            id_doctor_specialization => t.id_doctor_specialization
        )
        into v_ticket
        from kabenyk_st.tickets t
        where t.id_ticket = p_id_ticket;
        --or t.id_ticket = 9; -- для проверки работы exception

        return v_ticket;
    exception
        when too_many_rows then
            dbms_output.put_line ('Error. Too many rows');
            kabenyk_st.add_error_log(
                $$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2),
                '{"error":"' || sqlerrm
                ||'","id_ticket":"' || p_id_ticket
                ||'","backtrace":"' || dbms_utility.format_error_backtrace()
                ||'"}'
            );
        return null;
    end;

    function is_ticket_open_as_func (
        p_id_ticket in number
    )
    return boolean
    as
        v_ticket_flag number;
    begin
        select t.id_ticket_flag into v_ticket_flag
        from kabenyk_st.tickets t
        where t.id_ticket = p_id_ticket;

        if v_ticket_flag != 1 then
            raise kabenyk_st.pkg_errors.e_ticket_not_open_exception;
        end if;

        return true;
    exception
        when kabenyk_st.pkg_errors.e_ticket_not_open_exception then
            dbms_output.put_line ('Error. Ticket is not open');
            kabenyk_st.add_error_log(
                $$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2),
                '{"error":"' || sqlerrm
                ||'","id_ticket":"' || p_id_ticket
                ||'","ticket_flag":"' || v_ticket_flag
                ||'","backtrace":"' || dbms_utility.format_error_backtrace()
                ||'"}'
            );
        return false;
    end;

    function is_time_correct_as_func (
        p_id_ticket in number
    )
    return boolean
    as
        v_begin_time date;
    begin
        select t.begin_time into v_begin_time
        from kabenyk_st.tickets t
        where t.id_ticket = p_id_ticket;

        if v_begin_time < sysdate then
            raise kabenyk_st.pkg_errors.e_ticket_time_exception;
        end if;

        return true;
    exception
        when kabenyk_st.pkg_errors.e_ticket_time_exception then
            dbms_output.put_line ('Error. Time is not correct');
            kabenyk_st.add_error_log(
                $$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2),
                '{"error":"' || sqlerrm
                ||'","id_ticket":"' || p_id_ticket
                ||'","begin_time":"' || v_begin_time
                ||'","backtrace":"' || dbms_utility.format_error_backtrace()
                ||'"}'
            );
        return false;
    end;

    procedure changing_ticket_flag_to_close_as_proc (
        p_id_ticket in number
    )
    as
    begin
        update kabenyk_st.tickets t
        set t.id_ticket_flag = 2
        where t.id_ticket = p_id_ticket;
        commit;
    end;

    procedure changing_ticket_flag_to_open_as_proc (
        p_id_ticket in number
    )
    as
    begin
        update kabenyk_st.tickets t
        set t.id_ticket_flag = 1
        where t.id_ticket = p_id_ticket;
        commit;
    end;
end pkg_tickets;

-- для вызова ошибки
declare
    v_ticket kabenyk_st.tickets%rowtype;
begin
    v_ticket := kabenyk_st.pkg_tickets.get_ticket_by_id (
        p_id_ticket => 3
    );
end;

--проверка работы getter'а
declare
    v_ticket kabenyk_st.t_ticket;
begin
    v_ticket := kabenyk_st.pkg_tickets.get_ticket_by_id (
        p_id_ticket => 7
    );
    dbms_output.put_line(
        kabenyk_st.to_char_t_ticket(v_ticket)
    );
end;

-- вызов функции все талоны врача и вывод массива в консоль
declare
    v_arr_ticket kabenyk_st.t_arr_ticket := kabenyk_st.t_arr_ticket();
begin
    v_arr_ticket := kabenyk_st.pkg_tickets.all_tickets_by_doctor_as_func(
        p_id_doctor => 3
    );

    if v_arr_ticket.count>0 then
    for i in v_arr_ticket.first..v_arr_ticket.last
    loop
    declare
        v_item kabenyk_st.t_ticket := v_arr_ticket(i);
    begin
        dbms_output.put_line(kabenyk_st.to_char_t_ticket(v_item));
    end;
    end loop;
    end if;
end;

