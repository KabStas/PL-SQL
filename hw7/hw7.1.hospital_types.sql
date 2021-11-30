create or replace type kabenyk_st.t_hospital as object(
    id_hospital number,
    name varchar2(100),
    id_hospital_availability number,
    id_hospital_type number,
    id_organization number
);

create or replace type kabenyk_st.t_arr_hospital
    as table of kabenyk_st.t_hospital;

create or replace type kabenyk_st.t_hospital_time as object(
    id_time number,
    day varchar2(100),
    begin_time varchar2(5),
    end_time varchar2(5),
    id_hospital number
);
create or replace type kabenyk_st.t_arr_hospital_time
    as table of kabenyk_st.t_hospital_time;

create or replace type kabenyk_st.t_extended_hospital as object(
    hospital kabenyk_st.t_hospital,
    hospital_time kabenyk_st.t_arr_hospital_time
);
create or replace type kabenyk_st.t_arr_extended_hospital
    as table of kabenyk_st.t_extended_hospital;