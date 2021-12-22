create or replace procedure kabenyk_st.job_getting_hospitals_data_action
as

    v_result integer;
    v_response kabenyk_st.t_arr_hospital_external := kabenyk_st.t_arr_hospital_external();

begin

    v_response := kabenyk_st.parsing_hospitals_clob(
        out_result => v_result
    );
    if v_response.count>0 then
    for i in v_response.first..v_response.last
    loop
    declare
        v_item kabenyk_st.t_hospital_external := v_response(i);
    begin
        kabenyk_st.pkg_hospitals.merging_hospital_table(
            p_hospital_external => v_item,
            out_result => v_result
        );
    end;
    end loop;
    end if;

end;

create or replace procedure kabenyk_st.job_getting_specialties_data_action
as

    v_result integer;
    v_response kabenyk_st.t_arr_specialty_external := kabenyk_st.t_arr_specialty_external();

begin
    v_response := kabenyk_st.parsing_specialties_clob(
        out_result => v_result
    );
    if v_response.count>0 then
    for i in v_response.first..v_response.last
    loop
    declare
        v_item kabenyk_st.t_specialty_external := v_response(i);
    begin
        kabenyk_st.pkg_specialties.merging_specialties_table(
            p_specialty_external => v_item,
            out_result => v_result
        );
    end;
    end loop;
    end if;

end;

create or replace procedure kabenyk_st.job_getting_doctors_data_action
as

    v_result integer;
    v_response kabenyk_st.t_arr_doctor_external := kabenyk_st.t_arr_doctor_external();

begin

    v_response := kabenyk_st.parsing_doctors_clob(
        out_result => v_result
    );

    if v_response.count>0 then
    for i in v_response.first..v_response.last
    loop
    declare
        v_item kabenyk_st.t_doctor_external := v_response(i);
    begin
        kabenyk_st.pkg_doctors.merging_doctors_table(
            p_doctor_external => v_item,
            out_result => v_result
        );
    end;
    end loop;
    end if;



end;

begin
    kabenyk_st.job_getting_doctors_data_action;
end;

begin
    kabenyk_st.job_getting_hospitals_data_action;
end;

begin
    kabenyk_st.job_getting_specialties_data_action;
end;

begin
    kabenyk_st.job_getting_hospitals_data_action;
end;

begin
    kabenyk_st.job_getting_doctors_data_action;
end;

begin
    kabenyk_st.job_getting_specialties_data_action();
end;

begin
    kabenyk_st.job_getting_doctors_data_action();
end;



