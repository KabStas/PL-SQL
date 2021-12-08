create or replace function packing_doctors_to_clob (
    p_response in kabenyk_st.t_arr_doctor,
    p_result in integer
)
return clob
as

    v_json json_object_t := json_object_t();
    v_json_response json_array_t := json_array_t();
    v_return_clob clob;

begin

    v_json.put('code', p_result);

    if p_response.count>0 then
    for i in p_response.first..p_response.last
    loop
    declare
        v_item kabenyk_st.t_doctor := p_response(i);
        v_object json_object_t := json_object_t();
    begin
        v_object.put('id_doctor', v_item.id_doctor);
        v_object.put('id_hospital', v_item.id_hospital);
        v_object.put('surname', v_item.surname);
        v_object.put('name', v_item.name);
        v_object.put('patronymic', v_item.patronymic);
        v_object.put('area', v_item.area);
        v_object.put('id_doctors_qualifications', v_item.id_doctors_qualifications);

        v_json_response.append(v_object);
    end;
    end loop;
    end if;

    v_json.put('response', v_json_response);

    v_return_clob := v_json.to_Clob();

    return v_return_clob;
end;

create or replace function packing_doctor_to_clob (
    p_response in kabenyk_st.t_doctor,
    p_result in integer
)
return clob
as

    v_json json_object_t := json_object_t();
    v_json_response json_array_t := json_array_t();
    v_return_clob clob;
    v_object json_object_t := json_object_t();
begin

    v_json.put('code', p_result);

    v_object.put('id_doctor', p_response.id_doctor);
    v_object.put('id_hospital', p_response.id_hospital);
    v_object.put('surname', p_response.surname);
    v_object.put('name', p_response.name);
    v_object.put('patronymic', p_response.patronymic);
    v_object.put('area', p_response.area);
    v_object.put('id_doctors_qualifications', p_response.id_doctors_qualifications);

    v_json_response.append(v_object);

    v_json.put('response', v_json_response);

    v_return_clob := v_json.to_Clob();

    return v_return_clob;
end;

create or replace function packing_hospitals_to_clob (
    p_response in kabenyk_st.t_arr_hospital,
    p_result in integer
)
return clob
as

    v_json json_object_t := json_object_t();
    v_json_response json_array_t := json_array_t();
    v_return_clob clob;

begin

    v_json.put('code', p_result);

    if p_response.count>0 then
    for i in p_response.first..p_response.last
    loop
    declare
        v_item kabenyk_st.t_hospital := p_response(i);
        v_object json_object_t := json_object_t();
    begin
        v_object.put('id_hospital', v_item.id_hospital);
        v_object.put('name', v_item.name);
        v_object.put('id_hospital_availability', v_item.id_hospital_availability);
        v_object.put('id_hospital_type', v_item.id_hospital_type);
        v_object.put('id_organization', v_item.id_organization);
        v_object.put('address', v_item.address);


        v_json_response.append(v_object);
    end;
    end loop;
    end if;

    v_json.put('response', v_json_response);

    v_return_clob := v_json.to_Clob();

    return v_return_clob;
end;

create or replace function packing_hospital_to_clob (
    p_response in kabenyk_st.t_hospital,
    p_result in integer
)
return clob
as

    v_json json_object_t := json_object_t();
    v_json_response json_array_t := json_array_t();
    v_return_clob clob;
    v_object json_object_t := json_object_t();
begin

    v_json.put('code', p_result);

    v_object.put('id_hospital', p_response.id_hospital);
    v_object.put('name', p_response.name);
    v_object.put('id_hospital_availability', p_response.id_hospital_availability);
    v_object.put('id_hospital_type', p_response.id_hospital_type);
    v_object.put('id_organization', p_response.id_organization);
    v_object.put('address', p_response.address);

    v_json_response.append(v_object);

    v_json.put('response', v_json_response);

    v_return_clob := v_json.to_Clob();

    return v_return_clob;
end;

create or replace function packing_hospitals_working_time_to_clob (
    p_response in kabenyk_st.t_arr_hospital_time,
    p_result in integer
)
return clob
as

    v_json json_object_t := json_object_t();
    v_json_response json_array_t := json_array_t();
    v_return_clob clob;

begin

    v_json.put('code', p_result);

    if p_response.count>0 then
    for i in p_response.first..p_response.last
    loop
    declare
        v_item kabenyk_st.t_hospital_time := p_response(i);
        v_object json_object_t := json_object_t();
    begin
        v_object.put('id_time', v_item.id_time);
        v_object.put('day', v_item.day);
        v_object.put('begin_time', v_item.begin_time);
        v_object.put('end_time', v_item.end_time);
        v_object.put('id_hospital', v_item.id_hospital);

        v_json_response.append(v_object);
    end;
    end loop;
    end if;

    v_json.put('response', v_json_response);

    v_return_clob := v_json.to_Clob();

    return v_return_clob;
end;

create or replace function packing_documents_to_clob (
    p_response in kabenyk_st.t_arr_patient_documents_numbers,
    p_result in integer
)
return clob
as

    v_json json_object_t := json_object_t();
    v_json_response json_array_t := json_array_t();
    v_return_clob clob;

begin

    v_json.put('code', p_result);

    if p_response.count>0 then
    for i in p_response.first..p_response.last
    loop
    declare
        v_item kabenyk_st.t_patient_documents_numbers := p_response(i);
        v_object json_object_t := json_object_t();
    begin
        v_object.put('id_document_number', v_item.id_document_number);
        v_object.put('id_patient', v_item.id_patient);
        v_object.put('id_document', v_item.id_document);
        v_object.put('value', v_item.value);

        v_json_response.append(v_object);
    end;
    end loop;
    end if;

    v_json.put('response', v_json_response);

    v_return_clob := v_json.to_Clob();

    return v_return_clob;
end;

create or replace function packing_journals_to_clob (
    p_response in kabenyk_st.t_arr_journal,
    p_result in integer
)
return clob
as

    v_json json_object_t := json_object_t();
    v_json_response json_array_t := json_array_t();
    v_return_clob clob;

begin

    v_json.put('code', p_result);

    if p_response.count>0 then
    for i in p_response.first..p_response.last
    loop
    declare
        v_item kabenyk_st.t_journal := p_response(i);
        v_object json_object_t := json_object_t();
    begin
        v_object.put('id_journal', v_item.id_journal);
        v_object.put('id_journal_record_status', v_item.id_journal_record_status);
        v_object.put('day_time', v_item.day_time);
        v_object.put('id_patient', v_item.id_patient);
        v_object.put('id_ticket', v_item.id_ticket);

        v_json_response.append(v_object);
    end;
    end loop;
    end if;

    v_json.put('response', v_json_response);

    v_return_clob := v_json.to_Clob();

    return v_return_clob;
end;

    create or replace function packing_patient_to_clob (
    p_response in kabenyk_st.t_patient,
    p_result in integer
)
return clob
as

    v_json json_object_t := json_object_t();
    v_json_response json_array_t := json_array_t();
    v_return_clob clob;
    v_object json_object_t := json_object_t();
begin

    v_json.put('code', p_result);

    v_object.put('id_patient', p_response.id_patient);
    v_object.put('surname', p_response.surname);
    v_object.put('name', p_response.name);
    v_object.put('patronymic', p_response.patronymic);
    v_object.put('date_of_birth', p_response.date_of_birth);
    v_object.put('id_gender', p_response.id_gender);
    v_object.put('phone', p_response.phone);
    v_object.put('area', p_response.area);
    v_object.put('id_account', p_response.id_account);

    v_json_response.append(v_object);

    v_json.put('response', v_json_response);

    v_return_clob := v_json.to_Clob();

    return v_return_clob;
end;

create or replace function packing_journal_to_clob (
    p_response in kabenyk_st.t_journal,
    p_result in integer
)
return clob
as

    v_json json_object_t := json_object_t();
    v_json_response json_array_t := json_array_t();
    v_return_clob clob;
    v_object json_object_t := json_object_t();
begin

    v_json.put('code', p_result);

    v_object.put('id_journal', p_response.id_journal);
    v_object.put('id_journal_record_status', p_response.id_journal_record_status);
    v_object.put('day_time', p_response.day_time);
    v_object.put('id_patient', p_response.id_patient);
    v_object.put('id_ticket', p_response.id_ticket);

    v_json_response.append(v_object);

    v_json.put('response', v_json_response);

    v_return_clob := v_json.to_Clob();

    return v_return_clob;
end;

create or replace function packing_specialties_to_clob (
    p_response in kabenyk_st.t_arr_specialty,
    p_result in integer
)
return clob
as

    v_json json_object_t := json_object_t();
    v_json_response json_array_t := json_array_t();
    v_return_clob clob;

begin

    v_json.put('code', p_result);

    if p_response.count>0 then
    for i in p_response.first..p_response.last
    loop
    declare
        v_item kabenyk_st.t_specialty := p_response(i);
        v_object json_object_t := json_object_t();
    begin
        v_object.put('id_specialty', v_item.id_specialty);
        v_object.put('specialty', v_item.specialty);
        v_object.put('min_age', v_item.min_age);
        v_object.put('max_age', v_item.max_age);
        v_object.put('id_gender', v_item.id_gender);

        v_json_response.append(v_object);
    end;
    end loop;
    end if;

    v_json.put('response', v_json_response);

    v_return_clob := v_json.to_Clob();

    return v_return_clob;
end;

create or replace function packing_tickets_to_clob (
    p_response in kabenyk_st.t_arr_ticket,
    p_result in integer
)
return clob
as

    v_json json_object_t := json_object_t();
    v_json_response json_array_t := json_array_t();
    v_return_clob clob;

begin

    v_json.put('code', p_result);

    if p_response.count>0 then
    for i in p_response.first..p_response.last
    loop
    declare
        v_item kabenyk_st.t_ticket := p_response(i);
        v_object json_object_t := json_object_t();
    begin
        v_object.put('id_ticket', v_item.id_ticket);
        v_object.put('id_ticket_flag', v_item.id_ticket_flag);
        v_object.put('begin_time', v_item.begin_time);
        v_object.put('end_time', v_item.end_time);
        v_object.put('id_doctor_specialization', v_item.id_doctor_specialization);

        v_json_response.append(v_object);
    end;
    end loop;
    end if;

    v_json.put('response', v_json_response);

    v_return_clob := v_json.to_Clob();

    return v_return_clob;
end;


create or replace function packing_ticket_to_clob (
    p_response in kabenyk_st.t_ticket,
    p_result in integer
)
return clob
as

    v_json json_object_t := json_object_t();
    v_json_response json_array_t := json_array_t();
    v_return_clob clob;
    v_object json_object_t := json_object_t();
begin

    v_json.put('code', p_result);

    v_object.put('id_ticket', p_response.id_ticket);
    v_object.put('id_ticket_flag', p_response.id_ticket_flag);
    v_object.put('begin_time', p_response.begin_time);
    v_object.put('end_time', p_response.end_time);
    v_object.put('id_doctor_specialization', p_response.id_doctor_specialization);

    v_json_response.append(v_object);

    v_json.put('response', v_json_response);

    v_return_clob := v_json.to_Clob();

    return v_return_clob;
end;

create or replace function packing_result_output_to_clob (
    p_response in kabenyk_st.t_result_output,
    p_result in integer
)
return clob
as

    v_json json_object_t := json_object_t();
    v_json_response json_array_t := json_array_t();
    v_return_clob clob;
    v_object json_object_t := json_object_t();
begin

    v_json.put('code', p_result);

    v_object.put('patient_surname', p_response.patient_surname);
    v_object.put('visit_date', p_response.visit_date);
    v_object.put('doctor_surname', p_response.doctor_surname);

    v_json_response.append(v_object);

    v_json.put('response', v_json_response);

    v_return_clob := v_json.to_Clob();

    return v_return_clob;
end;
