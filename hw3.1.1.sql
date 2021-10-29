--Выдать все города по регионам

declare
    cursor all_towns_by_regions_cursor (
        p_id_region in number
    )
    is
    select t.name, r.name
    from kabenyk_st.towns t
    join kabenyk_st.regions r
    on t.id_region = r.id_region
    where (r.id_region = p_id_region and p_id_region is not null)
          or (r.id_region is not null and p_id_region is null);

    type record_1 is record (
        town varchar2(100),
        region varchar2(100)
    );
    v_record_1 record_1;
    v_record_2 record_1;

    v_all_towns_by_regions_cursor sys_refcursor;

begin
    open all_towns_by_regions_cursor(null);

        dbms_output.put_line ('first cursor:');

        loop
            fetch all_towns_by_regions_cursor into v_record_1;

            exit when all_towns_by_regions_cursor%notfound;

            dbms_output.put_line (v_record_1.town|| ' - ' || v_record_1.region);
        end loop;

    close all_towns_by_regions_cursor;

    open v_all_towns_by_regions_cursor for
        select t.name,r.name
        from kabenyk_st.towns t
        join kabenyk_st.regions r using(id_region);

        dbms_output.put_line ('second cursor:');

        loop
            fetch v_all_towns_by_regions_cursor into v_record_2;

            exit when v_all_towns_by_regions_cursor%notfound;

            dbms_output.put_line (v_record_2.town|| ' - ' || v_record_2.region);
        end loop;

    close v_all_towns_by_regions_cursor;

    dbms_output.put_line ('third cursor:');

    for i in (
        select t.name as town,
               r.name as region
        from kabenyk_st.towns t
        join kabenyk_st.regions r using(id_region)
    )
    loop
        dbms_output.put_line (i.town|| ' - ' || i.region);
    end loop;
end;