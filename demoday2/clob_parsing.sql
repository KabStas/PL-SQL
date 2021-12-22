
create or replace function kabenyk_st.parsing_doctors_clob(
    out_result out number
)
return kabenyk_st.t_arr_doctor_external
as

    v_result integer;
    v_clob clob;
    v_response kabenyk_st.t_arr_doctor_external := kabenyk_st.t_arr_doctor_external();

begin

    v_clob := kabenyk_st.pkg_hospitals.clob_from_http(
        p_table => 'doctors',
        out_result => v_result
    );

    select kabenyk_st.t_doctor_external(
        id_doctor_external => r.id_doctor_external,
        id_hospital_external => r.id_hospital_external,
        surname => r.surname,
        name => r.name,
        patronymic => r.patronymic,
        id_specialty_external => r.id_specialty_external
    )
    bulk collect into v_response
    from json_table(v_clob, '$' columns(
        nested path '$[*]' columns(
            id_doctor_external number path '$.id_doctor',
            id_hospital_external number path '$.id_hospital',
            surname varchar2 path '$.lname',
            name varchar2 path '$.fname',
            patronymic varchar2 path '$.mname',
            id_specialty_external number path '$.id_specialty'
    ))) r;

    out_result := v_result;

    return v_response;

end;
/

create or replace function kabenyk_st.parsing_hospitals_clob(
    out_result out number
)
return kabenyk_st.t_arr_hospital_external
as

    v_result integer;
    v_clob clob;
    v_response kabenyk_st.t_arr_hospital_external := kabenyk_st.t_arr_hospital_external();

begin

    v_clob := kabenyk_st.pkg_hospitals.clob_from_http(
        p_table => 'hospitals',
        out_result => v_result
    );

    select kabenyk_st.t_hospital_external(
        id_hospital_external => r.id_hospital_external,
        name => r.name,
        address => r.address,
        id_town_external => r.id_town_external
    )
    bulk collect into v_response
    from json_table(v_clob, '$' columns(
        nested path '$[*]' columns(
            id_hospital_external number path '$.id_hospital',
            name varchar2 path '$.name',
            address varchar2 path '$.address',
            id_town_external number path '$.id_town'
    ))) r;

    out_result := v_result;

    return v_response;

end;

create or replace function kabenyk_st.parsing_specialties_clob(
    out_result out number
)
return kabenyk_st.t_arr_specialty_external
as

    v_result integer;
    v_clob clob;
    v_response kabenyk_st.t_arr_specialty_external := kabenyk_st.t_arr_specialty_external();

begin

    v_clob := kabenyk_st.pkg_hospitals.clob_from_http(
        p_table => 'specialties',
        out_result => v_result
    );

    select kabenyk_st.t_specialty_external(
        id_specialty_external => r.id_specialty_external,
        specialty => r.specialty,
        id_hospital_external => r.id_specialty_external
    )
    bulk collect into v_response
    from json_table(v_clob, '$' columns(
        nested path '$[*]' columns(
            id_specialty_external number path '$.id_specialty',
            specialty varchar2 path '$.name',
            id_hospital_external number path '$.id_hospital'
    ))) r;

    out_result := v_result;

    return v_response;

end;
