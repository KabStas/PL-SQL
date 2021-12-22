create or replace package kabenyk_st.test_pkg_doctor
as

    --%suite

    --%beforeall
    procedure seed_before_all;

    --%test(проверка получения по id)
    procedure get_doctor_by_id;

    --%test(ошибка получения по id)
    procedure failed_get_doctor_by_id;

    --%test(тест на foreign_key id_hospital
    --%throws(-01400)
    procedure check_doctor_id_hospital_constraint;

    --%test(тест на surname is not null)
    --%throws(-01400)
    procedure check_doctor_surname_constraint;

    --%test(тест на корректность запаковки данных)
    procedure check_serialising;

    --%test(ошибка параметра)
    procedure failed_get_doctor_by_id_doctor_speciality;

end;

create or replace package body kabenyk_st.test_pkg_doctor
as
    is_debug boolean := true;

    mock_id_doctor number;
    mock_id_hospital number;
    mock_doctor_surname varchar2(100);
    mock_doctor_name varchar2(100);
    mock_doctor_patronymic varchar2(100);

    procedure get_doctor_by_id
    as
        v_doctor kabenyk_st.t_doctor;
        v_result number;
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        v_doctor := kabenyk_st.pkg_doctors.get_doctor_by_id (
            p_id_doctor => mock_id_doctor,
            out_result => v_result
        );

        TOOL_UT3.UT.EXPECT(v_doctor.id_doctor).TO_EQUAL(mock_id_doctor);
        TOOL_UT3.UT.EXPECT(v_doctor.id_hospital).TO_EQUAL(mock_id_hospital);
        TOOL_UT3.UT.EXPECT(v_doctor.surname).TO_EQUAL(mock_doctor_surname);
        TOOL_UT3.UT.EXPECT(v_doctor.name).TO_EQUAL(mock_doctor_name);
        TOOL_UT3.UT.EXPECT(v_doctor.patronymic).TO_EQUAL(mock_doctor_patronymic);
        TOOL_UT3.UT.EXPECT(v_doctor.area).TO_BE_NULL();

    end;

    procedure failed_get_doctor_by_id
    as
        v_doctor kabenyk_st.t_doctor;
        v_result number;
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        v_doctor := kabenyk_st.pkg_doctors.get_doctor_by_id (
            p_id_doctor => -1,
            out_result => v_result);
        TOOL_UT3.UT.EXPECT(v_result).TO_EQUAL(kabenyk_st.pkg_code.c_error);
    end;


    procedure check_doctor_id_hospital_constraint
    as
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        insert into kabenyk_st.doctors(
            id_hospital,
            surname,
            name,
            patronymic
        )
        values (
            null,
            mock_doctor_surname,
            mock_doctor_name,
            mock_doctor_patronymic
        );
    end;

    procedure check_doctor_surname_constraint
    as
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        insert into kabenyk_st.doctors(
            id_hospital,
            surname,
            name,
            patronymic
        )
        values (
            mock_id_hospital,
            null,
            mock_doctor_name,
            mock_doctor_patronymic
        );
    end;

procedure check_serialising
    as

        v_return_clob clob;
        v_id_hospital number := 2;

    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        v_return_clob := kabenyk_st.json_all_doctors_by_hospital (
            p_id_hospital => v_id_hospital,
            p_area => null
        );

        TOOL_UT3.UT.EXPECT(v_return_clob).TO_EQUAL(
            to_clob(
                '{"code":1,"response":[{"id_doctor":3,"id_hospital":2,"surname":"Borisov","name":"Boris","patronymic":"Borisovich","area":2,"id_doctors_qualifications":3}]}'
            )
        );

    end;

    procedure failed_get_doctor_by_id_doctor_speciality
    as
        v_result number;
        v_doctor kabenyk_st.t_doctor;
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        v_doctor := kabenyk_st.pkg_doctors.get_doctor_by_id_doctor_speciality (
            p_id_doctor_speciality => -1,
            out_result => v_result);

        TOOL_UT3.UT.EXPECT(v_result).TO_EQUAL(kabenyk_st.pkg_code.c_error);

    end;

    procedure seed_before_all
    as
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        mock_id_hospital := 1;
        mock_doctor_surname := 'surname';
        mock_doctor_name := 'name';
        mock_doctor_patronymic := 'patronymic';

        insert into kabenyk_st.doctors(
            id_hospital,
            surname,
            name,
            patronymic
        )
        values (
            mock_id_hospital,
            mock_doctor_surname,
            mock_doctor_name,
            mock_doctor_patronymic
        )

        returning id_doctor into mock_id_doctor;

    end;
end;


begin
    TOOL_UT3.UT.RUN('KABENYK_ST.TEST_PKG_DOCTOR');
end;