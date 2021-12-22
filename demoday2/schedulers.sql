begin

    sys.dbms_scheduler.create_job(

        job_name        => 'kabenyk_st.job_getting_hospitals_data',
        start_date => to_timestamp_tz('2021/12/05 14:00:00.000000 +07:00','yyyy/mm/dd hh24:mi:ss.ff tzh:tzm'),
        repeat_interval => 'FREQ=HOURLY;INTERVAL=1;',
        end_date        => null,
        job_class       => 'DEFAULT_JOB_CLASS',
        job_type        => 'PLSQL_BLOCK',
        job_action      => 'begin kabenyk_st.job_getting_hospitals_data_action; end;'
    );

    sys.dbms_scheduler.create_job(

        job_name        => 'kabenyk_st.job_getting_specialties_data',
        start_date => to_timestamp_tz('2021/12/05 14:00:00.000000 +07:00','yyyy/mm/dd hh24:mi:ss.ff tzh:tzm'),
        repeat_interval => 'FREQ=HOURLY;INTERVAL=1;',
        end_date        => null,
        job_class       => 'DEFAULT_JOB_CLASS',
        job_type        => 'PLSQL_BLOCK',
        job_action      => 'begin kabenyk_st.job_getting_specialties_data_action; end;'
    );

    sys.dbms_scheduler.create_job(

        job_name        => 'kabenyk_st.job_getting_doctors_data',
        start_date => to_timestamp_tz('2021/12/05 14:00:00.000000 +07:00','yyyy/mm/dd hh24:mi:ss.ff tzh:tzm'),
        repeat_interval => 'FREQ=HOURLY;INTERVAL=1;',
        end_date        => null,
        job_class       => 'DEFAULT_JOB_CLASS',
        job_type        => 'PLSQL_BLOCK',
        job_action      => 'begin kabenyk_st.job_getting_doctors_data_action; end;'
    );

end;

begin
    sys.dbms_scheduler.enable(
        name      => 'kabenyk_st.job_getting_hospitals_data'
    );
    sys.dbms_scheduler.enable(
        name      => 'kabenyk_st.job_getting_specialties_data'
    );
    sys.dbms_scheduler.enable(
        name      => 'kabenyk_st.job_getting_doctors_data'
    );
end;

begin
    sys.dbms_scheduler.disable(
        name      => 'kabenyk_st.job_getting_hospitals_data'
    );
    sys.dbms_scheduler.disable(
        name      => 'kabenyk_st.job_getting_specialties_data'
    );
    sys.dbms_scheduler.disable(
        name      => 'kabenyk_st.job_getting_doctors_data'
    );
end;

begin
    sys.dbms_scheduler.drop_job(
        job_name      => 'kabenyk_st.job_getting_hospitals_data'
    );
    sys.dbms_scheduler.drop_job(
        job_name      => 'kabenyk_st.job_getting_specialties_data'
    );
    sys.dbms_scheduler.drop_job(
        job_name      => 'kabenyk_st.job_getting_doctors_data'
    );
end;

select * from user_scheduler_jobs;

select * from user_scheduler_job_log;