create or replace type kabenyk_st.t_doctor as object(
    id_doctor number,
    id_hospital number,
    surname varchar2(100),
    name varchar2(100),
    patronymic varchar2(100),
    area number,
    id_doctors_qualifications number
);

create or replace type kabenyk_st.t_arr_doctor
    as table of kabenyk_st.t_doctor;

create or replace type kabenyk_st.t_doctor_info as object(
    id_doctors_qualifications number,
    education varchar2(100),
    qualification varchar2(100),
    salary number,
    rating number
);

create or replace type kabenyk_st.t_arr_doctor_info
    as table of kabenyk_st.t_doctor_info;

create or replace type kabenyk_st.t_extended_doctor as object(
    doctor kabenyk_st.t_doctor,
    doctor_info kabenyk_st.t_arr_doctor_info
);

create or replace type kabenyk_st.t_arr_extended_doctor
    as table of kabenyk_st.t_extended_doctor;

alter type kabenyk_st.t_doctor
add constructor function t_doctor(
    id_doctor number,
    id_hospital number,
    surname  varchar2 default null,
    name varchar2 default null,
    patronymic varchar2 default null,
    area number,
    id_doctors_qualifications number
) return self as result
cascade;

create or replace type body kabenyk_st.t_doctor
as
    constructor function t_doctor(
        id_doctor number,
        id_hospital number,
        surname  varchar2 default null,
        name varchar2 default null,
        patronymic varchar2 default null,
        area number,
        id_doctors_qualifications number
    )
    return self as result
    as
    begin
        self.id_doctor := id_doctor;
        self.id_hospital := id_hospital;
        self.surname := surname;
        self.name := name;
        self.patronymic := patronymic;
        self.area := area;
        self.id_doctors_qualifications := id_doctors_qualifications;
        return;
    end;
end;
