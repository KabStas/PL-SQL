insert into kabenyk_st.regions(name)
values ('Кемеровская область');
insert into kabenyk_st.regions(name)
values ('Новосибирская область');
insert into kabenyk_st.regions(name)
values ('Алтайский край');

insert into kabenyk_st.towns(name, id_region)
values ('Кемерово', 1);
insert into kabenyk_st.towns(name, id_region)
values ('Новокузнецк', 1);
insert into kabenyk_st.towns(name, id_region)
values ('Новосибирск', 2);
insert into kabenyk_st.towns(name, id_region)
values ('Бердск', 2);
insert into kabenyk_st.towns(name, id_region)
values ('Барнаул', 3);
insert into kabenyk_st.towns(name, id_region)
values ('Бийск', 3);

insert into kabenyk_st.organizations(name, id_town)
values ('ГБ №1 г.Кемерово', 1);
insert into kabenyk_st.organizations(name, id_town)
values ('Ваш доктор', 2);
insert into kabenyk_st.organizations(name, id_town)
values ('ГБ №3 г.Новосибирск', 3);
insert into kabenyk_st.organizations(name, id_town)
values ('Авиценна', 4);
insert into kabenyk_st.organizations(name, id_town)
values ('ГБ №5 г.Барнаул', 5);
insert into kabenyk_st.organizations(name, id_town)
values ('Доктор Пилюлькин', 6);

insert into kabenyk_st.hospital_type(type)
values ('государственная');
insert into kabenyk_st.hospital_type(type)
values ('частная');

insert into kabenyk_st.hospital_availability(availability)
values ('Да');
insert into kabenyk_st.hospital_availability(availability)
values ('Нет');

insert into kabenyk_st.hospitals(name, id_hospital_availability, id_hospital_type, id_organization)
values ('Поликлиника №1', 1, 1, 1);
insert into kabenyk_st.hospitals(name, id_hospital_availability, id_hospital_type, id_organization)
values ('Ваш доктор №2', 1, 2, 2);
insert into kabenyk_st.hospitals(name, id_hospital_availability, id_hospital_type, id_organization)
values ('Поликлиника №3', 2, 1, 3);
insert into kabenyk_st.hospitals(name, id_hospital_availability, id_hospital_type, id_organization)
values ('Авиценна №4', 1, 2, 4);
insert into kabenyk_st.hospitals(name, id_hospital_availability, id_hospital_type, id_organization)
values ('Поликлиника №5', 1, 1, 5);
insert into kabenyk_st.hospitals(name, id_hospital_availability, id_hospital_type, id_organization)
values ('Доктор Пилюлькин - 6', 1, 2, 6);

insert into kabenyk_st.working_time(day, begin_time, end_time, id_hospital)
values ('Понедельник', '6.00', '00.00', 1);
insert into kabenyk_st.working_time(day, begin_time, end_time, id_hospital)
values ('Вторник', '7.00', '23.00', 2);
insert into kabenyk_st.working_time(day, begin_time, end_time, id_hospital)
values ('Среда', '8.00', '22.00', 3);
insert into kabenyk_st.working_time(day, begin_time, end_time, id_hospital)
values ('Четверг', '9.00', '21.00', 4);
insert into kabenyk_st.working_time(day, begin_time, end_time, id_hospital)
values ('Пятница', '10.00', '20.00', 5);
insert into kabenyk_st.working_time(day, begin_time, end_time, id_hospital)
values ('Суббота', '11.00', '19.00', 6);

insert into kabenyk_st.doctors(id_hospital, surname, name, patronymic, area, qualifications)
values (1, 'Абрамов', 'Абрам', 'Абрамович', 1, 'высшая категория');
insert into kabenyk_st.doctors(id_hospital, surname, name, patronymic, area, qualifications)
values (2, 'Борисов', 'Борис', 'Борисович', 2, 'первая категория');
insert into kabenyk_st.doctors(id_hospital, surname, name, patronymic, area, qualifications)
values (3, 'Вениаминов', 'Вениамин', 'Вениаминович', 3, 'вторая категория');
insert into kabenyk_st.doctors(id_hospital, surname, name, patronymic, area, qualifications)
values (4, 'Григорьев', 'Григорий', 'Григорьевич', 4, 'высшая категория');
insert into kabenyk_st.doctors(id_hospital, surname, name, patronymic, area, qualifications)
values (5, 'Денисов', 'Денис', 'Денисович', 5, 'первая категория');
insert into kabenyk_st.doctors(id_hospital, surname, name, patronymic, area, qualifications)
values (6, 'Евгеньев', 'Евгений', 'Евгеньевич', 6, 'вторая категория');
insert into kabenyk_st.doctors(id_hospital, surname, name, patronymic, area, qualifications)
values (5, 'Жуладзе', 'Жиза', 'Живаевич', 5, 'высшая категория');

insert into kabenyk_st.sex(sex)
values ('м');
insert into kabenyk_st.sex(sex)
values ('ж');
insert into kabenyk_st.sex(sex)
values ('м+ж');

insert into kabenyk_st.specializations(specialization, min_age, max_age, id_sex)
values ('педиатр', 0, 3, 3);
insert into kabenyk_st.specializations(specialization, min_age, max_age, id_sex)
values ('детский хирург', 4, 17, 3);
insert into kabenyk_st.specializations(specialization, min_age, max_age, id_sex)
values ('уролог', 18, 200, 1);
insert into kabenyk_st.specializations(specialization, min_age, max_age, id_sex)
values ('гинеколог', 18, 200, 2);
insert into kabenyk_st.specializations(specialization, min_age, max_age, id_sex)
values ('дерматолог-венеролог', 18, 200, 1);
insert into kabenyk_st.specializations(specialization, min_age, max_age, id_sex)
values ('репродуктолог', 18, 200, 2);

insert into kabenyk_st.doctors_specializations(id_doctor, id_specialization)
values (1,1);
insert into kabenyk_st.doctors_specializations(id_doctor, id_specialization)
values (1,2);
insert into kabenyk_st.doctors_specializations(id_doctor, id_specialization)
values (2,3);
insert into kabenyk_st.doctors_specializations(id_doctor, id_specialization)
values (2,5);
insert into kabenyk_st.doctors_specializations(id_doctor, id_specialization)
values (3,4);
insert into kabenyk_st.doctors_specializations(id_doctor, id_specialization)
values (3,6);
insert into kabenyk_st.doctors_specializations(id_doctor, id_specialization)
values (4,1);
insert into kabenyk_st.doctors_specializations(id_doctor, id_specialization)
values (5,2);
insert into kabenyk_st.doctors_specializations(id_doctor, id_specialization)
values (6,3);
insert into kabenyk_st.doctors_specializations(id_doctor, id_specialization)
values (7,2);

insert into kabenyk_st.ticket_flags(flag)
values ('открыт');
insert into kabenyk_st.ticket_flags(flag)
values ('закрыт');

insert into kabenyk_st.tickets(id_ticket_flag, begin_time, end_time, id_doctor)
values (2, to_date('2021/08/30 08:30', 'yyyy/mm/dd hh24:mi'), to_date('2021/08/30 08:45', 'yyyy/mm/dd hh24:mi'), 1);
insert into kabenyk_st.tickets(id_ticket_flag, begin_time, end_time, id_doctor)
values (2, to_date('2021/08/30 08:30', 'yyyy/mm/dd hh24:mi'), to_date('2021/08/30 08:45', 'yyyy/mm/dd hh24:mi'), 2);
insert into kabenyk_st.tickets(id_ticket_flag, begin_time, end_time, id_doctor)
values (2, to_date('2021/08/30 08:30', 'yyyy/mm/dd hh24:mi'), to_date('2021/08/30 08:45', 'yyyy/mm/dd hh24:mi'), 3);
insert into kabenyk_st.tickets(id_ticket_flag, begin_time, end_time, id_doctor)
values (1, to_date('2021/08/30 09:30', 'yyyy/mm/dd hh24:mi'), to_date('2021/08/30 09:45', 'yyyy/mm/dd hh24:mi'), 4);
insert into kabenyk_st.tickets(id_ticket_flag, begin_time, end_time, id_doctor)
values (1, to_date('2021/08/30 09:30', 'yyyy/mm/dd hh24:mi'), to_date('2021/08/30 09:45', 'yyyy/mm/dd hh24:mi'), 5);
insert into kabenyk_st.tickets(id_ticket_flag, begin_time, end_time, id_doctor)
values (1, to_date('2021/08/30 09:30', 'yyyy/mm/dd hh24:mi'), to_date('2021/08/30 09:45', 'yyyy/mm/dd hh24:mi'), 6);

insert into kabenyk_st.accounts(name)
values ('MMM');
insert into kabenyk_st.accounts(name)
values ('NNN');
insert into kabenyk_st.accounts(name)
values ('OOO');
insert into kabenyk_st.accounts(name)
values ('PPP');
insert into kabenyk_st.accounts(name)
values ('RRR');
insert into kabenyk_st.accounts(name)
values ('SSS');

insert into kabenyk_st.patients(surname, name, patronymic, date_of_birth,
                                medical_polis_number, id_sex, area, id_account)
values ('Макаров', 'Макар', 'Макарович', to_date('1980/02/01', 'yyyy/mm/dd'), '1111222233334444', 1, 1, 1);
insert into kabenyk_st.patients(surname, name, patronymic, date_of_birth,
                                medical_polis_number, passport_series_and_number,
                                snils_number, id_sex, phone, area, id_account)
values ('Некрасова', 'Наталья', 'Николаевна', to_date('1986/08/10', 'yyyy/mm/dd'), '2222333344445555',
        '3208158963', '08105798512', 2, 89048795689, 2, 2);
insert into kabenyk_st.patients(surname, name, patronymic, date_of_birth,
                                medical_polis_number, passport_series_and_number,
                                snils_number, id_sex, phone, area, id_account)
values ('Орлов', 'Олег', 'Олегович', to_date('1972/01/23', 'yyyy/mm/dd'), '3333444455556666',
        '3200145463', '08237798512', 1, 89010258689, 3, 3);
insert into kabenyk_st.patients(surname, name, patronymic, date_of_birth,
                                medical_polis_number, passport_series_and_number,
                                snils_number, id_sex, phone, area, id_account)
values ('Петров', 'Петр', 'Петрович', to_date('1956/02/24', 'yyyy/mm/dd'), '4444555566667777',
        '3202158963', '15837798257', 1, 89072378589, 4, 4);
insert into kabenyk_st.patients(surname, name, patronymic, date_of_birth,
                                medical_polis_number, id_sex, area, id_account)
values ('Рычков', 'Ринат', 'Ринатович', to_date('1979/10/01', 'yyyy/mm/dd'), '1111222255554444', 1, 5, 5);
insert into kabenyk_st.patients(surname, name, patronymic, date_of_birth,
                                medical_polis_number, id_sex, area, id_account)
values ('Степанова', 'Светлана', 'Степановна', to_date('1989/03/07', 'yyyy/mm/dd'), '9999222255554444', 2, 6, 6);

insert into kabenyk_st.journal_record_status(status)
values ('ожидание приема');
insert into kabenyk_st.journal_record_status(status)
values ('прием окончен');

insert into kabenyk_st.patients_journals(id_journal_record_status,
                                         day_time, id_patient, id_ticket)
values (2, to_date('2021/12/30 10:30', 'yyyy/mm/dd hh24:mi'), 1, 1);
insert into kabenyk_st.patients_journals(id_journal_record_status,
                                         day_time, id_patient, id_ticket)
values (1, to_date('2021/12/30 12:30', 'yyyy/mm/dd hh24:mi'), 3, 6);

commit;

--select * from KABENYK_ST.regions;
--select * from KABENYK_ST.towns;
--select * from KABENYK_ST.organizations;
--select * from KABENYK_ST.hospital_type;
--select * from KABENYK_ST.hospital_availability;
--select * from KABENYK_ST.hospitals;
--select * from KABENYK_ST.working_time;
--select * from KABENYK_ST.doctors;
--select * from KABENYK_ST.sex;
--select * from KABENYK_ST.specializations;
--select * from KABENYK_ST.doctors_specializations;
--select * from KABENYK_ST.ticket_flags;
--select * from KABENYK_ST.tickets;
--select * from KABENYK_ST.accounts;
--select * from KABENYK_ST.patients;
--select * from KABENYK_ST.journal_record_status;
--select * from KABENYK_ST.patients_journals;
