create or replace package kabenyk_st.pkg_tickets
as
    function all_tickets_by_doctor (
        p_id_doctor in number,
        out_result out integer
    )
    return kabenyk_st.t_arr_ticket;

    function get_ticket_by_id (
        p_id_ticket in number,
        out_result out integer
    )
    return kabenyk_st.t_ticket;

    function is_ticket_open (
        p_id_ticket in number,
        out_result out integer
    )
    return boolean;

    function is_time_correct (
        p_id_ticket in number,
        out_result out integer
    )
    return boolean;

    procedure changing_ticket_flag_to_close (
        p_id_ticket in number,
        out_result out integer
    );

    procedure changing_ticket_flag_to_open (
        p_id_ticket in number,
        out_result out integer
    );

end pkg_tickets;

create or replace package body kabenyk_st.pkg_tickets
as
    function all_tickets_by_doctor (
        p_id_doctor in number,
        out_result out integer
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

        out_result := kabenyk_st.pkg_code.c_ok;

        return v_arr_ticket;
    end;

    function get_ticket_by_id (
        p_id_ticket in number,
        out_result out integer
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

        out_result := kabenyk_st.pkg_code.c_ok;

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
            out_result := kabenyk_st.pkg_code.c_error;
        return null;
    end;

    function is_ticket_open (
        p_id_ticket in number,
        out_result out integer
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

        out_result := kabenyk_st.pkg_code.c_ok;

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
            out_result := kabenyk_st.pkg_code.c_ok;

        return false;
    end;

    function is_time_correct (
        p_id_ticket in number,
        out_result out integer
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

        out_result := kabenyk_st.pkg_code.c_ok;

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
            out_result := kabenyk_st.pkg_code.c_ok;

        return false;
    end;

    procedure changing_ticket_flag_to_close (
        p_id_ticket in number,
        out_result out integer
    )
    as
    begin
        update kabenyk_st.tickets t
        set t.id_ticket_flag = 2
        where t.id_ticket = p_id_ticket;
        commit;

        out_result := kabenyk_st.pkg_code.c_ok;

    end;

    procedure changing_ticket_flag_to_open (
        p_id_ticket in number,
        out_result out integer
    )
    as
    begin
        update kabenyk_st.tickets t
        set t.id_ticket_flag = 1
        where t.id_ticket = p_id_ticket;
        commit;

        out_result := kabenyk_st.pkg_code.c_ok;

    end;

end pkg_tickets;


