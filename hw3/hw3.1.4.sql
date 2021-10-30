-- Выдать всех врачей (неудаленных) конкретной больницы, отсортировать по квалификации:
-- у кого есть выше, по участку: если участок совпадает с участком пациента, то такие выше

declare
    cursor doctors_by_hospital_cursor (
        p_hospital_name in varchar2
    )
    is
    select
        h.name,
        d.surname,
        q.qualification,
        d.area
    from
        kabenyk_st.doctors d
        join kabenyk_st.hospitals h
            on d.id_hospital = h.id_hospital
        join kabenyk_st.doctors_qualifications q
            on d.id_doctors_qualifications = q.id_doctors_qualifications
    where (
          d.data_of_record_deletion is null) and
          ((
          h.name = p_hospital_name and
          p_hospital_name is not null
          ) or
          (
          h.name is not null and
          p_hospital_name is null
          ))
    order by qualification,
             case
                when d.area = 5 then 0
                else 1
            end;

    type record_1 is record (
        hospital varchar2(100),
        doctor varchar2(100),
        qualification varchar2(100),
        area number
    );

    v_record_1 record_1;
    v_record_2 record_1;

    v_doctors_by_hospital_cursor sys_refcursor;

begin
    open doctors_by_hospital_cursor('Авиценна №4');

        dbms_output.put_line ('first cursor:');

        loop
            fetch doctors_by_hospital_cursor into v_record_1;

            exit when doctors_by_hospital_cursor%notfound;

            dbms_output.put_line (v_record_1.hospital|| ', ' || v_record_1.doctor||
                                  ', ' || v_record_1.qualification||', ' || v_record_1.area ||
                                  ' участок');
        end loop;

    close doctors_by_hospital_cursor;

    open v_doctors_by_hospital_cursor for
        select
        h.name,
        d.surname,
        q.qualification,
        d.area
        from
            kabenyk_st.doctors d
            join kabenyk_st.hospitals h
                on d.id_hospital = h.id_hospital
            join kabenyk_st.doctors_qualifications q
                on d.id_doctors_qualifications = q.id_doctors_qualifications
        where d.data_of_record_deletion is null and
              h.name = 'Поликлиника №1'
        order by qualification,
                 case
                    when d.area = 5 then 0
                    else 1
                end;

        dbms_output.put_line ('second cursor:');

        loop
            fetch v_doctors_by_hospital_cursor into v_record_2;

            exit when v_doctors_by_hospital_cursor%notfound;

            dbms_output.put_line (v_record_2.hospital|| ', ' || v_record_2.doctor||
                                  ', ' || v_record_2.qualification||', ' || v_record_2.area ||
                                  ' участок');
        end loop;

    close v_doctors_by_hospital_cursor;

    dbms_output.put_line ('third cursor:');

    for i in (
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
                on d.id_doctors_qualifications = q.id_doctors_qualifications
        where d.data_of_record_deletion is null
        order by qualification,
                 case
                    when d.area = 5 then 0
                    else 1
                 end
    )
    loop
        dbms_output.put_line (i.hospital|| ', ' || i.doctor||', '
                             || i.qualification||', ' || i.area ||' участок');
    end loop;
end;