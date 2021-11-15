-- 1. Выдать все города по регионам
create or replace function
    kabenyk_st.get_all_towns_by_regions_as_func (
        p_id_region in number
    )
return sys_refcursor
as
    v_all_towns_by_regions_cursor sys_refcursor;
begin
    open v_all_towns_by_regions_cursor for
        select t.name,r.name
        from kabenyk_st.towns t
            join kabenyk_st.regions r
                on t.id_region = r.id_region
        where p_id_region is null or
              (p_id_region is not null and
              r.id_region = p_id_region);
    return v_all_towns_by_regions_cursor;
end;

declare
    v_all_towns_by_regions_cursor sys_refcursor;
    type record_1 is record (
        town varchar2(100),
        region varchar2(100)
    );
    v_record_1 record_1;
    v_id_region number := 3;
begin
    v_all_towns_by_regions_cursor := kabenyk_st.get_all_towns_by_regions_as_func(
        p_id_region => v_id_region
    );
    loop
        fetch v_all_towns_by_regions_cursor into v_record_1;
        exit when v_all_towns_by_regions_cursor%notfound;
        dbms_output.put_line (v_record_1.town|| ' - ' || v_record_1.region);
    end loop;
    close v_all_towns_by_regions_cursor;
end;

-- 2. Выдать все специальности (неудаленные), в которых есть хотя бы один доктор (неудаленный),
-- которые работают в больницах (неудаленных)
declare
    v_record kabenyk_st.pkg_specialties.t_record_1;
    v_id_hospital number;
begin
    v_record := kabenyk_st.pkg_specialties.all_specializations_as_func (
        p_id_hospital => v_id_hospital
    );
end;

-- 3. Выдать все больницы (неудаленные) конкретной специальности с пометками о
-- доступности, кол-ве врачей; отсортировать по типу: частные выше, по кол-ву
-- докторов: где больше выше, по времени работы: которые еще работают выше
declare
    v_record kabenyk_st.pkg_hospitals.t_record_1;
    v_id_specialization number;
begin
    v_record := kabenyk_st.pkg_hospitals.all_hospitals_by_specialization_as_func (
        p_id_specialization => v_id_specialization
    );
end;

-- 4. Выдать всех врачей (неудаленных) конкретной больницы, отсортировать по квалификации:
-- у кого есть выше, по участку: если участок совпадает с участком пациента, то такие выше
declare
    v_record kabenyk_st.pkg_doctors.t_record_1;
    v_id_hospital number;
    v_area number := 5;
begin
    v_record := kabenyk_st.pkg_doctors.all_doctors_by_hospital_as_func (
        p_id_hospital => v_id_hospital, p_area => v_area
    );
end;

-- 5. Выдать все талоны конкретного врача, не показывать талоны, которые начались
-- раньше текущего времени
declare
    v_record kabenyk_st.pkg_tickets.t_record_1;
    v_id_doctor number := 6;
begin
    v_record := kabenyk_st.pkg_tickets.all_tickets_by_doctor_as_func (
        p_id_doctor => v_id_doctor
    );
end;

-- 6. Выдать документы
declare
    v_record kabenyk_st.pkg_patients.t_record_1;
    v_id_patient number := 2;
begin
    v_record := kabenyk_st.pkg_patients.all_documents_by_patient_as_func (
        p_id_patient => v_id_patient
    );
end;

-- 7. Выдать расписание больниц
declare
    v_record kabenyk_st.pkg_hospitals.t_record_2;
    v_id_hospital number := 1;
begin
    v_record := kabenyk_st.pkg_hospitals.hospitals_working_time_as_func (
        p_id_hospital => v_id_hospital
    );
end;

-- 8.Выдать журнал пациента
declare
    v_record kabenyk_st.pkg_patients.t_record_2;
    v_id_patient number;
begin
    v_record := kabenyk_st.pkg_patients.patients_journal_by_patient_as_func (
        p_id_patient => v_id_patient
    );
end;

-- 9. Запись в журнал с проверками
declare
    v_id_ticket number := 3;
    v_id_patient number := 3;
begin
    kabenyk_st.check_for_ticket_accept_as_proc (
        p_id_ticket => v_id_ticket,
        p_id_patient => v_id_patient
    );
end;

-- 10. Удаление записи с проверками
declare
    v_id_journal number := 18;
    v_id_ticket number := 3;
begin
    kabenyk_st.check_for_journal_record_deletion_as_proc (
        p_id_journal => v_id_journal,
        p_id_ticket => v_id_ticket
    );
end;