create or replace package kabenyk_st.test_pkg_patient
as

    --%suite

    --%beforeall
    procedure seed_before_all;

    --%test(проверка получения по id)
    procedure get_patient_by_id;

    --%test(ошибка получения по id)
    --%throws(no_data_found)
    procedure failed_get_patient_by_id;

    --%test(тест на foreign_key id_account)
    --%throws(-01400)
    procedure check_patient_id_account_constraint;

    --%test(тест на date_of_birth is not null)
    --%throws(-01400)
    procedure check_patient_date_of_birth_constraint;

    --%test(тест на корректность запаковки данных)
    procedure check_serialising;

    --%test(ошибка параметра)
    --%throws(no_data_found)
    procedure failed_is_patient_has_oms;

end;
/

create or replace package body kabenyk_st.test_pkg_patient
as
    is_debug boolean := true;

    mock_id_patient number;
    mock_patient_surname varchar2(100);
    mock_patient_name varchar2(100);
    mock_patient_date_of_birth date;
    mock_patient_area number;
    mock_patient_id_gender number;
    mock_patient_id_account number;

    procedure get_patient_by_id
    as
        v_patient kabenyk_st.t_patient;
        v_result number;
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        v_patient := kabenyk_st.pkg_patients.get_patient_by_id (
            p_id_patient =>mock_id_patient,
            out_result => v_result
        );

        TOOL_UT3.UT.EXPECT(v_patient.id_patient).TO_EQUAL(mock_id_patient);
        TOOL_UT3.UT.EXPECT(v_patient.surname).TO_EQUAL(mock_patient_surname);
        TOOL_UT3.UT.EXPECT(v_patient.name).TO_EQUAL(mock_patient_name);
        TOOL_UT3.UT.EXPECT(v_patient.patronymic).TO_BE_NULL;
        TOOL_UT3.UT.EXPECT(v_patient.date_of_birth).TO_EQUAL(mock_patient_date_of_birth);
        TOOL_UT3.UT.EXPECT(v_patient.area).TO_EQUAL(mock_patient_area);
        TOOL_UT3.UT.EXPECT(v_patient.id_gender).TO_EQUAL(mock_patient_id_gender);
        TOOL_UT3.UT.EXPECT(v_patient.phone).TO_BE_NULL;
        TOOL_UT3.UT.EXPECT(v_patient.id_account).TO_EQUAL(mock_patient_id_account);


    end;

    procedure failed_get_patient_by_id
    as
        v_patient kabenyk_st.t_patient;
        v_result number;
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        v_patient := kabenyk_st.pkg_patients.get_patient_by_id (
            p_id_patient => -1,
            out_result => v_result);
    end;


    procedure check_patient_id_account_constraint
    as
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        insert into kabenyk_st.patients(
            surname,
            name,
            date_of_birth,
            area,
            id_gender,
            id_account
        )
        values (
            mock_patient_surname,
            mock_patient_name,
            mock_patient_date_of_birth,
            mock_patient_area,
            mock_patient_id_gender,
            null
        );
    end;

    procedure check_patient_date_of_birth_constraint
    as
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        insert into kabenyk_st.patients(
            surname,
            name,
            date_of_birth,
            area,
            id_gender,
            id_account
        )
        values (
            mock_patient_surname,
            mock_patient_name,
            null,
            mock_patient_area,
            mock_patient_id_gender,
            mock_patient_id_account
        );
    end;

    procedure check_serialising
    as

        v_return_clob clob;
        v_id_patient number := 3;

    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        v_return_clob := kabenyk_st.json_get_patient_by_id (
            p_id_patient => v_id_patient
        );

        TOOL_UT3.UT.EXPECT(v_return_clob).TO_BE_LIKE(
            '{"code":1,"response":[{"id_patient":3,"surname":"Orlov","name":"Oleg","patronymic":"Olegovich","date_of_birth":"1972-01-23T00:00:00","id_gender":1,"phone":null,"area":3,"id_account":3}]}'
        );

    end;

    procedure failed_is_patient_has_oms
    as
        v_result number;
        v_result_bool boolean;
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        v_result_bool := kabenyk_st.pkg_patients.is_patient_has_oms (
            p_id_patient => -1,
            out_result => v_result);
    end;



    procedure seed_before_all
    as
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        mock_patient_surname := 'surname';
        mock_patient_name := 'name';
        mock_patient_date_of_birth := add_months(sysdate, -(12*25));
        mock_patient_area := 1;
        mock_patient_id_gender := 1;
        mock_patient_id_account := 1;

        insert into kabenyk_st.patients(
            surname,
            name,
            date_of_birth,
            area,
            id_gender,
            id_account
        )
        values (
            mock_patient_surname,
            mock_patient_name,
            mock_patient_date_of_birth,
            mock_patient_area,
            mock_patient_id_gender,
            mock_patient_id_account
        )
        returning id_patient into mock_id_patient;
    end;


end;

begin
    TOOL_UT3.UT.RUN('KABENYK_ST.TEST_PKG_PATIENT');
end;