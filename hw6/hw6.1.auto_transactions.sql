create or replace procedure kabenyk_st.add_error_log(
    p_object_name varchar2,
    p_params varchar2,
    p_log_type varchar2 default 'common',
    p_is_three_month_ahead boolean default false
)
as
pragma autonomous_transaction;
begin

    if p_is_three_month_ahead then
        insert into kabenyk_st.error_log(sh_dt, object_name, log_type, params)
        values (sysdate + 93, p_object_name, p_log_type, p_params);
    else
        insert into kabenyk_st.error_log(object_name, log_type, params)
        values (p_object_name, p_log_type, p_params);
    end if;

    commit;
end;
