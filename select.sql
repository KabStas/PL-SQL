--1. Выдать все города по регионам
select
    kabenyk_st.towns.name as town,
    kabenyk_st.regions.name as region
from
    kabenyk_st.towns
join kabenyk_st.regions
    on kabenyk_st.towns.id_region = kabenyk_st.regions.id_region;

--2 Выдать все специальности (неудаленные), в которых есть хотя бы один доктор (неудаленный),
-- которые работают в больницах (неудаленных)
select
    s.specialization as specialization,
    d.surname as doctor,
    h.name as hospital
from
    kabenyk_st.specializations s
    join kabenyk_st.doctors d
        on s.id_specialization = d.id_doctor
    join kabenyk_st.hospitals h
        on h.id_hospital = d.id_hospital
where s.data_of_record_deletion is null
    and d.data_of_record_deletion is null
    and h.data_of_record_deletion is null;

--3. Выдать все больницы (неудаленные) конкретной специальности с пометками о
-- доступности, кол-ве врачей; отсортировать по типу: частные выше, по кол-ву
-- докторов: где больше выше, по времени работы: которые еще работают выше
select
    s.specialization as specialization,
    h.name as hospital,
    t.type as hospital_type,
    a.availability as availability,
    count(d.id_hospital) as doctors_quantity,
    case
        when to_char(sysdate, 'hh24:mi') < w.end_time
        then 'Yes'
        else 'No'
    end as is_working
from
    kabenyk_st.doctors_specializations ds
    join kabenyk_st.doctors d
        on d.id_doctor = ds.id_doctor
    join kabenyk_st.specializations s
        on s.id_specialization = ds.id_specialization
    join kabenyk_st.hospitals h
        on h.id_hospital = d.id_hospital
    join kabenyk_st.hospital_availability a
        on a.id_hospital_availability = h.id_hospital_availability
    join kabenyk_st.hospital_type t
        on t.id_hospital_type = h.id_hospital_type
    join kabenyk_st.working_time w
        on w.id_hospital = h.id_hospital
where s.specialization = 'гинеколог'
    and h.data_of_record_deletion is null
group by s.specialization, h.name, a.availability, t.type, w.end_time
order by t.type desc, doctors_quantity desc, is_working;

--4. Выдать всех врачей (неудаленных) конкретной больницы, отсортировать по квалификации:
-- у кого есть выше, по участку: если участок совпадает с участком пациента, то такие выше
select
    h.name as hospital,
    d.surname as doctor,
    q.qualification as qualification,
    d.area as area
from
    kabenyk_st.doctors d
    join kabenyk_st.hospitals h
        on d.id_hospital = h.id_hospital
    join kabenyk_st.doctors_qualifications q
        on d.id_doctor = q.id_doctor
where h.name = 'Авиценна №4'
    and d.data_of_record_deletion is null
order by qualification, area;

--5. Выдать все талоны конкретного врача, не показывать талоны, которые начались
-- раньше текущего времени
select
    d.surname as doctor,
    t.begin_time
from
    kabenyk_st.doctors d
    join kabenyk_st.tickets t
        on d.id_doctor = t.id_doctor
where d.surname = 'Абрамов'
    and t.begin_time > sysdate;

--6. Создать метод записи с проверками пациента на соответствие всем пунктам для записи








