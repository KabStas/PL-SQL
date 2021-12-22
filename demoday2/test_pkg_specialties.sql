create or replace package kabenyk_st.test_pkg_specialties
as

    --%suite

    --%beforeall
    procedure seed_before_all;

    --%test(проверка получения по id)
    procedure get_specialty_by_id;

    --%test(ошибка получения по id)
    --%throws(no_data_found)
    procedure failed_get_specialty_by_id;

    --%test(тест на specialty is not null)
    --%throws(-01400)
    procedure check_specialty_name_constraint;

    --%test(тест на корректность запаковки данных)
    procedure check_serialising;

    --%test(тест на корректность распаковки данных)
    procedure check_deserialising;

    --%test(проверка получения правильного кода)
    procedure is_gender_matched;

end;
/

create or replace package body kabenyk_st.test_pkg_specialties
as
    is_debug boolean := true;

    mock_id_specialty number;
    mock_specialty varchar2(100);
    mock_specialty_min_age number;
    mock_specialty_max_age number;
    mock_specialty_id_gender number;

    procedure get_specialty_by_id
    as
        v_specialty kabenyk_st.t_specialty;
        v_result number;
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        v_specialty := kabenyk_st.pkg_specialties.get_specialty_by_id (
            p_id_specialty => mock_id_specialty,
            out_result => v_result
        );

        TOOL_UT3.UT.EXPECT(v_specialty.id_specialty).TO_EQUAL(mock_id_specialty);
        TOOL_UT3.UT.EXPECT(v_specialty.specialty).TO_EQUAL(mock_specialty);
        TOOL_UT3.UT.EXPECT(v_specialty.min_age).TO_EQUAL(mock_specialty_min_age);
        TOOL_UT3.UT.EXPECT(v_specialty.max_age).TO_EQUAL(mock_specialty_max_age);
        TOOL_UT3.UT.EXPECT(v_specialty.id_gender).TO_EQUAL(mock_specialty_id_gender);
        TOOL_UT3.UT.EXPECT(v_specialty.id_specialty_external).TO_BE_NULL();

    end;

    procedure failed_get_specialty_by_id
    as
        v_specialty kabenyk_st.t_specialty;
        v_result number;
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        v_specialty := kabenyk_st.pkg_specialties.get_specialty_by_id (
            p_id_specialty => -1,
            out_result => v_result);
    end;


    procedure check_specialty_name_constraint
    as
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        insert into kabenyk_st.specialties(
            specialty,
            min_age,
            max_age,
            id_gender
        )
        values (
            null,
            mock_specialty_min_age,
            mock_specialty_max_age,
            mock_specialty_id_gender
        );
    end;

    procedure check_serialising
    as

        v_return_clob clob;

    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        v_return_clob := kabenyk_st.json_get_all_specialties_by_hospital (
            p_id_hospital => 6
        );

        TOOL_UT3.UT.EXPECT(v_return_clob).TO_EQUAL(
            to_clob(
                '{"code":1,"response":[{"id_specialty":3,"specialty":"urolog","min_age":18,"max_age":null,"id_gender":1}]}'
            )
        );

    end;

    procedure check_deserialising
    as

        v_arr_specialty kabenyk_st.t_arr_specialty_external := t_arr_specialty_external();
        v_result number;

    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        v_arr_specialty := kabenyk_st.parsing_specialties_clob (
            out_result => v_result
        );
        TOOL_UT3.UT.EXPECT(ANYDATA.CONVERTCOLLECTION(v_arr_specialty)).NOT_TO_BE_EMPTY();
        TOOL_UT3.UT.EXPECT(ANYDATA.CONVERTCOLLECTION(v_arr_specialty)).TO_HAVE_COUNT(3);
        TOOL_UT3.UT.EXPECT(v_arr_specialty(1).specialty).TO_EQUAL('Terapevt');
        TOOL_UT3.UT.EXPECT(v_arr_specialty(1).id_specialty_external).TO_EQUAL(1);
        tool_ut3.UT.EXPECT(v_arr_specialty(2).specialty).TO_EQUAL('Lor');
        tool_ut3.UT.EXPECT(v_arr_specialty(2).id_specialty_external).TO_EQUAL(2);
        tool_ut3.UT.EXPECT(v_arr_specialty(3).specialty).TO_EQUAL('Onkolog');
        tool_ut3.UT.EXPECT(v_arr_specialty(3).id_specialty_external).TO_EQUAL(3);

    end;

    procedure is_gender_matched
    as
        v_result number;
        v_result_bool boolean;
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        v_result_bool := kabenyk_st.pkg_specialties.is_gender_matched (
            p_id_patient => -1,
            p_id_specialty => null,
            out_result => v_result);
        TOOL_UT3.UT.EXPECT(v_result).TO_EQUAL(kabenyk_st.pkg_code.c_error);
    end;



    procedure seed_before_all
    as
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        mock_specialty := 'terapevt';
        mock_specialty_min_age := 10;
        mock_specialty_max_age := 18;
        mock_specialty_id_gender := 1;

        insert into kabenyk_st.specialties(
            specialty,
            min_age,
            max_age,
            id_gender
        )
        values (
            mock_specialty,
            mock_specialty_min_age,
            mock_specialty_max_age,
            mock_specialty_id_gender
        )
        returning id_specialty into mock_id_specialty;
    end;


end;

begin
    TOOL_UT3.UT.RUN('KABENYK_ST.TEST_PKG_SPECIALTIES');
end;