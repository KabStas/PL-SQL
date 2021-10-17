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

insert into kabenyk_st.doctors(id_hospital, surname, name, patronymic, area)
values (1, 'Абрамов', 'Абрам', 'Абрамович', 1);
insert into kabenyk_st.doctors(id_hospital, surname, name, patronymic, area)
values (2, 'Борисов', 'Борис', 'Борисович', 2);
insert into kabenyk_st.doctors(id_hospital, surname, name, patronymic, area)
values (3, 'Вениаминов', 'Вениамин', 'Вениаминович', 3);
insert into kabenyk_st.doctors(id_hospital, surname, name, patronymic, area)
values (4, 'Григорьев', 'Григорий', 'Григорьевич', 4);
insert into kabenyk_st.doctors(id_hospital, surname, name, patronymic, area)
values (5, 'Денисов', 'Денис', 'Денисович', 5);
insert into kabenyk_st.doctors(id_hospital, surname, name, patronymic, area)
values (6, 'Евгеньев', 'Евгений', 'Евгеньевич', 6);
insert into kabenyk_st.doctors(id_hospital, surname, name, patronymic, area)
values (5, 'Жуладзе', 'Жиза', 'Живаевич', 5);
insert into kabenyk_st.doctors(id_hospital, surname, name, patronymic, area)
values (4, 'Задов', 'Зиман', 'Зиманевич', 3);
insert into kabenyk_st.doctors(id_hospital, surname, name, patronymic, area)
values (4, 'Иванов', 'Иван', 'Иванович', 5);


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
values (10,2);
insert into kabenyk_st.doctors_specializations(id_doctor, id_specialization)
values (11,4);
insert into kabenyk_st.doctors_specializations(id_doctor, id_specialization)
values (12,4);

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
insert into kabenyk_st.tickets(id_ticket_flag, begin_time, end_time, id_doctor)
values (1, to_date('2021/11/30 09:30', 'yyyy/mm/dd hh24:mi'), to_date('2021/11/30 09:45', 'yyyy/mm/dd hh24:mi'), 1);

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
                                id_sex, area, id_account)
values ('Макаров', 'Макар', 'Макарович', to_date('1980/02/01', 'yyyy/mm/dd'), 1, 1, 1);
insert into kabenyk_st.patients(surname, name, patronymic, date_of_birth,
                                id_sex, phone, area, id_account)
values ('Некрасова', 'Наталья', 'Николаевна', to_date('1986/08/10', 'yyyy/mm/dd'), 2, 89048795689, 2, 2);
insert into kabenyk_st.patients(surname, name, patronymic, date_of_birth,
                                id_sex, phone, area, id_account)
values ('Орлов', 'Олег', 'Олегович', to_date('1972/01/23', 'yyyy/mm/dd'),
        1, 89010258689, 3, 3);
insert into kabenyk_st.patients(surname, name, patronymic, date_of_birth,
                                id_sex, phone, area, id_account)
values ('Петров', 'Петр', 'Петрович', to_date('1956/02/24', 'yyyy/mm/dd'),
        1, 89072378589, 4, 4);
insert into kabenyk_st.patients(surname, name, patronymic, date_of_birth,
                                id_sex, area, id_account)
values ('Рычков', 'Ринат', 'Ринатович', to_date('1979/10/01', 'yyyy/mm/dd'), 1, 5, 5);
insert into kabenyk_st.patients(surname, name, patronymic, date_of_birth,
                                id_sex, area, id_account)
values ('Степанова', 'Светлана', 'Степановна', to_date('1989/03/07', 'yyyy/mm/dd'), 2, 6, 6);

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

insert into kabenyk_st.documents(document_type, document_number)
values ('polis', '1111222233334444');
insert into kabenyk_st.documents(document_type, document_number)
values ('polis', '2222333344445555');
insert into kabenyk_st.documents(document_type, document_number)
values ('polis', '3333444455556666');
insert into kabenyk_st.documents(document_type, document_number)
values ('polis', '1111222255556666');
insert into kabenyk_st.documents(document_type, document_number)
values ('polis', '1111666633334444');
insert into kabenyk_st.documents(document_type, document_number)
values ('polis', '8888222233334444');

insert into kabenyk_st.PATIENTS_documents(id_patient, id_document)
values (1,1);
insert into kabenyk_st.PATIENTS_documents(id_patient, id_document)
values (2,2);
insert into kabenyk_st.PATIENTS_documents(id_patient, id_document)
values (3,3);
insert into kabenyk_st.PATIENTS_documents(id_patient, id_document)
values (4,4);
insert into kabenyk_st.PATIENTS_documents(id_patient, id_document)
values (5,5);
insert into kabenyk_st.PATIENTS_documents(id_patient, id_document)
values (6,6);

insert into kabenyk_st.doctors_qualifications(id_doctor, education, qualification, salary)
values (1, 'высшее', '1 категория', 60000);
insert into kabenyk_st.doctors_qualifications(id_doctor, education, qualification, salary)
values (2, 'высшее', '2 категория', 50000);
insert into kabenyk_st.doctors_qualifications(id_doctor, education, qualification, salary)
values (3, 'высшее', '3 категория', 40000);
insert into kabenyk_st.doctors_qualifications(id_doctor, education, qualification, salary)
values (4, 'высшее', '1 категория', 60000);
insert into kabenyk_st.doctors_qualifications(id_doctor, education, qualification, salary)
values (5, 'высшее', '2 категория', 50000);
insert into kabenyk_st.doctors_qualifications(id_doctor, education, qualification, salary)
values (6, 'высшее', '3 категория', 40000);
insert into kabenyk_st.doctors_qualifications(id_doctor, education, qualification, salary)
values (10, 'высшее', '1 категория', 60000);
insert into kabenyk_st.doctors_qualifications(id_doctor, education, qualification, salary)
values (11, 'высшее', '2 категория', 50000);
insert into kabenyk_st.doctors_qualifications(id_doctor, education, qualification, salary)
values (12, 'высшее', '3 категория', 40000);

commit;
