-- 2. выдать документы

declare
    cursor documents_cursor (
        p_patient_surname in varchar2
    )
    is
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
    where (
          p.surname = p_patient_surname and
          p_patient_surname is not null
          ) or
          (
          p.surname is not null and
          p_patient_surname is null
          )
    order by p.surname;

    type record_1 is record (
        name varchar2(100),
        value varchar2(100),
        patient varchar2(100)

    );

    v_record_1 record_1;
    v_record_2 record_1;

    v_documents_cursor sys_refcursor;

begin
    open documents_cursor('Некрасова');

        dbms_output.put_line ('first cursor:');

        loop
            fetch documents_cursor into v_record_1;

            exit when documents_cursor%notfound;

            dbms_output.put_line (v_record_1.name|| ', ' ||
                                 ', ' || v_record_1.value||', ' || v_record_1.patient);
        end loop;

    close documents_cursor;

    open v_documents_cursor for

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
        where p.surname = 'Макаров';

        dbms_output.put_line ('second cursor:');

        loop
            fetch v_documents_cursor into v_record_2;

            exit when v_documents_cursor%notfound;

            dbms_output.put_line (v_record_2.name|| ', ' ||
                                 ', ' || v_record_2.value||', ' || v_record_2.patient);
        end loop;

    close v_documents_cursor;

    dbms_output.put_line ('third cursor:');

    for i in (
        select
        d.name as document,
        dn.value as value,
        p.surname as patient
        from
            kabenyk_st.documents d
            join kabenyk_st.documents_numbers dn
                on d.id_document = dn.id_document
            join kabenyk_st.patients p
                on dn.id_patient = p.id_patient
        order by p.surname
    )
    loop
        dbms_output.put_line (i.document||  ', ' ||
                             ', ' || i.value||', ' || i.patient);
    end loop;
end;
