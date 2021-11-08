-- Выдать все больницы (неудаленные) конкретной специальности с пометками о
-- доступности, кол-ве врачей; отсортировать по типу: частные выше, по кол-ву
-- докторов: где больше выше, по времени работы: которые еще работают выше

create or replace function kabenyk_st.all_hospitals_by_specialization_as_func (
    p_id_specialization in number
)
return sys_refcursor
as
    v_all_hospitals_by_specialization_cursor sys_refcursor;
begin
    open v_all_hospitals_by_specialization_cursor for
        select
            s.specialization,
            h.name,
            t.type,
            a.availability,
            count(d.id_hospital) as doctors_quantity
--             case
--                 when to_char(sysdate, 'hh24:mi') < w.end_time
--                 then 0
--                 else 1
--             end as is_working
        from kabenyk_st.specializations s
            join kabenyk_st.doctors_specializations ds
                on s.id_specialization = ds.id_specialization
            join kabenyk_st.doctors d
                on d.id_doctor = ds.id_doctor
            join kabenyk_st.hospitals h
                on h.id_hospital = d.id_hospital
            join kabenyk_st.hospital_availability a
                on a.id_hospital_availability = h.id_hospital_availability
            join kabenyk_st.hospital_type t
                on t.id_hospital_type = h.id_hospital_type
--             join kabenyk_st.working_time w
--                 on h.id_hospital = w.id_hospital
        where h.data_of_record_deletion is null
              and
              (p_id_specialization is null
              or
              (p_id_specialization is not null and
              s.id_specialization = p_id_specialization))
        group by s.specialization, h.name, a.availability, t.type, t.id_hospital_type --w.end_time
        order by specialization,
            case
                when t.id_hospital_type = 2 then 0
                else 1
            end,
            doctors_quantity desc/*, is_working desc*/;

    return v_all_hospitals_by_specialization_cursor;
end;

declare
    v_all_hospitals_by_specialization_cursor sys_refcursor;
    type record_1 is record (
        specialization varchar2(100),
        hospital varchar2(100),
        hospital_type varchar2(100),
        availability varchar2(100),
        doctors_quantity number
        --is_working number
    );
    v_record_1 record_1;
    v_id_specialization number;
begin
    v_all_hospitals_by_specialization_cursor := kabenyk_st.all_hospitals_by_specialization_as_func(
        p_id_specialization => v_id_specialization
    );

    loop
        fetch v_all_hospitals_by_specialization_cursor into v_record_1;

        exit when v_all_hospitals_by_specialization_cursor%notfound;

        dbms_output.put_line (v_record_1.specialization|| ', ' || v_record_1.hospital||
                             ', ' || v_record_1.hospital_type||', врачей - ' || v_record_1.doctors_quantity);
    end loop;

    close v_all_hospitals_by_specialization_cursor;
end;