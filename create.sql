create sequence kabenyk_st.seq_for_primary_key
    minvalue 1
    maxvalue 99999999999999999999999999999999
    start with 1
    increment by 1;

create table kabenyk_st.regions(
    id_region number default kabenyk_st.seq_for_primary_key.nextval primary key,
    name      varchar2(100) not null
);
create table kabenyk_st.towns(
    id_town number default kabenyk_st.seq_for_primary_key.nextval primary key,
    name varchar2(100) not null,
    id_region number references kabenyk_st.regions (id_region)
);
create table kabenyk_st.organizations(
    id_organization number default kabenyk_st.seq_for_primary_key.nextval primary key,
    name varchar2(100) not null,
    id_town number references kabenyk_st.towns (id_town)
);
create table kabenyk_st.hospital_type(
    id_hospital_type number default kabenyk_st.seq_for_primary_key.nextval primary key,
    type varchar2(20) not null
);
create table kabenyk_st.hospital_availability(
    id_hospital_availability number default kabenyk_st.seq_for_primary_key.nextval primary key,
    availability varchar2(10) not null
);
create table kabenyk_st.hospitals(
    id_hospital number default kabenyk_st.seq_for_primary_key.nextval primary key,
    name varchar2(100) not null,
    id_hospital_availability number references kabenyk_st.hospital_availability (id_hospital_availability),
    id_hospital_type number references kabenyk_st.hospital_type (id_hospital_type),
    id_organization number references kabenyk_st.organizations (id_organization)
);
create table kabenyk_st.working_time(
    id_time number default kabenyk_st.seq_for_primary_key.nextval primary key,
    day varchar2(100) not null,
    begin_time varchar2(5) not null,
    end_time varchar2(5) not null,
    id_hospital number references kabenyk_st.hospitals (id_hospital) ON DELETE CASCADE
);
create table kabenyk_st.doctors(
    id_doctor number default kabenyk_st.seq_for_primary_key.nextval primary key,
    id_hospital number references kabenyk_st.hospitals (id_hospital) ON DELETE CASCADE,
    surname varchar2(100) not null,
    name varchar2(100) not null,
    patronymic varchar2(100) not null,
    area number not null,
    qualifications varchar2(100) not null
);
create table kabenyk_st.sex(
    id_sex number default kabenyk_st.seq_for_primary_key.nextval primary key,
    sex varchar2(100) not null
);
create table kabenyk_st.specializations(
    id_specialization number default kabenyk_st.seq_for_primary_key.nextval primary key,
    specialization varchar2(100) not null,
    min_age number not null,
    max_age number not null,
    id_sex number references kabenyk_st.sex(id_sex)
);
create table kabenyk_st.doctors_specializations(
    id_doctor number,
    id_specialization number,
    primary key (id_doctor, id_specialization),
    foreign key (id_doctor) references kabenyk_st.doctors (id_doctor) ON DELETE CASCADE,
    foreign key (id_specialization) references kabenyk_st.specializations (id_specialization) ON DELETE CASCADE
);
create table kabenyk_st.ticket_flags(
    id_ticket_flag number default kabenyk_st.seq_for_primary_key.nextval primary key,
    flag varchar2(10) not null
);
create table kabenyk_st.tickets(
    id_ticket number default kabenyk_st.seq_for_primary_key.nextval primary key,
    id_ticket_flag number references kabenyk_st.ticket_flags (id_ticket_flag),
    begin_time date not null,
    end_time date not null,
    id_doctor number references kabenyk_st.doctors (id_doctor) ON DELETE CASCADE
);
create table kabenyk_st.accounts(
    id_account number default kabenyk_st.seq_for_primary_key.nextval primary key,
    name varchar2(100) not null
);
create table kabenyk_st.patients(
    id_patient number default kabenyk_st.seq_for_primary_key.nextval primary key,
    surname varchar2(100) not null,
    name varchar2(100) not null,
    patronymic varchar2(100),
    date_of_birth date not null,
    document varchar2(100) not null,
    id_sex number references kabenyk_st.sex (id_sex),
    phone number,
    area number not null,
    id_account number references kabenyk_st.accounts (id_account)
);
create table kabenyk_st.patients_passports(
    id_patient_passport number default kabenyk_st.seq_for_primary_key.nextval primary key,
    series_and_number number (10),
    id_patient references kabenyk_st.patients (id_patient)
);
create table kabenyk_st.patients_snils(
    id_patient_snils number default kabenyk_st.seq_for_primary_key.nextval primary key,
    snils_number number (11),
    id_patient references kabenyk_st.patients (id_patient)
);
create table kabenyk_st.patients_medical_polis(
    id_patients_medical_polis number default kabenyk_st.seq_for_primary_key.nextval primary key,
    polis_number number (16),
    id_patient references kabenyk_st.patients (id_patient)
);
create table kabenyk_st.journal_record_status(
    id_journal_record_status number default kabenyk_st.seq_for_primary_key.nextval primary key,
    status varchar2(100) not null
);
create table kabenyk_st.patients_journals(
    id_journal number default kabenyk_st.seq_for_primary_key.nextval primary key,
    id_journal_record_status number references kabenyk_st.journal_record_status (id_journal_record_status),
    day_time date not null,
    id_patient number references kabenyk_st.patients (id_patient),
    id_ticket number references kabenyk_st.tickets (id_ticket) ON DELETE CASCADE
);