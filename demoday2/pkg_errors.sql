create or replace package kabenyk_st.pkg_error
as
    e_patient_recorded_exception exception;
    e_patient_gender_exception exception;
    e_patient_age_exception exception;
    e_patient_oms_exception exception;
    e_ticket_not_open_exception exception;
    e_ticket_time_exception exception;
    e_doctor_deleted_exception exception;
    e_specialty_deleted_exception exception;
    e_hospital_deleted_exception exception;
    e_hospital_work_exception exception;

    pragma exception_init(e_patient_recorded_exception, -20006);
    pragma exception_init(e_patient_gender_exception, -20007);
    pragma exception_init(e_patient_age_exception, -20008);
    pragma exception_init(e_patient_oms_exception, -20009);
    pragma exception_init(e_ticket_not_open_exception, -20010);
    pragma exception_init(e_ticket_time_exception, -20011);
    pragma exception_init(e_doctor_deleted_exception, -20012);
    pragma exception_init(e_specialty_deleted_exception, -20013);
    pragma exception_init(e_hospital_deleted_exception, -20014);
    pragma exception_init(e_hospital_work_exception, -20015);

end;