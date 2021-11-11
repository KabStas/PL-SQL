create or replace function kabenyk_st.all_documents_by_patient_as_func (
    p_id_patient in number
)
return sys_refcursor
as
    v_all_documents_by_patient_cursor sys_refcursor;
begin
    open v_all_documents_by_patient_cursor for
        select
            d.name,
            dn.value,
            p.surname
        from kabenyk_st.documents d
            join kabenyk_st.documents_numbers dn
                on d.id_document = dn.id_document
            join kabenyk_st.patients p
                on dn.id_patient = p.id_patient
        where p_id_patient is null
              or (p_id_patient is not null and p.id_patient = p_id_patient);
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
    v_id_patient number := 2;
begin
    v_all_documents_by_patient_cursor := kabenyk_st.all_documents_by_patient_as_func (
        p_id_patient => v_id_patient
    );

        loop
            fetch v_all_documents_by_patient_cursor into v_record_1;

            exit when v_all_documents_by_patient_cursor%notfound;

            dbms_output.put_line (v_record_1.name || ', ' || v_record_1.value ||
                                  ', ' || v_record_1.patient);
        end loop;

    close v_all_documents_by_patient_cursor;
end;
