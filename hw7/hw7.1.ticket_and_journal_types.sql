create or replace type kabenyk_st.t_ticket as object(
    id_ticket number,
    id_ticket_flag number,
    begin_time date,
    end_time date,
    id_doctor_specialization number
);

create or replace type kabenyk_st.t_arr_ticket
    as table of kabenyk_st.t_ticket;

create or replace type kabenyk_st.t_journal as object(
    id_journal number,
    id_journal_record_status number,
    day_time date,
    id_patient number,
    id_ticket number
);

create or replace type kabenyk_st.t_arr_journal
    as table of kabenyk_st.t_journal;

alter type kabenyk_st.t_ticket
add constructor function t_ticket(
    id_ticket number,
    id_ticket_flag number,
    begin_time date,
    end_time date,
    id_doctor_specialization number
) return self as result
cascade;

create or replace type body kabenyk_st.t_ticket
as
    constructor function t_ticket(
        id_ticket number,
        id_ticket_flag number,
        begin_time date,
        end_time date,
        id_doctor_specialization number
    )
    return self as result
    as
    begin
        self.id_ticket := id_ticket;
        self.id_ticket_flag := id_ticket_flag;
        self.begin_time := begin_time;
        self.end_time := end_time;
        self.id_doctor_specialization := id_doctor_specialization;
        return;
    end;
end;

alter type kabenyk_st.t_journal
add constructor function t_journal(
    id_journal number,
    id_journal_record_status number,
    day_time date,
    id_patient number,
    id_ticket number
) return self as result
cascade;

create or replace type body kabenyk_st.t_journal
as
    constructor function t_journal(
        id_journal number,
        id_journal_record_status number,
        day_time date,
        id_patient number,
        id_ticket number
    )
    return self as result
    as
    begin
        self.id_journal := id_journal;
        self.id_journal_record_status := id_journal_record_status;
        self.day_time := day_time;
        self.id_patient := id_patient;
        self.id_ticket := id_ticket;
        return;
    end;
end;
