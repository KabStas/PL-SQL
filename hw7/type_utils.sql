create or replace function kabenyk_st.indent(n number)
return varchar2
as
    v_indent varchar2(4000);
begin
    for i in 1..n loop
        v_indent := v_indent||'     ';
    end loop;
    return v_indent;
end;
/

create or replace function kabenyk_st.to_char_t_doctor(
    p_doctor kabenyk_st.t_doctor,
    p_deep_level number default 0
)
return varchar2
as
    function ind(n number) return varchar2 as begin return kabenyk_st.indent(n); end;
begin
    return (
        (case when p_deep_level <> 0 then '' else '| ' end)||'kabenyk_st.t_doctor('||chr(13)||
        '| '||ind(p_deep_level+1)||'id_doctor            : '||p_doctor.id_doctor||chr(13)||
        '| '||ind(p_deep_level+1)||'id_hospital          : '||p_doctor.id_hospital||chr(13)||
        '| '||ind(p_deep_level+1)||'surname              : '||p_doctor.surname||chr(13)||
        '| '||ind(p_deep_level+1)||'name                 : '||p_doctor.name||chr(13)||
        '| '||ind(p_deep_level+1)||'patronymic           : '||p_doctor.patronymic||chr(13)||
        '| '||ind(p_deep_level+1)||'area                 : '||p_doctor.area||chr(13)||
        '| '||ind(p_deep_level+1)||'id_doc_qualifications: '||p_doctor.id_doctors_qualifications||chr(13)||
        '| '||ind(p_deep_level)||');'
    );
end;
/

create or replace function kabenyk_st.to_char_t_ticket(
    p_ticket kabenyk_st.t_ticket,
    p_deep_level number default 0
)
return varchar2
as
    function ind(n number) return varchar2 as begin return kabenyk_st.indent(n); end;
begin
    return (
        (case when p_deep_level <> 0 then '' else '| ' end)||'kabenyk_st.t_ticket('||chr(13)||
        '| '||ind(p_deep_level+1)||'id_ticket       : '||p_ticket.id_ticket||chr(13)||
        '| '||ind(p_deep_level+1)||'id_ticket_flag  : '||p_ticket.id_ticket_flag||chr(13)||
        '| '||ind(p_deep_level+1)||'begin_time      : '||to_char (p_ticket.begin_time, 'yyyy.mm.dd hh24:mi')||chr(13)||
        '| '||ind(p_deep_level+1)||'end_time        : '||to_char (p_ticket.end_time, 'yyyy.mm.dd hh24:mi')||chr(13)||
        '| '||ind(p_deep_level+1)||'id_doc_specialty: '||p_ticket.id_doctor_specialization||chr(13)||
        '| '||ind(p_deep_level)||');'
    );
end;

create or replace function kabenyk_st.to_char_t_patient(
    p_patient kabenyk_st.t_patient,
    p_deep_level number default 0
)
return varchar2
as
    function ind(n number) return varchar2 as begin return kabenyk_st.indent(n); end;
begin
    return (
        (case when p_deep_level <> 0 then '' else '| ' end)||'kabenyk_st.t_patient('||chr(13)||
        '| '||ind(p_deep_level+1)||'id_patient   : '||p_patient.id_patient||chr(13)||
        '| '||ind(p_deep_level+1)||'surname      : '||p_patient.surname||chr(13)||
        '| '||ind(p_deep_level+1)||'name         : '||p_patient.name||chr(13)||
        '| '||ind(p_deep_level+1)||'patronymic   : '||p_patient.patronymic||chr(13)||
        '| '||ind(p_deep_level+1)||'date_of_birth: '||p_patient.date_of_birth||chr(13)||
        '| '||ind(p_deep_level+1)||'id_gender    : '||p_patient.id_gender||chr(13)||
        '| '||ind(p_deep_level+1)||'area         : '||p_patient.area||chr(13)||
        '| '||ind(p_deep_level+1)||'id_account   : '||p_patient.id_account||chr(13)||
        '| '||ind(p_deep_level)||');'
    );
end;

create or replace function kabenyk_st.to_char_t_journal(
    p_journal kabenyk_st.t_journal,
    p_deep_level number default 0
)
return varchar2
as
    function ind(n number) return varchar2 as begin return kabenyk_st.indent(n); end;
begin
    return (
        (case when p_deep_level <> 0 then '' else '| ' end)||'kabenyk_st.t_journal('||chr(13)||
        '| '||ind(p_deep_level+1)||'id_journal           : '||p_journal.id_journal||chr(13)||
        '| '||ind(p_deep_level+1)||'id_journal_rec_status: '||p_journal.id_journal_record_status||chr(13)||
        '| '||ind(p_deep_level+1)||'date                 : '||to_char (p_journal.day_time, 'yyyy.mm.dd hh24:mi')||chr(13)||
        '| '||ind(p_deep_level+1)||'id_patient           : '||p_journal.id_patient||chr(13)||
        '| '||ind(p_deep_level+1)||'id_ticket            : '||p_journal.id_ticket||chr(13)||
        '| '||ind(p_deep_level)||');'
    );
end;

create or replace function kabenyk_st.to_char_t_hospital(
    p_hospital kabenyk_st.t_hospital,
    p_deep_level number default 0
)
return varchar2
as
    function ind(n number) return varchar2 as begin return kabenyk_st.indent(n); end;
begin
    return (
        (case when p_deep_level <> 0 then '' else '| ' end)||'kabenyk_st.t_hospital('||chr(13)||
        '| '||ind(p_deep_level+1)||'id_hospital             : '||p_hospital.id_hospital||chr(13)||
        '| '||ind(p_deep_level+1)||'name                    : '||p_hospital.name||chr(13)||
        '| '||ind(p_deep_level+1)||'id_hospital_availability: '||p_hospital.id_hospital_availability||chr(13)||
        '| '||ind(p_deep_level+1)||'id_hospital_type        : '||p_hospital.id_hospital_type||chr(13)||
        '| '||ind(p_deep_level+1)||'id_organization         : '||p_hospital.id_organization||chr(13)||
        '| '||ind(p_deep_level)||');'
    );
end;

create or replace function kabenyk_st.to_char_t_hospital_time(
    p_hospital_time kabenyk_st.t_hospital_time,
    p_deep_level number default 0
)
return varchar2
as
    function ind(n number) return varchar2 as begin return kabenyk_st.indent(n); end;
begin
    return (
        (case when p_deep_level <> 0 then '' else '| ' end)||'kabenyk_st.t_hospital_time('||chr(13)||
        '| '||ind(p_deep_level+1)||'id_hospital : '||p_hospital_time.id_hospital||chr(13)||
        '| '||ind(p_deep_level+1)||'day         : '||p_hospital_time.day||chr(13)||
        '| '||ind(p_deep_level+1)||'begin_time  : '||p_hospital_time.begin_time||chr(13)||
        '| '||ind(p_deep_level+1)||'end_time    : '||p_hospital_time.end_time||chr(13)||
        '| '||ind(p_deep_level)||');'
    );
end;

create or replace function kabenyk_st.to_char_t_specialty(
    p_specialty kabenyk_st.t_specialty,
    p_deep_level number default 0
)
return varchar2
as
    function ind(n number) return varchar2 as begin return kabenyk_st.indent(n); end;
begin
    return (
        (case when p_deep_level <> 0 then '' else '| ' end)||'kabenyk_st.t_specialty('||chr(13)||
        '| '||ind(p_deep_level+1)||'id_specialty : '||p_specialty.id_specialty||chr(13)||
        '| '||ind(p_deep_level+1)||'specialty    : '||p_specialty.specialty||chr(13)||
        '| '||ind(p_deep_level+1)||'min_age      : '||p_specialty.min_age||chr(13)||
        '| '||ind(p_deep_level+1)||'max_age      : '||p_specialty.max_age||chr(13)||
        '| '||ind(p_deep_level+1)||'id_gender    : '||p_specialty.id_gender||chr(13)||
        '| '||ind(p_deep_level)||');'
    );
end;

create or replace function kabenyk_st.to_char_t_documents(
    p_document kabenyk_st.t_patient_documents_numbers,
    p_deep_level number default 0
)
return varchar2
as
    function ind(n number) return varchar2 as begin return kabenyk_st.indent(n); end;
begin
    return (
        (case when p_deep_level <> 0 then '' else '| ' end)||'kabenyk_st.t_specialty('||chr(13)||
        '| '||ind(p_deep_level+1)||'id_patient  : '||p_document.id_patient||chr(13)||
        '| '||ind(p_deep_level+1)||'id_document : '||p_document.id_document||chr(13)||
        '| '||ind(p_deep_level+1)||'value       : '||p_document.value||chr(13)||
        '| '||ind(p_deep_level)||');'
    );
end;