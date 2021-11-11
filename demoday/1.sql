create or replace function
    kabenyk_st.get_all_towns_by_regions_as_func (
        p_id_region in number
)
return sys_refcursor
as
    v_all_towns_by_regions_cursor sys_refcursor;
begin
    open v_all_towns_by_regions_cursor for
        select t.name,r.name
        from kabenyk_st.towns t
            join kabenyk_st.regions r
                on t.id_region = r.id_region
        where p_id_region is null or
              (p_id_region is not null and
              r.id_region = p_id_region);
    return v_all_towns_by_regions_cursor;
end;

declare
    v_all_towns_by_regions_cursor sys_refcursor;
    type record_1 is record (
        town varchar2(100),
        region varchar2(100)
    );
    v_record_1 record_1;
    v_id_region number;
begin
    v_all_towns_by_regions_cursor := kabenyk_st.get_all_towns_by_regions_as_func(
        p_id_region => v_id_region
    );
    loop
        fetch v_all_towns_by_regions_cursor into v_record_1;
        exit when v_all_towns_by_regions_cursor%notfound;
        dbms_output.put_line (v_record_1.town|| ' - ' || v_record_1.region);
    end loop;
    close v_all_towns_by_regions_cursor;
end;
