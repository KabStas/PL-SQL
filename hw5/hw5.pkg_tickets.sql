create or replace package kabenyk_st.pkg_tickets
as
    type t_record_1 is record (
        doctor varchar2(100),
        begin_time date
    );

    function all_tickets_by_doctor_as_func (
        p_id_doctor in number
    )
    return kabenyk_st.pkg_tickets.t_record_1;

    function get_ticket_by_id (
        p_id_ticket in number
    )
    return kabenyk_st.tickets%rowtype;

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
    return kabenyk_st.pkg_tickets.t_record_1
    as
        v_all_tickets_by_doctor_cursor sys_refcursor;
        v_record kabenyk_st.pkg_tickets.t_record_1;
    begin
        open v_all_tickets_by_doctor_cursor for
            select
                d.surname,
                t.begin_time
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
            loop
                fetch v_all_tickets_by_doctor_cursor into v_record;

                exit when v_all_tickets_by_doctor_cursor%notfound;

                dbms_output.put_line (
                    v_record.doctor|| ', ' ||
                    to_char (v_record.begin_time, 'yyyy.mm.dd hh24:mi')
                );
            end loop;
        close v_all_tickets_by_doctor_cursor;
        return v_record;
    end;

    function get_ticket_by_id (
        p_id_ticket in number
    )
    return kabenyk_st.tickets%rowtype
    as
        v_ticket kabenyk_st.tickets%rowtype;
    begin
        select *
        into v_ticket
        from kabenyk_st.tickets t
        where t.id_ticket = p_id_ticket;

        return v_ticket;
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
            dbms_output.put_line ('Error. Ticket is not open');
        end if;

        return v_ticket_flag = 1;
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
            dbms_output.put_line ('Error. Time is not correct');
        end if;

        return v_begin_time > sysdate;
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
