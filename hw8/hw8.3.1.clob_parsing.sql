
create or replace function kabenyk_st.parsing_doctors_clob(
    out_result out number
)
return kabenyk_st.t_arr_doctor
as

    v_result integer;
    v_clob clob;
    v_response kabenyk_st.t_arr_doctor := kabenyk_st.t_arr_doctor();

begin

    v_clob := kabenyk_st.pkg_hospitals.clob_from_http(
        p_table => 'doctors',
        out_result => v_result
    );

    select kabenyk_st.t_doctor(
        id_doctor => null,
        id_hospital => null,
        surname => r.surname,
        name => r.name,
        patronymic => r.patronymic,
        area => null,
        id_doctors_qualifications => null,
        external_id_doctor => r.external_id_doctor,
        external_id_hospital => r.external_id_hospital,
        external_id_specialty => r.external_id_specialty
    )
    bulk collect into v_response
    from json_table(v_clob, '$' columns(
        nested path '$[*]' columns(
            surname varchar2 path '$.lname',
            name varchar2 path '$.fname',
            patronymic varchar2 path '$.mname',
            external_id_doctor number path '$.id_doctor',
            external_id_hospital number path '$.id_hospital',
            external_id_specialty number path '$.id_specialty'
    ))) r;

    out_result := v_result;

    return v_response;

end;
/

create or replace function kabenyk_st.parsing_hospitals_clob(
    out_result out number
)
return kabenyk_st.t_arr_hospital
as

    v_result integer;
    v_clob clob;
    v_response kabenyk_st.t_arr_hospital := kabenyk_st.t_arr_hospital();

begin

    v_clob := kabenyk_st.pkg_hospitals.clob_from_http(
        p_table => 'hospitals',
        out_result => v_result
    );

    select kabenyk_st.t_hospital(
        id_hospital => null,
        name => r.name,
        id_hospital_availability => null,
        id_hospital_type => null,
        id_organization => null,
        address => r.address,
        external_id_hospital => r.external_id_hospital,
        external_id_town => r.external_id_town
    )
    bulk collect into v_response
    from json_table(v_clob, '$' columns(
        nested path '$[*]' columns(
            name varchar2 path '$.name',
            address varchar2 path '$.address',
            external_id_hospital number path '$.id_hospital',
            external_id_town number path '$.id_town'
    ))) r;

    out_result := v_result;

    return v_response;

end;

create or replace function kabenyk_st.parsing_specialties_clob(
    out_result out number
)
return kabenyk_st.t_arr_specialty
as

    v_result integer;
    v_clob clob;
    v_response kabenyk_st.t_arr_specialty := kabenyk_st.t_arr_specialty();

begin

    v_clob := kabenyk_st.pkg_hospitals.clob_from_http(
        p_table => 'specialties',
        out_result => v_result
    );

    select kabenyk_st.t_specialty(
        id_specialty => null,
        specialty => r.specialty,
        min_age => null,
        max_age => null,
        id_gender => null,
        external_id_specialty => r.external_id_specialty,
        external_id_hospital => r.external_id_hospital
    )
    bulk collect into v_response
    from json_table(v_clob, '$' columns(
        nested path '$[*]' columns(
            specialty varchar2 path '$.name',
            external_id_specialty number path '$.id_specialty',
            external_id_hospital number path '$.id_hospital'
    ))) r;

    out_result := v_result;

    return v_response;

end;
