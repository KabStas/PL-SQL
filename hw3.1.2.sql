--Выдать все специальности (неудаленные), в которых есть хотя бы один доктор (неудаленный),
-- которые работают в больницах (неудаленных)

declare
    cursor specializations_by_active_doctors_cursor (
        p_id_specialization in number
    )
    is
    select
        s.specialization,
        d.surname,
        h.name
    from
        kabenyk_st.specializations s
        join kabenyk_st.doctors d
            on s.id_specialization = d.id_doctor
        join kabenyk_st.hospitals h
            on h.id_hospital = d.id_hospital
    where (
          s.data_of_record_deletion is null and
          d.data_of_record_deletion is null and
          h.data_of_record_deletion is null and
          s.id_specialization = p_id_specialization and
          p_id_specialization is not null
          ) or
          (
          s.data_of_record_deletion is null and
          d.data_of_record_deletion is null and
          h.data_of_record_deletion is null and
          s.id_specialization is not null and
          p_id_specialization is null);

    type record_1 is record (
        specialization varchar2(100),
        doctor varchar2(100),
        hospital varchar2(100)
    );
    v_record_1 record_1;
    v_record_2 record_1;

    v_specializations_by_active_doctors_cursor sys_refcursor;

begin
    open specializations_by_active_doctors_cursor(3);

        dbms_output.put_line ('first cursor:');

        loop
            fetch specializations_by_active_doctors_cursor into v_record_1;

            exit when specializations_by_active_doctors_cursor%notfound;

            dbms_output.put_line (v_record_1.specialization|| ', ' || v_record_1.doctor||
                                  ', ' || v_record_1.hospital);
        end loop;

    close specializations_by_active_doctors_cursor;

    open v_specializations_by_active_doctors_cursor for
        select
        s.specialization,
        d.surname,
        h.name
        from
            kabenyk_st.specializations s
            join kabenyk_st.doctors d
                on s.id_specialization = d.id_doctor
            join kabenyk_st.hospitals h
                on h.id_hospital = d.id_hospital
        where s.data_of_record_deletion is null
            and d.data_of_record_deletion is null
            and h.data_of_record_deletion is null;

        dbms_output.put_line ('second cursor:');

        loop
            fetch v_specializations_by_active_doctors_cursor into v_record_2;

            exit when v_specializations_by_active_doctors_cursor%notfound;

            dbms_output.put_line (v_record_2.specialization|| ', ' || v_record_2.doctor||
                                  ', ' || v_record_2.hospital);
        end loop;

    close v_specializations_by_active_doctors_cursor;

    dbms_output.put_line ('third cursor:');

    for i in (
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
            and h.data_of_record_deletion is null
    )
        loop
        dbms_output.put_line (i.specialization|| ', ' || i.doctor||
                                  ', ' || i.hospital);
    end loop;
end;











