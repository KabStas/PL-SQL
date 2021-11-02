-- 2. выдать документы

create or replace function
    kabenyk_st.all_documents_by_patient_as_func
return sys_refcursor
as
    v_all_documents_by_patient_cursor sys_refcursor;
    v_id_patient number;
begin
    v_id_patient := 2;
    open v_all_documents_by_patient_cursor for
        select
            d.name,
            dn.value,
            p.surname
        from
            kabenyk_st.documents d
            join kabenyk_st.documents_numbers dn
                on d.id_document = dn.id_document
            join kabenyk_st.patients p
                on dn.id_patient = p.id_patient
        where v_id_patient is null
              or
              (v_id_patient is not null and
              p.id_patient = v_id_patient);
    return v_all_documents_by_patient_cursor;
end;

declare
    v_all_documents_by_patient_cursor sys_refcursor;

    type record_1 is record (
        name varchar2(100),
        value varchar2(100),
        patient varchar2(100)
    );
    v_record_1 record_1;

begin
    v_all_documents_by_patient_cursor := kabenyk_st.all_documents_by_patient_as_func();

        loop
            fetch v_all_documents_by_patient_cursor into v_record_1;

            exit when v_all_documents_by_patient_cursor%notfound;

            dbms_output.put_line (v_record_1.name|| ', ' ||
                                 ', ' || v_record_1.value||', ' || v_record_1.patient);
        end loop;

    close v_all_documents_by_patient_cursor;
end;