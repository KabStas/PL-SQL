--Выдать все специальности (неудаленные), в которых есть хотя бы один доктор (неудаленный),
-- которые работают в больницах (неудаленных)

create or replace function
    kabenyk_st.all_specializations_as_func
return sys_refcursor
as
    v_all_specializations_cursor sys_refcursor;
    v_id_hospital number;
begin
    open v_all_specializations_cursor for
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
        where v_id_hospital is null or
              (v_id_hospital is not null and
              h.id_hospital = v_id_hospital);
    return v_all_specializations_cursor;
end;

declare
    v_all_specializations_cursor sys_refcursor;
    type record_1 is record (
        specialization varchar2(100),
        doctor varchar2(100),
        hospital varchar2(100)
    );
    v_record_1 record_1;
begin
    v_all_specializations_cursor := kabenyk_st.all_specializations_as_func();

    loop
            fetch v_all_specializations_cursor into v_record_1;

            exit when v_all_specializations_cursor%notfound;

            dbms_output.put_line (v_record_1.specialization|| ', ' || v_record_1.doctor||
                                  ', ' || v_record_1.hospital);
        end loop;

    close v_all_specializations_cursor;
end;