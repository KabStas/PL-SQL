create or replace function kabenyk_st.all_doctors_by_hospital_as_func (
    p_id_hospital in number, p_area in number
)
return sys_refcursor
as
    v_all_doctors_by_hospital_cursor sys_refcursor;
begin
    open v_all_doctors_by_hospital_cursor for
        select
            h.name,
            d.surname,
            q.qualification,
            d.area
        from kabenyk_st.doctors d
            join kabenyk_st.hospitals h
                on d.id_hospital = h.id_hospital
            join kabenyk_st.doctors_qualifications q
                on d.id_doctors_qualifications = q.id_doctors_qualifications
        where d.data_of_record_deletion is null
              and
              (p_id_hospital is null
              or
              (p_id_hospital is not null and
              d.id_hospital = p_id_hospital))
        order by qualification,
            case
                when d.area = p_area then 0
                else 1
            end;
    return v_all_doctors_by_hospital_cursor;
end;

declare
    v_all_doctors_by_hospital_cursor sys_refcursor;
    type record_1 is record (
        hospital varchar2(100),
        doctor varchar2(100),
        qualification varchar2(100),
        area number
    );
    v_record_1 record_1;
    v_id_hospital number := 4;
    v_area number := 5;
begin

    v_all_doctors_by_hospital_cursor := kabenyk_st.all_doctors_by_hospital_as_func (
        p_id_hospital => v_id_hospital, p_area => v_area
    );
        loop
            fetch v_all_doctors_by_hospital_cursor into v_record_1;

            exit when v_all_doctors_by_hospital_cursor%notfound;

            dbms_output.put_line (v_record_1.hospital|| ', ' || v_record_1.doctor||
                                  ', ' || v_record_1.qualification||', ' || v_record_1.area ||
                                  ' участок');
        end loop;

    close v_all_doctors_by_hospital_cursor;
end;
