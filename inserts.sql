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

insert into kabenyk_st.doctors_qualifications(education, qualification, salary)
values ('высшее', '1 категория', 60000);
insert into kabenyk_st.doctors_qualifications(education, qualification, salary)
values ('высшее', '2 категория', 50000);
insert into kabenyk_st.doctors_qualifications(education, qualification, salary)
values ('высшее', '3 категория', 40000);
insert into kabenyk_st.doctors_qualifications(education, qualification, salary)
values ('высшее', '1 категория', 60000);
insert into kabenyk_st.doctors_qualifications(education, qualification, salary)
values ('высшее', '2 категория', 50000);
insert into kabenyk_st.doctors_qualifications(education, qualification, salary)
values ('высшее', '3 категория', 40000);
insert into kabenyk_st.doctors_qualifications(education, qualification, salary)
values ('высшее', '1 категория', 60000);
insert into kabenyk_st.doctors_qualifications(education, qualification, salary)
values ('высшее', '2 категория', 50000);
insert into kabenyk_st.doctors_qualifications(education, qualification, salary)
values ('высшее', '3 категория', 40000);

insert into kabenyk_st.doctors(id_hospital, surname, name, patronymic, area, id_doctors_qualifications)
values (1, 'Абрамов', 'Абрам', 'Абрамович', 1, 2);
insert into kabenyk_st.doctors(id_hospital, surname, name, patronymic, area, id_doctors_qualifications)
values (2, 'Борисов', 'Борис', 'Борисович', 2, 3);
insert into kabenyk_st.doctors(id_hospital, surname, name, patronymic, area, id_doctors_qualifications)
values (3, 'Вениаминов', 'Вениамин', 'Вениаминович', 3, 4);
insert into kabenyk_st.doctors(id_hospital, surname, name, patronymic, area, id_doctors_qualifications)
values (4, 'Григорьев', 'Григорий', 'Григорьевич', 4, 5);
insert into kabenyk_st.doctors(id_hospital, surname, name, patronymic, area, id_doctors_qualifications)
values (5, 'Денисов', 'Денис', 'Денисович', 5, 6);
insert into kabenyk_st.doctors(id_hospital, surname, name, patronymic, area, id_doctors_qualifications)
values (6, 'Евгеньев', 'Евгений', 'Евгеньевич', 6, 7);
insert into kabenyk_st.doctors(id_hospital, surname, name, patronymic, area, id_doctors_qualifications)
values (5, 'Жуладзе', 'Жиза', 'Живаевич', 5, 8);
insert into kabenyk_st.doctors(id_hospital, surname, name, patronymic, area, id_doctors_qualifications)
values (4, 'Задов', 'Зиман', 'Зиманевич', 3, 9);
insert into kabenyk_st.doctors(id_hospital, surname, name, patronymic, area, id_doctors_qualifications)
values (4, 'Иванов', 'Иван', 'Иванович', 5, 10);

insert into kabenyk_st.gender(gender)
values ('м');
insert into kabenyk_st.gender(gender)
values ('ж');

insert into kabenyk_st.specializations(specialization, min_age, max_age)
values ('педиатр', 0, 3);
insert into kabenyk_st.specializations(specialization, min_age, max_age)
values ('детский хирург', 4, 17);
insert into kabenyk_st.specializations(specialization, min_age, max_age, ID_GENDER)
values ('уролог', 18, 200, 1);
insert into kabenyk_st.specializations(specialization, min_age, max_age, ID_GENDER)
values ('гинеколог', 18, 200, 2);
insert into kabenyk_st.specializations(specialization, min_age, max_age, ID_GENDER)
values ('дерматолог-венеролог', 18, 200, 1);
insert into kabenyk_st.specializations(specialization, min_age, max_age, ID_GENDER)
values ('репродуктолог', 18, 200, 2);

insert into kabenyk_st.doctors_specializations(id_doctor, id_specialization)
values (2, 1);
insert into kabenyk_st.doctors_specializations(id_doctor, id_specialization)
values (2, 2);
insert into kabenyk_st.doctors_specializations(id_doctor, id_specialization)
values (3, 3);
insert into kabenyk_st.doctors_specializations(id_doctor, id_specialization)
values (3, 5);
insert into kabenyk_st.doctors_specializations(id_doctor, id_specialization)
values (4, 4);
insert into kabenyk_st.doctors_specializations(id_doctor, id_specialization)
values (4, 6);
insert into kabenyk_st.doctors_specializations(id_doctor, id_specialization)
values (5, 1);
insert into kabenyk_st.doctors_specializations(id_doctor, id_specialization)
values (6, 2);
insert into kabenyk_st.doctors_specializations(id_doctor, id_specialization)
values (7, 3);
insert into kabenyk_st.doctors_specializations(id_doctor, id_specialization)
values (8, 2);
insert into kabenyk_st.doctors_specializations(id_doctor, id_specialization)
values (9, 4);
insert into kabenyk_st.doctors_specializations(id_doctor, id_specialization)
values (10, 4);

insert into kabenyk_st.ticket_flags(flag)
values ('открыт');
insert into kabenyk_st.ticket_flags(flag)
values ('закрыт');

insert into kabenyk_st.tickets(id_ticket_flag, begin_time, end_time, id_doctor)
values (2, to_date('2021/08/30 08:30', 'yyyy/mm/dd hh24:mi'), to_date('2021/08/30 08:45', 'yyyy/mm/dd hh24:mi'), 2);
insert into kabenyk_st.tickets(id_ticket_flag, begin_time, end_time, id_doctor)
values (2, to_date('2021/08/30 08:30', 'yyyy/mm/dd hh24:mi'), to_date('2021/08/30 08:45', 'yyyy/mm/dd hh24:mi'), 3);
insert into kabenyk_st.tickets(id_ticket_flag, begin_time, end_time, id_doctor)
values (2, to_date('2021/08/30 08:30', 'yyyy/mm/dd hh24:mi'), to_date('2021/08/30 08:45', 'yyyy/mm/dd hh24:mi'), 4);
insert into kabenyk_st.tickets(id_ticket_flag, begin_time, end_time, id_doctor)
values (1, to_date('2021/08/30 09:30', 'yyyy/mm/dd hh24:mi'), to_date('2021/08/30 09:45', 'yyyy/mm/dd hh24:mi'), 5);
insert into kabenyk_st.tickets(id_ticket_flag, begin_time, end_time, id_doctor)
values (1, to_date('2021/08/30 09:30', 'yyyy/mm/dd hh24:mi'), to_date('2021/08/30 09:45', 'yyyy/mm/dd hh24:mi'), 6);
insert into kabenyk_st.tickets(id_ticket_flag, begin_time, end_time, id_doctor)
values (1, to_date('2021/08/30 09:30', 'yyyy/mm/dd hh24:mi'), to_date('2021/08/30 09:45', 'yyyy/mm/dd hh24:mi'), 7);
insert into kabenyk_st.tickets(id_ticket_flag, begin_time, end_time, id_doctor)
values (1, to_date('2021/11/30 09:30', 'yyyy/mm/dd hh24:mi'), to_date('2021/11/30 09:45', 'yyyy/mm/dd hh24:mi'), 8);

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
                                id_gender, area, id_account)
values ('Макаров', 'Макар', 'Макарович', to_date('1980/02/01', 'yyyy/mm/dd'), 1, 1, 1);
insert into kabenyk_st.patients(surname, name, patronymic, date_of_birth,
                                id_gender, phone, area, id_account)
values ('Некрасова', 'Наталья', 'Николаевна', to_date('1986/08/10', 'yyyy/mm/dd'), 2, 89048795689, 2, 2);
insert into kabenyk_st.patients(surname, name, patronymic, date_of_birth,
                                id_gender, phone, area, id_account)
values ('Орлов', 'Олег', 'Олегович', to_date('1972/01/23', 'yyyy/mm/dd'),
        1, 89010258689, 3, 3);
insert into kabenyk_st.patients(surname, name, patronymic, date_of_birth,
                                id_gender, phone, area, id_account)
values ('Петров', 'Петр', 'Петрович', to_date('1956/02/24', 'yyyy/mm/dd'),
        1, 89072378589, 4, 4);
insert into kabenyk_st.patients(surname, name, patronymic, date_of_birth,
                                id_gender, area, id_account)
values ('Рычков', 'Ринат', 'Ринатович', to_date('1979/10/01', 'yyyy/mm/dd'), 1, 5, 5);
insert into kabenyk_st.patients(surname, name, patronymic, date_of_birth,
                                id_gender, area, id_account)
values ('Степанова', 'Светлана', 'Степановна', to_date('1989/03/07', 'yyyy/mm/dd'), 2, 6, 6);

insert into kabenyk_st.journal_record_status(status)
values ('ожидание приема');
insert into kabenyk_st.journal_record_status(status)
values ('прием окончен');

insert into kabenyk_st.patients_journals(id_journal_record_status,
                                         day_time, id_patient, id_ticket)
values (2, to_date('2021/12/30 10:30', 'yyyy/mm/dd hh24:mi'), 1, 2);
insert into kabenyk_st.patients_journals(id_journal_record_status,
                                         day_time, id_patient, id_ticket)
values (1, to_date('2021/12/30 12:30', 'yyyy/mm/dd hh24:mi'), 3, 7);

insert into kabenyk_st.documents(name)
values ('polis');
insert into kabenyk_st.documents(name)
values ('passport');
insert into kabenyk_st.documents(name)
values ('snils');

insert into kabenyk_st.documents_numbers(id_patient, id_document, value)
values (1, 4, 1111222233334444);
insert into kabenyk_st.documents_numbers(id_patient, id_document, value)
values (2, 4, 2222333344445555);
insert into kabenyk_st.documents_numbers(id_patient, id_document, value)
values (3, 4, 2222333344446666);
insert into kabenyk_st.documents_numbers(id_patient, id_document, value)
values (4, 4, 1111222233335555);
insert into kabenyk_st.documents_numbers(id_patient, id_document, value)
values (5, 4, 3333222233334444);
insert into kabenyk_st.documents_numbers(id_patient, id_document, value)
values (6, 4, 7777222233334444);

commit;
