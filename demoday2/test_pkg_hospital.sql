create or replace package kabenyk_st.test_pkg_hospital
as

    --%suite

    --%beforeall
    procedure seed_before_all;

    --%test(проверка получения по id)
    procedure get_hospital_by_id;

    --%test(ошибка получения по id)
    --%throws(no_data_found)
    procedure failed_get_hospital_by_id;

    --%test(тест на foreign_key id_hospital_availability)
    --%throws(-01400)
    procedure check_hospital_id_hospital_availability_constraint;

    --%test(тест на date_of_birth is not null)
    --%throws(-01400)
    procedure check_hospital_name_constraint;

    --%test(тест на корректность запаковки данных)
    procedure check_serialising;

    --%test(тест на корректность распаковки данных)
    procedure check_deserialising;

    --%test(ошибка параметра)
    --%throws(no_data_found)
    procedure failed_is_hospital_marked_as_deleted;

end;
/

create or replace package body kabenyk_st.test_pkg_hospital
as
    is_debug boolean := true;

    mock_id_hospital number;
    mock_hospital_name varchar2(100);
    mock_id_hospital_availability number;
    mock_id_hospital_type number;
    mock_id_organization number;

    procedure get_hospital_by_id
    as
        v_hospital kabenyk_st.t_hospital;
        v_result number;
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        v_hospital := kabenyk_st.pkg_hospitals.get_hospital_by_id (
            p_id_hospital => mock_id_hospital,
            out_result => v_result
        );

        TOOL_UT3.UT.EXPECT(v_hospital.id_hospital).TO_EQUAL(mock_id_hospital);
        TOOL_UT3.UT.EXPECT(v_hospital.name).TO_EQUAL(mock_hospital_name);
        TOOL_UT3.UT.EXPECT(v_hospital.id_hospital_availability).TO_EQUAL(mock_id_hospital_availability);
        TOOL_UT3.UT.EXPECT(v_hospital.id_hospital_type).TO_EQUAL(mock_id_hospital_type);
        TOOL_UT3.UT.EXPECT(v_hospital.id_organization).TO_EQUAL(mock_id_organization);
        TOOL_UT3.UT.EXPECT(v_hospital.address).TO_BE_NULL();

    end;

    procedure failed_get_hospital_by_id
    as
        v_hospital kabenyk_st.t_hospital;
        v_result number;
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        v_hospital := kabenyk_st.pkg_hospitals.get_hospital_by_id (
            p_id_hospital => -1,
            out_result => v_result);
    end;


    procedure check_hospital_id_hospital_availability_constraint
    as
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        insert into kabenyk_st.hospitals(
            name,
            id_hospital_availability,
            id_hospital_type,
            id_organization
        )
        values (
            mock_hospital_name,
            null,
            mock_id_hospital_type,
            mock_id_organization
        );
    end;

    procedure check_hospital_name_constraint
    as
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        insert into kabenyk_st.hospitals(
            name,
            id_hospital_availability,
            id_hospital_type,
            id_organization
        )
        values (
            null,
            mock_id_hospital_availability,
            mock_id_hospital_type,
            mock_id_organization
        );
    end;

    procedure check_serialising
    as

        v_return_clob clob;
        v_id_hospital number := 160;

    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        v_return_clob := kabenyk_st.json_get_hospital_by_id (
            p_id_hospital => v_id_hospital
        );

        TOOL_UT3.UT.EXPECT(v_return_clob).TO_EQUAL(
            to_clob(
                '{"code":1,"response":[{"id_hospital":160,"name":"Poliklinika 5","id_hospital_availability":1,"id_hospital_type":null,"id_organization":null,"address":"g. Kemerovo, pr. Lenina, 104"}]}'
            )
        );

    end;

    procedure check_deserialising
    as

        v_arr_hospital kabenyk_st.t_arr_hospital_external := t_arr_hospital_external();
        v_result number;

    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        v_arr_hospital := kabenyk_st.parsing_hospitals_clob (
            out_result => v_result
        );
        TOOL_UT3.UT.EXPECT(ANYDATA.CONVERTCOLLECTION(v_arr_hospital)).NOT_TO_BE_EMPTY();
        TOOL_UT3.UT.EXPECT(ANYDATA.CONVERTCOLLECTION(v_arr_hospital)).TO_HAVE_COUNT(3);
        TOOL_UT3.UT.EXPECT(v_arr_hospital(1).name).TO_EQUAL('Poliklinika 5');
        TOOL_UT3.UT.EXPECT(v_arr_hospital(1).address).TO_EQUAL('g. Kemerovo, pr. Lenina, 104');
        TOOL_UT3.UT.EXPECT(v_arr_hospital(2).name).TO_EQUAL('Detskaya poliklinika');
        TOOL_UT3.UT.EXPECT(v_arr_hospital(2).address).TO_EQUAL('g. Kemerovo, yl. Kytyzova, 36');
        TOOL_UT3.UT.EXPECT(v_arr_hospital(3).name).TO_EQUAL('Jenskaya konsultaciya');
        TOOL_UT3.UT.EXPECT(v_arr_hospital(3).address).TO_EQUAL('g. Novokyzneck, pr. Bardina, 26');

    end;

    procedure failed_is_hospital_marked_as_deleted
    as
        v_result number;
        v_result_bool boolean;
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        v_result_bool := kabenyk_st.pkg_hospitals.is_hospital_marked_as_deleted (
            p_id_ticket => -1,
            out_result => v_result);
    end;



    procedure seed_before_all
    as
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        mock_id_hospital := 1;
        mock_hospital_name := 'hospital_name';
        mock_id_hospital_availability := 1;
        mock_id_hospital_type := 1;
        mock_id_organization := 1;

        insert into kabenyk_st.hospitals(
            name,
            id_hospital_availability,
            id_hospital_type,
            id_organization
        )
        values (
            mock_hospital_name,
            mock_id_hospital_availability,
            mock_id_hospital_type,
            mock_id_organization
        )
        returning id_hospital into mock_id_hospital;
    end;


end;

begin
    TOOL_UT3.UT.RUN('KABENYK_ST.TEST_PKG_HOSPITAL');
end;