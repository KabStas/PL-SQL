create or replace type kabenyk_st.t_specialty as object(
    id_specialty number,
    specialty varchar2(100),
    min_age number,
    max_age number,
    id_gender number
);

create or replace type kabenyk_st.t_arr_specialty
    as table of kabenyk_st.t_specialty;