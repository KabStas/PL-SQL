create or replace package kabenyk_st.pkg_each_other_1
as
    function counting (
        p_number in number
    )
    return number;

    function multiplication_by_two (
        p_number in number
    )
    return number;
end pkg_each_other_1;

create or replace package kabenyk_st.pkg_each_other_2
as
    function counting  (
        p_number in number
    )
    return number;

    function division_by_two  (
        p_number in number
    )
    return number;

end pkg_each_other_2;

create or replace package body kabenyk_st.pkg_each_other_1
as
    function counting (p_number in number)
    return number
    as
        v_number_1 number := 100;
        v_number number;
    begin
        v_number_1 := kabenyk_st.pkg_each_other_2.division_by_two(v_number_1);
        v_number := v_number_1 + p_number;
        dbms_output.put_line ('v_number_1 in 1st package- ' || v_number_1);
        dbms_output.put_line ('p_number in 1st package- ' || p_number);
        dbms_output.put_line ('v_number in 1st package- ' || v_number);

        return v_number;
    end;

    function multiplication_by_two (
        p_number in number
    )
    return number
    as
        v_number number;
    begin
        v_number := p_number * 2;
        return v_number;
    end;
end pkg_each_other_1;

create or replace package body kabenyk_st.pkg_each_other_2
as
    function counting (p_number in number)
    return number
    as
        v_number_1 number := 100;
        v_number number;
    begin
        v_number_1 := kabenyk_st.pkg_each_other_1.multiplication_by_two(v_number_1);
        v_number := p_number - v_number_1;
        dbms_output.put_line ('v_number_1 in 2nd package- ' || v_number_1);
        dbms_output.put_line ('p_number in 2nd package- ' || p_number);
        dbms_output.put_line ('v_number in 2nd package- ' || v_number);
        return v_number;
    end;

    function division_by_two (
        p_number in number
    )
    return number
    as
        v_number number;
    begin
        v_number := p_number / 2;
        return v_number;
    end;

end pkg_each_other_2;