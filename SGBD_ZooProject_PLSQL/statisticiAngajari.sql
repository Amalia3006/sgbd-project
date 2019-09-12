set serveroutput on;
 
create or replace procedure employees_statistics
IS
nr_total_angajati number;
procent number;
idx INTEGER;
CURSOR nr_angajati_an is
select  to_char(hire_date,'YYYY') as an, count(*) as angajati_an from employees group by to_char(hire_date,'YYYY') order by an asc;

begin 
  for idx in nr_angajati_an
    loop
      procent:=((100*idx.angajati_an)/5000);
      DBMS_OUTPUT.PUT_LINE('in anul '||idx.an||' au fost angajati '||idx.angajati_an||' reprezentand '||procent||'% din angajari');
    end loop;
end;
/
begin
employees_statistics();
end;
/