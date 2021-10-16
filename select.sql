--1. Выдать все города по регионам
select
    kabenyk_st.towns.name as town,
    kabenyk_st.regions.name as region
from
    kabenyk_st.towns
join kabenyk_st.regions
    on kabenyk_st.towns.id_region = kabenyk_st.regions.id_region;

--2. Выдать все специальности (неудаленные), в которых есть хотя бы один доктор (неудаленный),
--    которые работают в больницах (неудаленных)
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
    and h.DATA_OF_RECORD_DELETION is null;

--3. Выдать все больницы (неудаленные) конкретной специальности с пометками о доступности,
-- кол-ве врачей; отсортировать по типу: частные выше, по кол-ву

select
    s.specialization as specialization,
    h.name as hospital,
    a.availability as availability,
    count(d.id_hospital) as doctors_quantity
from
    kabenyk_st.specializations s
    join kabenyk_st.doctors d
        on s.id_specialization = d.id_doctor
    join kabenyk_st.hospitals h
        on h.id_hospital = d.id_hospital
    join kabenyk_st.hospital_availability a
        on a.id_hospital_availability = h.id_hospital_availability
--where s.specialization = 'репродуктолог'
where s.specialization = 'уролог'
group by s.specialization, h.name, a.availability;

--order by h.id_hospital_type desc;
