select *
    from (
        select
            er.id_log,
            er.sh_dt,
            er.object_name,
            er.params,

            (select error
            from json_table(er.params, '$' columns (
                error varchar2(100) path '$.error'
            ))) error,

            (select value
            from json_table(er.params, '$' columns (
                value varchar2(100) path '$.value'
            ))) value

        from (
            select *
            from kabenyk_st.error_log er
            where trunc(er.sh_dt) between trunc(to_date('18.11.2021','dd.mm.yyyy'))
                and trunc(to_date('22.11.2021','dd.mm.yyyy'))
                and er.object_name like '%ALREADY_RECORDED%'
        ) er
    ) jt
where jt.value like '1';