create or replace type kabenyk_st.t_patient as object(
    id_patient number,
    surname varchar2(100),
    name varchar2(100),
    patronymic varchar2(100),
    date_of_birth date,
    id_gender number,
    phone number,
    area number,
    id_account number
);

create or replace type kabenyk_st.t_arr_patient
    as table of kabenyk_st.t_patient;

create or replace type kabenyk_st.t_patient_documents as object(
    id_document number,
    name varchar2(100)
);
create or replace type kabenyk_st.t_arr_patient_documents
    as table of kabenyk_st.t_patient_documents;

create or replace type kabenyk_st.t_patient_documents_numbers as object(
    id_document_number number,
    id_patient number,
    id_document number,
    value number
);
create or replace type kabenyk_st.t_arr_patient_documents_numbers
    as table of kabenyk_st.t_patient_documents_numbers;

create or replace type kabenyk_st.t_extended_patient as object(
    patient kabenyk_st.t_patient,
    patient_documents kabenyk_st.t_arr_patient_documents,
    patient_documents_numbers kabenyk_st.t_arr_patient_documents_numbers
);
create or replace type kabenyk_st.t_arr_extended_patient
    as table of kabenyk_st.t_extended_patient;

alter type kabenyk_st.t_patient
add constructor function t_patient(
    id_patient number,
    surname varchar2,
    name varchar2,
    patronymic varchar2,
    date_of_birth date,
    id_gender number,
    phone number default null,
    area number,
    id_account number
) return self as result
cascade;

create or replace type body kabenyk_st.t_patient
as
    constructor function t_patient(
        id_patient number,
        surname varchar2,
        name varchar2,
        patronymic varchar2,
        date_of_birth date,
        id_gender number,
        phone number default null,
        area number,
        id_account number
    )
    return self as result
    as
    begin
        self.id_patient := id_patient;
        self.surname := surname;
        self.name := name;
        self.patronymic := patronymic;
        self.date_of_birth := date_of_birth;
        self.id_gender := id_gender;
        self.phone := phone;
        self.area := area;
        self.id_account := id_account;
        return;
    end;
end;