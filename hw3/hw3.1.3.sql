-- Выдать все больницы (неудаленные) конкретной специальности с пометками о
-- доступности, кол-ве врачей; отсортировать по типу: частные выше, по кол-ву
-- докторов: где больше выше, по времени работы: которые еще работают выше

declare
    cursor specializations_by_hospital_and_doctors_cursor (
        p_specialization in varchar2
    )
    is
    select
        s.specialization,
        h.name,
        t.type,
        a.availability,
        count(d.id_hospital) as doctors_quantity,
        case
            when to_char(sysdate, 'hh24:mi') < w.end_time
            then 1
            else 0
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
    where (
          h.data_of_record_deletion is null) and
          ((
          s.specialization = p_specialization and
          p_specialization is not null
          ) or
          (
          s.specialization is not null and
          p_specialization is null
          ))
    group by s.specialization, h.name, a.availability, t.type, t.id_hospital_type, w.end_time
    order by
            case
                when t.id_hospital_type = 2 then 0
                else 1
            end,
            doctors_quantity desc, is_working desc;

    type record_1 is record (
        specialization varchar2(100),
        hospital varchar2(100),
        hospital_type varchar2(100),
        availability varchar2(100),
        doctors_quantity number,
        is_working number
    );

    v_record_1 record_1;
    v_record_2 record_1;

    v_specializations_by_hospital_and_doctors_cursor sys_refcursor;

begin
    open specializations_by_hospital_and_doctors_cursor('гинеколог');

        dbms_output.put_line ('first cursor:');

        loop
            fetch specializations_by_hospital_and_doctors_cursor into v_record_1;

            exit when specializations_by_hospital_and_doctors_cursor%notfound;

            dbms_output.put_line (v_record_1.specialization|| ', ' || v_record_1.hospital||
                                  ', ' || v_record_1.hospital_type||', ' || v_record_1.doctors_quantity);
        end loop;

    close specializations_by_hospital_and_doctors_cursor;

    open v_specializations_by_hospital_and_doctors_cursor for
        select
        s.specialization,
        h.name,
        t.type,
        a.availability,
        count(d.id_hospital) as doctors_quantity,
        case
            when to_char(sysdate, 'hh24:mi') < w.end_time
            then 1
            else 0
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
        where h.data_of_record_deletion is null and
              s.specialization = 'педиатр'
        group by s.specialization, h.name, a.availability, t.type, w.end_time
        order by
                case
                    when t.type = 'частная' then 0
                    else 1
                end,
                doctors_quantity desc, is_working desc;

        dbms_output.put_line ('second cursor:');

        loop
            fetch v_specializations_by_hospital_and_doctors_cursor into v_record_2;

            exit when v_specializations_by_hospital_and_doctors_cursor%notfound;

            dbms_output.put_line (v_record_2.specialization|| ', ' || v_record_2.hospital||
                                  ', ' || v_record_2.hospital_type||', ' || v_record_2.doctors_quantity);
        end loop;

    close v_specializations_by_hospital_and_doctors_cursor;

    dbms_output.put_line ('third cursor:');

    for i in (
        select
        s.specialization as specialization,
        h.name as hospital,
        t.type as hospital_type,
        a.availability,
        count(d.id_hospital) as doctors_quantity,
        case
            when to_char(sysdate, 'hh24:mi') < w.end_time
            then 1
            else 0
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
        where h.data_of_record_deletion is null
        group by s.specialization, h.name, a.availability, t.type, w.end_time
        order by
                case
                    when t.type = 'частная' then 0
                    else 1
                end,
                doctors_quantity desc, is_working desc
    )
    loop
        dbms_output.put_line (i.specialization|| ', ' || i.hospital||
                             ', ' || i.hospital_type||', ' || i.doctors_quantity);
    end loop;
end;






