create or replace package kabenyk_st.test_pkg_ticket
as

    --%suite

    --%beforeall
    procedure seed_before_all;

    --%test(проверка получения по id)
    procedure get_ticket_by_id;

    --%test(ошибка получения по id)
    --%throws(no_data_found)
    procedure failed_get_ticket_by_id;

    --%test(тест на id_ticket_flag is not null)
    --%throws(-01400)
    procedure check_id_ticket_flag_constraint;

    --%test(тест на foreign_key id_doctor_specialization
    --%throws(-01400)
    procedure check_id_doctor_specialization_constraint;

    --%test(тест на корректность запаковки данных)
    procedure check_serialising;

    --%test(ошибка параметра)
    --%throws(no_data_found)
    procedure failed_is_ticket_open;

end;
/

create or replace package body kabenyk_st.test_pkg_ticket
as
    is_debug boolean := true;

    mock_id_ticket number;
    mock_id_ticket_flag number;
    mock_ticket_begin_time date;
    mock_ticket_end_time date;
    mock_id_doctor_specialization number;

    procedure get_ticket_by_id
    as
        v_ticket kabenyk_st.t_ticket;
        v_result number;
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        v_ticket := kabenyk_st.pkg_tickets.get_ticket_by_id (
            p_id_ticket => mock_id_ticket,
            out_result => v_result
        );

        TOOL_UT3.UT.EXPECT(v_ticket.id_ticket).TO_EQUAL(mock_id_ticket);
        TOOL_UT3.UT.EXPECT(v_ticket.id_ticket_flag).TO_EQUAL(mock_id_ticket_flag);
        TOOL_UT3.UT.EXPECT(v_ticket.begin_time).TO_EQUAL(mock_ticket_begin_time);
        TOOL_UT3.UT.EXPECT(v_ticket.end_time).TO_EQUAL(mock_ticket_end_time);
        TOOL_UT3.UT.EXPECT(v_ticket.id_doctor_specialization).TO_EQUAL(mock_id_doctor_specialization);

    end;

    procedure failed_get_ticket_by_id
    as
        v_ticket kabenyk_st.t_ticket;
        v_result number;
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        v_ticket := kabenyk_st.pkg_tickets.get_ticket_by_id (
            p_id_ticket => -1,
            out_result => v_result);
    end;


    procedure check_id_ticket_flag_constraint
    as
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        insert into kabenyk_st.tickets(
            id_ticket_flag,
            begin_time,
            end_time,
            id_doctor_specialization
        )
        values (
            null,
            mock_ticket_begin_time,
            mock_ticket_end_time,
            mock_id_doctor_specialization
        );
    end;

    procedure check_id_doctor_specialization_constraint
    as
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        insert into kabenyk_st.tickets(
            id_ticket_flag,
            begin_time,
            end_time,
            id_doctor_specialization
        )
        values (
            mock_id_ticket_flag,
            mock_ticket_begin_time,
            mock_ticket_end_time,
            null
        );
    end;

    procedure check_serialising
    as

        v_return_clob clob;

    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        v_return_clob := kabenyk_st.json_get_ticket_by_id (
            p_id_ticket => 3
        );

        TOOL_UT3.UT.EXPECT(v_return_clob).TO_BE_LIKE(
            '{"code":1,"response":[{"id_ticket":3,"id_ticket_flag":2,"begin_time":"2021-12-30T08:30:00","end_time":"2021-11-30T08:45:00","id_doctor_specialization":3}]}'
        );

    end;

    procedure failed_is_ticket_open
    as
        v_result number;
        v_result_bool boolean;
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        v_result_bool := kabenyk_st.pkg_tickets.is_ticket_open (
            p_id_ticket => -1,
            out_result => v_result);
        --tool_ut3.ut.expect(v_result).TO_EQUAL(kabenyk_st.pkg_code.c_error);
    end;

    procedure seed_before_all
    as
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        mock_id_ticket_flag := 1;
        mock_ticket_begin_time := to_date('2021/12/30 09:30', 'yyyy/mm/dd hh24:mi');
        mock_ticket_end_time := to_date('2021/12/30 09:40', 'yyyy/mm/dd hh24:mi');
        mock_id_doctor_specialization := 1;

        insert into kabenyk_st.tickets(
            id_ticket_flag,
            begin_time,
            end_time,
            id_doctor_specialization
        )
        values (
            mock_id_ticket_flag,
            mock_ticket_begin_time,
            mock_ticket_end_time,
            mock_id_doctor_specialization
        )
        returning id_ticket into mock_id_ticket;
    end;


end;

begin
    TOOL_UT3.UT.RUN('KABENYK_ST.TEST_PKG_TICKET');
end;