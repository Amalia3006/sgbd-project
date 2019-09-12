set serveroutput on;

--verificare bilete in functie de varsta
--iau de la tastatura numarul ticket-ului apoi verific ce tip de bilet trebuie sa fie adica calculez varsta pentru vizitator si intorc tipul de bilet

create or replace procedure checkAge(ticket in number) as
  age number;
  begin
    select floor(TRUNC(MONTHS_BETWEEN(SYSDATE, date_of_birth))/12) into age from visitors join persons on visitor_id=person_id and ticket_number = ticket;
     DBMS_OUTPUT.PUT_LINE(' VARSTA ESTE ' || age);
    if(age <= 18 and age>0) then
      dbms_output.put_line('ticket-ul este de copil sau student');
     else if(age>18 and age < 65) then
         DBMS_OUTPUT.PUT_LINE('ticket-ul este normal');
        else  DBMS_OUTPUT.PUT_LINE(' ticket cu reducere de pensionar');
        end if;
      end if;
      exception
     when NO_DATA_FOUND then
         DBMS_OUTPUT.PUT_LINE('Nu exista acest numar de ticket');
  end;
/
--select * from visitors where ticket_number=507;

exec checkAge(-90);
exec checkAge(157);
exec checkAge(507);

create or replace function giveTicket(data_nastere in date) return varchar2 as 
  age number;
  begin
  select floor(TRUNC(MONTHS_BETWEEN(SYSDATE, date_of_birth))/12) into age from persons where data_nastere=date_of_birth;
  if (age<=18) then
  return 'copil/student';
  else if(age>18 and age<65) then
  return 'normal';
  else return 'pensioar';
  end if;
  end if;

  end;
  /

 create or replace function giveTicketName(id in number) return varchar2 as 
  age number;
  begin
  select floor(TRUNC(MONTHS_BETWEEN(SYSDATE, date_of_birth))/12) into age from persons p where p.person_id=id;
  if (age<=18) then
  return 'copil/student';
  else if(age>18 and age<65) then
  return 'normal';
  else return 'pensioar';
  end if;
  end if;
  
  end;
  /